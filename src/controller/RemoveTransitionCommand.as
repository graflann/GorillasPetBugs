package controller 
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import view.mediators.PlayMediator;
	import view.mediators.StageMediator;
	import view.mediators.TransitionMediator;
	import view.panels.TransitionPanel;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class RemoveTransitionCommand extends SimpleCommand implements ICommand 
	{
		
		public function RemoveTransitionCommand() 
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */	
		override public function execute(notification:INotification):void 
		{
			var stageMediator:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			var transitionMediator:TransitionMediator = facade.retrieveMediator(TransitionMediator.NAME) as TransitionMediator;
			var panel:TransitionPanel = transitionMediator.getViewComponent() as TransitionPanel
			
			stageMediator.removePanel(panel);
		}
		
	}

}