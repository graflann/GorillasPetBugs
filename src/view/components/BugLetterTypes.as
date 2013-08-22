package view.components 
{
	/**
	 * 2D Vector instances with management that for use in BugLetter; for use by BugLetter
	 * @author Grant Flannery
	 */
	internal class BugLetterTypes 
	{		
		internal static function getLetter(key:String):Vector.<Vector.<int>>
		{
			return _arrLetters[key] as Vector.<Vector.<int>>;
		}
		
		private static var b:Vector.<Vector.<int>> = new <Vector.<int>> [
			new<int> [1,1,1,1,0],
			new<int> [1,0,0,0,1],
			new<int> [1,0,0,0,1],
			new<int> [1,1,1,1,0],
			new<int> [1,0,0,0,1],
			new<int> [1,0,0,0,1],
			new<int> [1,1,1,1,0]
		];
		
		private static var g:Vector.<Vector.<int>> = new <Vector.<int>> [
			new<int> [1,1,1,1,1],
			new<int> [1,0,0,0,0],
			new<int> [1,0,0,0,0],
			new<int> [1,0,1,1,1],
			new<int> [1,0,0,0,1],
			new<int> [1,0,0,0,1],
			new<int> [1,1,1,1,1]
		];
		
		private static var p:Vector.<Vector.<int>> = new <Vector.<int>> [
			new<int> [1,1,1,1,1],
			new<int> [1,0,0,0,1],
			new<int> [1,0,0,0,1],
			new<int> [1,1,1,1,1],
			new<int> [1,0,0,0,0],
			new<int> [1,0,0,0,0],
			new<int> [1,0,0,0,0]
		];
		
		private static var _arrLetters:Object = {
			B: b,
			G: g,
			P: p
		};
	}

}