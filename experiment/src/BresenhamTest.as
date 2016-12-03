package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0xcccccc")]
	public class BresenhamTest extends Sprite
	{
		private var bmp:Bitmap = new Bitmap(new BitmapData(640,480,false));
		public function BresenhamTest()
		{
			super();
			
			addChild(bmp);
			
			drawLine(0,0,640, 300);
		}
		
		private function drawLine(x0:int, y0:int, x1:int, y1:int):void
		{
			var k:Number = (y1 - y0)/(x1 - x0);
			var curX:int = x0, curY:int = y0;
			var tempY:Number = y0;
			var d:int;
			while(curX <= x1){
				//画点
				var p:Point = changeCoordinate(curX, curY);
				bmp.bitmapData.setPixel32(p.x, p.y, 0);
				//步进x, y
				curX++;
				d++;
				tempY = y0 + d*k;
				if(Math.abs(tempY - curY) >= 0.5){
					curY++;
				}
			}
		}
		
		private function changeCoordinate(x:Number, y:Number):Point
		{
			return new Point(x, stage.stageHeight - y);
		}
	}
}