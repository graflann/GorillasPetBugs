package engine
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * May 7th
	 * 
	 * @author Jordan Shiba
	 * @usage Class that will handle all keyboard and mouse inputs
	 */
	
	public class Input
	{
		//Member variables
		private var _vecKeyDown:Vector.<Boolean>;
		private var _vecPrevKeyDown:Vector.<Boolean>;
		private var _mouseDown:Boolean;
		
		/**
		 * CTOR
		 * 
		 */ 
		public function Input() 
		{
			init();
		}
		
		public function clear():void
		{
			Main.instance.stage.removeEventListener(Event.ACTIVATE, activateWindow);
			Main.instance.stage.removeEventListener(Event.DEACTIVATE, deactivateWindow);
			
			if(Main.instance.stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				Main.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			if(Main.instance.stage.hasEventListener(KeyboardEvent.KEY_UP))
				Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			
			//_vecKeyDown.length = 0;
			_vecKeyDown = null;
			
			//_vecPrevKeyDown.length = 0;
			_vecPrevKeyDown = null;
		}
		
		/**
		 * Initialise 
		 */
		private function init():void
		{
			//Init the vector with 256 key numbers
			_vecKeyDown = new Vector.<Boolean>(256);
			_vecKeyDown.fixed = true;
			
			_vecPrevKeyDown = new Vector.<Boolean>(256);
			_vecPrevKeyDown.fixed = true;
			
			//Set the mouse down to false
			_mouseDown = false;
			
			//Set up the listeners for keyboard and mouse input
			Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
			Main.instance.stage.addEventListener(Event.ACTIVATE, activateWindow, false, 0, true);
			Main.instance.stage.addEventListener(Event.DEACTIVATE, deactivateWindow, false, 0, true);
		}
		
		/**
		 * When the flash play gains OS focus
		 * @param	e Event
		 */
		private function activateWindow(e:Event):void
		{
			_vecKeyDown = new Vector.<Boolean>(256);
			
			_mouseDown = false;
			
			Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
		}
		
		/**
		 * When the flash player loses OS focus
		 * @param	e Event
		 */
		private function deactivateWindow(e:Event):void
		{						
			Main.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		/**
		 * Is the key passed in down or up
		 * 
		 * @param	keyCode uint of the ascii character code for a character
		 * @return  Boolean whether the key is pressed down or not
		 */
		public function isKeyDown(keyCode:uint):Boolean
		{
			return _vecKeyDown[keyCode];
		}
		
		
		/**
		 * Is the key passed in down or up
		 * 
		 * @param	keyCode uint of the ascii character code for a character
		 * @return  Boolean whether the key is pressed down or not
		 */
		public function isPrevKeyDown(keyCode:uint):Boolean
		{
			return _vecPrevKeyDown[keyCode];
		}
		
		/**
		 * Is the left mouse button being pressed down
		 * 
		 * @return Boolean whether the mouse is down or not
		 */
		public function isMouseDown():Boolean
		{
			return _mouseDown;
		}
		
		/**
		 * 
		 * @param	keyCodes
		 */
		public function checkPrevKeyDown(keyCodes:Array):void
		{
			var keyCode:uint;
			
			for each(keyCode in keyCodes)
			{
				_vecPrevKeyDown[keyCode] = _vecKeyDown[keyCode];
			}
		}
		
		/**
		 * Keydown Event
		 * 
		 * @param	e KeyboardEvent
		 */
		private function keyDown(e:KeyboardEvent):void
		{
			_vecKeyDown[e.keyCode] = true;
		}
		
		/**
		 * Key Up Event
		 * 
		 * @param	e KeyboardEvent
		 */
		private function keyUp(e:KeyboardEvent):void
		{
			_vecKeyDown[e.keyCode] = false;
		}
		
		/**
		 * Mouse Down Event
		 * 
		 * @param	e MouseEvent
		 */
		private function mouseDown(e:MouseEvent):void
		{
			//Set mouse down to true;
			_mouseDown = true;
		}
		
		/**
		 * Mouse Up Event
		 * 
		 * @param	e MouseEvent
		 */
		private function mouseUp(e:MouseEvent):void
		{
			//Set mouse down to false
			_mouseDown = false;
		}
		
	}

}