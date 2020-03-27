/**
 * 由此例可以得出3D变换如果不做透视处理的话, 那么前面的插值计算就是仿射变换
 * 
 * 
 * 
 * 
 */
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF(width="1000", height="800", frameRate="60", backgroundColor="0")]
	public class AffineTransfomAndInterpolation extends Sprite
	{
		[Embed(source="assets/Cat256256.jpg")]
		private var Cat:Class;
		
		private var cat:Bitmap = new Cat();
		private var src:Sprite = new Sprite();
		private var dest:Sprite = new Sprite();
		
		private var bitmap:Bitmap = new Bitmap(new BitmapData(256, 256, false, 0));
		private var dest2:Sprite = new Sprite();
		
		private var in1:Sprite = new Sprite();
		private var in2:Sprite = new Sprite();
		private var in3:Sprite = new Sprite();
		
		private var out1:Sprite = new Sprite();		
		private var out2:Sprite = new Sprite();		
		private var out3:Sprite = new Sprite();		
		
		private var matrix:Matrix = new Matrix();
		
		private var currentP:Sprite;
		private var plist:Array = [in1, in2, in3, out1, out2, out3];
		private var index:int = 0;
		
		public function AffineTransfomAndInterpolation()
		{
			super();
			src.x = 100;
			src.y = 50;
			addChild(src);
			src.addChild(cat);
			
			dest.x = src.x + src.width + 40;
			dest.y = src.y;
			addChild(dest);
			
			in1.graphics.beginFill(0x00ff00);
			in1.graphics.drawCircle(0,0,10);
			in1.graphics.endFill();
			in1.x = cat.x;
			in1.y = cat.y;
			src.addChild(in1);
			
			in2.graphics.beginFill(0x00ff00);
			in2.graphics.drawCircle(0,0,10);
			in2.graphics.endFill();
			in2.x = cat.x + 256;
			in2.y = cat.y;
			src.addChild(in2);
			
			in3.graphics.beginFill(0x00ff00);
			in3.graphics.drawCircle(0,0,10);
			in3.graphics.endFill();
			in3.x = cat.x;
			in3.y = cat.y + 256;
			src.addChild(in3);
			
			
			out1.graphics.beginFill(0x00ff00);
			out1.graphics.drawCircle(0,0,10);
			out1.graphics.endFill();
			out1.x = 0;
			out1.y = 0;
			dest.addChild(out1);
			
			out2.graphics.beginFill(0x00ff00);
			out2.graphics.drawCircle(0,0,10);
			out2.graphics.endFill();
			out2.x = 256;
			out2.y = 0;
			dest.addChild(out2);
			
			out3.graphics.beginFill(0x00ff00);
			out3.graphics.drawCircle(0,0,10);
			out3.graphics.endFill();
			out3.x = 0;
			out3.y = 256;
			dest.addChild(out3);
			
			dest2.x = dest.x;
			dest2.y = src.y + src.height + 40;
			dest2.addChild(bitmap);
			addChild(dest2);
			
			currentP = plist[index];
			currentP.graphics.beginFill(0xff0000);
			currentP.graphics.drawCircle(0,0,10);
			currentP.graphics.endFill();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);		
			
			process();
		}
		
		private function process():void
		{
			addjustMatrix();
			
			bitmap.bitmapData.fillRect(bitmap.bitmapData.rect, 0);
			drawTriangle(new Point(out1.x, out1.y), new Point(out2.x, out2.y), new Point(out3.x, out3.y),
						new Point(in1.x, in1.y), new Point(in2.x, in2.y), new Point(in3.x, in3.y),
						bitmap.bitmapData, cat.bitmapData);			
		}
		
		private function addjustMatrix():void
		{
			var dIn32x:Number = in3.x - in2.x;
			var dIn13x:Number = in1.x - in3.x;
			var dIn21x:Number = in2.x - in1.x;
			var dIn32y:Number = in3.y - in2.y;
			var dIn13y:Number = in1.y - in3.y;
			var dIn21y:Number = in2.y - in1.y;
			
			var denomAB:Number = 1/((in1.x * dIn32y) + (in2.x * dIn13y) + (in3.x * dIn21y));
			var denomCD:Number = 1/((in1.y * dIn32x) + (in2.y * dIn13x) + (in3.y * dIn21x));
			
			matrix.a = ((out1.x * dIn32y) + (out2.x * dIn13y) + (out3.x * dIn21y)) * denomAB;
			matrix.b = ((out1.y * dIn32y) + (out2.y * dIn13y) + (out3.y * dIn21y)) * denomAB;
			matrix.c = ((out1.x * dIn32x) + (out2.x * dIn13x) + (out3.x * dIn21x)) * denomCD;
			matrix.d = ((out1.y * dIn32x) + (out2.y * dIn13x) + (out3.y * dIn21x)) * denomCD;
			matrix.tx = out1.x - (matrix.a * in1.x) - (matrix.c * in1.y);
			matrix.ty = out1.y - (matrix.b * in1.x) - (matrix.d * in1.y);
			
			dest.graphics.clear();
			dest.graphics.beginBitmapFill(cat.bitmapData, matrix, false, true);
			dest.graphics.lineStyle(2, 0xffffff);
			dest.graphics.moveTo(out1.x, out1.y);
			dest.graphics.lineTo(out2.x, out2.y);
			dest.graphics.lineTo(out3.x, out3.y);
			dest.graphics.lineTo(out1.x, out1.y);
			dest.graphics.endFill();
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
					currentP.graphics.beginFill(0x00ff00);
					currentP.graphics.drawCircle(0,0,10);
					currentP.graphics.endFill();
					if(index >= plist.length)
					{
						index = 0;
					}
					
					currentP = plist[index];
					currentP.graphics.beginFill(0xff0000);
					currentP.graphics.drawCircle(0,0,10);
					currentP.graphics.endFill();
					break;
			}
			
			process();
		}
		
		public function drawTriangle(p1:Point, p2:Point, p3:Point,
									 uv1:Point, uv2:Point, uv3:Point,
									 bmd:BitmapData, texture:BitmapData):void
		{
			
			var temp:Point;
			var tempUV:Point;
			if(p1.y > p2.y)
			{
				temp = p1;
				p1 = p2;
				p2 = temp;
				
				tempUV = uv1;
				uv1 = uv2;
				uv2 = tempUV;
			}
			
			if(p1.y > p3.y)
			{
				temp = p1;
				p1 = p3;
				p3 = temp;
				
				tempUV = uv1;
				uv1 = uv3;
				uv3 = tempUV;
			}
			
			if(p2.y > p3.y)
			{
				temp = p2;
				p2 = p3;
				p3 = temp;
				
				tempUV = uv2;
				uv2 = uv3;
				uv3 = tempUV;
			}

			var a:Number = p3.y - p1.y;
			var b:Number = p1.x - p3.x;
			var c:Number = p3.x*p1.y - p1.x*p3.y;
			var result:Number = p2.x*a + p2.y*b + c;
			var y:int;
			if(result > 0)
			{
				for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
				{
					if(y < p2.y)
					{
						processScanLine(y, p1, p3, p1, p2, uv1, uv3, uv1, uv2, bmd, texture);
					}else
					{
						processScanLine(y, p1, p3, p2, p3, uv1, uv3, uv2, uv3, bmd, texture);
					}
				}
			}else
			{
				for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
				{
					if(y < p2.y)
					{
						processScanLine(y, p1, p2, p1, p3, uv1, uv2, uv1, uv3, bmd, texture);
					}else
					{
						processScanLine(y, p2, p3, p1, p3, uv2, uv3, uv1, uv3, bmd, texture);
					}
				}
			}
		}
		
		private function processScanLine(y:int, pa:Point, pb:Point, pc:Point, pd:Point, 
										 uva:Point, uvb:Point, uvc:Point, uvd:Point,
										 bmd:BitmapData, texture:BitmapData):void
		{
			var gradient1:Number = pa.y != pb.y ? (y - pa.y) / (pb.y - pa.y) : 1;
			var gradient2:Number = pc.y != pd.y ? (y - pc.y) / (pd.y - pc.y) : 1;
			
			var sx:int = interpolate(pa.x, pb.x, gradient1) >> 0;
			var ex:int = interpolate(pc.x, pd.x, gradient2) >> 0;
			
			var su:Number = interpolate(uva.x, uvb.x, gradient1);
			var eu:Number = interpolate(uvc.x, uvd.x, gradient2);
			
			var sv:Number = interpolate(uva.y, uvb.y, gradient1);
			var ev:Number = interpolate(uvc.y, uvd.y, gradient2);

			for(var x:int = sx; x < ex; x++) {
				var gradient:Number = (x - sx)/(ex - sx);
				var u:Number = interpolate(su, eu, gradient) >> 0;
				var v:Number = interpolate(sv, ev, gradient) >> 0;
				bmd.setPixel(x, y, texture.getPixel(u,v));
			}
		}
		
		private function interpolate(p0:Number, p1:Number, gradient:Number):Number
		{
			return p0 + (p1 - p0)* clamp(gradient);
		}
		
		private static function clamp(value:Number, min:Number = 0, max:Number = 1):Number
		{
			return Math.max(min, Math.min(value, max));
		}
	}
}


