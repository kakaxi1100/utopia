package test.collision
{
	import flash.geom.Rectangle;
	
	import org.ares.vernalbreeze.VBVector;
	/**
	 *要计算每个顶点到X,Y轴的投影
	 * 这样可以算出包围盒的最大最小值 
	 * 矩阵旋转变换
	 *|cosθ, -sinθ| |x|
	 *|sinθ, cosθ |*|y|	 
	 * @author JuLi
	 * 
	 */
	public class VBAABB
	{
		private var mMin:VBVector = new VBVector();
		private var mMax:VBVector = new VBVector();
		
		public var shape:Rectangle = new Rectangle();
		public function VBAABB()
		{
		}
		
		public function updateAABB(vertexs:Vector.<VBVector>):void
		{
			if(vertexs.length == 0) return;
			var ymin:Number = vertexs[0].y;
			var ymax:Number = vertexs[0].y;
			var xmin:Number = vertexs[0].x; 
			var xmax:Number = vertexs[0].x;
			
			for(var i:int = 0; i<vertexs.length; i++)
			{
				//找到Y轴的最小和最大顶点
				if(vertexs[i].y > ymax)
				{
					ymax = vertexs[i].y;
				}else if(vertexs[i].y < ymin)
				{
					ymin = vertexs[i].y;
				}
				//找到X轴的最小和最大顶点
				if(vertexs[i].x > xmax)
				{
					xmax = vertexs[i].x;
				}else if(vertexs[i].x < xmin)
				{
					xmin = vertexs[i].x;
				}
			}
			//开始构建AABB
			shape.x = xmin;
			shape.y = ymin;
			shape.width = xmax - xmin;
			shape.height = ymax - ymin;
		}
	}
}