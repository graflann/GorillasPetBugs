package view.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField
	
	import assets.AssetManager;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * Offers general status information to player during play (Ready? Go!, Game Over,etc.)
	 * @author Grant Flannery
	 */
	public class StatusComponent extends Sprite 
	{
		public static const BACKGROUND_OFFSET:Point = new Point(-4, 2);
		
		public static const READY:String 		= "READY?";
		public static const GO:String 			= "GO!";
		public static const GAME_OVER:String 	= "GAME OVER";
		public static const ONE_MOMENT:String 	= "ONE MOMENT...";
		public static const PAUSED:String 		= "PAUSED";
		public static const PRESS_SPACE_TO_RESTART:String 	= "PRESS SPACE TO RESTART";
		
		private var _statusText:TextField;
		private var _subText:TextField;
		
		private var _timer:Timer;
		
		public function StatusComponent() 
		{			
			
		}
		
		public function init():void
		{
			_statusText = new TextField();
			_statusText.embedFonts = true;
			_statusText.defaultTextFormat = AssetManager.getTextFormat(FontName.AXI_5X5_BLACK_LARGE);
			_statusText.mouseEnabled = false;
			
			_subText = new TextField();
			_subText.embedFonts = true;
			_subText.defaultTextFormat = AssetManager.getTextFormat(FontName.AXI_5X5_BLACK);
			_subText.mouseEnabled = false;
			
			_subText.text = PRESS_SPACE_TO_RESTART;
			_subText.autoSize = TextFieldAutoSize.CENTER;
			
			_timer = new Timer(0, 1);
			
			addChild(_statusText);
		}
		
		public function setText(text:String):void
		{
			graphics.clear();
			
			_statusText.text = text;
			_statusText.autoSize = TextFieldAutoSize.CENTER;
			_statusText.x = 0;
			_statusText.y = _statusText.height * 0.25;
			
			graphics.beginFill(0xC8C8B0, 1);
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.drawRoundRect(BACKGROUND_OFFSET.x, BACKGROUND_OFFSET.y, _statusText.width, _statusText.height, 16, 16);
			graphics.endFill();
			
			if (text == GAME_OVER)
			{
				_subText.x = (_statusText.width * 0.5) - (_subText.width * 0.5);
				_subText.y = _statusText.height * 0.73;
			
				addChild(_subText);
				
				_statusText.y -= 8;
			}
		}
		
		public function getText():String
		{
			return _statusText.text;
		}
		
		public function setTimedStatus(text:String, delay:Number):void
		{
			setText(text);
			
			_timer.delay = delay;
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			_timer.start();
		}
		
		public function clear():void
		{
			removeChildren();
			
			graphics.clear();
			
			if (_timer.running)
			{
				_timer.stop();
			}
			
			_timer = null;
			
			_statusText = null;
			_subText = null;
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			dispatchEvent(new Event(Constants.STATUS_TEXT_CHANGE, true));
		}
	}
}