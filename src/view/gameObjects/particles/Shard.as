package view.gameObjects.particles 
{
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import assets.AssetManager;
	import starling.utils.deg2rad;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class Shard extends Particle 
	{
		private var _mc:MovieClip;
		
		public function Shard() 
		{
			
		}
		
		override public function init():void 
		{
			super.init();
			
			_mc = new MovieClip(AssetManager.getTextures("shard"), 10);
			_mc.x = -(_mc.width * 0.5);
			_mc.y = -(_mc.height * 0.5);
			addChild(_mc);
			
			_mc.loop = true;
		}
		
		override public function update(targetX:Number = 0, targetY:Number = 0, originX:Number = 0, originY:Number = 0):void 
		{
			if (_isAlive)
			{
				x += _velocity.x;
				y += _velocity.y;
				
				if (y > Constants.HEIGHT)
				{
					kill();
				}
			}
		}
		
		override public function clear():void
		{
			super.clear();
			
			_mc.dispose();
			_mc = null;
		}
		
		override public function kill():void 
		{
			super.kill();
			
			Starling.juggler.remove(_mc);
		}
		
		override public function create(
			container:DisplayObjectContainer, 
			maxPosX:Number = 0, 	maxPosY:Number = 0, 
			posOffsetX:Number = 0, 	posOffsetY:Number = 0,
			minVelX:Number = 0, 	maxVelX:Number = 0, 
			minVelY:Number = 0, 	maxVelY:Number = 0,  
			minScale:Number = 1, 	maxScale:Number = 1,
			destX:Number = 0, 		destY:Number = 0,
			isRotated:Boolean = false):void
		{
			super.create(container, maxPosX, maxPosY, posOffsetX, posOffsetY, minVelX, maxVelX, minVelY, maxVelY, minScale, maxScale, destX, destY, isRotated);
			
			_mc.currentFrame = 1;
			
			Starling.juggler.add(_mc);
			
			_mc.play();
		}
	}

}