package view.gameObjects 
{
	import flash.geom.Point;
	import starling.display.Sprite;
	import view.gameObjects.GameObject;
	import view.gameObjects.bugs.Bug;
	
	import view.gameObjects.bugs.BugType;
	
	import view.components.GridComponent;
	
	/**
	 * ...
	 * @author Grant Flannery
	 */
	public class BugContainer extends GameObject 
	{
		public static const MAX_BUGS:int = 3;
		public static const MAX_HEIGHT:int = GridComponent.UNIT * 3;
		
		private var _vecBugs:Vector.<Bug>;
		public function get vecBugs():Vector.<Bug> { return _vecBugs; }
		
		private var _cellPosition:Point;
		public function set cellPosition(value:Point):void 	{ _cellPosition = value; }
		public function get cellPosition():Point			{ return _cellPosition; }
		
		public function BugContainer() 
		{
			
		}
		
		override public function init():void 
		{
			super.init();
			
			_vecBugs = new Vector.<Bug>(MAX_BUGS);
			_vecBugs.fixed = true;
			
			_cellPosition = new Point();
			
			spawn();
			
			_isAlive = true;
		}
		
		override public function update(targetX:Number = 0, targetY:Number = 0, originX:Number = 0, originY:Number = 0):void 
		{
			if (_isAlive)
			{
				
			}
		}
		
		override public function clear():void 
		{
			var i:int = -1;
			
			super.clear();
			
			_cellPosition = null;
			
			while (++i < _vecBugs.length)
			{
				_vecBugs[i].clear();
				_vecBugs[i] = null;
			}

			_vecBugs = null;
		}
		
		public function rotate():void
		{
			for (var i:int = 0; i < MAX_BUGS; i++ )
			{
				_vecBugs[i].y += GridComponent.UNIT;
				
				if (_vecBugs[i].y == MAX_HEIGHT)
				{
					_vecBugs[i].y = 0;
				}
			}
		}
		
		public function reset(pt:Point, container:BugContainer):void
		{
			x = pt.x;
			y = pt.y;
			
			//spawn();
			
			duplicate(container);
			
			_isAlive = true;
		}
		
		public function spawn():void
		{
			var bug:Bug,
			i:int = 0;
			
			for (i = 0; i < MAX_BUGS; i++ )
			{	
				if(_vecBugs[i])
					_vecBugs[i].clear();
					
				_vecBugs[i] = null;
				
				bug = new Bug(BugType.getOption(Utils.randomInRange(0, 5)));
				bug.init();
				
				if (i > 0)
				{
					var index:int = i - 1;
					bug.y = _vecBugs[index].y + _vecBugs[index].height;
				}
				
				_vecBugs[i] = bug;
				addChild(bug);
			}
		}
		
		private function duplicate(container:BugContainer):void
		{
			var bug:Bug,
			i:int = 0;
			
			for (i = 0; i < MAX_BUGS; i++ )
			{
				_vecBugs[i] = null;
				
				bug = new Bug(container.vecBugs[i].color);
				bug.init();
				
				if (i > 0)
				{
					var index:int = i - 1;
					bug.y = _vecBugs[index].y + _vecBugs[index].height;
				}
				
				_vecBugs[i] = bug;
				addChild(bug);
			}
		}
	}
}