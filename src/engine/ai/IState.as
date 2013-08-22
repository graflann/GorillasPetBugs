package engine.ai 
{
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public interface IState 
	{
		function enter():void;
		function update():void;
		function exit():void;
		function clear():void;
	}
	
}