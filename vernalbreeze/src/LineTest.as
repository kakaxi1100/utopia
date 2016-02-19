package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Point;

	[SWF(frameRate="60", backgroundColor="0",height="400",width="550")]
	public class LineTest extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(550,400, false, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var error_factor:Number = 0.5;
		public function LineTest()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addChild(bmp);
			
			draw_help1_4(new Point(0,0), new Point(550,150));
		}
		
		private function draw_help5(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = Math.round(end.x) - Math.round(start.x);
			var dy:int = Math.round(end.y) - Math.round(start.y);
			var k2dx:int = 2*dy;
			var d2dx:int = 0;
			var x:int = Math.round(start.x);
			var y:int = Math.round(start.y);
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				d2dx = d2dx + k2dx;
				if(d2dx > dx)
				{
					d2dx = d2dx - dx;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help4(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = Math.round(end.x) - Math.round(start.x);
			var dy:int = Math.round(end.y) - Math.round(start.y);
			var k2dx:Number = 2*dy;
			var d2dx:Number = 0;
			var x:int = Math.round(start.x);
			var y:int = Math.round(start.y);
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff*Math.random());
				d2dx = d2dx + k2dx;
				if(d2dx > dx)
				{
					d2dx = d2dx - dx;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help3(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = end.x - start.x;
			var dy:int = end.y - start.y;
			var k2dx:Number = 2*dy;
			var d2dx:Number = 0;
			var x:Number = start.x;
			var y:Number = start.y;
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				d2dx = d2dx + k2dx;
				if(d2dx > dx)
				{
					d2dx = d2dx - dx;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help2(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = end.x - start.x;
			var dy:int = end.y - start.y;
			var k2:Number = 2*dy/dx;
			var d2:Number = 0;
			var x:Number = start.x;
			var y:Number = start.y;
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				d2 = d2 + k2;
				if(d2 > 1)
				{
					d2 = d2 - 1;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help1_4(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = Math.round(end.x) - Math.round(start.x);
			var dy:int = Math.round(end.y) - Math.round(start.y);
			var k2dx:int = 2*dy;
			var error2dx:int = -dx;
			var x:int = start.x;
			var y:int = start.y;
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				error2dx = error2dx + k2dx;
				if(error2dx > 0)
				{
					error2dx = -dx;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help1_3(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = end.x - start.x;
			var dy:int = end.y - start.y;
			var k2dx:Number = 2*dy;
			var error2dx:Number = -dx;
			var x:Number = start.x;
			var y:Number = start.y;
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				error2dx = error2dx + k2dx;
				if(error2dx > 0)
				{
					error2dx = -dx;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help1_2(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = end.x - start.x;
			var dy:int = end.y - start.y;
			var k2:Number = 2*dy/dx;
			var error2:Number = -1;
			var x:Number = start.x;
			var y:Number = start.y;
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				error2 = error2 + k2;
				if(error2 > 0)
				{
					error2 = -1;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help1_1(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = end.x - start.x;
			var dy:int = end.y - start.y;
			var k:Number = dy/dx;
			var d:Number = 0;
			var error:Number = -0.5;
			var x:Number = start.x;
			var y:Number = start.y;
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				error = error + k;
				if(error > 0)
				{
					error = -0.5;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
		
		private function draw_help(start:Point, end:Point):void
		{
			bmd.lock();
			var dx:int = end.x - start.x;
			var dy:int = end.y - start.y;
			var k:Number = dy/dx;
			var d:Number = 0;
			var x:Number = start.x;
			var y:Number = start.y;
			for(var i:int = 0; i < dx ; i++)
			{
				bmd.setPixel32(x,y, 0xffffff);
				d = d + k;
				if(d > 0.5)
				{
					d = d - 0.5;
					y++;
				}
				x++;
			}
			bmd.unlock();
		}
	}
}