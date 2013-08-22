package view.gameObjects.particles.text 
{
	import flash.display.BitmapData;
	import flash.events.*;
	import starling.animation.*;
	import starling.core.*;
	import starling.display.*;
	import view.components.GridComponent;
	import starling.textures.Texture;
	import starling.text.TextField;
	import flash.display.Shape;
	
	/**
	 * Renders BONUS! for any bonus Bugs removed during turn
	 * @author Grant Flannery
	 */
	public class Bonus extends TextParticle 
	{
		public function Bonus() 
		{
			
		}
		
		override public function init():void 
		{
			var i:int = 0,
			bmd:BitmapData,
			textOffset:Number = 2;
			
			super.init();
			
			_backgroundShape = new Shape();
			_backgroundShape.graphics.beginFill(0xC8C8B0, 0.75);
			_backgroundShape.graphics.lineStyle(2, 0xFFFFFF);
			_backgroundShape.graphics.drawRoundRect(2, 2, 64, 24, 8, 8);
			_backgroundShape.graphics.endFill();
			
			bmd = new BitmapData(68, 28, true, 0x00000000);
			bmd.draw(_backgroundShape);
			
			_background = new Image(Texture.fromBitmapData(bmd));
			_background.x = -2;
			_background.y = -2;
			addChild(_background);
			
			_vecTextField = new Vector.<TextField>(3);
			_vecTextField.fixed = true;
			
			for (i = 0; i < _vecTextField.length; i++ )
			{
				if (i < 2)
				{
					_vecTextField[i] = new TextField(64, 32, "", FontName.AXI_5X5, 13, 0xFFFFFF, true);
				}
				else
				{
					_vecTextField[i] = new TextField(64, 32, "", FontName.AXI_5X5, 13, 0x0);
				}
				
				if (i > 0)
				{
					_vecTextField[i].x += textOffset;
					_vecTextField[i].y += textOffset;
				}
				else 
				{
					_vecTextField[i].x += (textOffset * 2);
					_vecTextField[i].y += (textOffset * 2);
				}
				
				addChild(_vecTextField[i]);
			}
			
			bmd.dispose();
			bmd = null;
		}
		
		override public function create(container:DisplayObjectContainer, maxPosX:Number = 0, maxPosY:Number = 0, posOffsetX:Number = 0, posOffsetY:Number = 0, minVelX:Number = 0, maxVelX:Number = 0, minVelY:Number = 0, maxVelY:Number = 0, minScale:Number = 1, maxScale:Number = 1, destX:Number = 0, destY:Number = 0, isRotated:Boolean = false):void 
		{
			super.create(container, maxPosX, maxPosY, posOffsetX, posOffsetY, minVelX, maxVelX, minVelY, maxVelY, minScale, maxScale, destX, destY, isRotated);
			
			_tween = new Tween(this, 2.0);
			_tween.fadeTo(0);
			_tween.animate("y", maxPosY - (GridComponent.UNIT * 2));
			_tween.onComplete = onTweenComplete;
			Starling.juggler.add(_tween);
		}
		
		override public function kill():void 
		{
			super.kill();
			
			alpha = 1;
			
			Starling.juggler.remove(_tween);
			_tween = null;
		}
		
		private function onTweenComplete():void
		{
			kill();
		}
	}

}