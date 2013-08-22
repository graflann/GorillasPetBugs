package controller 
{
	import model.proxies.DataProxy;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * Loads high score stuff
	 * @author Grant Flannery
	 */
	public class InitDataCommand extends SimpleCommand implements ICommand 
	{
		
		public function InitDataCommand() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			var dataProxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			dataProxy.retrieveCookie();
		}
	}

}