package view.gameObjects.particles.bugs 
{
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	
	import assets.AssetManager;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class YellowBug extends FreeBug 
	{
		
		public function YellowBug() 
		{
			
		}
		
		override public function init():void 
		{
			_mc = new MovieClip(AssetManager.getTextures("yellowBug"), 8);
			_mc.x = -_mc.width * 0.5;
			_mc.y = -_mc.height * 0.5;
			addChild(_mc);
			
			super.init();
			
			_rotationOffset = Math.PI * 0.25;
		}
	}

}