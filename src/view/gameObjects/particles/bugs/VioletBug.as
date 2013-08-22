package view.gameObjects.particles.bugs 
{
	import starling.display.MovieClip;
	
	import assets.AssetManager;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class VioletBug extends FreeBug 
	{
		
		public function VioletBug() 
		{
			
		}
		
		override public function init():void 
		{
			_mc = new MovieClip(AssetManager.getTextures("violetBug"), 8);
			_mc.x = -_mc.width * 0.5;
			_mc.y = -_mc.height * 0.5;
			addChild(_mc);
			
			super.init();
		}
	}

}