package test.shape
{
	import flash.display.Graphics;
	
	import org.ares.vernalbreeze.VBVector;

	public class DrawUtil
	{
		public function DrawUtil()
		{
		}
		
		public static function drawRim(g:Graphics, v:VBVector, r:Number = 5):void
		{
			g.lineStyle(1,0xff0000);
			g.drawCircle(v.x,v.y,r);
		}
		
		public static function drawLine(g:Graphics, v1:VBVector, v2:VBVector):void
		{
			g.lineStyle(1,0x00ff00);
			g.moveTo(v1.x, v1.y);
			g.lineTo(v2.x, v2.y);
		}
	}
}