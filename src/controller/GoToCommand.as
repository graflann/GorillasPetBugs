package controller 
{
	import flash.display.Stage;
	import model.proxies.DataProxy;
	import model.vo.TransitionVO;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import view.mediators.CustomMediator;
	import view.mediators.StageMediator;
	import view.mediators.TransitionMediator;
	import view.panels.Panel;
	import view.panels.TransitionPanel;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class GoToCommand extends SimpleCommand implements ICommand 
	{
		
		public function GoToCommand() 
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void
		{
			var currentPrefix:String,
			newPrefix:String,
			currentPanelIndex:int;
			
			if (!notification.getBody())
			{
				var dataProxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
				
				currentPrefix 	= dataProxy.transitionVO.currentPrefix;
				newPrefix		= dataProxy.transitionVO.newPrefix;
			}
			else
			{
				var transitionVO:TransitionVO = notification.getBody() as TransitionVO;
				
				currentPrefix 	= transitionVO.currentPrefix;
				newPrefix		= transitionVO.newPrefix;
			}
			
			var stageMediator:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			
			var transitionMediator:TransitionMediator = facade.retrieveMediator(TransitionMediator.NAME) as TransitionMediator;
			var transitionPanel:TransitionPanel = transitionMediator.getViewComponent() as TransitionPanel;
			
			var currentMediator:CustomMediator = facade.retrieveMediator(currentPrefix + "Mediator") as CustomMediator;
			
			var NewPanelClass:Class = getDefinitionByName("view.panels." + newPrefix + "Panel") as Class;
			var NewMediatorClass:Class = getDefinitionByName("view.mediators." + newPrefix + "Mediator") as Class;
			
			currentPanelIndex = Game.instance.getChildIndex(transitionPanel.starlingSprite);
			
			trace("CURRENT PANEL INDEX" + currentPanelIndex.toString());
			
			//remove current 
			stageMediator.removePanel(stageMediator.currentPanel);
			facade.removeMediator(currentPrefix + "Mediator");
			
			stageMediator.currentPanel = new NewPanelClass();
			
			//register new Mediator and add its view component (Panel instance)
			facade.registerMediator(new NewMediatorClass(stageMediator.currentPanel));
			
			stageMediator.addPanel(stageMediator.currentPanel, 0);
		}
		
	}

}