package view.components 
{
	import starling.display.Sprite;
	import  view.gameObjects.bugs.Bug;
	import assets.AssetManager;
	import view.gameObjects.bugs.BugType;
	
	/**
	 * References a 2D array to form a letter from bug Image instances; for use by BugWord
	 * @author Grant Flannery
	 */
	internal class BugLetter extends Sprite 
	{
		internal static const UNIT:Number = GridComponent.UNIT * 0.5;
		
		private var _key:String;
		
		private var _letter:Vector.<Vector.<int>>;

		private var _vecBugs:Vector.<Bug>;
		
		private var _w:Number;
		public function get w():Number { return _w; }
		
		public function BugLetter(key:String) 
		{
			if (key.length > 1)
			{
				throw new Error("String arg length cannot exceed 1.");
			}
			
			_key = key;
		}
		
		internal function init():void
		{
			var bug:Bug,
			bugIndex:int = 0,
			i:int = -1,
			j:int;
			
			_vecBugs = new <Bug>[];
			
			_letter = BugLetterTypes.getLetter(_key);
			
			_w = _letter[0].length * UNIT;
			
			//iterate through the letter, consisting of a Vector.<Vector.<int>> instance
 			while (++i < _letter.length)
			{
				j = -1;
				while (++j < _letter[i].length)
				{
					if (_letter[i][j] > 0) //0 is left blank
					{
						bug = new Bug(BugType.getOption(bugIndex));
						bug.init();
						bug.stopAnimation();
						bug.scaleX = 0.5;
						bug.scaleY = 0.5;
						bug.x = UNIT * j;
						bug.y = UNIT * i;
						addChild(bug);
						
						_vecBugs.push(bug);
						
						bugIndex++;
						
						if (bugIndex > BugType.MAX)
						{
							bugIndex = 0;
						}
					}
				}
			}	
		}
		
		internal function clear():void
		{
			var i:int = 0;
			
			removeChildren(0, -1, true);
			
			for (i; i < _vecBugs.length; i++ )
			{
				_vecBugs[i].clear();
				_vecBugs[i] = null;
			}
			_vecBugs.length = 0;
			_vecBugs = null;
		}
	}

}