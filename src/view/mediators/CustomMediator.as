package view.mediators 
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import starling.display.Sprite;
	
	/**
	 * extends Mediator functionality
	 * @author Grant Flannery
	 */
	public class CustomMediator extends Mediator implements IMediator
	{
		public function CustomMediator(mediatorName:String = null, viewComponent:Object = null) 
		{
			super(mediatorName, viewComponent);
		}
		
		public function clear(request:String = null):void { }
		
		public function setDataProvider(data:Object):void { }
	}

}