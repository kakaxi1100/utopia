package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0xcccccc")]
	public class BezierDynamicTest extends Sprite
	{
		private var center:Point = new Point(0,200);
		private var maxX:Number = 200;
		private var s1:Sprite = new Sprite();
		private var s2:Sprite = new Sprite();
		private var s3:Sprite = new Sprite();
		private var s4:Sprite = new Sprite();
		private var step:Number = 1;
		
		public function BezierDynamicTest()
		{
			super();
			s1.graphics.lineStyle(1, 0xffffff);
			s1.graphics.moveTo(center.x, center.y);
			
			s2.graphics.lineStyle(1, 0xff0000);
			s2.graphics.moveTo(center.x, center.y);
			
			s3.graphics.lineStyle(1, 0x00ff00);
			s3.graphics.lineTo(20, 0);
			s3.graphics.lineStyle(1, 0x0000ff);
			s3.graphics.moveTo(0,0);
			s3.graphics.lineTo(0, 20);
			
			s3.graphics.lineStyle(1, 0x000000);
			s3.graphics.beginFill(0);
			s3.graphics.drawRect(-5, -10, 10, 20);
			s3.graphics.drawCircle(0 , 0, 5);
			s3.graphics.endFill();
			s3.x = center.x;
			s3.y = center.y;
			
			addChild(s3);
			addChild(s2);
			addChild(s1);
			
//			drawAll();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onMouseClick);
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			sin_generator();
		}
		
		private var sin_generator:Function = function():Function
		{
			var x:Number = 0;
			var y:Number = 0;
			var φ:Number = 0;
			var k:Number = 0;
			return function():void
			{
				φ += 0.1;
				s1.graphics.clear();
				s1.graphics.lineStyle(1,0xFFFFFF);
				s1.graphics.moveTo(center.x, center.y);
				x = 0;
				y = 0;
				while(x < 500){
					x += 1;
					y = 20 * Math.sin(0.05 * x + φ);
					s1.graphics.lineTo(center.x + x, center.y + y);
				}
				//计算小车的位置
				s3.x = 100 + center.x;
				s3.y = 20*Math.sin(0.05 * s3.x + φ) + center.y;
				//计算小车的角度
				k = 20 * 0.05 * Math.cos(0.05 * s3.x + φ);
				s3.rotation = Math.atan(k) * 180 / Math.PI;
			}
		}();
		
		
		private var drawEnterFrame:Function = function():Function{
			var y:Number = 0;
			var x:Number = 0;
			var k:Number = 0;
			return function drawSin(obj:DisplayObject):void
			{
				x += step;
				y = original_sin(x);
				
				//这个是 tanφ, 要用atan来求出角度！
				k = derivative_sin(x);
				obj.x = x + center.x;
				obj.y = y + center.y;
				obj.rotation = Math.atan(k) * 180 / Math.PI;
				s1.graphics.lineTo(x + center.x, y + center.y);
			}
		}();
		
//------------------------step-----------------------------------------		
		protected function onMouseClick(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SPACE){
				step = -1;
			}else{
				step = 1;
			}
			
			drawAll();
		}
		
		private var drawAll:Function = function():Function{
			var y:Number = 0;
			var x:Number = 0;
			var k:Number = 0;
			return function drawSin():void
			{
				//					if(x < maxX)
				//					{
				x += step;
				y = original_sin(x);
				
				//这个是 tanφ, 要用atan来求出角度！
				k = derivative_sin(x);
				s3.x = x + center.x;
				s3.y = y + center.y;
				s3.rotation = Math.atan(k) * 180 / Math.PI;
				s1.graphics.lineTo(x + center.x, y + center.y);
				drawLine(x, y, k);
				//					}
			}
		}();
		
		private function drawLine(x0:Number, y0:Number, k:Number):void
		{
			var b:Number = y0 - k*x0;
			s2.graphics.clear();
			s2.graphics.lineStyle(1, 0xff0000);
			s2.graphics.moveTo(x0 + center.x, y0 + center.y);
			s2.graphics.lineTo(x0 + 100 + center.x, k*(x0 + 100) + b + center.y);
		}
		
//---------------------------sin-----------------------------------
		//sin导数
		private function derivative_sin(x:Number):Number
		{
			return 100 * 0.05 * Math.cos(0.05 * x + 10);
		}
		//sin 原函数
		private function original_sin(x:Number):Number
		{
			return 100 * Math.sin(0.05 * x + 10);
		}
//---------------------------parabola------------------------------------	
		//抛物线导数
		private function derivative_parabola(x:Number):Number
		{
			return 0.02*x;
		}
		
		//抛物线原函数
		private function original_parabola(x:Number):Number
		{
			return 0.01 * x*x;
		}
	}
}