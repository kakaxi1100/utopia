package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import vo.td.CPoint4D;
	import vo.td.CPolygon;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0xcccccc")]
	public class GouraudTest extends Sprite
	{
		private var list:Vector.<CPoint4D>;
		private var p:CPolygon;
		private var i1:uint = 0xFFFFFF;
		private var i2:uint = 0xFFFFFF;
		private var i3:uint = 0xFF00FF;
		
		private var bmp:Bitmap = new Bitmap(new BitmapData(800, 600, false, 0));
		public function GouraudTest()
		{
			super();
			
			addChild(bmp);
			
//			list = new Vector.<CPoint4D>();
//			p = new CPolygon(list, 0 , 1, 2);
			
			drawGouraudTriangle(400,50, 350,100, 450,100, bmp.bitmapData);
		}
		//平顶三角形
		//x1, y1为最低点
		public function drawGouraudTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, bmd:BitmapData):void
		{
			//左边斜率
			var dxLy:Number = (x2 - x1) / (y2 - y1);
			//左边颜色梯度
			var diLy:Number = (i2 - i1) / (y2 - y1);
			//右边斜率
			var dxRy:Number = (x3 - x1) / (y3 - y1);
			//右边颜色梯度
			var diRy:Number = (i3 - i1) / (y3 - y1);
			
			//左边缘和右边缘的起始点
			var xLeft:Number = x1, xRight:Number = x1;
			//颜色强度的起点
			var iLeft:Number = i1, iRight:Number = i1;
			//当前扫描线位置
			var color:Number = i1;
			//水平颜色梯度
			var dix:Number = 0;
			
			//开始水平扫描
			for(var i:int = Math.round(y1); i <= Math.round(y2); i++)
			{
				//开始垂直扫描
				for(var j:int = Math.round(xLeft); j <= Math.round(xRight); j++)
				{
//					trace(j, i, color);
					//描点
					bmd.setPixel32(j , i, Math.round(color));
					
					color += dix;
				}
				//计算左右两边x的位置
				xLeft += dxLy;
				xRight += dxRy;
				//计算颜色强度
				iLeft += diLy;
				iRight += diRy;
				dix = (xRight - xLeft) == 0 ? 0 : (iRight - iLeft) / (xRight - xLeft);
				color = iLeft;
			}
		}
	}
}