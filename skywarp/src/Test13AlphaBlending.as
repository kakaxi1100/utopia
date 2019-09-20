package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import skywarp.version2.SWPoint3D;

	/**
	 * Alpha 混合 
	 * 
	 * alpha 混合包含两个方面, Zsort 和  Z 缓存
	 * 这并不是一个完美的解决方案,但是相对游戏来说是可以接受的
	 * 
	 * 完美的解决方案需要大量的运算
	 * 
	 * @author juli
	 * 
	 */
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class Test13AlphaBlending extends Sprite
	{
		[Embed(source="assets/images/checkerboard800.png")]
		private var Background:Class;
		private var back:Bitmap = new Background();
		
		private var bmd:BitmapData = new BitmapData(800, 600, true, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var centerX:int = stage.stageWidth >> 1;
		private var centerY:int = stage.stageHeight >> 1;
		private var centerZ:int = 200;
		
		private var vertexList:Array = [];
		private var polygonList:Array = [];
		private var polygonZAverage:Array = [];
		private var zSortList:Array = [];
		private var polygonColorList:Array = [];
		
		private var tempP1:SWPoint3D = new SWPoint3D();
		private var tempP2:SWPoint3D = new SWPoint3D();
		private var p1World:SWPoint3D = new SWPoint3D();
		private var p2World:SWPoint3D = new SWPoint3D();
		private var p3World:SWPoint3D = new SWPoint3D();
		// 视点, 也就是相机方向是(0,0,1)
		private var camera:SWPoint3D = new SWPoint3D(centerX, centerY,0);
		
		private var toggle:int = 0;
		public function Test13AlphaBlending()
		{
			super();
			
			bmd.copyPixels(back.bitmapData, back.bitmapData.rect, new Point());
			stage.addChild(bmp);
			Utils.setZBuffer(bmd);
			
			var p:SWPoint3D;
			p = new SWPoint3D(50, 50, -50);
			vertexList.push(p);
			p = new SWPoint3D(-50, 50, -50);
			vertexList.push(p);
			p = new SWPoint3D(-50, 50, 50);
			vertexList.push(p);
			p = new SWPoint3D(50, 50, 50);
			vertexList.push(p);
			p = new SWPoint3D(50, -50, -50);
			vertexList.push(p);
			p = new SWPoint3D(-50, -50, -50);
			vertexList.push(p);
			p = new SWPoint3D(-50, -50, 50);
			vertexList.push(p);
			p = new SWPoint3D(50, -50, 50);
			vertexList.push(p);
			
			polygonList.push(
				2, 1, 0,
				3, 2, 0,
				4, 7, 0,
				7, 3, 0,
				6, 7, 4,
				5, 6, 4,
				2, 6, 1,
				6, 5, 1,
				7, 6, 3,
				6, 2, 3,
				5, 4, 0,
				1, 5, 0
			);
			
			for(var i:int = 0; i < polygonList.length / 3; i++)
			{
				zSortList[i] = i;
				var colorA:uint = (Math.random()*0.5 + 0.5) * 0xFF >> 0;
				var colorR:uint = Math.random() * 0xFF >> 0;
				var colorG:uint = Math.random() * 0xFF >> 0;
				var colorB:uint = Math.random() * 0xFF >> 0;
				var colorHex:uint = colorA << 24 | colorR << 16 | colorG << 8 | colorB;
				polygonColorList[i] = colorHex;
			}
			
			
			for(i = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
				p3D.rotateY(-45);
//				p3D.rotateX(-90);
//				p3D.rotateZ(-90);
			}
			
			this.zSort();
			this.fillTriangle();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var count:int = 2;
		protected function onKeyDown(event:KeyboardEvent):void
		{
//			if(count > 0)
//			{
//				count--;
//				return;
//			}else{
//				count = 2;
//			}
			
			var p3D:SWPoint3D;
			var i:int;
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
				{
					for(i = 0; i < this.vertexList.length; i++)
					{
						p3D = this.vertexList[i];
						p3D.rotateY(1);
					}
					break;
				}
				case Keyboard.RIGHT:
				{
					for(i = 0; i < this.vertexList.length; i++)
					{
						p3D = this.vertexList[i];
						p3D.rotateY(-1);
					}
					break;
				}
				case Keyboard.SPACE:
				{
					for(i = 0; i < polygonList.length / 3; i++)
					{
						var colorA:uint = (Math.random()*0.5 + 0.5) * 0xFF >> 0;
						var colorR:uint = Math.random() * 0xFF >> 0;
						var colorG:uint = Math.random() * 0xFF >> 0;
						var colorB:uint = Math.random() * 0xFF >> 0;
						var colorHex:uint = colorA << 24 | colorR << 16 | colorG << 8 | colorB;
						polygonColorList[i] = colorHex;
					}
					break;
				}
				case Keyboard.ENTER:
				{
					toggle = ~toggle;
					break;
				}
				default:
				{
					break;
				}
			}
			
			Utils.clearZBuffer();
			this.zSort();
			this.fillTriangle();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(!toggle) return;
			
			for(var i:int = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
//				p3D.rotateX(rotaX);
				p3D.rotateY(1);
//				p3D.rotateZ(rotaZ);
			}
			
			Utils.clearZBuffer();
			this.zSort();
			this.fillTriangle();
		}
		
		private function zSort():void
		{
			var i:int;
			for(i = 0; i < zSortList.length; i++)
			{
				zSortList[i] = i;
			}
			
			
			for(i = 0; i < this.polygonList.length - 2; i += 3)
			{
				var p1:SWPoint3D = this.vertexList[this.polygonList[i]];
				var p2:SWPoint3D = this.vertexList[this.polygonList[i + 1]];
				var p3:SWPoint3D = this.vertexList[this.polygonList[i + 2]];
				
//				trace(p1.z + centerZ, p2.z + centerZ, p3.z + centerZ);
				//计算平均Z值
				var zAverage:Number = (p1.z + centerZ + p2.z + centerZ + p3.z + centerZ)/3;
				polygonZAverage[i/3 >> 0] = zAverage;
			}
			
			for(var j:int = 0; j < zSortList.length; j++)
			{
				for(var k:int = j + 1; k < zSortList.length; k++)
				{
					if(polygonZAverage[zSortList[j]] < polygonZAverage[zSortList[k]])
					{
						var temp:int = zSortList[k];
						zSortList[k] = zSortList[j];
						zSortList[j] = temp;
					}
				}
			}
			
//			trace(zSortList, polygonZAverage);
		}
		
		private function fillTriangle():void
		{
			bmd.fillRect(bmd.rect, 0);
			bmd.copyPixels(back.bitmapData, back.bitmapData.rect, new Point());
			for(var i:int = 0; i < this.zSortList.length; i++)
			{
				var polygonIndex:int = this.zSortList[i] * 3;
					
				var p1:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[polygonIndex]]);
				var p2:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[polygonIndex + 1]]);
				var p3:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[polygonIndex + 2]]);
				
				Utils.drawTriangle(p1, p2, p3, bmd, this.polygonColorList[this.zSortList[i]]);
			}
		}
		
		private function convertToScreen(p3D:SWPoint3D):SWPoint3D
		{
			var p:SWPoint3D = new SWPoint3D();
			p.x = (p3D.x / (p3D.z + centerZ)) * centerX + centerX;;
			p.y = (-p3D.y / (p3D.z + centerZ)) * centerY + centerY;
			p.z = p3D.z + centerZ;
			
			return p;
		}
	}
}
import flash.display.BitmapData;

import skywarp.version2.SWPoint3D;

class Utils
{
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
		
		var sx:int = interpolate(pa.x, pb.x, gradient1) >> 0;
		var ex:int = interpolate(pc.x, pd.x, gradient2) >> 0;
		
		//计算z的插值
		if(mIsZBuffer)
		{
			var sz:Number = interpolate(pa.z, pb.z, gradient1) >> 0;
			var ez:Number = interpolate(pc.z, pd.z, gradient2) >> 0;
		}
		
		var alpha:Number = (color >> 24 & 0xFF)/255;
		var redSource:uint = color >> 16 & 0xFF;
		var greenSource:uint = color >> 8 & 0xFF;
		var blueSource:uint = color & 0xFF; 
		var dest:uint;
		// drawing a line from left (sx) to right (ex) 
		for(var x:int = sx; x < ex; x++) {
			dest = bmd.getPixel32(x, y);
			var redDest:uint = dest >> 16 & 0xFF;
			var greenDest:uint = dest >> 8 & 0xFF;
			var blueDest:uint = dest & 0xFF;
			
			var red:Number = (alpha * redSource + (1 - alpha) * redDest);
			var green:Number = (alpha * greenSource + (1 - alpha) * greenDest);
			var blue:Number = (alpha * blueSource + (1 - alpha) * blueDest);
			
			if(red > 255) red = 255;
			if(green > 255) green = 255;
			if(blue > 255) blue = 255;
			
			var c:uint = red << 16 | green << 8 | blue;
			if(!mIsZBuffer)
			{
				bmd.setPixel(x, y, c);
			}else{
				//对每个点计算z值
				var gradient:Number = (x - sx)/(ex - sx);
				var z:Number = interpolate(sz, ez, gradient);
				putPixel(x, y, z, bmd, c);
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
			bmd.setPixel(x, y, color);
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