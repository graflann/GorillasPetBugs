package view.components 
{
	import starling.display.Sprite;
	
	/**
	 * "Word" comprised of BugLetter instances
	 * @author Grant Flannery
	 */
	public class BugWord extends Sprite 
	{
		private var _word:String;
		
		private var _vecBugLetter:Vector.<BugLetter>;
		
		public function BugWord(word:String) 
		{
			_word = word;
		}
		
		public function init():void
		{
			var i:int = -1,
			key:String,
			currentBugLetterX:Number = 0,
			bugLetter:BugLetter;
			
			_vecBugLetter = new <BugLetter>[];
			
			while (++i < _word.length)
			{
				key = _word.charAt(i);
				
				bugLetter = new BugLetter(key);
				bugLetter.init();
				
				if (i > 0)
				{
					bugLetter.x = currentBugLetterX + _vecBugLetter[i - 1].w + (BugLetter.UNIT * 2.5);
					currentBugLetterX = bugLetter.x;
				}
				
				addChild(bugLetter);
				
				_vecBugLetter.push(bugLetter);
			}
		}
		
		public function clear():void
		{
			var i:int = 0;
			
			removeChildren();
			
			for (i; i < _vecBugLetter.length; i++ )
			{
				_vecBugLetter[i].clear();
				_vecBugLetter[i] = null;
			}
			_vecBugLetter.length = 0;
			_vecBugLetter = null;
		}
	}

}