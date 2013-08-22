package view.gameObjects 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * Parent to derived GameObject instances
	 * @author Grant Flannery
	 */
	public class GameObject extends Sprite 
	{
		protected var _type:String;
		public function get type():String { return _type; }
		
		/**
		 * Sentinel value determining update status
		 */
		protected var _isAlive:Boolean;
		public function get isAlive():Boolean { return _isAlive; }
		
		/**
		 * Determines rate of screen movement per frame
		 */
		protected var _velocity:Point;
		public function set velocity(value:Point):void 	{ _velocity = value; }
		public function get velocity():Point 			{ return _velocity; }
		
		/**
		 * Caches position (x, y) from previous frame; assists in determining animations, etc.
		 */
		protected var _prevPosition:Point;
		public function set prevPosition(value:Point):void	{ _prevPosition = value; }
		public function get prevPosition():Point 			{ return _prevPosition; }
		
		/**
		 * ItemName (String) for use spawning (dynamic runtime creation) / typing an Item
		 */
		protected var _itemDrop:String;
		public function set itemDrop(value:String):void { _itemDrop = value; }
		public function get itemDrop():String			{ return _itemDrop; }
		
		/**
		 * Hold values for checking GameObject bounds thresholds relative to viewport
		 * (this property not directly related to collision; see _collider property for collision)
		 */
		protected var _bounds:Rectangle;
		
		/**
		 * Position of a potential target e.g. focus of an attack
		 */
		protected var _target:Point;
		
		/**
		 * CTOR - Should make this abstract or Interface?
		 */
		public function GameObject() 
		{
			
		}
		
		public function init():void
		{
			
		}
		
		public function update(targetX:Number = 0, targetY:Number = 0, originX:Number = 0, originY:Number = 0):void
		{
			
		}
		
		public function clear():void
		{
			removeEventListeners();
			removeChildren(0, -1, true);
		}
		
		public function recycle(container:DisplayObjectContainer, position:Point):void
		{
			_isAlive = true;
			
			x = position.x;
			y = position.y;
			
			container.addChild(this);
		}
		
		public function kill():void
		{	
			_isAlive = false;
			removeFromParent();
		}
			
	}

}