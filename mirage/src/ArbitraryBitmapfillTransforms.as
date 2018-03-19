/**
 * http://www.innerdrivestudios.com/blog/actionscript-2/as2-3d-principles-and-experiments/part-ii-arbitrary-bitmapfill-transforms
 * 任意三角形填充
 * if we map other points than the 
 * (0,0), (bitmap_width,0) and (0, bitmap_height) points, 
 * these equations are going to be more complex
 * 
 * 假设原图的 3个点位 in1, in2, in3 , 目标图的三个点为:out1, out2, out3
 * 
 * in1(x,y) => (a*in1.x + c*in1.y + tx, b*in1.x + d*in1.y + ty) => out1(x,y)
 * in2(x,y) => (a*in2.x + c*in2.y + tx, b*in2.x + d*in2.y + ty) => out2(x,y)
 * in3(x,y) => (a*in3.x + c*in3.y + tx, b*in3.x + d*in3.y + ty) => out3(x,y)
 *  
 * 
 * a*in1.x + c*in1.y + tx = out1.x
 * b*in1.x + d*in1.y + ty = out1.y
 * a*in2.x + c*in2.y + tx = out2.x
 * b*in2.x + d*in2.y + ty = out2.y
 * a*in3.x + c*in3.y + tx = out3.x
 * b*in3.x + d*in3.y + ty = out3.y
 * 
 * 
 * tx = out1.x – a*in1.x – c*in1.y
 * tx = out2.x – a*in2.x – c*in2.y
 * tx = out3.x – a*in3.x – c*in3.y
 * 
 * ty = out1.y – b*in1.x – d*in1.y
 * ty = out2.y – b*in2.x – d*in2.y
 * ty = out3.y – b*in3.x – d*in3.y
 * 
 * 
 * For 1-2 we found:
 * a = (out2.x – out1.x + c*(in1.y – in2.y)) / (in2.x – in1.x)
 * Logically 1-3 will give us:
 * a = (out3.x – out1.x + c*(in1.y – in3.y)) / (in3.x – in1.x)
 * 
 * This in turn provides us two different values for a we can compare:
 * (out2.x – out1.x + c*(in1.y – in2.y)) / (in2.x – in1.x)
 * =
 * (out3.x – out1.x + c*(in1.y – in3.y)) / (in3.x – in1.x)
 * 
 * Multiplying by (in2.x – in1.x)* (in3.x – in1.x) gives us:
 * (out2.x – out1.x + c*(in1.y – c*in2.y)) * (in3.x – in1.x)
 * =
 * (out3.x – out1.x + c*(in1.y – c*in3.y)) * (in2.x – in1.x)
 * 
 * Rewriting this:
 * (out2.x – out1.x)* (in3.x – in1.x) + c*(in1.y – in2.y)* (in3.x – in1.x)
 * =
 * (out3.x – out1.x) * (in2.x – in1.x) + c*(in1.y – in3.y) * (in2.x – in1.x)
 * 
 * which is the same as (combining the c’s and non c’s)
 * c*(in1.y – in2.y)* (in3.x – in1.x) – c*(in1.y – in3.y) * (in2.x – in1.x) 
 * =
 * (out3.x – out1.x) * (in2.x – in1.x) – (out2.x – out1.x)* (in3.x – in1.x)
 * 
 * in which we can isolate c:
 * c * ((in1.y – in2.y)* (in3.x – in1.x) – (in1.y – in3.y) * (in2.x – in1.x)) 
 * =
 * (out3.x – out1.x) * (in2.x – in1.x) – (out2.x – out1.x)* (in3.x – in1.x)
 * 
 * finally giving us:
 * c = ((out3.x – out1.x) * (in2.x – in1.x) – (out2.x – out1.x)* (in3.x – in1.x)) /
 * ((in1.y – in2.y)* (in3.x – in1.x) – (in1.y – in3.y) * (in2.x – in1.x))
 * =>
 * c = (out1.x*(in3.x-in2.x)+out2.x*(in1.x-in3.x)+out3.x*(in2.x – in1.x)) /
 * (in1.y *(in3.x-in2.x)+in2.y*(in1.x-in3.x)+in3.y*(in2.x – in1.x)))
 * 
 * 
 * 最后的通用公式:
 * var dIn32x:Number = in3.x – in2.x;
 * var dIn13x:Number = in1.x – in3.x;
 * var dIn21x:Number = in2.x – in1.x;
 * var dIn32y:Number = in3.y – in2.y;
 * var dIn13y:Number = in1.y – in3.y;
 * var dIn21y:Number = in2.y – in1.y;
 * 
 * var denomAB:Number = 1/((in1.x * dIn32y) + (in2.x * dIn13y) + (in3.x * dIn21y));
 * var denomCD:Number = 1/((in1.y * dIn32x) + (in2.y * dIn13x) + (in3.y * dIn21x));
 * 
 * var matrix:Matrix = new Matrix();
 * 
 * matrix.a = ((out1.x * dIn32y) + (out2.x * dIn13y) + (out3.x * dIn21y)) * denomAB;
 * matrix.b = ((out1.y * dIn32y) + (out2.y * dIn13y) + (out3.y * dIn21y)) * denomAB;
 * matrix.c = ((out1.x * dIn32x) + (out2.x * dIn13x) + (out3.x * dIn21x)) * denomCD;
 * matrix.d = ((out1.y * dIn32x) + (out2.y * dIn13x) + (out3.y * dIn21x)) * denomCD;
 * matrix.tx = out1.x – (matrix.a * in1.x) – (matrix.c * in1.y);
 * matrix.ty = out1.y – (matrix.b * in1.x) – (matrix.d * in1.y);
 * 
 * 
 * 
 */


package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	
	[SWF(width="800", height="600", frameRate="120", backgroundColor="0")]
	public class ArbitraryBitmapfillTransforms extends Sprite
	{
		private var matrix:Matrix = new Matrix();
		
		[Embed(source="assets/Cat256256.jpg")]
		private var Cat:Class;
		
		private var cat:Bitmap = new Cat();
		
		private var p0:Sprite = new Sprite();
		private var p1:Sprite = new Sprite();
		private var p2:Sprite = new Sprite();
		
		private var dest:Sprite = new Sprite();
		
		private var currentP:Sprite;
		private var plist:Array = [p0, p1, p2];
		private var index:int = 0;
		public function ArbitraryBitmapfillTransforms()
		{
			super();
			
			dest.x = 100;
			dest.y = 100;
			dest.addChild(cat);
			addChild(dest);
			
			p0.graphics.beginFill(0x00ff00);
			p0.graphics.drawCircle(0,0,10);
			p0.graphics.endFill();
			p0.x = dest.x;
			p0.y = dest.y;
			addChild(p0);
			
			p1.graphics.beginFill(0x00ff00);
			p1.graphics.drawCircle(0,0,10);
			p1.graphics.endFill();
			p1.x = dest.x + 256;
			p1.y = 0;
			addChild(p1);
			
			p2.graphics.beginFill(0x00ff00);
			p2.graphics.drawCircle(0,0,10);
			p2.graphics.endFill();
			p2.x = 0;
			p2.y = dest.y + 256;
			addChild(p2);
			
			matrix.a = (p1.x - p0.x) / 256;
			matrix.b = (p1.y - p0.y) / 256;
			matrix.c = (p2.x - p0.x) / 256;
			matrix.d = (p2.y - p0.y) / 256;
			matrix.tx = p0.x;
			matrix.ty = p0.y;
			
			dest.transform.matrix = this.matrix;
			
			currentP = plist[index];
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function addjustMatrix():void
		{
			matrix.a = (p1.x - p0.x) / 256;
			matrix.b = (p1.y - p0.y) / 256;
			matrix.c = (p2.x - p0.x) / 256;
			matrix.d = (p2.y - p0.y) / 256;
			matrix.tx = p0.x;
			matrix.ty = p0.y;
			
			dest.transform.matrix = this.matrix;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					currentP.y -= 10;
					break;
				case Keyboard.DOWN:
					currentP.y += 10;
					break;
				case Keyboard.LEFT:
					currentP.x -= 10;
					break;
				case Keyboard.RIGHT:
					currentP.x += 10;
					break;
				case Keyboard.SPACE:
					index++
					if(index >= plist.length)
				{
					index = 0;
				}
					
					currentP = plist[index];
					break;
			}
			
			addjustMatrix();
		}
	}
}