package view.gameObjects.bugs 
{
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class BugType 
	{
		public static const QUALIFIED_PATH:String 					= "view.gameObjects.jars.";
		public static const RUNTIME_QUALIFIED_PATH:String 			= "view.gameObjects.jars::";
		
		public static const NONE:String			= "none";
		public static const RED:String 			= "red";
		public static const BLUE:String 		= "blue";
		public static const YELLOW:String		= "yellow";
		public static const GREEN:String 		= "green";
		public static const GREY:String 		= "grey";
		public static const VIOLET:String 		= "violet";
		
		private static const OPTIONS:Array 	= 	[RED,
												BLUE,
												YELLOW,
												GREEN,
												GREY,
												VIOLET];
												
		private static const DESCRIPTIONS:Array 	= 	["SCARLET LADY",
														"COBALT TARANTULA",
														"GOLDEN SCARAB",
														"VIRIDIAN MOTH",
														"BLACK ANT",
														"IANTHINE FLY"];
														
		public static const MAX:int = OPTIONS.length - 1;
															
		public static function getOption(index:int):String
		{
			return OPTIONS[index] as String;
		}
		
		public static function getDescription(index:int):String
		{
			return DESCRIPTIONS[index] as String;
		}
	}

}