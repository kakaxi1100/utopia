package test.shape
{
	import flash.display.Graphics;
	
	import org.ares.vernalbreeze.VBVector;
	
	import test.collision.VBAABB;

	public class DrawUtil
	{
		public function DrawUtil()
		{
		}
		
		public static function drawRim(g:Graphics, v:VBVector, r:Number = 5, thickness:Number = 1, color:uint = 0xff0000):void
		{
			g.lineStyle(thickness,color);
			g.drawCircle(v.x,v.y,r);
		}
		
		public static function drawLine(g:Graphics, v1:VBVector, v2:VBVector, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			g.lineStyle(thickness,color);
			g.moveTo(v1.x, v1.y);
			g.lineTo(v2.x, v2.y);
		}
		
		public static function drawAABB(g:Graphics, bb:VBAABB, thickness:Number = 1, color:uint = 0x00ff00):void
		{
			g.lineStyle(thickness,color);
			g.drawRect(bb.min.x, bb.min.y, bb.max.x - bb.min.x, bb.max.y - bb.min.y);
		}
	}
}