package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vo.Base;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0")]
	public class TriangleTest extends Sprite
	{
//----------------bitmap 划线-----------------------------------------		
		private var p1:Point = new Point(50, 0);
		private var p2:Point = new Point(150, 0);
		private var p3:Point = new Point(50, 200);
		
		private var back:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
		public function TriangleTest()
		{
			super();
			
			//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.BOTTOM_RIGHT;
			
			Base.worldCenterX = stage.stageWidth >> 1;
			Base.worldCenterY = stage.stageHeight >> 1;
			
			//将0点坐标变为左下角
			back.scaleY = -1;
			back.y += back.height;
			addChild(back);
			
			Base.drawTriangle(p1.x + Base.worldCenterX, p1.y + Base.worldCenterY, 
							  p2.x + Base.worldCenterX, p2.y + Base.worldCenterY, 
							  p3.x + Base.worldCenterX, p3.y + Base.worldCenterY, 
							  back.bitmapData, 0xFFFF00);
			
			stage.addEventListener(MouseEvent.CLICK, onMouseCli1ck);
		}
		
		protected function onMouseCli1ck(event:MouseEvent):void
		{
			back.bitmapData.fillRect(back.bitmapData.rect, 0);
			
			p1.setTo(Math.random()*640 - 320, Math.random()*480 - 240);
			p2.setTo(Math.random()*640 - 320, Math.random()*480 - 240);
			p3.setTo(Math.random()*640 - 320, Math.random()*480 - 240);
			
			Base.drawTriangle(p1.x + Base.worldCenterX, p1.y + Base.worldCenterY, 
							  p2.x + Base.worldCenterX, p2.y + Base.worldCenterY, 
							  p3.x + Base.worldCenterX, p3.y + Base.worldCenterY, 
							  back.bitmapData, Math.random()*0xFFFFFF);
		}
		
//-----------------graphics 画线-----------------------------------------------
//		private var p0:Point = new Point(100, 100);
//		private var p1:Point = new Point(50, 0);
//		private var p2:Point = new Point(150, 0);
//		
//		private var p3:Point = new Point(50, 200);
//		private var p4:Point = new Point(150, 200);
//		private var p5:Point = new Point(100, 100);
//		
//		public function TriangleTest()
//		{
//			super();
//			
//			this.graphics.lineStyle(1, 0xFFFF00);
////			bottomTriangle();
////			upTriangle();
//			
//			drawTriangle(p1.x,p1.y, p2.x, p2.y, p3.x, p3.y);
//			
//			stage.addEventListener(MouseEvent.CLICK, onMouseCli1ck);
//		}
//		
//		protected function onMouseCli1ck(event:MouseEvent):void
//		{
//			this.graphics.clear();
//			this.graphics.lineStyle(1, 0xFFFF00);
//
//			p1.setTo(Math.random()*640, Math.random()*480);
//			p2.setTo(Math.random()*640, Math.random()*480);
//			p3.setTo(Math.random()*640, Math.random()*480);
//			drawTriangle(p1.x,p1.y, p2.x, p2.y, p3.x, p3.y);
//			
//			trace(p1, p2, p3);
//		}
//		
//		private function drawTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
//		{
//			x1 = Math.round(x1);
//			y1 = Math.round(y1);
//			x2 = Math.round(x2);
//			y2 = Math.round(y2);
//			x3 = Math.round(x3);
//			y3 = Math.round(y3);
//			
//			//一条线
//			if((x1 == x2 && x2 == x3) || (y1 == y2 && y2 == y3))
//			{
//				return;
//			}
//			
//			var tempX:Number, tempY:Number, newX:Number, longK:Number;
//			//按升序排列y值 p1, p2, p3
//			if(y2 < y1)
//			{
//				tempX = x2;
//				tempY = y2;
//				x2 = x1;
//				y2 = y1;
//				x1 =tempX;
//				y1 = tempY;
//			}
//			if(y3 < y1)
//			{
//				tempX = x3;
//				tempY = y3;
//				x3 = x1;
//				y3 = y1;
//				x1 =tempX;
//				y1 = tempY;
//			}
//			if(y3 < y2)
//			{
//				tempX = x3;
//				tempY = y3;
//				x3 = x2;
//				y3 = y2;
//				x2 =tempX;
//				y2 = tempY;
//			}
//			
//			if(y1 == y2)//平底
//			{
//				bottomTriangle(x1,y1,x2,y2,x3,y3);
//			}else if(y2 == y3){//平顶
//				upTriangle(x1,y1,x2,y2,x3,y3);
//			}else{//任意
//				tempY = y2 - y1;//p2的Y值相对于p1点的坐标, 因为现在的计算相当于p1点是原点了
//				longK = (x3 - x1)/(y3 - y1);//求最长边斜率的倒数
//				newX = x1 + (tempY * longK);//分离上下三角形的最长斜边上的点的X值, Y值就是P2咯, 当然要转化为 世界坐标还需要加上 p1的 x 值
//				
//				bottomTriangle(x2, y2, newX, y2, x3, y3);
//				upTriangle(x1, y1, x2, y2, newX, y2);
//			}
//			
//		}
//		
//		private function upTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
//		{
//			var kLeft:Number = (x2 - x1) / (y2 - y1);
//			var kRight:Number = (x3 - x1) / (y3 - y1);
//			
//			var xs:Number = x1, xe:Number = x1;
//			for(var y:Number = y1; y <= y2; y++)
//			{
//				//画图
//				this.graphics.moveTo(xs, y);
//				this.graphics.lineTo(xe, y);
//				
//				xs += kLeft;
//				xe += kRight;
//			}
//		}
//		
//		private function bottomTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
//		{
//			var kLeft:Number = (x3 - x1) / (y3 - y1);
//			var kRight:Number = (x3 - x2) / (y3 - y2);
//			
//			var xs:Number = x1, xe:Number = x2;
//			for(var y:Number = y1; y <= y3; y++)
//			{
//				//画图
//				this.graphics.moveTo(xs, y);
//				this.graphics.lineTo(xe, y);
//				xs += kLeft;
//				xe += kRight;
//			}
//		}
	}
}