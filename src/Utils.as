package
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	/**
	 * Basic additional math / conversion utils for rand, sorts, etc.
	 */
	public class Utils
	{	
		/**
		 * Returns Class within current ApplicationDomain via String
		 * @param	className
		 * @return	Class
		 */
		public static function getDefinition(className:String):Class
		{
			return ApplicationDomain.currentDomain.getDefinition(className) as Class;
		}
		
		/**
		 * Takes the local coordinates of one display object and converts it into local coordiantes for another
		 * @return
		 */
		public static function getLocalPt(displayObject1:DisplayObject, displayObject2:DisplayObject, pt:Point = null):Point
		{
			if (pt)	return displayObject1.globalToLocal(displayObject2.localToGlobal(new Point(pt.x, pt.y)));
			else	return displayObject1.globalToLocal(displayObject2.localToGlobal(new Point(displayObject2.x, displayObject2.y)));
		}
		
		/**
		 * Custom random sort
		 * @param	a 		Object
		 * @param	b 		Object
		 * @param	fields	Array
		 * @return			int
		 */
		public static function randomCompare(a:Object, b:Object, fields:Array = null):int 
		{			
			return randomInRange(-1, 1);
		}
		
		/**
		 * Randomly generates a number within a range
		 * @param	min		Number
		 * @param	max		Number
		 * @return			Number
		 */
		public static function randomInRange(min:Number, max:Number):Number 
		{
			return Math.round(Math.random() * (max - min)) + min;
		}
		
		/**
		 * Returns a random boolean
		 * @return
		 */
		public static function randomBool():Boolean 
		{
			var rand:Number = Math.random();
			
			if(rand <= 0.5) 	return true; 
			else				return false;
		}
		
		/**
		 * Converts degrees to radians
		 * @param	deg	Number
		 * @return		Number
		 */
		public static function degToRad(deg:Number):Number
		{
			var rad:Number = deg * (Math.PI / 180);
			return rad;
		}
		
		/**
		 * Converts radians to degrees
		 * @param	rad	Number
		 * @return		Number
		 */
		public static function radToDeg(rad:Number):Number
		{
			var deg:Number = rad * (180 / Math.PI);
			return deg;
		}
		
		/**
		 * Converts string to bool
		 * @param	value	String
		 * @return			Boolean
		 */
		public static function stringToBool(value:String):Boolean
		{
			switch(value) 
			{
			case "1":
			case "true":
			case "yes":
				return true;
			case "0":
			case "false":
			case "no":
				return false;
			default:
				return Boolean(value);
			}
		}
		
		/**
		 * Creates a deep copy of an object
		 */
		public static function clone(source:Object):* 
		{
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return(copier.readObject());
		}
	}
}