package model.vo 
{
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class TransitionVO extends Object 
	{
		public var currentPrefix:String;
		
		public var newPrefix:String;
		
		public var isFullTransition:Boolean;
		
		public function TransitionVO() 
		{
			currentPrefix = "";
			newPrefix = "";
			
			isFullTransition = false;
		}
		
	}

}