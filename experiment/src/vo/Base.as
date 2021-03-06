package vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import file.ParseString;
	
	import vo.td.CObjective;
	import vo.td.CPoint3D;
	import vo.td.CPoint4D;
	import vo.td.CPolygon;
	import vo.td.Objective;
	import vo.td.Polygon;

	public class Base
	{
		public static var worldCenterX:Number = 0;
		public static var worldCenterY:Number = 0;
		
		//将零点坐标转换为左下角, 方便做透视变换
		public static function changeCoordinate(x:Number, y:Number, h:Number):Point
		{
			return new Point(x, h-y);
		}
		
		//解析文件返回一个objective
		//传入的是原始文件字符串
		public static function parseObjective4D(raw:String):CObjective
		{
			var obj:CObjective = new CObjective();
			//去掉了空行,注释和前后空格的行
			var lines:Array = ParseString.getTrimLines(raw);
			//开始解析
			var i:int = 0, index:int = 0;
			//1.解析物体信息
			//将物品信息的每个参数存入数组
			var line:Array = (lines[index++] as String).split(" ");
			line[0] = ParseString.trim(line[0]);//trim后的物品名称
			line[1] = ParseString.trim(line[1]);//trim后的顶点数
			line[2] = ParseString.trim(line[2]);//trim后的多边形数
			obj.name = line[0];
			obj.vertexsNum = line[1];
			obj.polysNum = line[2];
			//2.添加顶点
			var p:CPoint4D;
			for(i = 0; i < obj.vertexsNum; i++)
			{
				line = lines[index++].split(" ");
				line[0] = ParseString.trim(line[0]);//mx
				line[1] = ParseString.trim(line[1]);//my
				line[2] = ParseString.trim(line[2]);//mz
				
				p = new CPoint4D(parseInt(line[0]), parseInt(line[1]), parseInt(line[2]));
				obj.vlist[i] = p;
			}
			
			//计算包围球
			obj.updateSphere();
			
			//local vertexs--> trans vertexs
			//因为polygon不需要tvertexs列表了,它的数据来自于object的trans vertexs 列表
			obj.vertexLocalToTrans();

			var polygon:CPolygon;
			//3.polygon list 添加多边形列表
			for(i = 0; i < obj.polysNum; i++)
			{
				line = lines[index++].split(" ");
				line[0] = ParseString.trim(line[0]);//description (no use now)
				line[1] = ParseString.trim(line[1]);//polygon vertexs
				line[2] = ParseString.trim(line[2]);//polygon vertex indexs
				line[3] = ParseString.trim(line[3]);//polygon vertex indexs
				line[4] = ParseString.trim(line[4]);//polygon vertex indexs
				
				line[0] = parseInt(line[0], 16);
				line[1] = parseInt(line[1]);
				line[2] = parseInt(line[2]);
				line[3] = parseInt(line[3]);
				line[4] = parseInt(line[4]);
				
				polygon = new CPolygon(obj.tvlist, line[2], line[3], line[4], line[0]);
				obj.plist[i] = polygon;
			}
			
			return obj;
		}
		
		
		//解析文件返回一个objective
		//传入的是原始文件字符串
		public static function parseObjective(raw:String):Objective
		{
			var obj:Objective = new Objective();
			//去掉了空行,注释和前后空格的行
			var lines:Array = ParseString.getTrimLines(raw);
			//开始解析
			var i:int = 0, index:int = 0;
			//1.解析物体信息
			//将物品信息的每个参数存入数组
			var line:Array = (lines[index++] as String).split(" ");
			line[0] = ParseString.trim(line[0]);//trim后的物品名称
			line[1] = ParseString.trim(line[1]);//trim后的顶点数
			line[2] = ParseString.trim(line[2]);//trim后的多边形数
			obj.name = line[0];
			obj.vertexsNum = line[1];
			obj.polysNum = line[2];
			//2.添加顶点
			var p:CPoint3D;
			for(i = 0; i < obj.vertexsNum; i++)
			{
				line = lines[index++].split(" ");
				line[0] = ParseString.trim(line[0]);//mx
				line[1] = ParseString.trim(line[1]);//my
				line[2] = ParseString.trim(line[2]);//mz
				
				p = new CPoint3D(parseInt(line[0]), parseInt(line[1]), parseInt(line[2]));
				obj.vlist[i] = p;
			}
			//local vertexs--> trans vertexs
			//因为polygon不需要tvertexs列表了,它的数据来自于object的trans vertexs 列表
			obj.vertexLocalToTrans();
			var polygon:Polygon;
			//3.polygon list 添加多边形列表
			for(i = 0; i < obj.polysNum; i++)
			{
				line = lines[index++].split(" ");
				line[0] = ParseString.trim(line[0]);//description (no use now)
				line[1] = ParseString.trim(line[1]);//polygon vertexs
				line[2] = ParseString.trim(line[2]);//polygon vertex indexs
				line[3] = ParseString.trim(line[3]);//polygon vertex indexs
				line[4] = ParseString.trim(line[4]);//polygon vertex indexs
				
				line[0] = parseInt(line[0], 16);
				line[1] = parseInt(line[1]);
				line[2] = parseInt(line[2]);
				line[3] = parseInt(line[3]);
				line[4] = parseInt(line[4]);
				
				polygon = new Polygon(obj.tvlist, line[2], line[3], line[4]);
				obj.plist[i] = polygon;
			}
			
			return obj;
		}
		
		//填充光栅化三角形
		public static function drawTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, bmd:BitmapData, color:uint = 0xFF0000):void
		{
			x1 = Math.round(x1);
			y1 = Math.round(y1);
			x2 = Math.round(x2);
			y2 = Math.round(y2);
			x3 = Math.round(x3);
			y3 = Math.round(y3);
			
			
			//一条线
			if((x1 == x2 && x2 == x3) || (y1 == y2 && y2 == y3))
			{
				return;
			}
			
			var tempX:Number, tempY:Number, newX:Number, longK:Number;
			//按升序排列y值 p1, p2, p3
			if(y2 < y1)
			{
				tempX = x2;
				tempY = y2;
				x2 = x1;
				y2 = y1;
				x1 =tempX;
				y1 = tempY;
			}
			if(y3 < y1)
			{
				tempX = x3;
				tempY = y3;
				x3 = x1;
				y3 = y1;
				x1 =tempX;
				y1 = tempY;
			}
			if(y3 < y2)
			{
				tempX = x3;
				tempY = y3;
				x3 = x2;
				y3 = y2;
				x2 =tempX;
				y2 = tempY;
			}
			
			if(y1 == y2)//平底
			{
				bottomTriangle(x1,y1,x2,y2,x3,y3, bmd, color);
			}else if(y2 == y3){//平顶
				upTriangle(x1,y1,x2,y2,x3,y3, bmd, color);
			}else{//任意
				tempY = y2 - y1;//p2的Y值相对于p1点的坐标, 因为现在的计算相当于p1点是原点了
				longK = (x3 - x1)/(y3 - y1);//求最长边斜率的倒数
				newX = x1 + (tempY * longK);//分离上下三角形的最长斜边上的点的X值, Y值就是P2咯, 当然要转化为 世界坐标还需要加上 p1的 x 值
				
				bottomTriangle(x2, y2, newX, y2, x3, y3, bmd, color);
				upTriangle(x1, y1, x2, y2, newX, y2, bmd, color);
			}
		}
		
		//平顶三角形
		//y1<y2<y3
		private static function upTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, bmd:BitmapData, color:uint = 0xFF0000):void
		{
			var kLeft:Number = (x2 - x1) / (y2 - y1);
			var kRight:Number = (x3 - x1) / (y3 - y1);
			
			var xs:Number = x1, xe:Number = x1;
			for(var y:Number = y1; y <= y2; y++)
			{
				//画图
				drawLineXY(xs, y, xe, y, bmd, color);
			
				xs += kLeft;
				xe += kRight;
			}
		}
		
		//平底三角形
		//y1<y2<y3
		private static function bottomTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, bmd:BitmapData, color:uint = 0xFF0000):void
		{
			var kLeft:Number = (x3 - x1) / (y3 - y1);
			var kRight:Number = (x3 - x2) / (y3 - y2);
			
			var xs:Number = x1, xe:Number = x2;
			for(var y:Number = y1; y <= y3; y++)
			{
				//画图
				drawLineXY(xs, y, xe, y, bmd, color);
				
				xs += kLeft;
				xe += kRight;
			}
		}
		
		public static function drawLineXY(sx:Number, sy:Number, ex:Number, ey:Number, bmd:BitmapData, color:uint = 0xFF0000):void
		{
			var start:Point = new Point(sx, sy);
			var end:Point = new Point(ex, ey);
			drawLine(start, end, bmd, color);
		}
		
		//画直线算法
		public static function drawLine(start:Point, end:Point, bmd:BitmapData, color:uint = 0xFF0000):void
		{
			bmd.lock(); 
			
			var dx:int = end.x - start.x;  
			var dy:int = end.y - start.y;  
			
			var x:int = start.x;  
			var y:int = start.y;  
			
			var xInc:int;  
			var yInc:int;  
			var i:int;  
			
			if(dx >=0)  
			{  
				xInc = 1;  
			}else  
			{  
				xInc = -1;  
				dx = -dx;//总共要走多少步, 一定是正的
			}  
			
			if(dy >= 0)  
			{  
				yInc = 1;  
			}else  
			{  
				yInc = -1;  
				dy = -dy;  
			}  
			
			//比较值的时候，都是按照第一象限来比较，只不过，步进的时候，按照 xInc, yInc 来步进  
			var k2dx:int = 2*dx;  
			
			var k2dy:int = 2*dy;  
			var error:int;  
			
			if(dx >= dy)//近X轴线 ,注意判断条件！
			{  
				error = k2dy - dx;
				for(i = 0; i <= dx ; i++)  
				{  
					bmd.setPixel32(x,y, color);  
					if(error > 0)  
					{  
						error -= k2dx;//这里为什么要这么减呢？看笔记吧,化简到这步其实经历了很多过程
						y += yInc;  
					}
					error += k2dy;  
					
					x += xInc;  
				}  
			}else//近Y轴线  
			{  
				error = k2dx - dy;
				for(i = 0; i <= dy ; i++)  
				{  
					bmd.setPixel32(x,y, color);  
					if(error > 0)  
					{  
						error -= k2dy;  
						x += xInc;  
					}
					error += k2dx;  
					
					y += yInc;  
				}  
			}  
			
			bmd.unlock();  
		}
	}
}