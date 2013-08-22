package events 
{
	import flash.events.Event;
	
	/**
	 * Event that may contain a generic payload delivery
	 * @author Grant Flannery
	 */
	public class MessageEvent extends Event 
	{
		public var message:Object;
		
		public function MessageEvent(type:String, value:Object, bubbles:Boolean = true, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
			message = value;
		}
		
	}

}