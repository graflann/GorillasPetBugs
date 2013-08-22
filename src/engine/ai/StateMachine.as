package engine.ai 
{
	import view.gameObjects.GameObject;
	
	/**
	 * A simple finite state machine that manages various GameObject states
	 * Big ups to Lee Brimelow on his nice SM tutorial: http://gotoandlearn.com/play.php?id=155
	 * @author Grant Flannery
	 */
	public class StateMachine 
	{
		private var _arrStates:Array;
		
		private var _currentKey:String;
		
		private var _previousKey:String;
		
		private var _currentState:IState;
		
		public function StateMachine() 
		{
			_arrStates = [];
		}
		
		public function setState(key:String):void
		{
			//init
			if (!_currentKey)
			{
				_currentKey = key;
				_currentState = _arrStates[_currentKey].state;
				_currentState.enter();
				return;
			}
			
			//redundancy
			if (_currentKey == key)
			{
				trace("Attempting to go from " + _currentKey + " to " + key + "  is redundant.");
				return;
			}
			
			//to allowed
			if (_arrStates[_currentKey].to.indexOf(key) != -1)
			{
				_currentState.exit();
				
				_previousKey = _currentKey;
				_currentKey = key;
				
				_currentState =  _arrStates[_currentKey].state;
			}
			else //to disallowed
			{
				trace("Going from " + _currentKey + " to " + key + " is an invalid state change.");
				return;
			}
			
			//if a state change is valid, transition into the new IState...
			_currentState.enter();
		}
		
		public function addState(key:String, iState:IState, arrToStates:Array):void
		{
			_arrStates[key] = { state:iState, to:arrToStates.toString() };
		}
		
		public function update():void
		{
			//trace("CURRENT STATE KEY: " + _currentKey);
			if(_currentState)
				_currentState.update();
		}
		
		public function clear():void
		{
			for (var key:String in _arrStates)
			{
				_arrStates[key].state.clear();
				_arrStates[key] = null;
			}
			
			_arrStates = null;
			_currentState = null;
		}
		
		public function nullifyCurrent():void
		{
			_currentKey = null;
		}
	}

}