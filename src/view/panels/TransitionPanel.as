package view.panels 
{
	import view.components.TransitionComponent;
	import starling.display.Sprite;
	
	/**
	 * Provides brief visual transition between panels
	 * @author Grant Flannery
	 */
	public class TransitionPanel extends Panel 
	{
		private var _transitionComponent:TransitionComponent;
		
		public function TransitionPanel() 
		{
			
		}
		
		override public function init():void 
		{
			_starlingSprite = new Sprite();
			
			_transitionComponent = new TransitionComponent();
			_transitionComponent.init();
			_starlingSprite.addChild(_transitionComponent);
		}
		
		override public function clear():void 
		{
			super.clear();
			
			_transitionComponent.clear();
		}
		
		public function transitionIn():void
		{
			_transitionComponent.transitionIn();
		}
		
		public function transitionOut():void
		{
			_transitionComponent.transitionOut();
		}
	}

}