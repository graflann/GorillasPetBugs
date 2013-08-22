package view.gameObjects.particles 
{
	import starling.display.DisplayObjectContainer;
	import flash.geom.Point;
	import starling.utils.deg2rad;
	import view.gameObjects.GameObject;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class Particle extends GameObject 
	{
		
		public function Particle() 
		{
			
		}
		
		override public function init():void 
		{
			_type = getQualifiedClassName(this).slice(ParticleTypes.RUNTIME_QUALIFIED_PATH.length);
			
			_isAlive = false;
			
			velocity = new Point();
		}
		
		override public function update(targetX:Number = 0, targetY:Number = 0, originX:Number = 0, originY:Number = 0):void 
		{
			if (_isAlive)
			{
				x += _velocity.x;
				y += _velocity.y;
				
				checkBounds();
			}
		}
		
		override public function clear():void 
		{
			super.clear();
		}
		
		override public function kill():void
		{
			_isAlive = false;
			removeFromParent();
		}
		
		public function create(
			container:DisplayObjectContainer, 
			maxPosX:Number = 0, 	maxPosY:Number = 0,
			posOffsetX:Number = 0, 	posOffsetY:Number = 0, 
			minVelX:Number = 0, 	maxVelX:Number = 0, 
			minVelY:Number = 0, 	maxVelY:Number = 0, 
			minScale:Number = 1, 	maxScale:Number = 1,
			destX:Number = 0, destY:Number = 0,
			isRotated:Boolean = false):void
		{
			x = Utils.randomInRange(maxPosX - posOffsetX, maxPosX + posOffsetX);
			y = Utils.randomInRange(maxPosY - posOffsetY, maxPosY + posOffsetY);
			
			_velocity.x = Utils.randomInRange(minVelX, maxVelX);
			_velocity.y = Utils.randomInRange(minVelY, maxVelY);
	
			if(isRotated)
				rotation = Utils.randomInRange(deg2rad(0), deg2rad(360));
			
			_isAlive = true;
			
 			container.addChild(this);
		}
		
		protected function checkBounds():void
		{
			if (y < -height || x < -width || x > Constants.WIDTH || y > Constants.HEIGHT)
			{
				kill();
			}
		}
	}

}