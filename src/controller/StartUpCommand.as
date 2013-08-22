package controller 
{
	import flash.display.Stage;

	import model.proxies.DataProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.mediators.StageMediator;
	import org.puremvc.as3.patterns.observer.Notification;
	
	/**
	 * Controls the init of the app
	 * @author Grant Flannery
	 */
	public class StartUpCommand extends SimpleCommand implements ICommand 
	{
		public function StartUpCommand() 
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		override public function execute(notification:INotification):void 
		{
			var stage:Stage = notification.getBody() as Stage;
			
			facade.registerMediator(new StageMediator(stage));
			
			facade.registerProxy(new DataProxy());
		}
		
	}

}