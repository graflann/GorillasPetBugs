package view.components 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import view.gameObjects.bugs.Bug;
	import starling.textures.Texture;
	import view.gameObjects.bugs.BugType;
	
	/**
	 * Funky transition using Bug instances
	 * @author Grant Flannery
	 */
	public class TransitionComponent extends Sprite 
	{
		private static const DELAY:Number = 1000 / 60;
		private static const TOTAL_UNITS:Point = new Point((Constants.WIDTH / GridComponent.UNIT), (Constants.HEIGHT / GridComponent.UNIT));
		private static const MAX_UNITS:Point = new Point(TOTAL_UNITS.x / 3, TOTAL_UNITS.y / 2);
		private static const TOTAL_TICKS:int = MAX_UNITS.x * MAX_UNITS.y;
		private static const TOTAL_BUGS:int = TOTAL_UNITS.x * TOTAL_UNITS.y;
		private static const OFFSET:Point = new Point(Constants.WIDTH / 3, Constants.HEIGHT * 0.5);
		
		public var isFullTransition:Boolean;
		
		private var _vecBugs:Vector.<Bug>;
		
		private var _background:Image;
		
		private var _bugIndex:int;
		
		private var _timer:Timer;
		
		private var _position:Point;
		private var _currentUnits:Point;
		private var _horiUnits:Point;
		private var _vertUnits:Point;
		
		private var _directionKey:String;
		private var _arrDirectionFunctions:Array;
		
		public function TransitionComponent() 
		{
			
		}
		
		public function init():void
		{
			var i:int = -1, j:int;
			var bmd:BitmapData = new BitmapData(Constants.WIDTH, Constants.HEIGHT, true, 0xFFC8C8B0);
			var optionValue:int = 0;
			var bug:Bug;
			
			bmd.draw(bmd);
			_background = new Image(Texture.fromBitmapData(bmd, false));
			addChild(_background);
			
			_vecBugs = new Vector.<Bug>();
			
			i = -1;
			while (++i < TOTAL_BUGS)
			{
				bug = new Bug(BugType.getOption(optionValue));
				bug.init();
				bug.stopAnimation();
				
				_vecBugs.push(bug);
				
				++optionValue
				
				if (optionValue > 5)
					optionValue = 0;
			}
			
			_bugIndex = 0;
			
			_position 	= new Point();
			_currentUnits = new Point();
			_horiUnits 	= new Point(0, MAX_UNITS.x - 1);
			_vertUnits 	= new Point(1, MAX_UNITS.y - 1);
			
			_directionKey = Constants.RIGHT;
			
			_arrDirectionFunctions = [];
			_arrDirectionFunctions[Constants.UP] 	= upFunction;
			_arrDirectionFunctions[Constants.RIGHT] = rightFunction;
			_arrDirectionFunctions[Constants.DOWN] 	= downFunction;
			_arrDirectionFunctions[Constants.LEFT] 	= leftFunction;
			
			//setPositions
			i = -1;
			while (++i < TOTAL_TICKS)
			{
				j = -1;
				while (++j < 6)
				{
					var tempIndex:int = 0;
					
					_vecBugs[i].x = _position.x;
					_vecBugs[i].y = _position.y;
					addChild(_vecBugs[i]);
					
					tempIndex = i + (TOTAL_BUGS / 6);
					_vecBugs[tempIndex].x = _position.x + OFFSET.x;
					_vecBugs[tempIndex].y = _position.y;
					addChild(_vecBugs[tempIndex]);
					
					tempIndex = i + (TOTAL_BUGS / 3);
					_vecBugs[tempIndex].x = _position.x + (OFFSET.x << 1);
					_vecBugs[tempIndex].y = _position.y;
					addChild(_vecBugs[tempIndex]);
					
					tempIndex = i + (TOTAL_BUGS / 2);
					_vecBugs[tempIndex].x = _position.x;
					_vecBugs[tempIndex].y = _position.y + OFFSET.y;
					addChild(_vecBugs[tempIndex]);
					
					tempIndex = i + (TOTAL_BUGS * 2 / 3);
					_vecBugs[tempIndex].x = _position.x + OFFSET.x;
					_vecBugs[tempIndex].y = _position.y + OFFSET.y;
					addChild(_vecBugs[tempIndex]);
					
					tempIndex = i + (TOTAL_BUGS * 5 / 6);
					_vecBugs[tempIndex].x = _position.x + (OFFSET.x << 1);
					_vecBugs[tempIndex].y = _position.y + OFFSET.y;
					addChild(_vecBugs[tempIndex]);
				}
				
				_arrDirectionFunctions[_directionKey]();
			}
			
			isFullTransition = false;
			
			_timer = new Timer(DELAY, TOTAL_TICKS);
			_timer.addEventListener(TimerEvent.TIMER, onTimerOut, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			_timer.start();
		}
		
		public function clear():void
		{	
			var i:int = -1;
			
			removeChildren();
			
			if (_timer.running)
			{
				_timer.stop();
			}
			
			_timer.removeEventListener(TimerEvent.TIMER, onTimerIn);
			_timer.removeEventListener(TimerEvent.TIMER, onTimerOut);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			_timer = null;
			
			while (++i < _vecBugs.length)
			{
				_vecBugs[i].clear();
				_vecBugs[i] = null;
			}
			
			_vecBugs.length = 0;
			_vecBugs = null;

			_background.dispose();
			_background = null;
			
			_position = null;
			_currentUnits = null;
			_horiUnits = null;
			_vertUnits = null;

			_arrDirectionFunctions = null;
		}
		
		public function transitionIn():void
		{
			_timer = null;
			
			isFullTransition = true;
			
			_bugIndex = 0;
			addChild(_background);
			
			_timer = new Timer(DELAY, TOTAL_TICKS);
			_timer.addEventListener(TimerEvent.TIMER, onTimerIn, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			_timer.start();
		}
		
		public function transitionOut():void
		{
			_timer = null;
			
			isFullTransition = false;
			
			_bugIndex = 0;
			//addChild(_background);
			
			_timer = new Timer(DELAY, TOTAL_TICKS);
			_timer.addEventListener(TimerEvent.TIMER, onTimerOut, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			_timer.start();
		}
		
		private function addBugs():void
		{
			var i:int = -1;
			while (++i < 6)
			{
				var tempIndex:int = 0;
				
				addChild(_vecBugs[_bugIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS / 6);
				addChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS / 3);
				addChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS / 2);
				addChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS * 2 / 3);
				addChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS * 5 / 6);
				addChild(_vecBugs[tempIndex]);
			}
			
			++_bugIndex;
		}
		
		private function removeBugs():void
		{
			var i:int = -1;
			while (++i < 6)
			{
				var tempIndex:int = 0;
				
				removeChild(_vecBugs[_bugIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS / 6);
				removeChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS / 3);
				removeChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS / 2);
				removeChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS * 2 / 3);
				removeChild(_vecBugs[tempIndex]);
				
				tempIndex = _bugIndex + (TOTAL_BUGS * 5 / 6);
				removeChild(_vecBugs[tempIndex]);
			}
			
			++_bugIndex;
		}
		
		private function upFunction():void
		{
			_currentUnits.y--;
				
			if (_currentUnits.y == _vertUnits.x)
			{
				_vertUnits.x++;
				_directionKey = Constants.RIGHT;
				
				_position.x = GridComponent.UNIT * ((int)(_currentUnits.x));
			}
			_position.y = GridComponent.UNIT * ((int)(_currentUnits.y));
		}
		
		private function rightFunction():void
		{
			_currentUnits.x++;
				
			if (_currentUnits.x == _horiUnits.y)
			{
				_horiUnits.y--;
				_directionKey = Constants.DOWN;
				
				_position.y = GridComponent.UNIT * ((int)(_currentUnits.y));
			}

			_position.x = GridComponent.UNIT * ((int)(_currentUnits.x));
		}
		
		private function downFunction():void
		{
			_currentUnits.y++;
				
			if (_currentUnits.y == _vertUnits.y)
			{
				_vertUnits.y--;
				_directionKey = Constants.LEFT;
				
				_position.x = GridComponent.UNIT * ((int)(_currentUnits.x));
			}

			_position.y = GridComponent.UNIT * ((int)(_currentUnits.y));
		}
		
		private function leftFunction():void
		{
			_currentUnits.x--;
				
			if (_currentUnits.x == _horiUnits.x)
			{
				_horiUnits.x++;
				_directionKey = Constants.UP;
				
				_position.y = GridComponent.UNIT * ((int)(_currentUnits.y));
			}

			_position.x = GridComponent.UNIT * ((int)(_currentUnits.x));
		}
		
		//EVENT HANDLERS
		private function onTimerIn(e:TimerEvent):void
		{
			addBugs();
		}
		
		private function onTimerOut(e:TimerEvent):void
		{
			removeBugs();
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			if (isFullTransition)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTimerIn);
				dispatchEvent(new Event(Constants.TRANSITION_HALF_COMPLETE, true));
				transitionOut();
			}
			else
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTimerOut);
				dispatchEvent(new Event(Constants.TRANSITION_COMPLETE, true));
			}
		}
	}

}