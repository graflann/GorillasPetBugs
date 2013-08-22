package  
{
	import flash.display.Stage;
	import flash.events.Event;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import controller.*;
	
	import engine.AssetManager;
	
	import view.mediators.*;
	
	import model.proxies.*;
	
	/**
	 * The hub of PureMVC framework
	 * @author Grant Flannery
	 */
	public class ApplicationFacade extends Facade 
	{
		//APPLICATION
		public static const STARTUP:String  			= "startUp";
		public static const INIT_APP:String				= "initializeApplication";
		public static const INIT_DATA:String			= "initializeData";
		public static const LOAD_LEVEL:String			= "loadLevel";
		public static const LEVEL_LOADED:String			= "levelLoaded";
		public static const GO_TO:String				= "goTo";
		public static const ADD_TRANSITION:String		= "addTransition";
		public static const REMOVE_TRANSITION:String	= "removeTransition";
		public static const ADD_TO_OVERLAY:String		= "addToStage";
		public static const DESTROY:String				= "destroy";
		
		//IMPLEMENTATION
		public static const RETRIEVE_DATA:String		= "retrieveData";
		public static const SET_INTERACTION_DATA:String = "setInteractionData";
		public static const DATA_LOAD_COMPLETE:String 	= "dataLoadComplete";
		public static const SAVE_HIGH_SCORE:String 		= "saveHighScore";

		//GAME
		public static const PAUSE:String 	= "pause";
		public static const MUTE:String 	= "mute";
		
		public static var isInited:Boolean = false;
		
		/**
		 * List of all Command names
		 */
		private static var _vecCommandNames:Vector.<String>;
		
		/**
		 * List of all Mediator names
		 */
		private static var _vecMediatorNames:Vector.<String>;
		
		/**
		 * List of all Proxy names
		 */
		private static var _vecProxyNames:Vector.<String>;
		
		public static function getInstance():ApplicationFacade
		{
			if (!instance) 
				instance = new ApplicationFacade();
				
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			initLists();
			
			super.initializeController();
			
			//APPLICATION
			registerCommand(STARTUP, StartUpCommand);
			registerCommand(INIT_DATA, InitDataCommand);
			
			registerCommand(RETRIEVE_DATA, RetrieveDataCommand);
			
			registerCommand(SET_INTERACTION_DATA, SetInteractionDataCommand);
			
			registerCommand(GO_TO, GoToCommand);
			registerCommand(ADD_TRANSITION, AddTransitionCommand);
			registerCommand(REMOVE_TRANSITION, RemoveTransitionCommand);
			
			registerCommand(DESTROY, DestructionCommand);
			
			//IMPLEMENTATION
			registerCommand(SAVE_HIGH_SCORE, SaveHighScoreCommand);
		}

		public function startup(stage:Object):void
		{
			sendNotification(STARTUP, stage);
		}
		
		public function destroy():void
		{
			var i:int = 0;
			var mediator:CustomMediator;
			
			for (i = 0; i < _vecCommandNames.length; i++ )
			{
				removeCommand(_vecCommandNames[i]);
			}
			
			for (i = 0; i < _vecMediatorNames.length; i++ )
			{
				mediator = retrieveMediator(_vecMediatorNames[i]) as CustomMediator;
				
				if (mediator)
				{
					mediator.clear();
					removeMediator(_vecMediatorNames[i]);
				}
			}
			
			for (i = 0; i < _vecProxyNames.length; i++ )
			{
				removeProxy(_vecProxyNames[i]);
			}
			
			_vecCommandNames.length = 0;
			_vecCommandNames = null;
			
			_vecMediatorNames.length = 0;
			_vecMediatorNames = null;
			
			_vecProxyNames.length = 0;
			_vecProxyNames = null;
			
			AssetManager.flushAllBitmapData();
			
			trace("DESTROYING...");
		}
		
		private function initLists():void
		{
			_vecCommandNames 	= new Vector.<String>();
			_vecMediatorNames 	= new Vector.<String>();
			_vecProxyNames 		= new Vector.<String>();
			
			//Command names
			_vecCommandNames.push(STARTUP);
			_vecCommandNames.push(INIT_DATA);
			_vecCommandNames.push(LOAD_LEVEL);
			_vecCommandNames.push(RETRIEVE_DATA);
			_vecCommandNames.push(SET_INTERACTION_DATA);
			_vecCommandNames.push(DESTROY);
			
			//Mediator names
			_vecMediatorNames.push(StageMediator.NAME);
			_vecMediatorNames.push(TitleMediator.NAME);
			_vecMediatorNames.push(PlayMediator.NAME);
			_vecMediatorNames.push(TransitionMediator.NAME);
			
			//Proxy names
			//_vecProxyNames.push(DataProxy.NAME);
			//_vecProxyNames.push(InteractionProxy.NAME);
		}
	}

}