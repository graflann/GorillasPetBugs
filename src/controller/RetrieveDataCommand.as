package controller 
{
	//import model.proxies.DataProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import view.mediators.CustomMediator;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Generic command that dynamically injects proxy data into mediator viewComponent
	 * @author Grant Flannery
	 */
	public class RetrieveDataCommand extends SimpleCommand implements ICommand 
	{
		
		public function RetrieveDataCommand() 
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		override public function execute(notification:INotification):void 
		{				
			var proxyName:String = notification.getBody().proxy as String;
			var proxy:Proxy = facade.retrieveProxy(proxyName) as Proxy;
			
			var mediatorName:String = notification.getBody().mediator as String;
			var mediator:CustomMediator = facade.retrieveMediator(mediatorName) as CustomMediator;
			
			mediator.setDataProvider(proxy.getData());
		}
		
	}

}