package view.components 
{
	import flash.display.BitmapData;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import view.gameObjects.bugs.Bug;
	import view.gameObjects.bugs.BugType;
	
	import assets.AssetManager;
	
	import engine.Score;
	
	import starling.textures.Texture;
	
	import starling.core.Starling;
	
	/**
	 * Renders current session score
	 * @author Grant Flannery
	 */
	public class ScoreComponent extends Sprite
	{
		private var _background:Image;
		
		private var _scoreText:TextField;
		public function get scoreText():TextField { return _scoreText; }
		
		private var _highScoreText:TextField;
		public function get highScoreText():TextField { return _highScoreText; }
		
		private var _highScoreDesc:TextField;
		
		private var _bonusContainer:Sprite;
		
		private var _bonusText:TextField;
		
		private var _bonusBug:Bug;
		
		private var _isBonusVisible:Boolean;
		
		private var _scoreTween:Tween;
		
		public function ScoreComponent() {}
		
		public function init():void
		{
			var bmd:BitmapData = new BitmapData(Constants.WIDTH, 32, true, 0xAAC8C8B0);
			
			Score.init();
			
			_background = new Image(Texture.fromBitmapData(bmd));
			addChild(_background)
	
			_scoreText = new TextField(Constants.WIDTH * 0.25, 32, Score.sessionTotal.toString(), FontName.AXI_5X5, 16, 0x0);
			_scoreText.hAlign = "left";
			_scoreText.x = 8; 
			_scoreText.y = 8;
			addChild(_scoreText);
			
			_highScoreText = new TextField(Constants.WIDTH * 0.25, 32, Score.high.toString(), FontName.AXI_5X5, 16, 0x0);
			_highScoreText.hAlign = "left";
			_highScoreText.x = Constants.WIDTH - _highScoreText.width; 
			_highScoreText.y = 8;
			addChild(_highScoreText);
			
			_highScoreDesc = new TextField(32, 32, "HI", FontName.AXI_5X5, 16, 0x0);
			_highScoreDesc.hAlign = "left";
			_highScoreDesc.x = _highScoreText.x - _highScoreDesc.width; 
			_highScoreDesc.y = 8;
			addChild(_highScoreDesc);
			
			_bonusContainer = new Sprite();
			
			_bonusText = new TextField(72, 32, "BONUS", FontName.AXI_5X5, 16, 0x0);
			_bonusText.hAlign = "left";
			_bonusText.x = 8;
			_bonusText.y = 8;
			_bonusContainer.addChild(_bonusText);
			
			_bonusContainer.x = (width * 0.5) - (_bonusContainer.width * 0.5) - 20;
			_bonusContainer.alpha = 0;
			addChild(_bonusContainer);
			
			_isBonusVisible = false;
			
			bmd.dispose();
			bmd = null;
		}
		
		public function update(useTween:Boolean = false):void
		{
			_scoreText.text = Score.sessionTotal.toString();
			_highScoreText.text = Score.high.toString();
			
			updateBonus();
			
			if (useTween)
			{
				_scoreText.alpha = 0;
				
				if (_scoreTween)
				{
					Starling.juggler.remove(_scoreTween);
					_scoreTween = null;
				}
				
				_scoreTween = new Tween(_scoreText, 2.0);
				_scoreTween.fadeTo(1);
				Starling.juggler.add(_scoreTween);
			}
		}
		
		public function clear():void
		{
			removeChildren();
			
			_bonusContainer.removeChildren();
			
			_background.dispose();
			_background = null;
			
			_scoreText.dispose();
			_scoreText = null;
			
			_bonusText.dispose();
			_bonusText = null;
			
			if (_bonusBug)
			{
				_bonusBug.clear();
				_bonusBug = null;
			}
			
			_bonusContainer.dispose();
			_bonusContainer = null;
		}
		
		public function forceBonusRemoval():void
		{
			if (_bonusBug)
			{
				removeBonus();
			}
		}
		
		private function updateBonus():void
		{
			if (Score.bonusColor != "" && _isBonusVisible == false)
			{
				addBonus();
			}
			else if(Score.bonusColor == "" && _isBonusVisible == true)
			{
				removeBonus();
			}
		}
		
		private function addBonus():void
		{
			_bonusBug = new Bug(Score.bonusColor);
			_bonusBug.init();
			_bonusBug.x = _bonusText.x + _bonusText.width - 8;
			_bonusContainer.addChild(_bonusBug);
			
			_bonusContainer.alpha = 1;
			
			_isBonusVisible = true;
		}
		
		private function removeBonus():void
		{
			_bonusContainer.alpha = 0;
			
			_bonusContainer.removeChild(_bonusBug);
			_bonusBug.clear();
			_bonusBug = null;
			
			_isBonusVisible = false;
		}
	}

}