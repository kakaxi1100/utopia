package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0xcccccc")]
	public class BresenhamTest extends Sprite
	{
		private var bmp:Bitmap = new Bitmap(new BitmapData(640,480,false));
		
		private var sp1:Sprite = new Sprite();
		private var sp2:Sprite = new Sprite();
		private var isMouseDown:Boolean = false;
		private var drawed:Boolean = false;
		private var target:Sprite;
		public function BresenhamTest()
		{
			super();
				
			addChild(bmp);
			
			sp1.graphics.lineStyle(1, 0xff0000);
			sp1.graphics.beginFill(0);
			sp1.graphics.drawCircle(0,0,10);
			sp1.graphics.endFill();
			sp1.x = sp1.y = changeCoordinate(100,100).x;
			addChild(sp1);
			
			sp2.graphics.lineStyle(1, 0x00ff00);
			sp2.graphics.beginFill(0);
			sp2.graphics.drawCircle(0,0,10);
			sp1.graphics.endFill();
			sp2.x = sp2.y = changeCoordinate(200,200).x;
			addChild(sp2)
			
//			drawLine(100,100,540, 200);
//			drawLineEntire(600,100,540, 200);
			
			sp1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			sp2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			sp1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			sp2.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			sp1.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			sp2.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(!target) return;
			
			if(isMouseDown == false){
				if(drawed == false){
					drawed = true;
					bmp.bitmapData.fillRect(bmp.bitmapData.rect, 0xffffff);	
					var v1:Point = changeCoordinate(sp1.x, sp1.y);
					var v2:Point = changeCoordinate(sp2.x, sp2.y);
					drawLineEntire(v1.x, v1.y, v2.x, v2.y);
				}
				
			}else{
				target.x = this.mouseX;
				target.y = this.mouseY;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			isMouseDown = false;
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			isMouseDown = true;	
			drawed = false;
			target = event.target as Sprite;
		}
		
		
		//DDA有错误的算法 未解决 二三象限
		private function drawLineEntire(x0:int, y0:int, x1:int, y1:int):void
		{
			//第一步, 计算斜率
			var k:Number = (y1 - y0)/(x1 - x0);
			var kreverse:Number = (x1 - x0)/(y1 - y0);
			var dx:int = (x1 - x0) > 0 ? x1 - x0 : x0 - x1;
			var dy:int = (y1 - y0) > 0 ?　y1 - y0 : y0 - y1;
			var xStep:int = (x1 - x0) > 0 ? 1:-1;
			var yStep:int = (y1 - y0) > 0 ? 1:-1;
			var index:int = 0;
			var curX:int = x0, curY:int = y0;
			var realX:Number = x0, realY:Number = y0;
			var p:Point;
			if((k < 1 && k > 0) || (k > -1 && k < 0)){//x步进
				while(index <= dx ){
					//画点
					p = changeCoordinate(curX, curY);
					bmp.bitmapData.setPixel32(p.x, p.y, 0);
					//步进
					curX += xStep;
					realY += k;
					if(Math.abs(Math.abs(realY) - Math.abs(curY)) >= 0.5){
						curY+=yStep;
					}
					index++;
				}
			}else{//y步进
				while(index <= dy ){
					//画点
					p = changeCoordinate(curX, curY);
					bmp.bitmapData.setPixel32(p.x, p.y, 0);
					//步进
					curY += yStep;
					realX += kreverse;
					if(Math.abs(Math.abs(realX) - Math.abs(curX)) >= 0.5){
						curX += xStep;
					}
					index++;
				}
			}
		}
		
		private function drawLine(x0:int, y0:int, x1:int, y1:int):void
		{
			var k:Number = (y1 - y0)/(x1 - x0);
			if(Math.abs(k) < 1){
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
			}else{
				
			}
		}
		
		private function changeCoordinate(x:Number, y:Number):Point
		{
			return new Point(x, stage.stageHeight - y);
		}
	}
}