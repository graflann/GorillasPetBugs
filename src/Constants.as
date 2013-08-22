package  
{
	/**
	 * Global constants for events, properties, misc...
	 * @author Grant Flannery
	 */
	public class Constants
	{
		public static const GORILLAS_PET_BUGS:String = "GORILLA'S PET BUGS";
		
		//DIMENSIONS
		public static const WIDTH:uint 	= Main.instance.stage.stageWidth;
		public static const HEIGHT:uint = Main.instance.stage.stageHeight;
		public static const FPS:Number 	= Main.instance.stage.frameRate;
		
		//COLORS (24-bit)
		public static const BEIGE:uint 		= 0xC2B7A9;
		public static const GREEN:uint 		= 0x88FF88;
		public static const BLACK:uint		= 0x000000;
		public static const IVORY:uint 		= 0xF4F4F4;
		public static const WHITE:uint 		= 0xFFFFFF;
		public static const GRAY:uint		= 0xCCCCCC;
		public static const DARK_GRAY:uint 	= 0x797979;
		public static const RED:uint		= 0xFF0000;
		public static const YELLOW:uint 	= 0xFFFF00;
		public static const ORANGE:uint 	= 0xFF7700;
		
		//COLOR KEYS
		public static const BLUE_KEY:String 	= "blue";
		public static const GREEN_KEY:String 	= "green";
		public static const GREY_KEY:String 	= "grey";
		public static const RED_KEY:String 		= "red";
		public static const VIOLET_KEY:String 	= "violet";
		public static const YELLOW_KEY:String 	= "yellow";
		
		//DIRECTIONS
		public static const UP:String 		= "up";
		public static const DOWN:String 	= "down";
		public static const LEFT:String 	= "left";
		public static const RIGHT:String 	= "right";
		
		//BASIC UI EVENTS
		public static const START:String    				= "start";
		public static const RESET:String    				= "reset";
		public static const MASK_TWEEN_COMPLETE:String    	= "maskTweenComplete";
		public static const NEXT:String						= "next";
		public static const BACK:String						= "back";
		public static const SAVE:String						= "save";
		public static const CLOSE:String					= "close";
		public static const CLEAR:String					= "clear";
		public static const CONTINUE:String 				= "continue";
		public static const BEGIN:String   					= "begin";
		public static const DESTROY:String  				= "destroy";
		public static const PAUSE:String  					= "pause";
		public static const MUTE:String  					= "mute";
		
		public static const INTERACTION_COMPLETE:String 	= "interactionComplete"
		
		//MODAL EVENTS
		public static const INTRO:String		= "Intro";
		public static const HELP:String			= "Help";
		public static const PRINT:String		= "Print";
		public static const FINAL:String		= "Final";
		
		public static const TRANSITION_IN:String 	= "transitionIn";
		public static const TRANSITION_OUT:String 	= "transitionOut";
		
		public static const REMOVE_MODAL:String = "removeModal";
		
		//GAME EVENTS
		public static const UPDATE_SCORE:String 				= "updateScore";
		public static const UPDATE_INPUT_INC:String 			= "updateInputInc";
		public static const JAR_CRACKED:String 					= "jarCracked";
		public static const TRANSITION_HALF_COMPLETE:String 	= "transitionHalfComplete";
		public static const TRANSITION_COMPLETE:String 			= "transitionComplete";
		public static const STATUS_TEXT_CHANGE:String		    = "statusTextChange";
		public static const STARLING_STATUS_TEXT_CHANGE:String  = "starlingStatusTextChange";
		public static const START_GORILLA_KICK:String			= "startGorillaKick";
	}
}