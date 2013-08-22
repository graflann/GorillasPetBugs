package model.proxies 
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import model.vo.TransitionVO;
	
	import org.puremvc.as3.patterns.observer.Notification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import flash.events.NetStatusEvent;
	
	import engine.Score;
	
	/**
	 * Load / saves high score and caches data between various states
	 * @author Grant Flannery
	 */
	public class DataProxy extends Proxy implements IProxy
	{
		//CONSTANTS////////////////////////////////////////////////////////
		public static const NAME:String = "DataProxy";
	
		//SharedObject ID
		private static const SO_ID:String = "bugs";
		//////////////////////////////////////////////////////////
		
		public var transitionVO:TransitionVO;
		
		private var _so:SharedObject;

		
		public function DataProxy() 
		{
			super(NAME, new Object());
		}
		
		override public function getData():Object 
		{
			return null;
		}
		
		override public function onRegister():void 
		{
			transitionVO = new TransitionVO();
		}
		
		public function retrieveCookie():void
		{
			read();
			
			facade.notifyObservers(new Notification(ApplicationFacade.DATA_LOAD_COMPLETE));
		}
		
		/**
		 * Parses SharedObject data and populates master value objects
		 * @param	xml
		 */
		private function read():void
		{	
			_so = SharedObject.getLocal(SO_ID);
			
			//update high score if SharedObject available
			if (_so.data.highScore)
				Score.high = uint(_so.data.highScore);
		}
		
		/**
		 * Save the high score using shared object
		 */
		public function save():void
		{
			var flushStatus:String = null;
			
			_so = SharedObject.getLocal(SO_ID),
			_so.data.highScore = Score.high;
			
            try 
			{
                flushStatus = _so.flush(0x400); //set 1kb min
            } 
			catch (error:Error) 
			{
                throw new Error("Error...Could not write SharedObject to disk\n");
            }
		}
	}
}