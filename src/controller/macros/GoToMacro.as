package controller.macros 
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import controller.*;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class GoToMacro extends MacroCommand implements ICommand 
	{
		
		public function GoToMacro() 
		{
			super();
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override protected function initializeMacroCommand():void 
		{
			addSubCommand(GoToCommand);
			addSubCommand(AddTransitionCommand);
		}
		
		public function execute(notification:INotification):void 
		{
			
		}
		
	}

}