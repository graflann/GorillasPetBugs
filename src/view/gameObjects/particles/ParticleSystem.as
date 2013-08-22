package view.gameObjects.particles 
{
	import starling.display.DisplayObjectContainer;
	import starling.utils.deg2rad;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class ParticleSystem 
	{
		private var _type:String;
		public function get type():String { return _type; }
		
		private var _max:int;
		public function get max():int { return _max; }
		
		private var _vecParticles:Vector.<Particle>;
		
		private var _index:int;
		private var _currentIndex:int = 0;
		
		
		public function ParticleSystem(type:String, max:int = 8) 
		{
			_type = type;
			_max = max;
		}
		
		public function init():void
		{
			var ParticleClass:Class = getDefinitionByName(ParticleTypes.QUALIFIED_PATH + _type) as Class;
			
			_vecParticles = new Vector.<Particle>();
			
			for (var i:int = 0; i < _max; i++ )
			{
				_vecParticles.push(new ParticleClass());
				_vecParticles[i].init();
			}
		}
		
		public function update():void
		{
			var i:int = -1;
			
			while (++i < _max)
			{
				_vecParticles[i].update();
			}
		}
		
		public function clear():void
		{
			for (var i:int = 0; i < _max; i++ )
			{
				_vecParticles[i].clear();
				_vecParticles[i] = null;
			}
			
			_vecParticles.length = 0;
			_vecParticles = null;
		}
		
		public function emit(
			container:DisplayObjectContainer, 
			quantity:int, 
			maxPosX:Number = 0, maxPosY:Number = 0,
			posOffsetX:Number = 0, posOffsetY:Number = 0,
			minVelX:Number = 0, maxVelX:Number = 0, 
			minVelY:Number = 0, maxVelY:Number = 0, 
			minScale:Number = 1, maxScale:Number = 1,
			destX:Number = 0, destY:Number = 0,
			isRotated:Boolean = false):void
		{
			var i:int = -1;
			var particle:Particle;
			
			while (++i < quantity)
			{
				particle = getParticle();
				
				if (particle)
				{
					particle.create(container, 
						maxPosX, maxPosY, 
						posOffsetX, posOffsetY,
						minVelX, maxVelX, 
						minVelY, maxVelY, 
						minScale, maxScale,
						destX, destY,
						isRotated);
				}
			}
		}
		
		public function getParticle():Particle
		{
			_index = -1;
			
			while (++_index < _max)
			{
				if (!_vecParticles[_index].isAlive)
				{
					return _vecParticles[_index];
				}
			}
			
			return null;
		}
		
		public function getParticleByIndex(index:int):Particle
		{
			return _vecParticles[index];
		}
		
		public function getCurrentParticle():Particle
		{
			if(_index != -1)
				return _vecParticles[_index];
			
			return null;
		}
		
		public function length():int
		{
			return _vecParticles.length;
		}
	}

}