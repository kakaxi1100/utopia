package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class Test3DrawTriangle extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800, 600);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var pointContianer:Sprite = new Sprite();
		private var p1:Point = new Point();
		private var p2:Point = new Point();
		private var p3:Point = new Point();
		public function Test3DrawTriangle()
		{
			super();
			stage.addChild(bmp);
			stage.addChild(pointContianer);
			
//			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			
//			p1.setTo(400, 300);
//			p2.setTo(350, 350);
//			p3.setTo(300, 400);
			
//			p1.setTo(400, 300);
//			p2.setTo(200, 300);
//			p3.setTo(300, 200);
			
//			p1.setTo(400, 100);
//			p2.setTo(400, 300);
//			p3.setTo(500, 300);
			
//			p1.setTo(400, 100);
//			p2.setTo(400, 300);
//			p3.setTo(300, 300);
			
//			p1.setTo(500, 100);
//			p2.setTo(300, 101);
//			p3.setTo(400, 200);
			
			
//			p1.setTo(700, 109);
//			p2.setTo(500, 110.2766218483448);
//			p3.setTo(700, 442);
			
//			p1.setTo(700, 109);
//			p2.setTo(500, 110);
//			p3.setTo(700, 442);
			
			p1.setTo(100, 100);
			p2.setTo(200, 100);
			p3.setTo(100, 300);
			
			this.drawTriangleEasy(p1, p2, p3);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			var i:int;
			switch(event.keyCode)
			{
				case Keyboard.B:
					bmd.fillRect(bmd.rect, 0xffffffff);
					this.pointContianer.graphics.clear();
					
					this.randomTriangle();
					break;
				case Keyboard.A:
					this.randomTriangle();
					break;
				case Keyboard.SPACE:
					for(i = 0; i < 10; i++)
					{
						this.randomTriangle();
					}
					break;
				case Keyboard.BACKSPACE:
					bmd.fillRect(bmd.rect, 0xffffffff);
					this.pointContianer.graphics.clear();
					break;
			}
		}
		
		
		private function randomTriangle():void
		{
			p1.x = Math.random() * 800;
			p1.y = Math.random() * 600;
			p2.x = Math.random() * 800;
			p2.y = Math.random() * 600;
			p3.x = Math.random() * 800;
			p3.y = Math.random() * 600;
			
			this.drawTriangleEasy(p1, p2, p3, Math.random()*0xffffff);
		}
		
		private function drawTriangleEasy(p1:Point, p2:Point, p3:Point, color:uint = 0):void
		{
			//1. 按y值排序 p1.y ≤ p2.y ≤ p3.y 
			var temp:Point;
			//p1.y < p2.y
			if(p1.y > p2.y)
			{
				temp = p1;
				p1 = p2;
				p2 = temp;
			}
			//p1.y < p3.y
			if(p1.y > p3.y)
			{
				temp = p1;
				p1 = p3;
				p3 = temp;
			}
			//p2.y < p3.y
			if(p2.y > p3.y)
			{
				temp = p2;
				p2 = p3;
				p3 = temp;
			}
			trace(p1, p2, p3);
			this.pointContianer.graphics.beginFill(0xff0000, 1);
			this.pointContianer.graphics.drawCircle(p1.x, p1.y, 2);
			this.pointContianer.graphics.drawCircle(p2.x, p2.y, 2);
			this.pointContianer.graphics.drawCircle(p3.x, p3.y, 2);
			this.pointContianer.graphics.endFill();
			//2.判断p2在p1p3的那一侧, 只比较x值是不够的
			//可以用直线的一般方程来判断, <0 在左侧, >0在右侧. 可用 y-x=0  y-2x=0  y-0.5x=0 这三条直线来检测
			//已知两点可求得直线的一般方程式, AX + BY + C = 0, (x1, y1), (x2, y2) 先用斜截式考虑飞0情况展开, 再考虑0的情况, 可求得
			// A = Y2 - Y1,  B = X1 - X2, C = X2*Y1 - X1*Y2
			// p1 => (x1, y1) , p3 => (x2, y2) 因为斜率是按照 p1计算的
			var a:Number = p3.y - p1.y;
			var b:Number = p1.x - p3.x;
			var c:Number = p3.x*p1.y - p1.x*p3.y;
			var result:Number = p2.x*a + p2.y*b + c;
			var y:int;
			if(result > 0)
			{
				trace("p2 at right of p1p3");
				for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
				{
					if(y < p2.y)
					{
						this.processScanLine(y, p1, p3, p1, p2, color);
					}else
					{
						this.processScanLine(y, p1, p3, p2, p3, color);//平顶 如果 p1.y == p2.y 直接就处理这里了, 精妙!
					}
				}
			}else
			{
				trace("p2 at left of p1p3");
				for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
				{
					if(y < p2.y)
					{
						this.processScanLine(y, p1, p2, p1, p3, color);
					}else
					{
						this.processScanLine(y, p2, p3, p1, p3, color);
					}
				}
			}
		}
	
		//处理扫描线
		//y表示当前处理的行值
		// pa, pb 是左边的线, pc, pd 是右边的线
		private function processScanLine(y:int, pa:Point, pb:Point, pc:Point, pd:Point, color:uint = 0):void
		{
			//这里的处理非常巧妙, 佩服佩服！！
			//先得到, 左边线的处理进度, 再得到右边线的处理进度
			var gradient1:Number = pa.y != pb.y ? (y - pa.y) / (pb.y - pa.y) : 1;
			var gradient2:Number = pc.y != pd.y ? (y - pc.y) / (pd.y - pc.y) : 1;
			
			var sx:int = this.interpolate(pa.x, pb.x, gradient1) >> 0;
			var ex:int = this.interpolate(pc.x, pd.x, gradient2) >> 0;
			
			// drawing a line from left (sx) to right (ex) 
			for(var x:int = sx; x < ex; x++) {
				this.bmd.setPixel(x, y, color);
			}
		}
		
		//gradient是一个0~1之间的数
		// p0 + (p1 - p0)*gradient
		private function interpolate(p0:Number, p1:Number, gradient:Number):Number
		{
			return p0 + (p1 - p0)* this.clamp(gradient);
		}
		
		// Clamping values to keep them between 0 and 1
		private function clamp(value:Number, min:Number = 0, max:Number = 1):Number
		{
			return Math.max(min, Math.min(value, max));
		}
		
//--------------------------------------------------------------------------		
//		private function drawTriangle(p1:Point, p2:Point, p3:Point):void
//		{
//			//1. 按y值排序 p1.y ≤ p2.y ≤ p3.y 
//			var temp:Point;
//			//p1.y < p2.y
//			if(p1.y > p2.y)
//			{
//				temp = p1;
//				p1 = p2;
//				p2 = temp;
//			}
//			//p1.y < p3.y
//			if(p1.y > p3.y)
//			{
//				temp = p1;
//				p1 = p3;
//				p3 = temp;
//			}
//			//p2.y < p3.y
//			if(p2.y > p3.y)
//			{
//				temp = p2;
//				p2 = p3;
//				p3 = temp;
//			}
//			trace(p1, p2, p3);
//			this.pointContianer.graphics.beginFill(0xff0000, 1);
//			this.pointContianer.graphics.drawCircle(p1.x, p1.y, 2);
//			this.pointContianer.graphics.drawCircle(p2.x, p2.y, 2);
//			this.pointContianer.graphics.drawCircle(p3.x, p3.y, 2);
//			this.pointContianer.graphics.endFill();
//			//2.判断p2在p1p3的那一侧, 只比较x值是不够的
//			//可以用直线的一般方程来判断, <0 在左侧, >0在右侧. 可用 y-x=0  y-2x=0  y-0.5x=0 这三条直线来检测
//			//已知两点可求得直线的一般方程式, AX + BY + C = 0, (x1, y1), (x2, y2) 先用斜截式考虑飞0情况展开, 再考虑0的情况, 可求得
//			// A = Y2 - Y1,  B = X1 - X2, C = X2*Y1 - X1*Y2
//			// p1 => (x1, y1) , p3 => (x2, y2) 因为斜率是按照 p1计算的
//			var a:Number = p3.y - p1.y;
//			var b:Number = p1.x - p3.x;
//			var c:Number = p3.x*p1.y - p1.x*p3.y;
//			var result:Number = p2.x*a + p2.y*b + c;
//			
//			//来判断起最初的起始点和终点
//			var sx:Number = p1.x, ex:Number = p1.x;
//			//计算斜率倒数以及sx和ex取什么值, 这里的是斜率的倒数, 因为是求y步进时,x如何变化
//			var d13:Number = 0, d12:Number = 0, d23:Number = 0;
//			if(p3.y != p1.y)
//			{
//				d13 = (p3.x - p1.x)/(p3.y - p1.y);
//			}
//			
//			if(p2.y != p1.y)
//			{
//				d12 = (p2.x - p1.x)/(p2.y - p1.y);
//			}
//			
//			if(p3.y != p2.y)
//			{
//				d23 = (p3.x - p2.x)/(p3.y - p2.y);
//			}
//			trace(d13, d12, d23);
//			var y:int;
//			if(result < 0)
//			{
//				trace("p2 at left of p1p3");
//				if(p2.y == p1.y)
//				{
//					sx = p2.x;
//				}
//				
//				for(y = (p1.y >> 0) ; y <= (p3.y >> 0);)
//				{
//					trace(sx, ex, y);
//					drawLine(sx, ex, y);
//					y++;
//					if(y < p2.y) //这里忽略了小数点, 所以会造成画不完全
//					{
//						trace();
//						sx += d12;
//					}else{
//						trace();
//						sx += d23;
//					}
//					ex += d13;
//				}
//			}else if(result > 0)
//			{
//				trace("p2 at right of p1p3");
//				if(p2.y == p1.y)
//				{
//					ex = p2.x;
//				}
//				
//				for(y = p1.y >> 0 ; y <= (p3.y >> 0);)
//				{
////					trace(sx, ex, y);
//					drawLine(sx, ex, y);
//					y++
//					if(y < p2.y)
//					{
//						ex += d12;
//					}else{
//						ex += d23;
//					}
//					sx += d13;
//				}
//			}else{
//				trace("p2 is in line of p1p3");
//				if(p3.y == p1.y)//水平线
//				{
//					sx = minValue(p1.x, p2.x, p3.x);
//					ex = maxValue(p1.x, p2.x, p3.x);
//					drawLine(sx, ex, y);
//				}else{
//					for(y = p1.y >> 0 ; y <= (p3.y >> 0);)
//					{
//						drawLine(sx, ex, y);
//						y++
//						sx += d13;
//						ex += d13;
//					}	
//				}
//			}
//		}
//		
//		
//		private function drawLine(sx:Number, ex:Number, y:int):void
//		{
//			sx = sx >> 0;
//			ex = ex >> 0;
//			
//			for(var x:int = sx; x <= ex; x++)
//			{
//				this.bmd.setPixel(x, y, 0);
//			}
//		}
//		
//		private function maxValue(v1:Number, v2:Number, v3:Number):Number
//		{
//			var max:Number = v1;
//			if(max < v2)
//			{
//				max = v2;
//			}
//			
//			if(max < v3)
//			{
//				max = v3;
//			}
//			
//			return max;
//		}
//		
//		private function minValue(v1:Number, v2:Number, v3:Number):Number
//		{
//			var min:Number = v1;
//			if(min > v2)
//			{
//				min = v2;
//			}
//			
//			if(min > v3)
//			{
//				min = v3;
//			}
//			
//			return min;
//		}
	}
}