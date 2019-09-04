package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import skywarp.version2.SWPoint3D;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class Test10ReverseZBuffer extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800, 600);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var centerX:int = stage.stageWidth >> 1;
		private var centerY:int = stage.stageHeight >> 1;
		private var centerZ:int = 200;
		private var vertexList:Array = [];
		private var polygonList:Array = [];
		public function Test10ReverseZBuffer()
		{
			super();
			stage.addChild(bmp);
			var p:SWPoint3D;
			Utils.setZBuffer(bmd);
			
			p = new SWPoint3D(50, 50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, 50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, 50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, 50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, -50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, -50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, -50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, -50, -50);
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
			
			this.drawWrieframe();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
				p3D.rotateY(1);
				p3D.rotateX(1);
				p3D.rotateZ(1);
			}
			this.drawWrieframe();
		}
		
		private function drawWrieframe():void
		{
			bmd.fillRect(bmd.rect, 0xffffffff);
			Utils.clearZBuffer();
			for(var i:int = 0; i < this.polygonList.length - 2; i+=3)
			{
				var p1:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i]]);
				var p2:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 1]]);
				var p3:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 2]]);
				var color:Number = 0.25 + ((i % this.polygonList.length) / this.polygonList.length) * 0.75;
				var colorU:uint = (color * 255) >> 0;
				var colorHex:uint = 0xff << 24 | colorU << 16 | colorU << 8 | colorU;
				Utils.drawTriangle(p1, p2, p3, bmd, colorHex);
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
			var sz:Number = interpolate(1/pa.z, 1/pb.z, gradient1);
			var ez:Number = interpolate(1/pc.z, 1/pd.z, gradient2);
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
	
	
	//要用1/z来存,具体原因看第11章, 具体推算看第十二章
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
			mDepthBuffer[i] = 0;//将其设置到最远处
		}
		mIsZBuffer = true;
	}
	
	public static function clearZBuffer():void
	{
		if(!mIsZBuffer) return;
		for(var i:uint = 0; i < mDepthBuffer.length; i++)
		{
			mDepthBuffer[i] = 0;
		}
	}
	
	private static function putPixel(x:Number, y:Number, z:Number, bmd:BitmapData, color:uint):void
	{
		//当前处理的那个pixel
		var index:uint = ((x>>0) + (y>>0) * bmd.width);
		
		if(mDepthBuffer[index] > z)
		{
			//假如这个点在depth的后面, 就不用画了
		}else
		{
			mDepthBuffer[index] = z;
			bmd.setPixel32(x, y, color);
		}
	}
}