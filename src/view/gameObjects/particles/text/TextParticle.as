package view.gameObjects.particles.text 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.animation.Tween;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import view.gameObjects.particles.Particle;
	
	import starling.core.Starling;
	
	import flash.events.TimerEvent;
	
	import starling.textures.Texture;
	
	/**
	 * 
	 * @author Grant Flannery
	 */
	public class TextParticle extends Particle 
	{
		protected var _backgroundShape:Shape;
		protected var _background:Image;
		
		protected var _vecTextField:Vector.<TextField>;
		
		protected var _tween:Tween;
		
		protected var _timer:Timer;
		
		protected var _dest:Point;
		
		public function TextParticle() 
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
					_vecTextField[i] = new TextField(64, 32, "", FontName.AXI_5X5, 16, 0xFFFFFF, true);
				}
				else
				{
					_vecTextField[i] = new TextField(64, 32, "", FontName.AXI_5X5, 16, 0x0);
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
		
		override public function clear():void 
		{
			super.clear();
			
			for (var i:int = 0; i < _vecTextField.length; i++ )
			{
				_vecTextField[i].dispose();
				_vecTextField[i] = null;
			}
			_vecTextField = null;
			
			_backgroundShape.graphics.clear();
			_backgroundShape = null;
			
			_background.dispose();
			_background = null;
			
			_tween = null;
						
			_timer = null;
		}
		
		public function setText(value:String):void
		{
			var i:int = 0,
			length:int = _vecTextField.length;
			
			while (++i < length)
			{
				_vecTextField[i].text = value;
			}
		}
	}

}