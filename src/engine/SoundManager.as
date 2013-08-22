package engine 
{
	import flash.events.Event;
	import flash.media.*;
	import assets.AssetManager;
	
	/**
	 * Handles lib referenced Sound classes
	 * @author Grant Flannery
	 */
	public class SoundManager 
	{
		/**
		 * Member Soundchannel instance
		 */
		private static var _arrSoundChannels:Array;
		
		/**
		 * Caches sound positions for resuming from pause
		 */
		private static var _arrSoundPositions:Array;
		
		/**
		 * SoundTransform for manipulating channels
		 */
		private static var _soundTransform:SoundTransform;
		
		/**
		 * Mute toggle
		 */
		private static var _isMuted:Boolean;
		public static function get isMuted():Boolean { return _isMuted; }
		
		/**
		 * Init static SoundChannel instance
		 */
		public static function init():void
		{
			_arrSoundChannels = [];
			
			_arrSoundPositions = [];

			_soundTransform = new SoundTransform();
			
			_isMuted = false;
		}
		
		public static function clear():void
		{
			for (var key:String in _arrSoundChannels)
			{
				_arrSoundChannels[key].stop();
				
				if (_arrSoundChannels[key].hasEventListener(Event.SOUND_COMPLETE))
					_arrSoundChannels[key].removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
					
				_arrSoundChannels[key] = null;
				delete _arrSoundChannels[key];
			}
			
			_arrSoundChannels = null;
		}
		
		public static function play(name:String):void
		{
			_arrSoundChannels[name] = assets.AssetManager.getSound(name).play(0, 0, _soundTransform);
			
			_arrSoundChannels[name].addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
		}
		
		public static function stop(name:String):void
		{
			if (_arrSoundChannels[name].hasEventListener(Event.SOUND_COMPLETE))
				_arrSoundChannels[name].removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
					
			_arrSoundChannels[name].stop();	
		}
		
		public static function changeVolume(value:Number):void
		{
			var key:String;
			
			_soundTransform.volume = value;
			
			for (key in _arrSoundChannels)
			{
				_arrSoundChannels[key].soundTransform = _soundTransform;
			}
		}
		
		public static function pauseAll():void
		{
			var key:String;
			
			if (!_isMuted)
			{
				for (key in _arrSoundChannels)
				{
					_arrSoundPositions[key] = _arrSoundChannels[key].position;
					_arrSoundChannels[key].stop();
				}
			}
		}
		
		public static function resumeAll():void
		{
			var key:String,
			position:Number;
			
			if (!_isMuted)
			{
				for (key in _arrSoundChannels)
				{
					position = _arrSoundPositions[key];
					
					if (position > 0)
					{
						_arrSoundChannels[key] = assets.AssetManager.getSound(key).play(position);
					}
				}
			}
		}
		
		public static function toggleMute():void
		{
			_isMuted = !_isMuted;
			
			(_isMuted) ? SoundManager.changeVolume(0) : SoundManager.changeVolume(1);
		}
		
		//EVENT HANDLING
		private static function onSoundComplete(e:Event):void
		{
			var soundChannel:SoundChannel = e.target as SoundChannel;
			
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			soundChannel.stop();
			
			if (soundChannel == _arrSoundChannels[SoundName.MUSIC])
			{
				play(SoundName.MUSIC);
			}
		}
	}

}