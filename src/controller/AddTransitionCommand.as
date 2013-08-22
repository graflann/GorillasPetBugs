package controller 
{
	import model.proxies.DataProxy;
	import model.vo.TransitionVO;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import view.mediators.TransitionMediator;
	import view.mediators.StageMediator;
	import view.panels.TransitionPanel;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class AddTransitionCommand extends SimpleCommand implements ICommand 
	{
		
		public function AddTransitionCommand() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			var transitionVO:TransitionVO = notification.getBody() as TransitionVO;
			
			var dataProxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			var stageMediator:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			var transitionMediator:TransitionMediator = facade.retrieveMediator(TransitionMediator.NAME) as TransitionMediator;
			var panel:TransitionPanel = transitionMediator.getViewComponent() as TransitionPanel;
			
			dataProxy.transitionVO.currentPrefix = transitionVO.currentPrefix;
			dataProxy.transitionVO.newPrefix = transitionVO.newPrefix;
			
			stageMediator.addPanel(panel);
			panel.transitionIn();
		}
		
	}

}