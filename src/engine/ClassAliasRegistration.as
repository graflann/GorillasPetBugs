package engine 
{
	import flash.net.registerClassAlias;
	
	import view.panels.*;
	import view.mediators.*;
	import view.gameObjects.particles.*;
	import view.gameObjects.particles.bugs.*;
	import view.gameObjects.particles.text.*;
	
	/**
	 * registration (forced compilation / obj creation?) of specific classes for getDefinitionByName use @ runtime...
	 * @author Grant Flannery
	 */
	public class ClassAliasRegistration 
	{
		public static function register():void
		{
			//PANELS
			registerClassAlias(PanelPrefix.TITLE + "Panel", TitlePanel);
			registerClassAlias(PanelPrefix.PLAY + "Panel", PlayPanel);
			
			//MEDIATORS
			registerClassAlias(PanelPrefix.TITLE + "Mediator", TitleMediator);
			registerClassAlias(PanelPrefix.PLAY + "Mediator", PlayMediator);
			
			//PARTICLES
			//root
			registerClassAlias(ParticleTypes.SHARD, Shard);
			
			//bugs
			registerClassAlias(ParticleTypes.BLUE_BUG, BlueBug);
			registerClassAlias(ParticleTypes.GREEN_BUG, GreenBug);
			registerClassAlias(ParticleTypes.GREY_BUG, GreyBug);
			registerClassAlias(ParticleTypes.RED_BUG, RedBug);
			registerClassAlias(ParticleTypes.VIOLET_BUG, VioletBug);
			registerClassAlias(ParticleTypes.YELLOW_BUG, YellowBug);
			
			//text
			registerClassAlias(ParticleTypes.TOTAL, Total);
			registerClassAlias(ParticleTypes.BONUS, Bonus);
		}
	}
}