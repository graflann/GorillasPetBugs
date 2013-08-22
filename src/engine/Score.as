package engine 
{
	import view.gameObjects.BugContainer;
	import view.gameObjects.bugs.BugType;
	
	/**
	 * Global scoring object containing all related back-end scoring values
	 * @author Grant Flannery
	 */
	public class Score 
	{
		private static const BUG_VALUE:uint 			= 100;
		private static const MAX_MULTIPLIER:Number 		= 8;
		private static const INPUT_INC:uint 			= 10;
		private static const INPUT_INC_MOD:Number 		= 0.01;
		private static const BONUS_INC:uint 			= 32;
		private static const DESCENT_DELAY_MIN:Number 	= 200;
		private static const DESCENT_DELAY_MAX:Number 	= 1000;
		private static const DESCENT_DELAY_DEC:Number 	= (DESCENT_DELAY_MAX - DESCENT_DELAY_MIN) / DESCENT_DELAY_MAX;
		private static const DESCENT_DELAY_SLOW_THRESHOLD:Number = DESCENT_DELAY_MAX * 0.5;
		private static const DESCENT_DELAY_FAST_THRESHOLD:Number = DESCENT_DELAY_MIN * 2;
		
		private static var _sessionTotal:uint;
		public static function get sessionTotal():uint { return _sessionTotal; }
		
		private static var _high:uint = 0;
		public static function set high(value:uint):void 	{ _high = value; }
		public static function get high():uint 				{ return _high; }
		
		private static var _totalBugsRemoved:int;
		public static function get totalBugsRemoved():int { return _totalBugsRemoved; }
		
		private static var _totalBonusBugsRemoved:int;
		public static function get totalBonusBugsRemoved():int { return _totalBonusBugsRemoved; }
		
		private static var _sessionTotalBugsRemoved:int;
		
		private static var _currentRemovedValue:uint;
		public static function get currentRemovedValue():uint { return _currentRemovedValue; }
		
		private static var _multiplier:Number;
		public static function get multiplier():Number { return _multiplier; }
		
		/**
		 * Delay of BugContainer descent rate in ms
		 */
		private static var _descentDelay:Number;
		public static function get descentDelay():Number { return _descentDelay; }
		
		private static var _hasReachedDescentMin:Boolean;
		
		private static var _bonusColor:String;
		public static function get bonusColor():String { return _bonusColor; }
		
		private static var _bonusThreshold:uint;
		
		private static var _bonusToggle:Boolean;
		
		public static function init():void
		{
			//_high may be given new default value in DataProxy if shared object (xml high score) is avaiable
			
			_sessionTotal = 0;
			_multiplier = 1;
			_totalBugsRemoved = 0;
			_totalBonusBugsRemoved = 0;
			_sessionTotalBugsRemoved = 0;
			_currentRemovedValue = 0;
			_descentDelay = DESCENT_DELAY_MAX;
			
			_bonusColor = "";
			_bonusThreshold = BONUS_INC;
			
			_hasReachedDescentMin = false;
			
			_bonusToggle = false;
		}
		
		public static function update():void 
		{
			_sessionTotalBugsRemoved += _totalBugsRemoved;
			
			calculateMultiplier();
			
			_totalBugsRemoved += _totalBonusBugsRemoved;
			
			if (_descentDelay > DESCENT_DELAY_MIN)
			{
				_descentDelay -= (DESCENT_DELAY_DEC * _totalBugsRemoved);
				
				if (_descentDelay <= DESCENT_DELAY_MIN)
				{
					_descentDelay = DESCENT_DELAY_MIN;
					_hasReachedDescentMin = true;
				}
					
				trace("DESCENT DELAY: " + _descentDelay.toString());
			}
			
			_currentRemovedValue = BUG_VALUE * _totalBugsRemoved * _multiplier + (_sessionTotalBugsRemoved * _multiplier);
			
			trace("VALUE: " + _currentRemovedValue.toString() + ", REMOVED: " + _totalBugsRemoved.toString()  + ", SESSION REMOVED: " + _sessionTotalBugsRemoved.toString() + ", BONUS REMOVED: " + _totalBonusBugsRemoved.toString() + ", X:" + _multiplier.toString() );
			
			_sessionTotal += _currentRemovedValue;
			
			updateHighScore();
			updateBonus();
		}
		
		public static function incTotalBugsRemoved():void
		{
			_totalBugsRemoved++;
		}
		
		public static function incTotalBonusBugsRemoved():void
		{
			_totalBonusBugsRemoved++;
		}
		
		public static function resetRemovedBugs():void
		{
			_totalBugsRemoved = _totalBonusBugsRemoved = 0;
			calculateMultiplier();
		}
		
		public static function incTotalByInput():void
		{
			_sessionTotal += int(INPUT_INC + (_sessionTotalBugsRemoved * INPUT_INC_MOD));
			
			updateHighScore();
		}
		
		private static function calculateMultiplier():void
		{
			if (_totalBugsRemoved > BugContainer.MAX_BUGS)
			{				
				_multiplier = _totalBugsRemoved - (BugContainer.MAX_BUGS - 1);
			}
			else
			{
				_multiplier = 1;
			}
		}
		
		private static function updateHighScore():void
		{
			//update the hi-score too
			if (_high < _sessionTotal)
				_high = _sessionTotal;
		}
		
		private static function updateBonus():void
		{
			if (_sessionTotalBugsRemoved >= _bonusThreshold)
			{
				if (!_bonusToggle)	
				{
					_bonusColor = BugType.getOption(Utils.randomInRange(0, 5));
					
					//once reached the min descent delay the delay is throttled back give the player more time during bonus
					if (_hasReachedDescentMin && _descentDelay <= DESCENT_DELAY_SLOW_THRESHOLD)
					{
						_descentDelay *= 2;
					}
				}
				else	
				{
					_bonusColor = "";
					
					//once reached the min descent delay is throttled up give the player less time during non-bonus
					if (_hasReachedDescentMin && _descentDelay >= DESCENT_DELAY_FAST_THRESHOLD)
					{
						_descentDelay *= 0.5;
					}
				}
					
				_bonusThreshold += BONUS_INC;
				
				_bonusToggle = !_bonusToggle;
			}
		}
	}

}