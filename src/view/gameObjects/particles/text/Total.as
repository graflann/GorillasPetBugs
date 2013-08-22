package view.gameObjects.particles.text 
{
	import flash.events.*;
	import starling.animation.*;
	import starling.core.*;
	import starling.display.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * Renders points the user totaled during the turn
	 * @author Grant Flannery
	 */
	public class Total extends TextParticle 
	{	
		public function Total() { }
		
		override public function init():void 
		{
			super.init();
			
			_dest = new Point();
			
			_timer = new Timer(500, 1);
		}
		
		override public function create(container:DisplayObjectContainer, maxPosX:Number = 0, maxPosY:Number = 0, posOffsetX:Number = 0, posOffsetY:Number = 0, minVelX:Number = 0, maxVelX:Number = 0, minVelY:Number = 0, maxVelY:Number = 0, minScale:Number = 1, maxScale:Number = 1, destX:Number = 0, destY:Number = 0, isRotated:Boolean = false):void 
		{
			super.create(container, maxPosX, maxPosY, posOffsetX, posOffsetY, minVelX, maxVelX, minVelY, maxVelY, minScale, maxScale, destX, destY, isRotated);
			
			alpha = 0;
			
			_tween = new Tween(this, 0.25);
			_tween.fadeTo(1);
			_tween.onComplete = onFadeTweenComplete;
			Starling.juggler.add(_tween);
			
			_dest.x = destX;
			_dest.y = destY;
		}
		
		override public function kill():void 
		{
			super.kill();
			
			Starling.juggler.remove(_tween);
			_tween = null;
		}
		
		private function onFadeTweenComplete():void
		{
			Starling.juggler.remove(_tween);
			_tween = null;
			
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			_timer.start();
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.stop();
			
			_tween = new Tween(this, 0.5);
			_tween.moveTo(_dest.x, _dest.y);
			_tween.onComplete = onMoveTweenComplete;
			Starling.juggler.add(_tween);
		}
		
		private function onMoveTweenComplete():void
		{
			kill();
		}
	}

}