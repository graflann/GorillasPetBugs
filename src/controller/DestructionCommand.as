package controller 
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import view.panels.Panel;
	
	import view.mediators.*;
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class DestructionCommand extends SimpleCommand implements ICommand 
	{
		public function DestructionCommand() 
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		override public function execute(notification:INotification):void 
		{
			/*var implementationMediator:ImplementationMediator = facade.retrieveMediator(ImplementationMediator.NAME) as ImplementationMediator;			
			var panel:Panel = implementationMediator.getViewComponent() as Panel;
			
			panel.dispatchEvent(new Event(Constants.DESTROY, true));*/
		}
	}

}