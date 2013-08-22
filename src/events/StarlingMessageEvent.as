package events 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class StarlingMessageEvent extends Event 
	{
		public static const UPDATE_WEAPON_LEVEL:String = "updateWeaponLevel";
		
		public var message:Object;
		
		public function StarlingMessageEvent(type:String, value:Object, bubbles:Boolean = true) 
		{
			super(type, bubbles);
			
			message = value;
		}
	}

}