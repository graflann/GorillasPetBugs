package engine 
{
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public interface IPanel 
	{
		/**
		 * Init defaults
		 */
		function init():void;
		
		/**
		 * Update loop
		 */
		function update():void;
		
		/**
		 * Roasts the state
		 */
		function clear():void;
	}
	
}