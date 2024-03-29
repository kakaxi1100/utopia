package skywarp.version2
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class SWUtils
	{
		public function SWUtils()
		{
		}
//-----------------------------------------------------------------------------------------		
		public static function drawTriangle(p1:SWPoint3D, p2:SWPoint3D, p3:SWPoint3D, bmd:BitmapData, color:uint = 0):void
		{
			//1. 按y值排序 p1.y ≤ p2.y ≤ p3.y 
			var temp:SWPoint3D;
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
//			trace(p1, p2, p3);

			//2.判断p2在p1p3的那一侧, 只比较x值是不够的
			//可以用直线的一般方程来判断, <0 在左侧, >0在右侧. 可用 y-x=0  y-2x=0  y-0.5x=0 这三条直线来检测
			//已知两点可求得直线的一般方程式, AX + BY + C = 0, (x1, y1), (x3, y3) 先用斜截式考虑飞0情况展开, 再考虑0的情况, 可求得
			// y = kx + b => k = (y3 - y1) / (x3 - x1) => 带入展开为一般式可得 => (y3-y1)X + (x1-x3)Y + (x3-x1)*b = 0
			// 将P1 点带入, 可求得b => (y1*x3 - y3*x1)/(x3 - x1)
			// 将b带入展开式可得:
			// (y3-y1)X + (x1-x3)Y + (y1*x3 - y3*x1) = 0
			// 所以可得 A, B, C 分别如下:
			// A = Y3 - Y1,  B = X1 - X3, C = X3*Y1 - X1*Y3
			// p1 => (x1, y1) , p3 => (x2, y2) 因为斜率是按照 p1计算的
			var a:Number = p3.y - p1.y;
			var b:Number = p1.x - p3.x;
			var c:Number = p3.x*p1.y - p1.x*p3.y;
			//将p2带入看是在左侧还是右侧, 如果相等就是在直线上
			var result:Number = p2.x*a + p2.y*b + c;
			var y:int;
			if(result > 0)
			{
//				trace("p2 at right of p1p3");
				for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
				{
					if(y < p2.y)
					{
						processScanLine(y, p1, p3, p1, p2, bmd, color);
					}else
					{
						processScanLine(y, p1, p3, p2, p3, bmd, color);//平顶 如果 p1.y == p2.y 直接就处理这里了, 精妙!
					}
				}
			}else
			{
//				trace("p2 at left of p1p3");
				for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
				{
					if(y < p2.y)
					{
						processScanLine(y, p1, p2, p1, p3, bmd, color);
					}else
					{
						processScanLine(y, p2, p3, p1, p3, bmd, color);
					}
				}
			}
		}
		
		//处理扫描线
		//y表示当前处理的行值
		// pa, pb 是左边的线, pc, pd 是右边的线
		private static function processScanLine(y:int, pa:SWPoint3D, pb:SWPoint3D, pc:SWPoint3D, pd:SWPoint3D, bmd:BitmapData, color:uint = 0):void
		{
			//这里的处理非常巧妙, 佩服佩服！！
			//先得到, 左边线的处理进度, 再得到右边线的处理进度
			var gradient1:Number = pa.y != pb.y ? (y - pa.y) / (pb.y - pa.y) : 1;
			var gradient2:Number = pc.y != pd.y ? (y - pc.y) / (pd.y - pc.y) : 1;
			
			//这里用到X, Y 的同比的, 当Yg = 0 时, Xg = 0 当 Yg = 1 时 Xg = 1
			//可以画个以Pa, Pb为对角线的矩形试试
			var sx:int = interpolate(pa.x, pb.x, gradient1) >> 0;
			var ex:int = interpolate(pc.x, pd.x, gradient2) >> 0;
			
			//计算z的插值
			if(mIsZBuffer)
			{
				var sz:Number = interpolate(pa.z, pb.z, gradient1) >> 0;
				var ez:Number = interpolate(pc.z, pd.z, gradient2) >> 0;
			}
			// drawing a line from left (sx) to right (ex) 
			for(var x:int = sx; x < ex; x++) {
				if(!mIsZBuffer)
				{
					bmd.setPixel32(x, y, color);
				}else{
					//对每个点计算z值
					var gradient:Number = (x - sx)/(ex - sx);
					var z:Number = interpolate(sz, ez, gradient);
					putPixel(x, y, z, bmd, color);
				}
			}
		}
		
		//gradient是一个0~1之间的数
		// p0 + (p1 - p0)*gradient
		private static function interpolate(p0:Number, p1:Number, gradient:Number):Number
		{
			return p0 + (p1 - p0)* clamp(gradient);
		}
		
		// Clamping values to keep them between 0 and 1
		private static function clamp(value:Number, min:Number = 0, max:Number = 1):Number
		{
			return Math.max(min, Math.min(value, max));
		}
		
		
		//要用1/z来存,具体原因看第11章
		//主要是因为Y的插值是根据屏幕坐标来的, 而Z的插值是根据空间坐标来的
		//而空间坐标转换到屏幕坐标是 除以了一个 Z的
		private static var mDepthBuffer:Array;
		private static var mIsZBuffer:Boolean = false;
		public static function setZBuffer(bmd:BitmapData):void
		{
			var size:uint = bmd.width * bmd.height;
			mDepthBuffer = new Array(size);
			for(var i:uint = 0; i < size; i++)
			{
				mDepthBuffer[i] = 99999999;//将其设置到最远处
			}
			mIsZBuffer = true;
		}
		
		public static function clearZBuffer():void
		{
			if(!mIsZBuffer) return;
			for(var i:uint = 0; i < mDepthBuffer.length; i++)
			{
				mDepthBuffer[i] = 99999999;
			}
		}
		
		private static function putPixel(x:Number, y:Number, z:Number, bmd:BitmapData, color:uint):void
		{
			//当前处理的那个pixel
			var index:uint = ((x>>0) + (y>>0) * bmd.width);
			
			if(mDepthBuffer[index] < z)
			{
				//假如这个点在depth的后面, 就不用画了
			}else
			{
				mDepthBuffer[index] = z;
				bmd.setPixel32(x, y, color);
			}
		}

//-----------------------------------------------------------------------------------------
		//递归画线法
		private static function DrawLineMid(bmd:BitmapData, p1:Point, p2:Point):void
		{
			var dist:Number = Point.distance(p1, p2);
			if(dist < 2){
				return;
			}
			
			var midPoint:Point = Point.interpolate(p1,p2,0.5);
			bmd.setPixel(midPoint.x, midPoint.y, 0);
			
			DrawLineMid(bmd, p1, midPoint);
			DrawLineMid(bmd, midPoint, p2);
		}
		
		//Bresenham
		public static function DrawLinePro(bmd:BitmapData, p1:SWPoint3D, p2:SWPoint3D, color:uint = 0):void
		{
			var x0:int = p1.x >> 0;
			var y0:int = p1.y >> 0;
			var x1:int = p2.x >> 0;
			var y1:int = p2.y >> 0;
			var dx:Number = Math.abs(x1 - x0);
			var dy:Number = Math.abs(y1 - y0);
			var sx:int = (x0 < x1) ? 1 : -1;
			var sy:int = (y0 < y1) ? 1 : -1;
			var err:Number = dx - dy;
			while(true) {
				bmd.setPixel32(x0, y0, color)
				if((x0 == x1) && (y0 == y1)) break;
				var e2:Number = 2 * err;
				if(e2 > -dy) { err -= dy; x0 += sx; }
				if(e2 < dx) { err += dx; y0 += sy; }
			}
		}
		
		//Bresenham
		public static function DrawLine(bmd:BitmapData, p1:SWPoint3D, p2:SWPoint3D, color:uint = 0):void
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
				bmd.setPixel32(x, y, color);
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
	}
}