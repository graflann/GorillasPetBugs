package view.panels 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.globalization.LocaleID;
	import flash.text.TextField;
	import model.vo.*;
	import starling.display.*;
	import view.components.*;
	import view.gameObjects.*;
	import view.gameObjects.particles.ParticleSystem;
	import view.gameObjects.particles.text.TextParticle;
	import view.gameObjects.particles.text.Total;
	
	import com.greensock.TweenMax;
	import starling.textures.Texture;
	import assets.AssetManager;
	
	import com.greensock.TweenMax;
	
	import view.gameObjects.particles.ParticleTypes;
	
	import engine.Score;
	
	import engine.SoundManager;
	
	/**
	 * Where actually playing the game takes place; this is the parent of level panels
	 * @author Grant Flannery
	 */
	public class PlayPanel extends Panel 
	{
		public static const GORILLA_ORIGIN:Point = new Point(48, 120);
		
		private var _background:Image;
		
		private var _mask:Shape;
		
		private var _gridComponent:GridComponent;
		public function get gridComponent():GridComponent { return _gridComponent; }
		
		private var _scoreComponent:ScoreComponent;
		public function get scoreComponent():ScoreComponent { return _scoreComponent; }
		
		private var _statusComponent:StatusComponent;
		public function get statusComponent():StatusComponent { return _statusComponent; }
		
		private var _muteSymbol:MuteSymbol;
		
		private var _gorilla:Gorilla;
		
		private var _totalParticleSystem:ParticleSystem;
		private var _bonusParticleSystem:ParticleSystem;
		
		public var isAuxiliaryInputEnabled:Boolean;
		
		/**
		 * CTOR
		 */
		public function PlayPanel() {}
		
		override public function init():void 
		{
			_starlingSprite = new Sprite();
			
			_mask = new Shape();
			_mask.graphics.beginBitmapFill(new BitmapData(Constants.WIDTH, Constants.HEIGHT, true, 0xFFC8C8B0), null, false);
			_mask.graphics.drawRect(0, 0, Constants.WIDTH, Constants.HEIGHT);
			_mask.graphics.endFill();
			
			_background = new Image(Texture.fromBitmapData(AssetManager.getBitmapData("emptyJarBackground")));
			_starlingSprite.addChild(_background);
			
			_gridComponent = new GridComponent();
			_gridComponent.init();
			_gridComponent.x = (Constants.WIDTH * 0.5) - (_gridComponent.width * 0.5);
			_gridComponent.y = (Constants.HEIGHT * 0.5) - (_gridComponent.height * 0.5);
			_starlingSprite.addChild(_gridComponent);
			_gridComponent.stop();
			
			_gorilla = new Gorilla();
			
			_scoreComponent = new ScoreComponent();
			_scoreComponent.init();
			
			_statusComponent = new StatusComponent();
			_statusComponent.init();
			
			_totalParticleSystem = new ParticleSystem("text." + ParticleTypes.TOTAL, 4);
			_totalParticleSystem.init();
			
			_bonusParticleSystem = new ParticleSystem("text." + ParticleTypes.BONUS, 4);
			_bonusParticleSystem.init();
			
			_starlingSprite.addChild(_scoreComponent);
			
			_muteSymbol = new MuteSymbol();
			_muteSymbol.init();
			_muteSymbol.x = Constants.WIDTH - _muteSymbol.width;
			_muteSymbol.y = Constants.HEIGHT - _muteSymbol.height;
			_starlingSprite.addChild(_muteSymbol);
			_muteSymbol.toggle(SoundManager.isMuted);
			
			addChild(_statusComponent);
			
			isAuxiliaryInputEnabled = false;
		}
		
		override public function update():void 
		{
			_gorilla.update();
			_gridComponent.update();
		}
		
		override public function clear():void 
		{
			var i:int = -1;
			
			super.clear();
			
			_gorilla.clear();
			_gorilla = null;
			
			_background.dispose();
			_background = null;
			
			_gridComponent.clear();
			_scoreComponent.clear();
			_statusComponent.clear();
			_muteSymbol.clear();
			
			_totalParticleSystem.clear();
			_totalParticleSystem = null;
			
			_gridComponent = null;
			_scoreComponent = null;
			_statusComponent = null;
			_muteSymbol = null;
			
			_mask.graphics.clear();
			_mask = null;
		}
		
		public function togglePause(isPaused:Boolean):void
		{
			_gridComponent.togglePause(isPaused);
		}
		
		public function createTotal(origin:Point, multiplier:Number, numBonus:Number):void
		{
			var particle:TextParticle;
			
			_totalParticleSystem.emit(_starlingSprite, 1, origin.x, origin.y, 0, 0, 0, 0, 0, 0, 1, 1, _scoreComponent.scoreText.x, _scoreComponent.scoreText.y);
			particle = _totalParticleSystem.getCurrentParticle() as TextParticle;
			particle.setText(Score.currentRemovedValue.toString());
			
			if(multiplier > 1)
			{
				_bonusParticleSystem.emit(_starlingSprite, 1, origin.x, origin.y - particle.height);
				particle = _bonusParticleSystem.getCurrentParticle() as TextParticle;
				particle.setText("X" + multiplier.toString());
			}
			
			if (numBonus > 0)
			{
				_bonusParticleSystem.emit(_starlingSprite, 1, origin.x, particle.y - particle.height);
				particle = _bonusParticleSystem.getCurrentParticle() as TextParticle;
				particle.setText("BONUS!");
			}
		}
		
		public function startGorillaKick():void
		{
			_gorilla.setState(Gorilla.KICK);
		}
		
		public function stopGorilla():void
		{
			_gorilla.setState(Gorilla.FRONT_STATIC);
		}
		
		public function startMaskFadeIn():void
		{
			addChild(_mask);
			TweenMax.to(_mask, 0.5, { alpha:1, onComplete:onMaskTweenInComplete } );
		}
		
		public function startMaskFadeOut():void
		{
			_gorilla.init();
			_gorilla.x = GORILLA_ORIGIN.x;
			_gorilla.y = GORILLA_ORIGIN.y;
			_starlingSprite.addChild(_gorilla);
			
			addChild(_mask);
			TweenMax.to(_mask, 0.5, { alpha:0, onComplete:onMaskTweenOutComplete } );
			SoundManager.play(SoundName.MUSIC);
		}
		
		public function toggleMute(isMute:Boolean):void
		{
			_muteSymbol.toggle(isMute);
		}
		
		private function onMaskTweenInComplete():void
		{
			dispatchEvent(new Event(Constants.MASK_TWEEN_COMPLETE, true));
		}
		
		private function onMaskTweenOutComplete():void
		{
			removeChild(_mask);
		}
	}

}