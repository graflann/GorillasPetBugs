package view.mediators 
{
	import model.vo.TransitionVO;
	import org.puremvc.as3.interfaces.INotification;
	import view.panels.*;
	import flash.events.Event;
	import view.panels.TitlePanel;
	import org.puremvc.as3.interfaces.IMediator;
	
	/**
	 * Mediates the StartPanel
	 * @author Grant Flannery
	 */
	public class TitleMediator extends CustomMediator implements IMediator
	{
		public static const NAME:String = "TitleMediator";
		
		public function TitleMediator(viewComponent:Object) 
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void 
		{
			panel.init();
			
			panel.addEventListener(Constants.START, onStart, false, 0, true);
			panel.addEventListener(Constants.MASK_TWEEN_COMPLETE, onMaskTweenComplete, false, 0, true);
		}
		
		override public function getMediatorName():String 
		{
			return NAME;
		}
		
		override public function listNotificationInterests():Array 
		{
			return [ApplicationFacade.REMOVE_TRANSITION];
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName())
			{
			case ApplicationFacade.REMOVE_TRANSITION:	onRemoveTransition(); break;
			}
		}
		
		override public function clear(request:String = null):void 
		{
			super.clear();
			
			if(panel.hasEventListener(Constants.START))
				panel.removeEventListener(Constants.START, onStart);
				
			if(panel.hasEventListener(Constants.MASK_TWEEN_COMPLETE))
				panel.removeEventListener(Constants.MASK_TWEEN_COMPLETE, onMaskTweenComplete);
			
			panel.clear();
			
			viewComponent = null;
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			
			clear();
		}
		
		protected function get panel():TitlePanel
		{
			return viewComponent as TitlePanel;
		}
		
		protected function onStart(e:Event):void
		{
			panel.startMaskFadeIn();
		}
		
		private function onMaskTweenComplete(e:flash.events.Event):void
		{			
			var transitionVO:TransitionVO = new TransitionVO();
			transitionVO.currentPrefix = PanelPrefix.TITLE;
			transitionVO.newPrefix = PanelPrefix.PLAY;
			
			panel.removeChildren();
			
			panel.removeEventListener(Constants.START, onStart);
			
			sendNotification(ApplicationFacade.ADD_TRANSITION, transitionVO);
		}
		
		//NOTIFICATION HANDLING
		private function onRemoveTransition():void
		{		
			panel.startTimer();
		}
	}

}