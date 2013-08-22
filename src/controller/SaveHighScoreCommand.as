package controller 
{
	import model.proxies.DataProxy;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * Saves the high score using a shared object / cookie
	 * @author Grant Flannery
	 */
	public class SaveHighScoreCommand extends SimpleCommand implements ICommand 
	{
		
		public function SaveHighScoreCommand() 
		{
			super();
		}
		

		override public function execute(notification:INotification):void 
		{
			var dataProxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			dataProxy.save();
		}
		
	}

}