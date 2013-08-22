package view.gameObjects.bugs 
{
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import starling.display.Image;
	import starling.display.MovieClip;
	import view.gameObjects.GameObject;
	
	import assets.AssetManager;
	
	import starling.textures.Texture;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class Bug extends GameObject
	{
		private var _color:String;
		public function get color():String { return _color; }
		
		private var _mc:MovieClip;
		
		private var _jarClip:MovieClip;
		
		private var _lid:Image;
		
		private var _fill:Image;
		
		private var _isCracked:Boolean;
		public function get isCracked():Boolean { return _isCracked; }
		
		private var _localPosition:Point;
		public function set localPosition(value:Point):void 	{ _localPosition = value; }
		public function get localPosition():Point				{ return _localPosition; }
		
		private var _cellPosition:Point;
		public function set cellPosition(value:Point):void 	{ _cellPosition = value; }
		public function get cellPosition():Point			{ return _cellPosition; }
		
		private var _isRemovalQualified:Boolean;
		public function set isRemovalQualified(value:Boolean):void	{ _isRemovalQualified = value; }
		public function get isRemovalQualified():Boolean 			{ return _isRemovalQualified; }
		
		private var _isDescentQualified:Boolean;
		public function set isDescentQualified(value:Boolean):void	{ _isDescentQualified = value; }
		public function get isDescentQualified():Boolean 			{ return _isDescentQualified; }
		
		public function Bug(color:String) 
		{
			_color = color;
		}
		
		override public function init():void 
		{
			_type = getQualifiedClassName(this).slice(BugType.RUNTIME_QUALIFIED_PATH.length);
			
			_isAlive = true;
			
			_fill = new Image(Texture.fromBitmapData(AssetManager.getBitmapData(_color + "Fill")));
			addChild(_fill);
			
			_mc = new MovieClip(AssetManager.getTextures(_color + "Bug"), 8);
			addChild(_mc);
			Starling.juggler.add(_mc);
			_mc.play();
			
			//Determines the overlaying jar assets for best contrast
			if(_color == BugType.BLUE || _color == BugType.GREY || _color == BugType.VIOLET)
				_jarClip = new MovieClip(AssetManager.getTextures("darkJar"), 5);
			else 
				_jarClip = new MovieClip(AssetManager.getTextures("lightJar"), 5);
			
			_jarClip.stop();
			_jarClip.loop = false;
			addChild(_jarClip);
			
			_lid = new Image(Texture.fromBitmapData(AssetManager.getBitmapData(_color + "Lid")));
			addChild(_lid);
			
			_isCracked = false;
			
			_cellPosition = new Point();
			
			_isRemovalQualified = false;
			_isDescentQualified = false;
		}
		
		override public function update(targetX:Number = 0, targetY:Number = 0, originX:Number = 0, originY:Number = 0):void 
		{
			if (_isCracked && !_jarClip.isPlaying)
			{
				kill();
			}
		}
		
		override public function clear():void
		{
			if (_jarClip)
			{
				Starling.juggler.remove(_jarClip);
				_jarClip.stop();
				_jarClip.dispose();
				_jarClip = null;
			}
			
			if (_mc)
			{
				Starling.juggler.remove(_mc);
				_mc.stop();
				_mc.dispose();
				_mc = null;
			}
			
			super.clear();
			
			if (_fill)
			{
				_fill.dispose();
				_fill = null;
			}
			
			if (_lid)
			{
				_lid.dispose();
				_lid = null;
			}
			
			_localPosition = null;
			_cellPosition = null;
		}
			
		public function crack():void
		{
			_isCracked = true;
			
			Starling.juggler.add(_jarClip);
			
			_jarClip.play();
		}
		
		public function stopAnimation():void
		{
			Starling.juggler.remove(_mc);
			_mc.currentFrame = 1;
		}
	}

}