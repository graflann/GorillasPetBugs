package view.mediators 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import starling.animation.Transitions;
	//import model.proxies.DataProxy;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import view.mediators.*;
	import view.panels.*;
	import engine.SoundManager;
	import starling.events.Event;
	import engine.KeyboardEx;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class StageMediator extends CustomMediator implements IMediator
	{
		public static const NAME:String = "StageMediator";
		
		public var currentPanel:Panel;
		
		private var _isPaused:Boolean;
		private var _isMuted:Boolean;
		
		public function StageMediator(viewComponent:Object) 
		{
			super(NAME, viewComponent);
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IMediator */
		override public function listNotificationInterests():Array 
		{
			return [ApplicationFacade.INIT_APP,
					ApplicationFacade.DATA_LOAD_COMPLETE];
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName())
			{
			case ApplicationFacade.INIT_APP:			initApp();				break;
			case ApplicationFacade.DATA_LOAD_COMPLETE:	onDataLoadComplete();	break;
			}
		}
		
		override public function getMediatorName():String 
		{
			return NAME;
		}
		
		protected function get stage():Stage
		{
			return getViewComponent() as Stage;
		}
		
		protected function get nativeOverlay():Sprite
		{
			return Main.nativeOverlay;
		}
		
		protected function get game():Game
		{
			return Game.instance;
		}
		
		//NOTIFICATION HANDLING METHODS
		private function initApp():void
		{
			sendNotification(ApplicationFacade.INIT_DATA);
		}
		
		private function onDataLoadComplete():void
		{
			//var proxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			//currentPanel = new PlayPanel();
			//facade.registerMediator(new PlayMediator(currentPanel));
			
			currentPanel = new TitlePanel();
			facade.registerMediator(new TitleMediator(currentPanel));
			
			//var panel:Panel = new TitlePanel();
			//facade.registerMediator(new TitleMediator(panel));
			
			//TRANSITION
			var transitionPanel:Panel = new TransitionPanel();
			facade.registerMediator(new TransitionMediator(transitionPanel));
			
			addPanel(currentPanel);
			addPanel(transitionPanel);
			
			Main.instance.starling.start()
		}
		
		public function addPanel(panel:Panel, index:int = -1):void
		{			
			nativeOverlay.addChild(panel);
			
			if(panel.starlingSprite)
			{
				if (index == -1)
					index = game.numChildren;
				
				game.addChildAt(panel.starlingSprite, index);
			}
		}
		
		public function removePanel(panel:Panel):void
		{
			nativeOverlay.removeChild(panel);
			
			if (panel.starlingSprite)
			{
				game.removeChild(panel.starlingSprite);
			}
		}
		
		
	}

}