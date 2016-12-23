package vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import file.ParseString;
	
	import vo.td.CPoint3D;
	import vo.td.Objective;
	import vo.td.Polygon;

	public class Base
	{
		//将零点坐标转换为左下角, 方便做透视变换
		public static function changeCoordinate(x:Number, y:Number, h:Number):Point
		{
			return new Point(x, h-y);
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