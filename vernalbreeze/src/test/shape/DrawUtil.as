package test.shape
{
	import flash.display.Graphics;
	
	import org.ares.vernalbreeze.VBVector;
	
	import test.collision.VBAABB;
	import test.collision.VBOBB;
	import test.collision.VBRim;
	import test.collision.VBSegment;

	public class DrawUtil
	{
		public function DrawUtil()
		{
		}
		/**
		 *画圆 
		 * @param g
		 * @param v
		 * @param r
		 * @param thickness
		 * @param color
		 * 
		 */		
		public static function drawRim(g:Graphics, v:VBVector, r:Number = 5, thickness:Number = 1, color:uint = 0xff0000):void
		{
			g.lineStyle(thickness,color);
			g.drawCircle(v.x,v.y,r);
		}
		public static function drawRim2(g:Graphics, rim:VBRim, thickness:Number = 1, color:uint = 0xff0000):void
		{
			g.lineStyle(thickness,color);
			g.drawCircle(rim.c.x,rim.c.y,rim.r);
		}
		/**
		 *画线 从 V1 点 到 V2 点
		 * @param g
		 * @param v1
		 * @param v2
		 * @param thickness
		 * @param color
		 * 
		 */		
		public static function drawLine(g:Graphics, v1:VBVector, v2:VBVector, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			g.lineStyle(thickness,color);
			g.moveTo(v1.x, v1.y);
			g.lineTo(v2.x, v2.y);
		}
		
		public static function drawLine2(g:Graphics, vs:VBSegment, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			g.lineStyle(thickness,color);
			g.moveTo(vs.start.x, vs.start.y);
			g.lineTo(vs.end.x, vs.end.y);
		}
		/**
		 *画 AABB 
		 * @param g
		 * @param bb
		 * @param thickness
		 * @param color
		 * 
		 */		
		public static function drawAABB(g:Graphics, aabb:VBAABB, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			g.lineStyle(thickness,color);
			g.drawRect(aabb.min.x, aabb.min.y, aabb.max.x - aabb.min.x, aabb.max.y - aabb.min.y);
		}
		/**
		 *画OBB 
		 * @param g
		 * @param obb
		 * @param thickness
		 * @param color
		 * 
		 */		
		public static function drawOBB(g:Graphics, obb:VBOBB, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			//1.在世界坐标系下求出半宽和半高对于OBB轴向的矢量值
			var tempW:VBVector = obb.x.mult(obb.halfWidth);//计算宽度的向量
			var tempH:VBVector = obb.y.mult(obb.halfHeight);//计算高度的向量
			//2.此时根据根据半宽和半高在 e0-e1 轴向上的矢量和既可以算出四个顶点 相对于世界坐标（0，0）的位置
			var a:VBVector = new VBVector(tempW.x + tempH.x, tempW.y + tempH.y);
			var b:VBVector = new VBVector(-tempW.x + tempH.x, -tempW.y + tempH.y);
			var c:VBVector = new VBVector(-tempW.x - tempH.x, -tempW.y - tempH.y);
			var d:VBVector = new VBVector(tempW.x - tempH.x, tempW.y - tempH.y);

			//3.再加上中心点在世界坐标的位置求出各点的世界坐标
			a.plusEquals(obb.center);
			b.plusEquals(obb.center);
			c.plusEquals(obb.center);
			d.plusEquals(obb.center);
	
			DrawUtil.drawLine(g, a, b, thickness, color);
			DrawUtil.drawLine(g, b, c, thickness, color);
			DrawUtil.drawLine(g, c, d, thickness, color);
			DrawUtil.drawLine(g, d, a, thickness, color);
		}
		
		/**
		 *根据顶点画多边形 
		 * 
		 */		
		public static function drawPolygon(g:Graphics, vertex:Vector.<VBVector>, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			for(var i:int = 0; i < vertex.length; i++)
			{
				var next:int = i+1;
				if(next >= vertex.length)
				{
					next = 0;
				}
				DrawUtil.drawLine(g, vertex[i], vertex[next],thickness, color);
			}
		}
		
		/**
		 *画三角形 
		 * @param g
		 * @param a
		 * @param b
		 * @param c
		 * @param thickness
		 * @param color
		 * 
		 */		
		public static function drawTriangle(g:Graphics, a:VBVector, b:VBVector, c:VBVector, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			g.lineStyle(thickness,color);
			g.moveTo(a.x, a.y);
			g.lineTo(b.x, b.y);
			g.lineTo(c.x, c.y);
			g.lineTo(a.x, a.y);
		}
	}
}