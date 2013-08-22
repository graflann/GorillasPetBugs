package view.components 
{
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import assets.AssetManager;
	
	/**
	 * Displays sound status
	 * @author Grant Flannery
	 */
	public class MuteSymbol extends Sprite 
	{
		private static const ON:int = 0;
		private static const OFF:int = 1;
		
		private var _mc:MovieClip;
		
		public function MuteSymbol() 
		{
			
		}
		
		public function init():void
		{
			_mc = new MovieClip(AssetManager.getTextures("muteSymbol"));
			_mc.loop = false;
			_mc.stop();
			
			_mc.currentFrame = ON;
			
			addChild(_mc);
		}
		
		public function toggle(isMuted:Boolean):void
		{
			(isMuted) ? _mc.currentFrame = OFF : _mc.currentFrame = ON;
		}
		
		public function clear():void
		{
			removeChildren();
			
			_mc.dispose();
			_mc = null;
		}
	}

}