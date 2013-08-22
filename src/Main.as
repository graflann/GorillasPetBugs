package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	import view.mediators.StageMediator;
	import view.panels.PlayPanel;
	
	import engine.ClassAliasRegistration;
	import engine.AssetManager;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import engine.SoundManager;
	
	import engine.KeyboardEx;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class Main extends Sprite 
	{
		/**
		 * A static reference to this (and only this) instance of Main
		 */
		private static var _instance:Main = null;
		public static function get instance():Main { return _instance; }
		
		/**
		 * A static ref to Starling's native overlay, a flash.display.Sprite that renders "above" all Starling/Stage3D objects;
		 * flash.display.* instances are added as children to this instance
		 */
		private static var _nativeOverlay:Sprite;
		public static function get nativeOverlay():Sprite { return Starling.current.nativeOverlay; }
		
		/**
		 * Reference to PureMVC facade / framework hub
		 */
		private var _facade:ApplicationFacade;
		public function get facade():ApplicationFacade	{ return _facade; }
		
		private var _starling:Starling;
		public function get starling():Starling { return _starling; }
		
		private static var _isPaused:Boolean;
		public static function get isPaused():Boolean { return _isPaused; }
		
		private var _stageMediator:StageMediator;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function initUpdate():void
		{
			_stageMediator = _facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_isPaused = false;
			
			_instance = this;
			_instance.stage.addEventListener(Constants.DESTROY, onDestroy, false, 0, true);
			
			ClassAliasRegistration.register();
			AssetManager.init();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_starling = new Starling(Game, stage);
			//_starling = new Starling(Game, stage, null, null, Context3DRenderMode.SOFTWARE);
			_starling.antiAliasing = 0;
				
			//Create the application instance and set the stage
			_facade = ApplicationFacade.getInstance();
			_facade.startup(stage);
		}
		
		private function update(e:Event):void
		{
			if (_stageMediator.currentPanel && !_isPaused)
			{
				_stageMediator.currentPanel.update();
			}
			
			//INPUT UTILS (PAUSE / MUTE / ETC.)
			if (_stageMediator.currentPanel is PlayPanel)
			{
				var playPanel:PlayPanel = _stageMediator.currentPanel as PlayPanel;
				
				if (playPanel.isAuxiliaryInputEnabled) //auxiliary input is the user's ability to control support stuff e.g. pause / mute
				{
					//toggle pause 
					if (Game.instance.input.isKeyDown(KeyboardEx.P) && !Game.instance.input.isPrevKeyDown(KeyboardEx.P))
					{
						togglePause();
					}
					
					//toggle mute
					if (Game.instance.input.isKeyDown(KeyboardEx.M) && !Game.instance.input.isPrevKeyDown(KeyboardEx.M))
					{
						SoundManager.toggleMute();
						_facade.sendNotification(ApplicationFacade.MUTE, SoundManager.isMuted);
					}
					
					Game.instance.input.checkPrevKeyDown([KeyboardEx.P, KeyboardEx.M]);
				}
			}
		}
		
		private function togglePause():void
		{
			_isPaused = !_isPaused;
			
			if (_isPaused) 
			{
				SoundManager.pauseAll();
				starling.stop();
				
				trace("STOP");
			}
			else
			{
				SoundManager.resumeAll();
				starling.start();
				
				trace("START");
			}
			
			_facade.sendNotification(ApplicationFacade.PAUSE, _isPaused);
		}
		
		private function onDestroy(e:Event):void
		{
			_instance.stage.removeEventListener(Constants.DESTROY, onDestroy);
			
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			
			_instance.stage.dispatchEvent(new Event(Constants.INTERACTION_COMPLETE, true));
			
			ApplicationFacade.getInstance().destroy();
		}
	}
	
}