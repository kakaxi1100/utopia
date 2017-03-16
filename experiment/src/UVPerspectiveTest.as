package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0xcccccc")]
	public class UVPerspectiveTest extends Sprite
	{
		[Embed(source="assets/wall01.jpg")]
		private var Wall:Class;
		
		private var wall:Bitmap = new Wall();
		private var bmp:Bitmap = new Bitmap(new BitmapData(400, 600, false, 0));
		private var bmp2:Bitmap = new Bitmap(new BitmapData(400,600,false,0));
		
		private var p1:Object = {"x":200, "y":0, "z":100, "u":32, "v":63};
		private var p2:Object = {"x":0, "y":536, "z":50, "u":0, "v":0};
		private var p3:Object = {"x":400, "y":536, "z":50, "u":63, "v":0};
		
		private var p4:Object = {"x":200, "y":0, "u":32, "v":63};
		private var p5:Object = {"x":0, "y":536, "u":0, "v":0};
		private var p6:Object = {"x":400, "y":536, "u":63, "v":0};
		
		public function UVPerspectiveTest()
		{
			super();
			
			addChild(wall);
			
			bmp.y += wall.y + wall.height;
			addChild(bmp);
			
			bmp2.y = bmp.y;
			bmp2.x = bmp.x + bmp.width;
			addChild(bmp2);
			
			drawWall();
			drawWall2();
		}
		private function drawWall2():void
		{
			var dxdyl:Number = (p5.x - p4.x) / (p5.y - p4.y);
			var dudyl:Number = (p5.u - p4.u) / (p5.y - p4.y);
			var dvdyl:Number = (p5.v - p4.v) / (p5.y - p4.y);
			
			var dxdyr:Number = (p6.x - p4.x) / (p6.y - p4.y);
			var dudyr:Number = (p6.u - p4.u) / (p6.y - p4.y);
			var dvdyr:Number = (p6.v - p4.v) / (p6.y - p4.y);
			
			var xl:Number = p4.x, xr:Number = p4.x;
			var ul:Number = p4.u, ur:Number = p4.u;
			var vl:Number = p4.v, vr:Number = p4.v;
			var du:Number = p4.u, dv:Number = p4.v;
			
			var ui:Number = p4.u, vi:Number = p4.v;
			//从上到下扫描
			for(var i:int = int(p4.y); i <= int(p5.y); i++)
			{
				//从左到右扫描
				for(var j:int = int(xl); j <= int(xr); j++)
				{
					//取点
					var color:uint = wall.bitmapData.getPixel32(Math.round(ui), Math.round(vi));
					//描点
					bmp2.bitmapData.setPixel(j, i, color);
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
		
		private function drawWall():void
		{
			var i:int, j:int;
			//此条扫描的的左右x值
			var dxleft:Number = p2.x - p1.x;
			var dxright:Number = p3.x - p1.x;
			var dxdyleft:Number = dxleft / (p2.y - p1.y);
			var dxdyright:Number = dxright / (p3.y - p1.y);
			var xleft:Number = p1.x, xright:Number = p1.x;
			
			//左右边线1/z的差值
			var d1zleft:Number = 1/p2.z - 1/p1.z;
			var d1zright:Number = 1/p3.z - 1/p1.z;
			//步进y需要改变的左右1/z的值
			var d1zdyleft:Number = d1zleft / (p2.y - p1.y);
			var d1zdyright:Number = d1zright / (p3.y - p1.y);
			//词条扫描线的左右1/z值			
			var o1zleft:Number = 1/p1.z, o1zright:Number = 1/p1.z;
			
			var dudzleft:Number = p2.u / p2.z - p1.u/p1.z;
			var dudzright:Number = p3.u / p3.z - p1.u/p1.z;
			var dudyleft:Number = dudzleft / (p2.y - p1.y);
			var dudyright:Number = dudzright / (p3.y - p1.y);
			var uzleft:Number = p1.u/p1.z, uzright:Number = p1.u/p1.z;
			
			var dvdzleft:Number = p2.v / p2.z - p1.v/p1.z;
			var dvdzright:Number = p3.v / p3.z - p1.v/p1.z;
			var dvdyleft:Number = dvdzleft / (p2.y - p1.y);
			var dvdyright:Number = dvdzright / (p3.y - p1.y);
			var vzleft:Number = p1.v/p1.z, vzright:Number = p1.v/p1.z;
			
			var dx:Number = 0, doz:Number = 0, duz:Number = 0, dvz:Number = 0;
			var uz:Number = uzleft, vz:Number = vzleft, oz:Number = o1zleft;
			var u:int, v:int, color:uint;
			//y扫描
			for(i = p1.y; i < p2.y; i++)
			{
				//x扫描
				for(j = int(xleft); j <= int(xright); j++)
				{
					u = Math.round(uz/oz);
					v = Math.round(vz/oz);
					//画图
					color = wall.bitmapData.getPixel32(u,v);	
					bmp.bitmapData.setPixel32(j, i, color);
					uz += duz;
					vz += dvz;
					oz += doz;
				}
				
				xleft += dxdyleft;
				xright += dxdyright;
				
				o1zleft += d1zdyleft;
				o1zright += d1zdyright;
				
				uzleft += dudyleft;
				uzright += dudyright;
				
				vzleft += dvdyleft;
				vzright += dvdyright;
				
				dx = xright - xleft;
				doz = (o1zright - o1zleft) / dx;
				duz = (uzright - uzleft) / dx;
				dvz = (vzright - vzleft) / dx;
				
				oz = o1zleft;
				uz = uzleft;
				vz = vzleft;
			}
		}
	}
}