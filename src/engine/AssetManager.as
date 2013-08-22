package engine 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.media.Sound;
	import flash.system.*;
	
	import flash.utils.*;
	
	/**
	 * References classes by String within this application's current ApplicationDomain
	 * @author Grant Flannery
	 */
	public class AssetManager
	{
		/**
		 * 32-bit color with fully transparent alpha channel
		 */
		private static var TRANSPARENT_FILL:uint = 0x00FFFFFF;
		
		/**
		 * Place holder array for instances of BitmapData from ClassroomObject MovieClip instances
		 */
		private static var _arrBitmapData:Array;
		
		/**
		 * A vector of String instances that serve as associative array keys for BitmapData
		 */
		private static var _vecKeys:Vector.<String>;
		
		
		public static function init():void
		{
			_arrBitmapData = [];
			_vecKeys = new Vector.<String>();
		}
		
		/**
		 * Adds BitmapData to the cache by String
		 * @param	name
		 * @param	displayObject
		 * @param	w
		 * @param	h
		 * @param	tx
		 * @param	ty
		 */
		public static function addBitmapData(className:String, displayObject:DisplayObject, w:Number, h:Number, tx:Number = 0, ty:Number = 0, isTransparent:Boolean = true):Boolean
		{
			if (!_arrBitmapData[className])
			{
				
				_arrBitmapData[className] = new BitmapData(w, h, isTransparent, TRANSPARENT_FILL);
				
				//translated offsets (tx, ty) determine the upper-left coordinate of BitmapData instance's draw
				_arrBitmapData[className].draw(displayObject, new Matrix(1, 0, 0, 1, tx, ty));
				
				_vecKeys.push(className);
				
				//added to cache
				return true;
			}
			
			//already in cache so not added
			return false;
		}
		
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
		 * Returns instance of DisplayObject via String
		 * @param	className
		 * @return	DisplayObject
		 */
		public static function getInstance(className:String):DisplayObject
		{
			var c:Class = getDefinition(className);
			
			return new c();
		}
		
		/**
		 * Returns instance of MovieClip via String
		 * @param	clipName
		 * @return 	MovieClip
		 */
		public static function getClip(className:String):MovieClip
		{
			return getInstance(className) as MovieClip;
		}
		
		/**
		 * Return instance of SimpleButton via String
		 * @param	className
		 * @return	SimpleButton
		 */
		public static function getButton(className:String):SimpleButton
		{
			return getInstance(className) as SimpleButton;
		}
		
		/**
		 * Acquires relevant BitmapData from a MovieClip and returns a Bitmap instance via String
		 * @param	className
		 * @param	tx
		 * @param	ty
		 * @param	isTransparent
		 * @return
		 */
		public static function getBitmap(className:String, tx:Number = 0, ty:Number = 0, isTransparent:Boolean = true):Bitmap
		{
			var bm:Bitmap;
			var bmd:BitmapData;
			var mc:MovieClip;
			
			//check for existence of the BitmapData within the Array
			if (!_arrBitmapData[className])
			{
				mc = getClip(className);
				
				_arrBitmapData[className] = new BitmapData(mc.width, mc.height, isTransparent, TRANSPARENT_FILL);
				
				//translated offsets (tx, ty) determine the upper-left coordinate of BitmapData instance's draw
				_arrBitmapData[className].draw(mc, new Matrix(1, 0, 0, 1, tx, ty));
				
				_vecKeys.push(className);
			}
				
			bmd = _arrBitmapData[className] as BitmapData;
			
			mc = null;
			
			bm = new Bitmap(bmd, PixelSnapping.AUTO, true);
			return bm;
		}
		
		/**
		 * Acquires relevant BitmapData from a MovieClip and returns it via String
		 * @param	className
		 * @param	tx
		 * @param	ty
		 * @param	isTransparent
		 * @return
		 */
		public static function getBitmapData(className:String, tx:Number = 0, ty:Number = 0, isTransparent:Boolean = true):BitmapData
		{
			var bmd:BitmapData;
			var mc:MovieClip;
			
			//check for existence of the BitmapData within the Array
			if (!_arrBitmapData[className])
			{
				mc = getClip(className);
				
				_arrBitmapData[className] = new BitmapData(mc.width, mc.height, isTransparent, TRANSPARENT_FILL);
				
				//translated offsets (tx, ty) determine the upper-left coordinate of BitmapData instance's draw
				_arrBitmapData[className].draw(mc, new Matrix(1, 0, 0, 1, tx, ty));
				
				_vecKeys.push(className);
			}
				
			bmd = _arrBitmapData[className] as BitmapData;
			
			mc = null;
			
			return bmd;
		}
		
		/**
		 * Gets Bitmaps data from a DisplayObject instance with some validation for a MovieClip instance
		 * @param	displayObject
		 * @param	tx
		 * @param	ty
		 * @param	currentFrame
		 * @param	isTransparent
		 * @return
		 */
		public static function getBitmapDataFromDisplayObject(displayObject:DisplayObject, tx:Number = 0, ty:Number = 0, currentFrame:int = 0, isTransparent:Boolean = true):BitmapData
		{
			var bmd:BitmapData;
			var className:String = displayObject.name;
			
			if (displayObject is MovieClip && currentFrame <= 0)
			{
				throw new Error("Please include a valid frame in the currentFrame argument when using a MovieClip instance");
			}
			
			//so individual frames of movieclip can be added to className for addition to bmd array with a unique key name as needed
			if (currentFrame != 0)
				className += currentFrame.toString();
			
			//check for existence of the BitmapData within the Array
			if (!_arrBitmapData[className])
			{
				_arrBitmapData[className] = new BitmapData(displayObject.width, displayObject.height, isTransparent, TRANSPARENT_FILL);
				
				//translated offsets (tx, ty) determine the upper-left coordinate of BitmapData instance's draw
				_arrBitmapData[className].draw(displayObject, new Matrix(1, 0, 0, 1, tx, ty));
				
				_vecKeys.push(className);
			}
				
			bmd = _arrBitmapData[className] as BitmapData;
			
			return bmd;
		}
		
		/**
		 * Returns an instance of Sound via String
		 * @param	className
		 * @return	SimpleButton
		 */
		public static function getSound(className:String):Sound
		{
			var c:Class = getDefinition(className);
			
			return new c() as Sound;
		}
		
		/**
		 * Flushes a paricular BitmapData instance from the cache (Array instance)
		 * @param	bitmapDataKey
		 */
		public static function flushBitmapData(bitmapDataKey:String):Boolean
		{
			if (_arrBitmapData[bitmapDataKey])
			{
				_arrBitmapData[bitmapDataKey].dispose();
				
				_arrBitmapData[bitmapDataKey] = null;
				
				//call hard delete since an associative array is a dynamic object (unsealed Class...)
				delete _arrBitmapData[bitmapDataKey];
				
				for (var i:int = 0; i < _vecKeys.length; i++ )
				{
					if (bitmapDataKey == _vecKeys[i])
					{
						_vecKeys[i] = null;
						_vecKeys.splice(i, 1);
						break;
					}
				}
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Flushes the entire cache (Array instance) by disposing of all BitmapData element instances within and nullifing them
		 */
		public static function flushAllBitmapData():void
		{
			for (var i:int = 0; i < _vecKeys.length; i++ )
			{
				_arrBitmapData[_vecKeys[i]].dispose();
				_arrBitmapData[_vecKeys[i]] = null;
				
				//call hard delete since an associative array is a dynamic object (unsealed Class...)
				delete _arrBitmapData[_vecKeys[i]];
			}
			
			_arrBitmapData.length = 0;
			_vecKeys.length = 0;
		}
		
		/**
		 * Scales Bitmap param to a max of either w (width) or h(height) DisplayObjectContainer dimension params
		 * @param	w
		 * @param	h
		 * @param	bm
		 * @param	displayObjectContainer
		 */
		public static function scaleContainerToDims(w:Number, h:Number, bm:Bitmap, displayObjectContainer:DisplayObjectContainer):void
		{
			var scalarX:Number;
			var scalarY:Number;
			
			displayObjectContainer.addChild(bm);
			
			scalarX = w / displayObjectContainer.width;
			scalarY = h / displayObjectContainer.height;
			
			if (scalarX < scalarY)
			{
				displayObjectContainer.scaleX *= scalarX;
				displayObjectContainer.scaleY *= scalarX;
			}
			else
			{
				displayObjectContainer.scaleX *= scalarY;
				displayObjectContainer.scaleY *= scalarY;
			}
		}
	}
}