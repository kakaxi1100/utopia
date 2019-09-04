package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0xcccccc")]
	public class UVTextureTest extends Sprite
	{
		[Embed(source="assets/wall01.jpg")]
		private var Wall:Class;
		
		private var wall:Bitmap = new Wall();
		private var bmp:Bitmap = new Bitmap(new BitmapData(800, 600, false, 0));
		
		private var p1:Object = {"x":400, "y":100, "u":0, "v":0};
		private var p2:Object = {"x":350, "y":200, "u":0, "v":63};
		private var p3:Object = {"x":450, "y":200, "u":63, "v":63};
		
		public function UVTextureTest()
		{
			super();
			
			addChild(wall);
			
			bmp.y += wall.y + wall.height;
			addChild(bmp);
			
			drawWall();
		}
		
		private function drawWall():void
		{
			var dxdyl:Number = (p2.x - p1.x) / (p2.y - p1.y);
			var dudyl:Number = (p2.u - p1.u) / (p2.y - p1.y);
			var dvdyl:Number = (p2.v - p1.v) / (p2.y - p1.y);
			
			var dxdyr:Number = (p3.x - p1.x) / (p3.y - p1.y);
			var dudyr:Number = (p3.u - p1.u) / (p3.y - p1.y);
			var dvdyr:Number = (p3.v - p1.v) / (p3.y - p1.y);
			
			var xl:Number = p1.x, xr:Number = p1.x;
			var ul:Number = p1.u, ur:Number = p1.u;
			var vl:Number = p1.v, vr:Number = p1.v;
			var du:Number = p1.u, dv:Number = p1.v;
			
			var ui:Number = p1.u, vi:Number = p1.v;
			//从上到下扫描
			for(var i:int = int(p1.y); i <= int(p2.y); i++)
			{
				//从左到右扫描
				for(var j:int = int(xl); j <= int(xr); j++)
				{
					//取点
					var color:uint = wall.bitmapData.getPixel32(Math.round(ui), Math.round(vi));
					//描点
					bmp.bitmapData.setPixel(j, i, color);
					//u,v取样
					ui += du;
					vi += dv;
				}
				//下一条扫描线
				xl += dxdyl;
				ul += dudyl;
				vl += dvdyl;
				
				xr += dxdyr;
				ur += dudyr;
				vr += dvdyr;
				
				du = (ur - ul)/(xr - xl);
				dv = (vr - vl)/(xr - xl);
				
				ui = ul;
				vi = vl;
			}
		}
	}
}