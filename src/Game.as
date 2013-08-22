
package  
{
	import assets.AssetManager;
	import engine.Input;
	import engine.KeyboardEx;
	import engine.SoundManager;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import org.puremvc.as3.patterns.observer.Notification;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import view.mediators.StageMediator;
	import view.panels.PlayPanel;
	
	/**
	 * Primary Starling Game container
	 * @author Grant Flannery
	 */
	public class Game extends Sprite 
	{	
		/**
		 * A static reference to this (and only this) instance of Main
		 */
		private static var _instance:Game = null;
		public static function get instance():Game { return _instance; }
		
		private static var _input:Input;
		public function get input():Input { return _input; }
		
		//Game timer vars
		private static const FRAME_RATE:int = 30;
		private static const FRAME_DELAY:Number = 1000 / FRAME_RATE;
		
		private static var _frameTimer:Timer;
		private var _beforeTime:int = 0;
		private var _afterTime:int = 0;
		private var _timeDiff:int = 0;
		private var _sleepTime:int = 0;
		private var _overSleepTime:int = 0;
		private var _excess:int = 0;
		
		public function Game() 
		{
			_instance = this;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			init();
		}
		
		private function init():void
		{
			_input = new Input();
		
			//init AssetManager / SoundManager
			AssetManager.init();
			SoundManager.init();
			
			Main.instance.facade.notifyObservers(new Notification(ApplicationFacade.INIT_APP));
			Main.instance.initUpdate();

			//addEventListener(Event.ENTER_FRAME, update);
			
			//init timer
			//_frameTimer = new Timer(FRAME_DELAY, 1);
			//_frameTimer.addEventListener(TimerEvent.TIMER, run);
			//_frameTimer.start();
		}
		
		//public function update():void
		//{
			//trace("UPDATING");
			//
			//if(_stageMediator.currentPanel && !_isPaused)
				//_stageMediator.currentPanel.update();
				//
			///*
			//INPUT UTILS (PAUSE / MUTE / ETC.)
			//toggle pause
			//if (_input.isKeyDown(KeyboardEx.P) && !_input.isPrevKeyDown(KeyboardEx.P))
			//{
				//if(_stageMediator.currentPanel is PlayPanel)
					//togglePause();
			//}
			//
			//toggle music
			//if (_input.isKeyDown(KeyboardEx.M) && !_input.isPrevKeyDown(KeyboardEx.M))
			//{
				//if(_stageMediator.currentPanel is PlayPanel)
					//SoundManager.toggleMute()
			//}
			//
			//_input.checkPrevKeyDown([KeyboardEx.P, KeyboardEx.M]);
			//*/
		//}
		//
		private function clear():void
		{
			removeChildren();
			removeEventListeners();
			
			_input.clear();
			_input = null;
		}
		
		private function run(e:TimerEvent):void
		{
			//note: I DID NOT create this sleep timer ()
			_beforeTime = getTimer();
            _overSleepTime = (_beforeTime - _afterTime) - _sleepTime;
			
			//update();
			
			_afterTime = getTimer();
            _timeDiff = _afterTime - _beforeTime;
            _sleepTime = (FRAME_DELAY - _timeDiff) - _overSleepTime;
			
            if (_sleepTime <= 0) 
			{
                _excess -= _sleepTime
                _sleepTime = 2;
            }        
			
			_frameTimer.reset();
            _frameTimer.delay = _sleepTime;
            _frameTimer.start();
			
			while (_excess > FRAME_DELAY) 
			{
				//update();
				_excess -= FRAME_DELAY;
            }
			
			e.updateAfterEvent();
		}
	}
}