package view.components 
{
	import assets.*;
	import assets.AssetManager;
	import engine.ai.*;
	import engine.Input;
	import engine.KeyboardEx;
	import engine.Score;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import view.gameObjects.*;
	import view.gameObjects.bugs.*;
	import view.gameObjects.particles.*;
	import starling.core.Starling;
	import engine.SoundManager;
	import flash.events.TimerEvent;
	
	/**
	 * Primary play component w/grid background
	 * @author Grant Flannery
	 */
	public class GridComponent extends Sprite
	{
		public static const UNIT:Number = 32;
		
		public static const UNIT_WIDTH:int = 6;
		public static const UNIT_HEIGHT:int = 16;
		
		private static const VERT_BUG_INC:Number = UNIT * 0.25;
		public static const INIT_ORIGIN:Point = new Point(UNIT * 2, 0);
		
		private var _stateMachine:StateMachine;
		public function get stateMachine():StateMachine { return _stateMachine; }
		
		private var _initializationArea:Image;
		private var _gridBackground:Image;
		
		private var _bugContainer:BugContainer;
		
		private var _previewBugContainer:BugContainer;
		public function get previewBugContainer():BugContainer { return _previewBugContainer; }
		
		private var _vecTotalCells:Vector.<Vector.<Bug>>;
		
		private var _shards:ParticleSystem;
		
		private var _timer:Timer;
		public function get timer():Timer { return _timer; }
		
		private var _timeDelay:Number;
		public function get timeDelay():Number 				{ return _timeDelay; }
		public function set timeDelay(value:Number):void 	{ _timeDelay = value; }
		
		public var timerCompletionFunction:Function;
		
		private var _bounds:Rectangle;
		
		private var _isUpdatingCellBugs:Boolean;
		
		private var _vecTempBugs:Vector.<Bug>;
		
		private var _arrBugParticleSystems:Array;
		
		private var _spawnTween:Tween;
		private var _moveTween:Tween;
		
		private var _moveOrigin:Point;
		
		private var _totalOrigin:Point;
		public function get totalOrigin():Point { return _totalOrigin; }
		
		private var _local2GlobalResultPt:Point;
		
		private var _inputEnabled:Boolean;
		
		public function GridComponent() 
		{
			
		}
		
		public function init():void
		{
			var key:String,
			bmd:BitmapData = new BitmapData(UNIT * UNIT_WIDTH, UNIT * 3, true, 0x88000000);
			
			_initializationArea = new Image(Texture.fromBitmapData(bmd, false));
			addChild(_initializationArea);
			
			_gridBackground = new Image(Texture.fromBitmapData(AssetManager.getBitmapData("gridBackground"), false));
			_gridBackground.y = _initializationArea.height;
			addChild(_gridBackground);
			
			_previewBugContainer = new BugContainer();
			_previewBugContainer.init();
			
			_bugContainer = new BugContainer();
			_bugContainer.init();
			
			_shards = new ParticleSystem(ParticleTypes.SHARD, 32);
			_shards.init();
			
			_bounds = new Rectangle(0, 0, width - UNIT, height - UNIT);
			
			_isUpdatingCellBugs = false;
			_vecTempBugs = new Vector.<Bug>();
			
			_local2GlobalResultPt = new Point();
			_totalOrigin = new Point();
			
			_arrBugParticleSystems = [];
			_arrBugParticleSystems[Constants.BLUE_KEY] 		= new ParticleSystem("bugs." + ParticleTypes.BLUE_BUG, 12);
			_arrBugParticleSystems[Constants.GREEN_KEY] 	= new ParticleSystem("bugs." + ParticleTypes.GREEN_BUG, 12);
			_arrBugParticleSystems[Constants.GREY_KEY] 		= new ParticleSystem("bugs." + ParticleTypes.GREY_BUG, 12);
			_arrBugParticleSystems[Constants.RED_KEY] 		= new ParticleSystem("bugs." + ParticleTypes.RED_BUG, 12);
			_arrBugParticleSystems[Constants.VIOLET_KEY] 	= new ParticleSystem("bugs." + ParticleTypes.VIOLET_BUG, 12);
			_arrBugParticleSystems[Constants.YELLOW_KEY] 	= new ParticleSystem("bugs." + ParticleTypes.YELLOW_BUG, 12);

			for (key in _arrBugParticleSystems)
			{
				_arrBugParticleSystems[key].init();
			}
			
			setCells();
			setTimer();
			setStateMachine();
			
			addChild(_bugContainer);
			_bugContainer.x = INIT_ORIGIN.x;
			_bugContainer.y = INIT_ORIGIN.y;
			
			updateLocalContainerValues();
			
			_inputEnabled = true;
			
			bmd.dispose();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function start():void
		{
			_stateMachine.setState(DefaultState.KEY);
		}
		
		public function stop():void
		{
			_stateMachine.nullifyCurrent()
		}
		
		public function update():void
		{	
			var key:String;
			
			_stateMachine.update();
			
			//NON-STATE SPECIFIC UPDATES
			//update any shard particles
			_shards.update();

			//update any bug particles
			for (key in _arrBugParticleSystems)
			{
				_arrBugParticleSystems[key].update();
			}
			
			Game.instance.input.checkPrevKeyDown([KeyboardEx.SPACE, KeyboardEx.LEFT, KeyboardEx.RIGHT]);
		}
		
		public function updateContainer():Boolean
		{
			if (Game.instance.input.isKeyDown(KeyboardEx.SPACE) && !Game.instance.input.isPrevKeyDown(KeyboardEx.SPACE))
			{
				_bugContainer.rotate();
			}
			
			checkContainerLeftCollision();
			checkContainerRightCollision();
			
			if (Game.instance.input.isKeyDown(KeyboardEx.DOWN))
			{
				checkBounds();
				updateLocalContainerValues();
			
				dispatchEventWith(Constants.UPDATE_INPUT_INC, true);
			
				if (checkContainerVerticalCollision(_bugContainer.cellPosition))
				{
					containerToGrid();
					return true;
				}
				else
				{
					_bugContainer.y += UNIT;
				}
			}

			checkBounds();
			updateLocalContainerValues();
			
			return false;
		}
		
		public function updateLocalContainerValues():void
		{
			var bug:Bug;
			var i:int = 0;
			
			_bugContainer.cellPosition.x = _bugContainer.x / UNIT;
			_bugContainer.cellPosition.y = (_bugContainer.y + (UNIT * 2)) / UNIT;
			
			//trace("CONTAINER INDICES: " + _bugContainer.cellPosition.toString());
			
			for each(bug in _bugContainer.vecBugs)
			{
				bug.localPosition = globalToLocal(_bugContainer.localToGlobal(new Point(bug.x, bug.y)));
				
				bug.cellPosition.x = bug.localPosition.x / UNIT;
				bug.cellPosition.y = bug.localPosition.y / UNIT;
				
				//trace("BUG INDICES: " + bug.cellPosition.toString());
			}
		}
		
		/**
		 * Transfer Bug instances from BugContainer to GridComponent 2D Vector based on bug cell position
		 */
		public function containerToGrid():void
		{
			//trace("CONTAINER TO GRID");
			
			var bug:Bug,
			x:int, 
			y:int, 
			i:int = 0;
			
			for each(bug in _bugContainer.vecBugs)
			{
				x = int(bug.cellPosition.x);
				y = int(bug.cellPosition.y);
				_vecTotalCells[x][y] = bug;
				
				bug.x = bug.localPosition.x;
				bug.y = bug.localPosition.y;
								
				_bugContainer.removeChild(bug);
				addChild(bug);
				
				i++;
			}
			
			//gridDebugOutput();
			//
			
			SoundManager.play(SoundName.CONTAINER_PLACE);
			
			_bugContainer.kill();
		}
		
		public function resetBugContainer():void
		{			
			_bugContainer.reset(_moveOrigin, _previewBugContainer);
			addChild(_bugContainer);
			
			_previewBugContainer.alpha = 0;
			
			(!_moveTween) ? _moveTween = new Tween(_bugContainer, 0.5, "easeOut") : _moveTween.reset(_bugContainer, 0.5, "easeOut");
			_moveTween.animate("x", INIT_ORIGIN.x);
			_moveTween.onComplete = onMoveTweenComplete;
			Starling.juggler.add(_moveTween);
		}
		
		public function createPreview():void
		{
			
		}
		
		public function checkBugRemoval():int
		{
			var i:int, 
			j:int, 
			prevY:int,
			numCellsRemoved:int = 0;
			
			//process radius for each available bug per cell
			for (i = 0; i < UNIT_WIDTH; i++ )
			{
				for (j = 0; j < UNIT_HEIGHT; j++ )
				{
					if (_vecTotalCells[i][j] != null)
					{
						checkRemovalRadius(_vecTotalCells[i][j]);
					}
				}
			}
			
			//post-radius processing, any Bug instance flagged for removal is, well, removed :D
			for (i = 0; i < UNIT_WIDTH; i++ )
			{
				for (j = (UNIT_HEIGHT - 1); j > -1; j-- )
				{
					if (_vecTotalCells[i][j] != null)
					{
						if (_vecTotalCells[i][j].isRemovalQualified)
						{
							numCellsRemoved++;
							
							Score.incTotalBugsRemoved();
							
							//Tally bonus
							if (_vecTotalCells[i][j].color == Score.bonusColor)
							{
								Score.incTotalBonusBugsRemoved();
							}
							
							_totalOrigin = localToGlobal(new Point(_vecTotalCells[i][j].x - (UNIT * 0.5), _vecTotalCells[i][j].y), _local2GlobalResultPt);
							
							_vecTotalCells[i][j].crack();
							
							//check for previous Bug instance in column not qualifed for removal for potential descent flagging
							//during subsequent Bug updating, those flagged for descent will do so
							prevY = j - 1;
							
							if (prevY > -1 && _vecTotalCells[i][prevY] && !_vecTotalCells[i][prevY].isRemovalQualified)
							{
								//trace("QUALIFIED FOR DESCENT: " + i + ", " + j);
								_vecTotalCells[i][prevY].isDescentQualified = true;
							}
						}
						else if (_vecTotalCells[i][j].isDescentQualified)
						{
							prevY = j - 1;
							
							if (prevY > -1 && _vecTotalCells[i][prevY] && !_vecTotalCells[i][prevY].isRemovalQualified)
							{
								//trace("QUALIFIED FOR DESCENT: " + i + ", " + j);
								_vecTotalCells[i][prevY].isDescentQualified = true;
							}
						}
					}
				}
			}
			
			return numCellsRemoved;
		}
		
		public function updateCracking():Boolean
		{
			var crackFinished:Boolean = false,
			offset:Number = UNIT * 0.5,
			translatedPt:Point,
			bug:Bug;
			
			for (var i:int = 0; i < UNIT_WIDTH; i++ )
			{
				for (var j:int = 0; j < UNIT_HEIGHT; j++ )
				{
					if (_vecTotalCells[i][j] != null && _vecTotalCells[i][j].isRemovalQualified)
					{
						bug = _vecTotalCells[i][j];
						
						bug.update();
						
						if (!bug.isAlive)
						{
							_shards.emit(this, 4, 
								bug.x + offset, 
								bug.y + offset, 
								3, 3, -2, 2, 3, 6, 1, 1, 0, 0, true);
							
							translatedPt = parent.globalToLocal(localToGlobal(new Point(bug.x, bug.y)));
							
							_arrBugParticleSystems[bug.color].emit(this.parent, 1, 
								translatedPt.x + (UNIT * 0.5), 
								translatedPt.y + (UNIT * 0.5), 
								0, 0, 2, 5, 2, 5, 1, 1, 0, 0, true);
							
							removeChild(_vecTotalCells[i][j]);
							_vecTotalCells[i][j].clear();
							_vecTotalCells[i][j] = null;
							
							bug = null;
							
							crackFinished = true;
						}
					}
				}
			}
			
			if (crackFinished)
				SoundManager.play(SoundName.GLASS_BREAK);

			return crackFinished;
		}
		
		public function updateCellBugs():int
		{
			var i:int, 
			j:int, 
			x:int, 
			y:int, 
			nextBugY:int,
			numBugsUpdating:int = 0;
			
			//trace("Updating Cell Bugs: ");
			
			for (i = 0; i < UNIT_WIDTH; i++ )
			{
				//invert column checks
				for (j = UNIT_HEIGHT - 1; j > -1; j--)
				{
					if (_vecTotalCells[i][j])
					{
						if (_vecTotalCells[i][j].isDescentQualified)
						{
							if (!checkIndividualBugCollision(_vecTotalCells[i][j].cellPosition))
							{
								numBugsUpdating++;
							}
						}
					}
				}
			}
			
			return numBugsUpdating;
		}
		
		public function checkGameOver():Boolean
		{
			for (var i:int = 0; i < UNIT_WIDTH; i++ )
			{
				for (var j:int = 0; j < 3; j++ )
				{
					if (_vecTotalCells[i][j])
					{
						dispatchEventWith(Constants.STARLING_STATUS_TEXT_CHANGE, true, StatusComponent.GAME_OVER);
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function updateGameOver():void
		{
			if (_inputEnabled && Game.instance.input && Game.instance.input.isKeyDown(KeyboardEx.SPACE) && !Game.instance.input.isPrevKeyDown(KeyboardEx.SPACE))
			{
				dispatchEventWith(Constants.STARLING_STATUS_TEXT_CHANGE, true, StatusComponent.ONE_MOMENT);
				dispatchEventWith(Constants.RESET, true);
				
				_inputEnabled = false;
				
				Game.instance.input.checkPrevKeyDown([KeyboardEx.SPACE]);
			}
		}
		
		public function bugContainerAutoMoveComplete():Boolean
		{
			checkBounds();
			
			if (checkContainerVerticalCollision(_bugContainer.cellPosition)) //check bug removal on collision
			{
				_stateMachine.setState(AutoMoveDelayState.KEY);
				return true;
			}

			_bugContainer.y += UNIT;
			return false;
		}
		
		public function clear():void 
		{
			var i:int = -1, j:int;
			
			removeEventListeners();
			removeChildren();
			
			stateMachine.clear();
			_stateMachine = null;
		
			_initializationArea.dispose();
			_initializationArea = null;
			
			_gridBackground.dispose();
			_gridBackground = null;
			
			_bugContainer.clear();
			_bugContainer = null;
			
			_previewBugContainer.clear();
			_previewBugContainer = null;
		
			while (++i < _vecTotalCells.length)
			{
				j = -1;
				
				while (++j < _vecTotalCells[i].length)
				{
					if (_vecTotalCells[i][j])
					{
						_vecTotalCells[i][j].clear();
						_vecTotalCells[i][j] = null;
					}
				}
				
				_vecTotalCells[i].length = 0;
				_vecTotalCells[i] = null;
			}
			_vecTotalCells.length = 0;
			_vecTotalCells = null;
			
			_shards.clear();
			_shards = null;
			
			if (_timer.running)
			{
				_timer.stop();
			}
			
			_timer = null;
			
			_bounds = null;
		
			i = -1;
			while (++i < _vecTempBugs.length)
			{
				if (_vecTempBugs[i])
				{
					_vecTempBugs[i].clear();
					_vecTempBugs[i] = null;
				}
			}
			_vecTempBugs.length = 0;
			_vecTempBugs = null;
			
			i = -1;
			while (++i < _arrBugParticleSystems.length)
			{
				_arrBugParticleSystems[i].clear();
				_arrBugParticleSystems[i] = null;
			}
			_arrBugParticleSystems.length = 0;
			_arrBugParticleSystems = null;
			
			_moveOrigin = null;
			
			_spawnTween = null;
			_moveTween = null;
			
			timerCompletionFunction = null;
		}
		
		public function togglePause(isPaused:Boolean):void
		{
			if (isPaused)
			{
				if (_timer.willTrigger(TimerEvent.TIMER_COMPLETE))
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompletionFunction);
				}
				
				Starling.juggler.remove(_moveTween);
			}
			else
			{
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompletionFunction, false, 0, true);
				_timer.start();
			}
		}
		
		private function setCells():void
		{
			var vecColumns:Vector.<Bug>;
			
			_vecTotalCells = new Vector.<Vector.<Bug>>(UNIT_WIDTH);
			
			for (var i:int = 0; i < UNIT_WIDTH; i++ )
			{
				vecColumns = new Vector.<Bug>(UNIT_HEIGHT);
				_vecTotalCells[i] = vecColumns;
			}
		}
		
		private function setTimer():void
		{
			_timeDelay = 1000;
			_timer = new Timer(_timeDelay, 1);
		}
		
		private function setStateMachine():void
		{
			_stateMachine = new StateMachine();
			
			_stateMachine.addState(DefaultState.KEY, 		new DefaultState(this), 		[RemovalState.KEY, AutoMoveDelayState.KEY]);
			_stateMachine.addState(ResetState.KEY, 			new ResetState(this), 			[DefaultState.KEY]);
			_stateMachine.addState(AutoMoveDelayState.KEY, 	new AutoMoveDelayState(this), 	[RemovalState.KEY]);
			_stateMachine.addState(RemovalState.KEY, 		new RemovalState(this), 		[CrackingState.KEY, ResetState.KEY, GameOverState.KEY]);
			_stateMachine.addState(CrackingState.KEY, 		new CrackingState(this), 		[DescendingState.KEY]);
			_stateMachine.addState(DescendingState.KEY, 	new DescendingState(this), 		[RemovalState.KEY]);
			_stateMachine.addState(GameOverState.KEY, 		new GameOverState(this), 		[DescendingState.KEY]);
			
			//_stateMachine.setState(DefaultState.KEY);
			//_stateMachine.nullifyCurrent();
			
			stop();
		}
		
		private function checkBounds():void 
		{
			if (_bugContainer.x < _bounds.left)
			{
				_bugContainer.x = _bounds.left;
			}
			else if (_bugContainer.x > _bounds.right)
			{
				_bugContainer.x = _bounds.right;
			}
			
			if (_bugContainer.y > _bounds.bottom)
			{
				_bugContainer.y = _bounds.bottom;
			}
		}
	
		
		private function checkContainerVerticalCollision(cellPosition:Point):Boolean
		{
			var x:int = (int)(cellPosition.x), y:int = (int)(cellPosition.y);
			
			
			if (y < (UNIT_HEIGHT - 1))
			{
				if (_vecTotalCells[x][y + 1] != null)
				{
					return true;
				}
				
				return false;
			}
			
			return true;
		}

		private function checkContainerRightCollision():void
		{
			if (Game.instance.input.isKeyDown(KeyboardEx.RIGHT) && !Game.instance.input.isPrevKeyDown(KeyboardEx.RIGHT))
			{
				var nextX:int, y:int, prevY1:int, prevY2:int;
				
				nextX = (int)(_bugContainer.cellPosition.x + 1);
				y = (int)(_bugContainer.cellPosition.y);
				prevY1 = y - 1;
				prevY2 = y - 2;
				
 				if(nextX < UNIT_WIDTH && (_vecTotalCells[nextX][y] == null && _vecTotalCells[nextX][prevY1] == null && _vecTotalCells[nextX][prevY2] == null))
				{
					_bugContainer.x += UNIT;
				}
			}
		}
		
		private function checkContainerLeftCollision():void
		{
			if (Game.instance.input.isKeyDown(KeyboardEx.LEFT) && !Game.instance.input.isPrevKeyDown(KeyboardEx.LEFT))
			{	
				var prevX:int = (int)(_bugContainer.cellPosition.x - 1), 
				y:int = (int)(_bugContainer.cellPosition.y), 
				prevY1:int = y - 1, 
				prevY2:int = y - 2;
				
				if(prevX > -1 && (_vecTotalCells[prevX][y] == null && _vecTotalCells[prevX][prevY1] == null && _vecTotalCells[prevX][prevY2] == null))
				{
					_bugContainer.x -= UNIT;
				}
			} 
		}
		
		private function checkRemovalRadius(bug:Bug):void
		{
			var i:int,
			x:int = (int)(bug.cellPosition.x), 
			prevX:int = x - 1, 
			nextX:int = x + 1,
			y:int = (int)(bug.cellPosition.y), 
			prevY:int = y - 1, 
			nextY:int = y + 1;
			
			_vecTempBugs.length = 0;
			
			//Cache bugs within 1 cell radius of Bug argument instance for color comps
			//0, 1, 2
			if (prevY > -1)
			{
				(prevX > -1) ? _vecTempBugs[0] = _vecTotalCells[prevX][prevY] : _vecTempBugs[0] = null;
				_vecTempBugs[1] = _vecTotalCells[x][prevY];
				(nextX < UNIT_WIDTH) ? _vecTempBugs[2] = _vecTotalCells[nextX][prevY] : _vecTempBugs[2] = null;
			}
			else
			{
				_vecTempBugs[0] = null;
				_vecTempBugs[1] = null;
				_vecTempBugs[2] = null;
			}
			
			//3, 4, 5
			(prevX > -1) ? _vecTempBugs[3] = _vecTotalCells[prevX][y] : _vecTempBugs[3] = null;
			_vecTempBugs[4] = _vecTotalCells[x][y];
			(nextX < UNIT_WIDTH) ? _vecTempBugs[5] = _vecTotalCells[nextX][y] : _vecTempBugs[5] = null;
			
			//6, 7, 8
			if (nextY < UNIT_HEIGHT)
			{
				(prevX > -1) ? _vecTempBugs[6] = _vecTotalCells[prevX][nextY] : _vecTempBugs[6] = null;
				_vecTempBugs[7] = _vecTotalCells[x][nextY];
				(nextX < UNIT_WIDTH) ? _vecTempBugs[8] = _vecTotalCells[nextX][nextY] : _vecTempBugs[8] = null;
			}
			else
			{
				_vecTempBugs[6] = null;
				_vecTempBugs[7] = null;
				_vecTempBugs[8] = null;
			}
			/////////////////////////////////////////////////////
			
			//8 distinct Color comps (tic-tac-toe style) to flag for removal
			//HORIZONTAL CHECKS #1, 2, & 3
			for (i = 0; i < 6; i +=3 )
			{
				if(_vecTempBugs[i] != null && _vecTempBugs[i + 1] != null && _vecTempBugs[i + 2] != null)
				{
					if (_vecTempBugs[i].color == _vecTempBugs[i + 1].color &&
						_vecTempBugs[i + 1].color == _vecTempBugs[i + 2].color &&
						_vecTempBugs[i + 1].color == _vecTempBugs[i + 2].color)
					{
						_vecTempBugs[i].isRemovalQualified = true;
						_vecTempBugs[i + 1].isRemovalQualified = true;
						_vecTempBugs[i + 2].isRemovalQualified = true;
					}
				}
			}
			
			//VERTICAL CHECKS #1, 2, & 3
			i = -1;
			while(++i < 3)
			{
				if(_vecTempBugs[i] != null && _vecTempBugs[i + 3] != null && _vecTempBugs[i + 6] != null)
				{
					if (_vecTempBugs[i].color == _vecTempBugs[i + 3].color &&
						_vecTempBugs[i + 3].color == _vecTempBugs[i + 6].color &&
						_vecTempBugs[i].color == _vecTempBugs[i + 6].color)
					{
						_vecTempBugs[i].isRemovalQualified = true;
						_vecTempBugs[i + 3].isRemovalQualified = true;
						_vecTempBugs[i + 6].isRemovalQualified = true;
					}
				}
			}
			
			//DIAGONAL CHECK #1
			if(_vecTempBugs[0] != null && _vecTempBugs[4] != null && _vecTempBugs[8] != null)
			{
				if (_vecTempBugs[0].color == _vecTempBugs[4].color &&
					_vecTempBugs[4].color == _vecTempBugs[8].color &&
					_vecTempBugs[0].color == _vecTempBugs[8].color)
				{
					_vecTempBugs[0].isRemovalQualified = true;
					_vecTempBugs[4].isRemovalQualified = true;
					_vecTempBugs[8].isRemovalQualified = true;
				}
			}
			
			//DIAGONAL CHECK #2
			if(_vecTempBugs[2] != null && _vecTempBugs[4] != null && _vecTempBugs[6] != null)
			{
				if (_vecTempBugs[2].color == _vecTempBugs[4].color &&
					_vecTempBugs[4].color == _vecTempBugs[6].color &&
					_vecTempBugs[2].color == _vecTempBugs[6].color)
				{
					_vecTempBugs[2].isRemovalQualified = true;
					_vecTempBugs[4].isRemovalQualified = true;
					_vecTempBugs[6].isRemovalQualified = true;
				}
			}
			/////////////////////////////////////////////////////
		}
		
		
		private function checkIndividualBugCollision(cellPosition:Point):Boolean
		{
			var x:int = (int)(cellPosition.x), 
			y:int = (int)(cellPosition.y), 
			nextY:int = (int)(cellPosition.y + 1);
						
			if (nextY < UNIT_HEIGHT)
			{
				if (_vecTotalCells[x][nextY] == null || _vecTotalCells[x][nextY].isDescentQualified)
				{
					_vecTotalCells[x][y].y += VERT_BUG_INC;
					
					if (_vecTotalCells[x][y].y % UNIT == 0)
					{
						_vecTotalCells[x][y].cellPosition.y = _vecTotalCells[x][y].y / UNIT;
						
						_vecTotalCells[x][nextY] = _vecTotalCells[x][y];
						_vecTotalCells[x][y] = null;
					}
					return false;
				}
				else
				{
					_vecTotalCells[x][y].isDescentQualified = false;
					return true;
				}
			}

			_vecTotalCells[x][y].isDescentQualified = false;
			return true;
		}
		
		private function gridDebugOutput():void
		{
			var i:int, 
			j:int,
			totalLine:String = "";
			
			for (j = 0; j < UNIT_HEIGHT; j++ )
			{			
				for (i = 0; i < UNIT_WIDTH; i++ )
				{
					var line:String;
					
					if (!_vecTotalCells[i][j])
					{
						line = "(" + i.toString() + ", " + j.toString() +  ") = null; ";
					}
					else
					{
						line = "(" + i.toString() + ", " + j.toString() +  ") = "+ _vecTotalCells[i][j].color + "; ";
					}
					
					totalLine += line;
				}
				
				trace("ROW #" + j.toString() + ": " + totalLine);
				
				totalLine = "";
			}
			
			trace("\n");
		}
		
		//TWEEN COMPLETION
		private function onMoveTweenComplete():void
		{
			Starling.juggler.remove(_moveTween);
			
			_previewBugContainer.spawn();
			
			(!_spawnTween) ? _spawnTween = new Tween(_previewBugContainer, 0.5) : _spawnTween.reset(_previewBugContainer, 0.5);
			_spawnTween.fadeTo(1);
			Starling.juggler.add(_spawnTween);
			
			stateMachine.setState(DefaultState.KEY);
		}
		
		//EVENT HANDLERS
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			parent.addChild(_previewBugContainer);
			_previewBugContainer.x = x - (UNIT * 1.5);
			_previewBugContainer.y = y;
			
			_moveOrigin = globalToLocal(new Point(_previewBugContainer.x, _previewBugContainer.y));
		}
	}
}
//END PACKAGE

//IStates implementations for StateMachine instance
import engine.ai.*;
import flash.events.*;
import starling.events.*;
import view.components.*;
import engine.Score;

//DefaultState; user manipulates BugContainer instance
class DefaultState implements IState
{
	public static const KEY:String = "default";
	
	private var _component:GridComponent;
	
	public function DefaultState(component:GridComponent)
	{
		_component = component;
	}
	
	public function enter():void
	{
		_component.timerCompletionFunction = onTimerComplete;
		
		_component.timer.addEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
		_component.timer.delay = Score.descentDelay;
		_component.timer.start();
	}
	
	public function update():void
	{
		if (_component.updateContainer())
		{
			_component.stateMachine.setState(RemovalState.KEY);
		}
	}
	
	public function exit():void
	{
		if (_component.timer.hasEventListener(TimerEvent.TIMER_COMPLETE))
		{
			_component.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
			_component.timer.stop();
		}
	}
	
	public function clear():void { _component = null; }
	
	private function onTimerComplete(e:TimerEvent):void
	{
		_component.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
		_component.timer.stop();
		
		//if there's no collision upon auto timer completion, reset the autotimer
		if (!_component.bugContainerAutoMoveComplete())
		{
			_component.timer.addEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
			_component.timer.start();
		}
	}
}

class ResetState implements IState
{
	public static const KEY:String = "reset";
	
	private var _component:GridComponent;
	
	public function ResetState(component:GridComponent)
	{
		_component = component;
	}
	
	public function enter():void
	{
		_component.timerCompletionFunction = onTimerComplete;
		
		_component.timer.addEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
		_component.timer.delay = 500;
		_component.timer.start();
		
		_component.dispatchEventWith(Constants.UPDATE_SCORE, true, _component.totalOrigin);
		_component.dispatchEventWith(Constants.START_GORILLA_KICK, true);
	}
	
	public function update():void
	{
		
	}
	
	public function exit():void
	{
	
	}
	
	public function clear():void { _component = null; }
	
	private function onTimerComplete(e:TimerEvent):void
	{
		_component.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
		_component.timer.stop();
		
		_component.resetBugContainer();
		
		//_component.stateMachine.setState(DefaultState.KEY);
	}
}

class AutoMoveDelayState implements IState
{
	public static const KEY:String = "autoMoveDelay";
	
	private var _component:GridComponent;
	
	public function AutoMoveDelayState(component:GridComponent)
	{
		_component = component;
	}
	
	public function enter():void
	{	
		_component.timerCompletionFunction = onTimerComplete;
		
		_component.timer.addEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
		_component.timer.delay = 500;
		_component.timer.start();
	}
	
	public function update():void
	{
	}
	
	public function exit():void
	{
	
	}
	
	public function clear():void { _component = null; }
	
	private function onTimerComplete(e:TimerEvent):void
	{
		_component.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
		_component.timer.stop();
	
		_component.containerToGrid();
		
		_component.stateMachine.setState(RemovalState.KEY);
	}
}

class RemovalState implements IState
{
	public static const KEY:String = "removal";
	
	private var _component:GridComponent;
	
	public function RemovalState(component:GridComponent)
	{
		_component = component;
	}
	
	public function enter():void
	{
		if (_component.checkBugRemoval() == 0)
		{
			if (_component.checkGameOver())
			{
				if (_component.timer.hasEventListener(TimerEvent.TIMER_COMPLETE))
				{
					_component.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
					_component.timer.stop();
				}
		
				_component.stateMachine.setState(GameOverState.KEY);
				return;
			}
			
			_component.stateMachine.setState(ResetState.KEY);
		}
		else
		{		
			_component.timerCompletionFunction = onTimerComplete;
			
			_component.timer.addEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
			_component.timer.delay = 500;
			_component.timer.start();
		}
	}
	
	public function update():void
	{
		
	}
	
	public function exit():void
	{
	
	}
	
	public function clear():void { _component = null; }
	
	private function onTimerComplete(e:TimerEvent):void
	{
		_component.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _component.timerCompletionFunction);
		_component.timer.stop();
		
		_component.stateMachine.setState(CrackingState.KEY);
	}
}

class CrackingState implements IState
{
	public static const KEY:String = "cracking";
	
	private var _component:GridComponent;
	
	public function CrackingState(component:GridComponent)
	{
		_component = component;
	}
	
	public function enter():void
	{
	}
	
	public function update():void
	{
		if (_component.updateCracking())
		{
			_component.stateMachine.setState(DescendingState.KEY);
		}
	}
	
	public function exit():void
	{
	
	}
	
	public function clear():void { _component = null; }
}

class DescendingState implements IState
{
	public static const KEY:String = "descending";
	
	private var _component:GridComponent;
	
	public function DescendingState(component:GridComponent)
	{
		_component = component;
	}
	
	public function enter():void
	{
	}
	
	public function update():void
	{
		if (_component.updateCellBugs() == 0)
		{
			_component.stateMachine.setState(RemovalState.KEY);
		}
	}
	
	public function exit():void
	{
	
	}
	
	public function clear():void { _component = null; }
}

class GameOverState implements IState
{
	public static const KEY:String = "gameOver";
	
	private var _component:GridComponent;
	
	public function GameOverState(component:GridComponent)
	{
		_component = component;
	}
	
	public function enter():void
	{
	}
	
	public function update():void
	{
		_component.updateGameOver();
	}
	
	public function exit():void
	{
	
	}
	
	public function clear():void { _component = null; }
}