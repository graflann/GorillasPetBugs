package view.gameObjects 
{
	import engine.ai.StateMachine;
	import starling.animation.Tween;
	import starling.display.MovieClip;
	
	import assets.AssetManager;
	
	import starling.core.Starling;
	
	import view.components.GridComponent;
	import view.panels.PlayPanel;

	/**
	 * The gorilla
	 * @author Grant Flannery
	 */
	public class Gorilla extends GameObject 
	{
		public static const FRONT:String 	= "front";
		public static const FRONT_STATIC:String 	= "frontStatic";
		public static const BACK:String 	= "back";
		public static const LEFT:String 	= "left";
		public static const RIGHT:String 	= "right";
		public static const KICK:String 	= "kick";
		public static const WALK:String 	= "walk";
		
		
		private var _mc:MovieClip;
		
		private var _arrMovieClips:Array;
		
		private var _stateMachine:StateMachine;
		
		private var _isFlipped:Boolean;
		
		private var _tween:Tween;
		
		public function Gorilla() {}
		
		override public function init():void 
		{
			super.init();
			
			_isAlive = true;
			
			setMovieClips();
			setStateMachine();
		}
		
		override public function update(targetX:Number = 0, targetY:Number = 0, originX:Number = 0, originY:Number = 0):void 
		{
			if (_isAlive)
			{
				_stateMachine.update();
			}
		}
		
		override public function clear():void 
		{
			super.clear();
			
			for (var key:String in _arrMovieClips)
			{
				_arrMovieClips[key].dispose();
				_arrMovieClips[key] = null;
			}
			
			_mc = null;
			
			_stateMachine.clear();
			_stateMachine = null;
			
			if (_tween)
				_tween = null;
		}
		
		public function setState(key:String):void
		{
			_stateMachine.setState(key);
		}
		
		private function checkFlip():void
		{
			if(_isFlipped)
			{
				if (_mc.scaleX != -1) 
				{
					_mc.scaleX = -1;
				}
			}
			else
			{
				if (_mc.scaleX != 1) 
				{
					_mc.scaleX = 1;
				}
			}
		}
		
		private function setMovieClips():void
		{
			_arrMovieClips = [];
			_arrMovieClips[FRONT] 	= new MovieClip(AssetManager.getTextures("gorillaFront"), 2);
			_arrMovieClips[BACK] 	= new MovieClip(AssetManager.getTextures("gorillaBack"), 2);
			_arrMovieClips[RIGHT] 	= new MovieClip(AssetManager.getTextures("gorillaSide"), 2);
			
			for (var key:String in _arrMovieClips)
			{
				_mc = _arrMovieClips[key];
				_mc.pivotX = _mc.width * 0.5;
			}
			
			_mc = _arrMovieClips[FRONT];
		}
		
		private function setStateMachine():void
		{
			_stateMachine = new StateMachine();
			
			_stateMachine.addState(FRONT_STATIC, new FrontStaticState(this), [
				FRONT
			]);
			
			_stateMachine.addState(FRONT, new FrontState(this), [
				BACK, 
				RIGHT,
				LEFT,
				KICK,
				FRONT_STATIC
			]);
			
			_stateMachine.addState(BACK, new BackState(this), [
				FRONT,
				RIGHT,
				LEFT,
				KICK,
				FRONT_STATIC
			]);
			
			_stateMachine.addState(RIGHT, new RightState(this), [
				FRONT,
				BACK,
				LEFT,
				KICK,
				FRONT_STATIC
			]);
			
			_stateMachine.addState(LEFT, new LeftState(this), [
				FRONT,
				BACK,
				RIGHT,
				KICK,
				FRONT_STATIC
			]);
			
			_stateMachine.addState(KICK, new KickState(this), [
				WALK,
				FRONT
			]);
			
			_stateMachine.addState(WALK, new WalkState(this), [
				FRONT
			]);
			
			_stateMachine.setState(FRONT);
		}
		
		//ISTATE IMPLEMENTATIONS
		//ENTER
		public function enterFrontStatic():void
		{
			_mc = _arrMovieClips[FRONT];
			addChild(_mc);
			
			_mc.loop = false;
			_mc.stop();
			_mc.currentFrame = 0;
			
			_isFlipped = false;
			checkFlip();
		}
		
		public function enterFront():void
		{
			_mc = _arrMovieClips[FRONT];
			addChild(_mc);
			
			Starling.juggler.add(_mc);
			
			_mc.loop = false;
			_mc.play();
			
			_isFlipped = false;
			checkFlip();
		}
		
		public function enterBack():void
		{
			_mc = _arrMovieClips[BACK];
			addChild(_mc);
			
			Starling.juggler.add(_mc);
			_mc.loop = false;
			_mc.play();
			
			_isFlipped = false;
			checkFlip();
		}
		
		public function enterRight():void
		{
			_mc = _arrMovieClips[RIGHT];
			addChild(_mc);
			
			Starling.juggler.add(_mc);
			_mc.fps = 2;
			_mc.loop = false;
			_mc.play();
			
			_isFlipped = false;
			checkFlip();
		}
		
		public function enterLeft():void
		{
			_mc = _arrMovieClips[RIGHT];
			addChild(_mc);
			
			Starling.juggler.add(_mc);
			_mc.fps = 2;
			_mc.loop = false;
			_mc.play();
			
			_isFlipped = true;
			checkFlip();
		}
		
		public function enterKick():void
		{
			_mc = _arrMovieClips[RIGHT];
			addChild(_mc);
			
			Starling.juggler.add(_mc);
			_mc.loop = false;
			_mc.play();
			
			_isFlipped = false;
			checkFlip();
			
			(!_tween) ? _tween = new Tween(this,  0.5, "easeIn") : _tween.reset(this,  0.5, "easeIn");
			_tween.animate("x", GridComponent.INIT_ORIGIN.x + (GridComponent.UNIT * 0.5));
			_tween.onComplete = onKickComplete;
			Starling.juggler.add(_tween);
		}
		
		public function enterWalk():void
		{
			_mc = _arrMovieClips[RIGHT];
			addChild(_mc);
			
			Starling.juggler.add(_mc);
			_mc.fps = 8;
			_mc.loop = true;
			_mc.play();
			
			_isFlipped = true;
			checkFlip();
			
			(!_tween) ? _tween = new Tween(this,  0.5) : _tween.reset(this,  0.5);
			_tween.animate("x", PlayPanel.GORILLA_ORIGIN.x);
			_tween.onComplete = onWalkComplete;
			Starling.juggler.add(_tween);
		}
		
		//UPDATE
		public function updateFront():void
		{
			if (!_mc.isPlaying)
			{
				_stateMachine.setState(LEFT);
			}
		}
		
		public function updateBack():void
		{
			if (!_mc.isPlaying)
			{
				_stateMachine.setState(RIGHT);
			}
		}
		
		public function updateRight():void
		{
			if (!_mc.isPlaying)
			{
				_stateMachine.setState(FRONT);
			}
		}
		
		public function updateLeft():void
		{
			if (!_mc.isPlaying)
			{
				_stateMachine.setState(BACK);
			}
		}
		
		public function updateKick():void
		{
			if (!_mc.currentFrame == 1)
			{
				_mc.stop();
				_mc.currentFrame = 1;
			}
		}
		
		//EXIT
		public function exitFront():void
		{
			_mc.stop();
			Starling.juggler.remove(_mc);
			removeChild(_mc);
		}
		
		public function exitBack():void
		{
			_mc.stop();
			Starling.juggler.remove(_mc);
			removeChild(_mc);
		}
		
		public function exitRight():void
		{
			_mc.stop();
			Starling.juggler.remove(_mc);
			removeChild(_mc);
		}
		
		public function exitLeft():void
		{
			_mc.stop();
			Starling.juggler.remove(_mc);
			removeChild(_mc);
		}
		
		public function exitKick():void
		{
			_mc.stop();
			Starling.juggler.remove(_mc);
			removeChild(_mc);
		}
		
		public function exitWalk():void
		{
			_mc.stop();
			Starling.juggler.remove(_mc);
			removeChild(_mc);
		}
		
		//TWEEN HANDLERS
		private function onKickComplete():void
		{
			Starling.juggler.remove(_tween);
			_stateMachine.setState(WALK);
		}
		
		private function onWalkComplete():void
		{
			Starling.juggler.remove(_tween);
			_stateMachine.setState(FRONT);
		}
	}

} //END PACKAGE

import engine.ai.IState;
import view.gameObjects.Gorilla

class FrontStaticState implements IState
{
	private var _g:Gorilla;
	
	public function FrontStaticState(g:Gorilla)
	{
		_g = g;
	}
	
	public function enter():void { _g.enterFrontStatic(); }
	
	public function update():void { }
	
	public function exit():void {  }
	
	public function clear():void { _g = null; }
}

class FrontState implements IState
{
	private var _g:Gorilla;
	
	public function FrontState(g:Gorilla)
	{
		_g = g;
	}
	
	public function enter():void { _g.enterFront(); }
	
	public function update():void { _g.updateFront(); }
	
	public function exit():void { _g.exitFront(); }
	
	public function clear():void { _g = null; }
}

class BackState implements IState
{
	private var _g:Gorilla;
	
	public function BackState(g:Gorilla)
	{
		_g = g;
	}
	
	public function enter():void { _g.enterBack(); }
	
	public function update():void { _g.updateBack(); }
	
	public function exit():void { _g.exitBack(); }
	
	public function clear():void { _g = null; }
}

class RightState implements IState
{
	private var _g:Gorilla;
	
	public function RightState(g:Gorilla)
	{
		_g = g;
	}
	
	public function enter():void { _g.enterRight(); }
	
	public function update():void { _g.updateRight(); }
	
	public function exit():void { _g.exitRight(); }
	
	public function clear():void { _g = null; }
}

class LeftState implements IState
{
	private var _g:Gorilla;
	
	public function LeftState(g:Gorilla)
	{
		_g = g;
	}
	
	public function enter():void { _g.enterLeft(); }
	
	public function update():void { _g.updateLeft(); }
	
	public function exit():void { _g.exitRight(); }
	
	public function clear():void { _g = null; }
}

class KickState implements IState
{
	private var _g:Gorilla;
	
	public function KickState(g:Gorilla)
	{
		_g = g;
	}
	
	public function enter():void { _g.enterKick(); }
	
	public function update():void { _g.updateKick(); }
	
	public function exit():void { _g.exitKick(); }
	
	public function clear():void { _g = null; }
}

class WalkState implements IState
{
	private var _g:Gorilla;
	
	public function WalkState(g:Gorilla)
	{
		_g = g;
	}
	
	public function enter():void { _g.enterWalk(); }
	
	public function update():void { }
	
	public function exit():void { _g.exitWalk(); }
	
	public function clear():void { _g = null; }
}

















