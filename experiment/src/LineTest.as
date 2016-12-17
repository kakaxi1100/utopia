package  
{  
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Point;  
	
	[SWF(frameRate="60", backgroundColor="0",height="600",width="800")]  
	public class LineTest extends Sprite  
	{  
		private var bmd:BitmapData = new BitmapData(800,600, false, 0);  
		private var bmp:Bitmap = new Bitmap(bmd);  
		private var error_factor:Number = 0.5;  
		public function LineTest()  
		{  
			stage.scaleMode = StageScaleMode.NO_SCALE;  
			addChild(bmp);  
			
//			draw_help3(new Point(0,300), new Point(800,300), 0xffffff);  
//			draw_help3(new Point(400,0), new Point(400,600), 0xffffff);  
//			draw_help3(new Point(400,300), new Point(500,500),0x00ffff);  
//			draw_help3(new Point(400,300), new Point(500,400),0x00ff00);  
//			draw_help3(new Point(400,300), new Point(300,500),0xffff00);  
//			draw_help3(new Point(400,300), new Point(300,400),0x0000ff);  
//			
//			draw_help3(new Point(100,600), new Point(800,10),0xff0000);  
			draw_help3(new Point(), new Point(800, 80), 0x00ffff);
			for_contrast_right_or_wrong(new Point(), new Point(800, 80), 0xff0000);
		}  
		
		private function for_contrast_right_or_wrong(start:Point, end:Point, color:uint):void  
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
				dx = -dx;//总共要走多少步  
			}  
			
			if(dy >= 0)  
			{  
				yInc = 1;  
			}else  
			{  
				yInc = -1;  
				dy = -dy;  
			}  
			
			var k:Number = dy/dx;
			var error:Number = k - 0.5;
			if(dx >= dy)//近X轴线  
			{  
				for(i = 0; i <= dx ; i++)  
				{  
					bmd.setPixel32(x,y, color);  
					if(error > 0)  
					{  
						y += yInc; 
						// 这里为什么是减1而不是0.5呢？因为y向上涨了1, 也就是当前的右边的y值变成了Y+1, 
						// 按 斜率是0.1算, 并且假如error是跟0.5比 即error > 0.5时 Y 步进1
						// 0~0.4 的时候，Y = 0, 当 误差到 0.5 时 Y = 1 此时 error = -0.5 真实的 y=0.5
						// 当y=0.6时, error = -0.4 Y=1
						//...
						// 当y=1.0时, error = 0  此时Y=1
						//...
						// 当 y=1.4时, error = 0.4， 此时Y=1
						// 当 y=1.5时, error = 0.5， 此时Y=2
						// 这个是符合预期的,可以画图看看。
						error -= 1;
					} 
					error = error + k;  
					x += xInc;  
				}  
			}
			
			bmd.unlock();  
		}  
		
		private function draw_help3(start:Point, end:Point, color:uint):void  
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
				dx = -dx;//总共要走多少步  
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
			var k2dx:int = 2*dy;  
			var error2dx:int = k2dx - 1;  
			
			var k2dy:int = 2*dx;  
			var error2dy:int = k2dy - 1;  
			
			if(dx >= dy)//近X轴线  
			{  
				for(i = 0; i <= dx ; i++)  
				{  
					bmd.setPixel32(x,y, color);  
					if(error2dx > 0)  
					{  
						y += yInc;  
						error2dx = error2dx + k2dx - 2*dx;  
					}else  
					{  
						error2dx = error2dx + k2dx;  
					}  
					x += xInc;  
				}  
			}else//近Y轴线  
			{  
				for(i = 0; i <= dy ; i++)  
				{  
					bmd.setPixel32(x,y, color);  
					if(error2dy > 0)  
					{  
						x += xInc;  
						error2dy = error2dy + k2dy - 2*dy;  
					}else  
					{  
						error2dy = error2dy + k2dy;  
					}  
					y += yInc;  
				}  
			}  
			
			bmd.unlock();  
		}  
		
		private function draw_help2(start:Point, end:Point):void  
		{  
			bmd.lock();  
			var dx:int = end.x - start.x;  
			var dy:int = end.y - start.y;  
			
			var x:int = start.x;  
			var y:int = start.y;  
			
			var k2dx:int = 2*dy;  
			var error2dx:int = k2dx - 1;  
			
			for(var i:int = 0; i < dx ; i++)  
			{  
				bmd.setPixel32(x,y, 0xffff00);  
				if(error2dx > 0)  
				{  
					y++;  
					error2dx = error2dx + k2dx - 2*dx;  
				}else  
				{  
					error2dx = error2dx + k2dx;  
				}  
				x++;  
			}  
			bmd.unlock();  
		}  
		
		private function draw_help(start:Point, end:Point):void  
		{  
			bmd.lock();  
			//必须是整点  
			var dx:int = end.x - start.x;  
			var dy:int = end.y - start.y;  
			
			var x:int = start.x;  
			var y:int = start.y;  
			
			var k:Number = dy/dx;  
			var error:Number = k - 0.5;//初始值  
			
			for(var i:int = 0; i < dx ; i++)  
			{  
				bmd.setPixel32(x,y, 0xffffff);  
				if(error > 0)//取右上的点  
				{  
					y++;  
					error = error + k - 1;  
				}else  
				{  
					error = error + k;  
				}  
				x++;  
			}  
			bmd.unlock();  
		}  
	}  
}  