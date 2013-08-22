package view.panels
{
	import assets.*;
	import com.greensock.TweenMax;
	import engine.Input;
	import engine.KeyboardEx;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import view.components.BugWord;
	import view.gameObjects.bugs.Bug;
	import view.gameObjects.bugs.BugType;
	import view.gameObjects.Gorilla;
	import view.panels.Panel;
	import engine.SoundManager;
	
	/**
	 * Main "BUGS" title screen
	 * @author Grant Flannery
	 */
	public class TitlePanel extends Panel 
	{
		private var _titleText:BugWord;
		
		private var _vecSubTitles:Vector.<TextField>;
		
		private var _vecDescriptions:Vector.<TextField>;
		private var _instructions:TextField;
		private var _copyright:TextField;
		
		private var _gorilla:Gorilla;
		
		private var _vecBugs:Vector.<Bug>;
		
		private var _vecMasks:Vector.<Image>;
		
		private var _maskTween:Tween;
		private var _maskIndex:int;
		
		private var _mask:Shape;
		
		private var _timer:Timer;
		
		private var _inputEnabled:Boolean;
		
		public function TitlePanel() { }
		
		override public function init():void
		{
			var i:int = 0,
			next:int,
			bmd:BitmapData = new BitmapData(Constants.WIDTH, 40, false, 0xFFC8C8B0),
			texture:Texture = Texture.fromBitmapData(bmd);
			
			_mask = new Shape();
			_mask.graphics.beginBitmapFill(new BitmapData(Constants.WIDTH, Constants.HEIGHT, true, 0xFFC8C8B0), null, false);
			_mask.graphics.drawRect(0, 0, Constants.WIDTH, Constants.HEIGHT);
			_mask.graphics.endFill();
			_mask.alpha = 0;
			
			_inputEnabled = false;
			
			_starlingSprite = new starling.display.Sprite();
			
			//SET THE TITLE
			_titleText = new BugWord("GPB");
			_titleText.init();
			_titleText.x = (Constants.WIDTH * 0.5) - (_titleText.width * 0.5);
			_titleText.y = 16;
			
			//SET SUBTITLES
			_vecSubTitles = new Vector.<TextField>(3);
			_vecSubTitles.fixed = true;
			
			//orilla's
			_vecSubTitles[0] = new TextField(Constants.WIDTH, 24, "ORILLA'S", FontName.AXI_5X5, 16, 0x0);
			_vecSubTitles[0].hAlign = "left";
			_vecSubTitles[0].x = _titleText.x + 16;
			_vecSubTitles[0].y = _titleText.y + 20;
			
			//orilla's
			_vecSubTitles[1] = new TextField(Constants.WIDTH, 24, "ET", FontName.AXI_5X5, 16, 0x0);
			_vecSubTitles[1].hAlign = "left";
			_vecSubTitles[1].x = _titleText.x + 136;
			_vecSubTitles[1].y =  _titleText.y + 68;
			
			//orilla's
			_vecSubTitles[2] = new TextField(Constants.WIDTH, 24, "UGS", FontName.AXI_5X5, 16, 0x0);
			_vecSubTitles[2].hAlign = "left";
			_vecSubTitles[2].x = _titleText.x + 304;
			_vecSubTitles[2].y = _titleText.y + _titleText.height - (_vecSubTitles[0].height * 0.5);
			
			//SET DESC and MASKS
			_vecDescriptions = new Vector.<TextField>(7);
			_vecDescriptions.fixed = true;
			
			_vecMasks = new Vector.<Image>(8);
			_vecMasks.fixed = true;
			
			//SET THE GORILLA
			_gorilla = new Gorilla();
			_gorilla.init();
			_gorilla.x = 144;
			_gorilla.y = _titleText.y + _titleText.height + 40;
			_starlingSprite.addChild(_gorilla);
			_gorilla.setState(Gorilla.FRONT_STATIC);
			
			_vecDescriptions[0] = new TextField(400, 44, "GORILLA", FontName.AXI_5X5, 16, 0x0);
			_vecDescriptions[0].vAlign = "center";
			_vecDescriptions[0].hAlign = "left";
			_vecDescriptions[0].y = _gorilla.y + 4;
			_starlingSprite.addChild(_vecDescriptions[0]);
			
			_vecMasks[0] = new Image(texture);
			_vecMasks[0].y = _gorilla.y;
			
			//SET THE BUG IMAGES W/DESCRIPTIONS
			_vecBugs = new Vector.<Bug>(6);
			_vecBugs.fixed = true;
			
			for (i = 0; i < _vecBugs.length; i++ )
			{
				next = i + 1;
				
				_vecBugs[i] = new Bug(BugType.getOption(i));
				_vecBugs[i].init();
				_vecBugs[i].x = 128;
				_vecBugs[i].y = _gorilla.y + _gorilla.height + 32 + (i * 48);
				
				_vecDescriptions[next] = new TextField(400, 44, BugType.getDescription(i), FontName.AXI_5X5, 16, 0x0);
				_vecDescriptions[next].vAlign = "center";
				_vecDescriptions[next].hAlign = "left";
				_vecDescriptions[next].x = _vecBugs[i].x + (_vecBugs[i].width * 1.5);
				_vecDescriptions[next].y = _vecBugs[i].y;
				
				_vecMasks[next] = new Image(texture);
				_vecMasks[next].y = _vecBugs[i].y;
				
				_starlingSprite.addChild(_vecBugs[i]);
				_starlingSprite.addChild(_vecDescriptions[next]);
			}
			
			_vecDescriptions[0].x = _vecDescriptions[1].x;
			
			//SET INSTRUCTIONS
			_instructions = new TextField(Constants.WIDTH, 24, "PRESS SPACE TO START", FontName.AXI_5X5, 16, 0x0);
			_instructions.x = (Constants.WIDTH * 0.5) - (_instructions.width * 0.5);
			_instructions.y = 562;
			_vecMasks[7] =  new Image(texture);
			_vecMasks[7].y = _instructions.y;
			
			//SET COPYRIGHT
			_copyright = new TextField(Constants.WIDTH, 24, "(C) GRANT FLANNERY 2012", FontName.AXI_5X5, 12, 0x0);
			_copyright.x = (Constants.WIDTH * 0.5) - (_instructions.width * 0.5);
			_copyright.y = 612;
			
			_starlingSprite.addChild(_titleText);
			
			for (i = 0; i < _vecSubTitles.length; i++ )
				_starlingSprite.addChild(_vecSubTitles[i]);
			
			_starlingSprite.addChild(_instructions);
			_starlingSprite.addChild(_copyright);
			
			//START MASK TWEENING
			for (i = 0; i < _vecMasks.length; i++ )
			{
				_starlingSprite.addChild(_vecMasks[i]);
			}
			
			bmd.dispose();
			bmd = null;
		}
		
		override public function update():void
		{
			if (_inputEnabled)
			{
				if (Game.instance.input.isKeyDown(KeyboardEx.SPACE) && !Game.instance.input.isPrevKeyDown(KeyboardEx.SPACE))
				{
					SoundManager.play(SoundName.CONTAINER_PLACE);
					_starlingSprite.removeChild(_instructions);
					dispatchEvent(new Event(Constants.START, true));
				}
				
				Game.instance.input.checkPrevKeyDown([KeyboardEx.SPACE]);
			}
		}
		
		override public function clear():void
		{
			var i:int = 0;
			
			super.clear();

			_maskTween = null;
			
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer.stop();
				_timer = null;
			}

			for (i = 0; i < _vecBugs.length; i++ )
			{
				_vecBugs[i].clear();
				_vecBugs[i] = null;
			}
			_vecBugs = null;
			
			for (i = 0; i < _vecDescriptions.length; i++ )
			{
				_vecDescriptions[i].dispose();
				_vecDescriptions[i] = null;
			}
			_vecDescriptions = null;
			
			for (i = 0; i < _vecMasks.length; i++ )
			{
				_vecMasks[i].dispose();
				_vecMasks[i] = null;
			}
			_vecMasks = null;
			
			for (i = 0; i < _vecSubTitles.length; i++ )
			{
				_vecSubTitles[i].dispose();
				_vecSubTitles[i] = null;
			}
			_vecSubTitles = null;
			
			_titleText.clear();
			_titleText = null;
			
			_instructions.dispose();
			_instructions = null;
			
			_copyright.dispose();
			_copyright = null;
			
			_mask.graphics.clear();
			_mask = null;
		}
		
		public function startTimer():void
		{
			//SETS TIME DELAY FOR INITIAL MASK TWEEN
			_timer = new Timer(1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			_timer.start();
		}
		
		public function startMaskFadeIn():void
		{
			addChild(_mask);
			TweenMax.to(_mask, 0.5, { alpha:1, onComplete:onMaskTweenInComplete } );
		}
		
		private function tweenMask():void
		{
			if (_maskTween)
			{
				Starling.juggler.remove(_maskTween);
			}
				
			//Tween next mask or enable input for user to advance to playing
			if (_maskIndex < _vecMasks.length)
			{
				(!_maskTween) ? _maskTween = new Tween(_vecMasks[_maskIndex], 0.75) : _maskTween.reset(_vecMasks[_maskIndex], 0.75);
				_maskTween.animate("x", Constants.WIDTH);
				_maskTween.animate("scaleX", 0);
				_maskTween.onComplete = tweenMask;
				Starling.juggler.add(_maskTween);
				
				_maskIndex++;
			}
			else
			{
				_inputEnabled = true;
			}
		}
		
		private function onMaskTweenInComplete():void
		{
			dispatchEvent(new Event(Constants.MASK_TWEEN_COMPLETE, true));
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.stop();
			_timer = null;
			
			tweenMask();
			//dispatchEvent(new Event(Constants.MASK_TWEEN_COMPLETE, true)); //temp shortcut out of title
		}
	}
}