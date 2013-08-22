package view.gameObjects.particles.bugs 
{
	import starling.display.DisplayObjectContainer;
	import view.gameObjects.GameObject;
	import view.gameObjects.particles.Particle;
	
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import starling.display.MovieClip;
	
	import assets.AssetManager;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class FreeBug extends Particle 
	{
		protected var _mc:MovieClip;
		
		protected var _rotationOffset:Number;
		
		public function FreeBug() 
		{
		}
		
		override public function init():void 
		{
			super.init();
			
			Starling.juggler.add(_mc);
			
			_mc.play();

			_rotationOffset = Math.PI * 0.5;
		}
		
		override public function clear():void 
		{
			super.clear();
			
			_mc.dispose();
			_mc = null;
		}
		
		override public function create(
			container:DisplayObjectContainer, 
			maxPosX:Number = 0, maxPosY:Number = 0, 
			posOffsetX:Number = 0, posOffsetY:Number = 0,
			minVelX:Number = 0, maxVelX:Number = 0, 
			minVelY:Number = 0, maxVelY:Number = 0,  
			minScale:Number = 1, maxScale:Number = 1,
			destX:Number = 0, destY:Number = 0,
			isRotated:Boolean = false):void
		{
			var rad:Number = Utils.degToRad(Utils.randomInRange(0, 360));
			
			super.create(container, maxPosX, maxPosY, posOffsetX, posOffsetY, minVelX, maxVelX, minVelY, maxVelY, minScale, maxScale, destX, destY, isRotated);
			
			_mc.currentFrame = 1;
			
			Starling.juggler.add(_mc);
			
			_mc.play();
			
			_velocity.x = Math.cos(rad) * Utils.randomInRange(minVelX, maxVelX);
			_velocity.y = Math.sin(rad) * Utils.randomInRange(minVelY, maxVelY);
			
			if (isRotated)
			{
				rotation = rad + _rotationOffset;
			}
		}
		
		override public function kill():void 
		{
			super.kill();
			
			Starling.juggler.remove(_mc);
		}
	}

}