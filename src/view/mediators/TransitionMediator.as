package view.mediators 
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import starling.events.Event;
	import view.panels.TransitionPanel;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class TransitionMediator extends CustomMediator implements IMediator 
	{
		public static const NAME:String = "TransitionMediator";
		
		public function TransitionMediator(viewComponent:Object) 
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void 
		{
			panel.init();
			
			panel.starlingSprite.addEventListener(Constants.TRANSITION_HALF_COMPLETE, onTransitionHalfComplete);
			panel.starlingSprite.addEventListener(Constants.TRANSITION_COMPLETE, onTransitionComplete);
		}
		
		override public function getMediatorName():String 
		{
			return NAME;
		}
		
		override public function clear(request:String = null):void 
		{
			super.clear();

			panel.starlingSprite.removeEventListener(Constants.TRANSITION_HALF_COMPLETE, onTransitionHalfComplete);
			panel.starlingSprite.removeEventListener(Constants.TRANSITION_COMPLETE, onTransitionComplete);
			panel.clear();
			
			viewComponent = null;
		}
		
		protected function get panel():TransitionPanel
		{
			return viewComponent as TransitionPanel;
		}
		
		private function onTransitionHalfComplete(e:Event):void
		{
			sendNotification(ApplicationFacade.GO_TO);
		}
		
		private function onTransitionComplete(e:Event):void
		{
			sendNotification(ApplicationFacade.REMOVE_TRANSITION);
		}
	}

}