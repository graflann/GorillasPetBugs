package view.mediators 
{
	import engine.Score;
	import flash.events.Event;
	import flash.geom.Point;
	import model.vo.TransitionVO;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import starling.events.Event;
	import view.components.StatusComponent;
	import view.panels.PanelPrefix;
	import view.panels.PlayPanel;
	import com.greensock.TweenMax;
	import engine.SoundManager;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class PlayMediator extends CustomMediator implements IMediator 
	{
		public static const NAME:String = "PlayMediator";
				
		public function PlayMediator(viewComponent:Object) 
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void 
		{
			panel.init();
			
			//var proxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			
			//Standard flash.events
			panel.addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToOverlay, false, 0, true);
			
			panel.addEventListener(Constants.STATUS_TEXT_CHANGE, onStatusTextChange, false, 0, true);
			panel.addEventListener(Constants.MASK_TWEEN_COMPLETE, onMaskTweenComplete, false, 0, true);

			//Starling specific events
			panel.starlingSprite.addEventListener(Constants.STARLING_STATUS_TEXT_CHANGE, onStarlingStatusTextChange);
			panel.starlingSprite.addEventListener(Constants.UPDATE_SCORE, onUpdateScore);
			panel.starlingSprite.addEventListener(Constants.UPDATE_INPUT_INC, onUpdateInputIncrement);
			panel.starlingSprite.addEventListener(Constants.RESET, onReset);
			panel.starlingSprite.addEventListener(Constants.START_GORILLA_KICK, onStartGorillaKick);
		}
		
		override public function getMediatorName():String 
		{
			return NAME;
		}
		
		override public function listNotificationInterests():Array 
		{
			return [ApplicationFacade.REMOVE_TRANSITION,
					ApplicationFacade.PAUSE,
					ApplicationFacade.MUTE];
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName())
			{
			case ApplicationFacade.REMOVE_TRANSITION:	onRemoveTransition();				break;
			case ApplicationFacade.PAUSE:				onPause(note.getBody() as Boolean);	break;
			case ApplicationFacade.MUTE:				onMute(note.getBody() as Boolean);	break;
			}
		}
		
		override public function clear(request:String = null):void 
		{
			super.clear();
			
			//Standard flash.events
			panel.removeEventListener(Constants.STATUS_TEXT_CHANGE, onStatusTextChange);
			panel.removeEventListener(Constants.MASK_TWEEN_COMPLETE, onMaskTweenComplete);
			
			panel.clear();
			
			viewComponent = null;
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			
			clear();
		}
		
		protected function get panel():PlayPanel
		{ 
			return viewComponent as PlayPanel;
		}
		
		protected function onAddedToOverlay(e:flash.events.Event):void
		{
			panel.removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToOverlay);
			sendNotification(ApplicationFacade.ADD_TO_OVERLAY, panel.parent);
		}
		
		private function statusTextChange(text:String):void
		{
			switch(text)
			{
				case StatusComponent.READY:
					panel.statusComponent.alpha = 0;
					TweenMax.to(panel.statusComponent, 0.5, {alpha:1});
					panel.statusComponent.setTimedStatus(StatusComponent.GO, 1500);
					break;
				case StatusComponent.GO:
					panel.gridComponent.start();
					panel.statusComponent.alpha = 0;
					panel.removeChild(panel.statusComponent);
					panel.isAuxiliaryInputEnabled = true;
					break;
				case StatusComponent.PAUSED:
					if (TweenMax.isTweening(panel.statusComponent))
						TweenMax.killTweensOf(panel.statusComponent);
					
					if (panel.statusComponent.alpha == 0)
					{
						panel.addChild(panel.statusComponent);
						TweenMax.to(panel.statusComponent, 0.5, {alpha:1});
					}
					else
					{
						panel.statusComponent.alpha = 0;
						
						if(panel.statusComponent.parent == panel)
							panel.removeChild(panel.statusComponent);
					}
					break;
				case StatusComponent.GAME_OVER:
					panel.isAuxiliaryInputEnabled = false;
					
					SoundManager.stop(SoundName.MUSIC);
					panel.stopGorilla();
					
					panel.scoreComponent.forceBonusRemoval();
	
					panel.statusComponent.alpha = 0;
					
					//save the new high score...
					if (Score.sessionTotal == Score.high)
					{
						sendNotification(ApplicationFacade.SAVE_HIGH_SCORE);
					}
					
					TweenMax.to(panel.statusComponent, 0.5, { alpha:1 } );
					panel.statusComponent.setText(StatusComponent.GAME_OVER);
					panel.addChild(panel.statusComponent);
					break;
				case StatusComponent.ONE_MOMENT:
					//panel.statusComponent.alpha = 0;
					//TweenMax.to(panel.statusComponent, 0.5, {alpha:1});
					//panel.statusComponent.setText(StatusComponent.ONE_MOMENT);
					break;
				default: throw new Error("Status text condition not applicable...");
			}
			
			centerStatusComponent();
		}
		
		
		private function centerStatusComponent():void
		{
			//center the PlayPanel's StatusComponent instance
			panel.statusComponent.x = ((Constants.WIDTH * 0.5) - StatusComponent.BACKGROUND_OFFSET.x) - (panel.statusComponent.width * 0.5);
			panel.statusComponent.y = (Constants.HEIGHT * 0.5) - (panel.statusComponent.height * 0.5);
		}
		
		//NOTIFICATION HANDLING
		private function onRemoveTransition():void
		{		
			panel.startMaskFadeOut();
			
			panel.statusComponent.setTimedStatus(StatusComponent.READY, 2000);
			centerStatusComponent();
		}
		
		private function onPause(isPaused:Boolean):void
		{
			panel.togglePause(isPaused);
			
			if (isPaused)
				panel.statusComponent.setText(StatusComponent.PAUSED);
			
			panel.dispatchEvent(new flash.events.Event(Constants.STATUS_TEXT_CHANGE, true));
		}
		
		private function onMute(isMute:Boolean):void
		{
			panel.toggleMute(isMute);
		}
		
		//NATIVE EVENT HANDLING
		private function onStatusTextChange(e:flash.events.Event):void
		{
			statusTextChange(panel.statusComponent.getText());
		}
		
		private function onMaskTweenComplete(e:flash.events.Event):void
		{
			var transitionVO:TransitionVO = new TransitionVO();
			transitionVO.currentPrefix = PanelPrefix.PLAY;
			transitionVO.newPrefix = PanelPrefix.PLAY;
			
			panel.removeChildren();
			
			sendNotification(ApplicationFacade.ADD_TRANSITION, transitionVO);
		}
		
		//STARLING-SPECIFIC EVENT HANDLING
		private function onStarlingStatusTextChange(e:starling.events.Event):void
		{
			statusTextChange(e.data as String);
		}
		
		private function onUpdateScore(e:starling.events.Event):void
		{
			if (Score.totalBugsRemoved > 0)
			{
				Score.update();
				
				panel.createTotal(e.data as Point, Score.multiplier, Score.totalBonusBugsRemoved);
				panel.scoreComponent.update(true);
				
				Score.resetRemovedBugs();
			}
		}
		
		private function onUpdateInputIncrement(e:starling.events.Event):void
		{
			Score.incTotalByInput();
			panel.scoreComponent.update();
		}
		
		private function onReset(e:starling.events.Event):void
		{
			SoundManager.play(SoundName.CONTAINER_PLACE);
			panel.startMaskFadeIn();
		}
		
		private function onStartGorillaKick(e:starling.events.Event):void
		{
			panel.startGorillaKick();
		}
	}

}