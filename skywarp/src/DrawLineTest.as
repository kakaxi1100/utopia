package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class DrawLineTest extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800, 600);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var p1:Point = new Point();
		private var p2:Point = new Point();
		private var mathod:int = 1;
		private var needClear:Boolean = false;
		public function DrawLineTest()
		{
			super();
			
			this.addChild(bmp);
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			p1.x = 400;
			p1.y = 200;
			p2.x = 400;
			p2.y = 300;
			this.bresenham(p1, p2);
			this.randomLine(500);
		}
		
		private function randomLine(num:int):void
		{
			for(var i:int = 0; i < num; i++)
			{
				p2.x = Math.random() * 800;
				p2.y = Math.random() * 600;
				p1.x = Math.random() * 800;
				p1.y = Math.random() * 600;
				this.bresenham(p1, p2);
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			if(needClear)
			{
				bmd.fillRect(bmd.rect, 0xffffffff);
			}
//			p2.x = Math.random() * 400 + 50;
//			p2.y = Math.random() * 300 + 50;
//			p1.x = Math.random() * 350 + 450;
//			p1.y = Math.random() * 300 + 50;
			
//			p2.x = Math.random() * 800;
//			p2.y = Math.random() * 600;
//			p1.x = Math.random() * 800;
//			p1.y = Math.random() * 600;
			
			
			p2.x = Math.random() * 800;
			p2.y = Math.random() * 600;
			p1.x = Math.random() * 800;
			p1.y = Math.random() * 600;
			
			
			if(mathod == 0){
				this.drawLine1(p1, p2);
			}else if(mathod == 1){
				this.bresenham(p1, p2);
			}
			trace(p1, p2);
		}
		
		//Bresenham 画线的两种方法: 判别式法和误差法
		//一. 判别式法 |m| < 1
		//假设直线方程为  y = mx + b;
		// 1. 假设第k点的 光栅点为 (xk, yk), 那么第 xk + 1 点的 y 值我们可以这么算 y = m(xk + 1) + b
		//	Dlower = y - yk = m(xk + 1) + b - yk;
		//	Dupper = (yk + 1) - y = yk + 1 - m(xk + 1) - b;
		// 2. 看Dlower和Dupper哪个更接近与y值来决定是取 yk还是yk + 1
		//	Dlower - Dupper = 2m(xk + 1) - 2yk + 2b - 1, m = Δy/Δx;
		//	令: Pk = Δx(Dlower - Dupper) = 2Δy*xk - 2Δx*yk + c; c = 2Δy + (2b-1)*Δx
		// 3. Pk+1 = 2Δy*xk+1 - 2Δx*yk+1 + c;
		//	Pk+1 - Pk = 2Δy*(xk+1 - xk) - 2Δx(yk+1 - yk);
		//	Pk+1 = Pk + 2Δy - 2Δx*(yk+1 - yk);    (yk+1 - yk)取1还是0取决于 Pk的符号 Pk = Δx(Dlower - Dupper)
		// 4. 由y0 = mx0 + b 可得
		//	P0 = 2Δy - Δx
		// 画线方法:
		// 1. 输入线段的两个端点, 并将左端点存储在(x0, y0)中;
		// 2. 将(x0, y0)画出
		// 3. 计算常量 Δx、Δy、2Δy 和 2Δy-2Δx, 并得到决策参数的第一个值: P0 = 2Δy - Δx;
		// 4. 从 k = 0 开始, 在沿线路径的每个 xk 处, 进行下列检测:
		//	如果 Pk < 0  下一个要绘制的点就是 (xk + 1, yk), 并且  Pk+1 = Pk + 2Δy
		//	否则, 下一个要绘制的点是 (xk + 1, yk + 1), 并且  Pk+1 = Pk + 2Δy - 2Δx
		// 5. 重复步骤4, 共Δx - 1次
		//
		//
		//二. 误差法
		// 在 Y(i+1) 的邻近两个垂直的光栅点位 Y(i+1)r  Y(i)r
		// 那么有 Y(i+1) - Y(i)r < 0.5 那么就取 Y(i)r  否则就取 Y(i+1)r
		// 取 ε(X(i+1)) =  Y(i+1) - Y(i)r - 0.5
		// 求 ε(X(i+2)) = Y(i+2) - Y(i+1)r - 0.5 = (Y(i+1) + m) - Y(i+1)r - 0.5
		// 当 ε(X(i+1)) >= 0 时 选Y(i+1)r
		// ε(X(i+2)) = ε(X(i+1)) + m - 1
		// 当 ε(X(i+1)) < 0 时 选Y(i)r
		// ε(X(i+2)) = ε(X(i+1)) + m
		// 初始时
		// ε(X(s+1)) = m - 0.5;
		// 为了不含实数类型 方程式两边同时乘以 2·Δx 即d=2·Δx·ε，则
		// 初始时 d = 2·Δy-Δx
		// 当d≥0时：{ d=d+2·(Δy－Δx)；
		//		　　　　　　y++；
		//			　　　x++；
		//	　　　　　}
		//	否则：　　{ d=d+2·Δy；
		//		　　　　　　x++；
		//	　　　　　}
		// 条件：0≤m≤1且x1<x2
		//
		//　　1、输入线段的两个端点坐标和画线颜色：x1，y1，x2，y2，color；
		//　　2、设置象素坐标初值：x=x1，y=y1；
		//　　3、设置初始误差判别值：p=2·Δy-Δx；
		//　　4、分别计算：Δx=x2-x1、Δy=y2-y1；
		//　　5、循环实现直线的生成：
		//　　　for(x=x1；x<=x2；x++)
		//　　　{ putpixel(x,y,color) ；
		//	　　　　if(p>=0)
		//	　　　　　{ y=y+1；
		//		　　　　　　p=p+2·(Δy-Δx)；
		//	　　　　　}
		//	　　　　else
		//	　　　　　{ p=p+2·Δy；
		//	　　　　　}
		//	
		//　　　}
		private function bresenham(p1:Point, p2:Point):void
		{
			// d0 没有计算
			var sx:int = p1.x >> 0;
			var sy:int = p1.y >> 0;
			var ex:int = p2.x >> 0;
			var ey:int = p2.y >> 0;
			var dx:int = Math.abs(ex - sx);
			var dy:int = Math.abs(ey - sy);
			var xInc:int = ex > sx ? 1 : -1;
			var yInc:int = ey > sy ? 1 : -1;
			
			var x:int = sx, y:int = sy;
			
			//判断是近X轴还是近Y轴, 如果是近Y轴 那么 公式中需要调换 dx和dy
			var isCloseX:Boolean = dx > dy ? true : false;
			if(!isCloseX)
			{
				var temp:int = dx;
				dx=dy;
				dy=temp;
			}
			
			var d:int = 2 * dy - dx;//d1 计算 x1 时候的d值
			
			while(true)
			{
				bmd.setPixel(x, y, 0);
				if(x == ex && y == ey) break;
				//x每步进一次, y取什么?
				if(isCloseX)
				{
					x += xInc;
				}else{
					y += yInc;
				}
				// 通过 误差 E 的符号来判断 应该取哪个值 E < 0 y or E > 0 y+1
				// E0 = -0.5 起始点总是取靠近下面的点
				// E1 = m - 0.5 => (y0 + m) - y0r - 0.5
				// E2 = (y1 + m) - y1r - 0.5
				//   ....
				// Ei+1 = (yi + m) - yir - 0.5
				// Ei+2 = (yi+1 + m) - y(i+1)r - 0.5
				// 求En的通用公式
				// Ei+1 = yi+1 - yir - 0.5;
				// if(Ei+1 > 0) 
				//		y(i+1)r = yir + 1 (为什么? 因为如果> 0.5那么下一个y一定上去了) 解释: 两个紧邻正方形组成的矩形, 那么它们的对角线经过共用边的中点即0.5 
				// else 
				//		y(i+1)r = yir
				//
				// ∴  Ei+1 >= 0 => Ei+2 = yi+1 + m - yir -1 -0.5 = yi+1 - yir - 0.5 + m - 1 = Ei+1 + m - 1
				// ∴  Ei+1 < 0 => Ei+2 = yi+1 + m - yir - 0.5 = yi+1 - yir - 0.5 + m = Ei+1 + m
				// ∴ 通用公式为
				// E0 = 0 or -0.5 or E0 = p1.y - (p1.y >> 0) > 0.5 ? 0.5 : -0.5;
				// En = En-1 + m - 1, En-1 >= 0 and En = En-1 + m, En-1 < 0
				// m = Δy/Δx 为了消除 0.5 和 Δx 我们乘以 2*Δx 因为不等式两边同乘一个正数, 符号性质不变
				// D0 = -2*Δx or = 0
				// D1 = 2*Δx * (m - 0.5) = 2 * Δy - Δx 
				// ....
				// Di+1 = 2 * Δx * [(yi + m) - yir - 0.5] = 2 * Δx *(yi+1 - yir - 0.5)  
				// Di+2 = 2 * Δx * [(yi+1 + m) - y(i+1)r - 0.5]
				// Di+1 >= 0 => Di+2 = 2 * Δx * (yi+1 + m - yir -1 -0.5) = 2 * Δx * (yi+1 - yir - 0.5 + m - 1) = Di+1 + 2 * (Δy - Δx)
				// Di+1 < 0 => Di+2 = 2 * Δx * (yi+1 + m - yir - 0.5) = 2 * Δx * (yi+1 - yir - 0.5 + m) = Di+1 + 2 * Δy
				
				if(d < 0){
					d = d + 2 * dy; 
				}else{
					if(isCloseX)
					{
						y += yInc;
					}else{
						x += xInc;
					}
					d = d + 2 * (dy - dx);
				}
					
			}
			
		}
		
		private function drawLine1(p1:Point, p2:Point):void
		{
			var dist:Number = Point.distance(p1, p2);
			if(dist < 2){
				return;
			}
			
			var midPoint:Point = Point.interpolate(p1,p2,0.5);
			this.bmd.setPixel(midPoint.x, midPoint.y, 0);
			
			this.drawLine1(p1, midPoint);
			this.drawLine1(midPoint, p2);
		}
	}
}