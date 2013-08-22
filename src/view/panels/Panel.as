package view.panels 
{
	import engine.IPanel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import starling.display.DisplayObject;
	
	import flash.events.Event;
	
	/**
	 * Base panel object
	 * @author Grant Flannery
	 */
	public class Panel extends Sprite implements IPanel
	{
		protected var _starlingSprite:starling.display.Sprite;
		public function get starlingSprite():starling.display.Sprite{ return _starlingSprite; }
		
		public function Panel() {}
		
		public function init():void {}
		
		public function update():void {}
		
		public function clear():void
		{
			removeChildren();
			
			if (_starlingSprite)
			{
				_starlingSprite.removeEventListeners();
				_starlingSprite.removeChildren(0, -1, true);
			}
		}
	}

}