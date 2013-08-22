package controller 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	//import model.proxies.DataProxy;
	//import model.proxies.InteractionProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class SetInteractionDataCommand extends SimpleCommand implements ICommand 
	{
		
		public function SetInteractionDataCommand() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{

		}
	}

}