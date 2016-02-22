package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import test.geometry.Poligen2D;

	[SWF(frameRate="60", backgroundColor="0",height="600",width="800")]
	public class GeometryTest extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800,600, false, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var clip:Rectangle = new Rectangle(200,100,200,200);
		
		public function GeometryTest()
		{
			
		}
		
		private function drawPolygen2D(polygen:Poligen2D):int
		{
			if(polygen.state)
			{
				for(var i:int = 0; i < polygen.vlist.length - 1; i++)
				{
					if(clipLine(polygen.vlist[i], polygen.vlist[i+1], clip))
					{
						drawLine(polygen.vlist[i], polygen.vlist[i+1], 0x00ff00);
					}
				}
				if(clipLine(polygen.vlist[i], polygen.vlist[0], clip))
				{
					drawLine(polygen.vlist[i], polygen.vlist[0], 0x00ff00);
				}
				return 1;
			}
			return 0;
		}
		
		private function clipLine(start:Point, end:Point, clipRect:Rectangle):int
		{
			const CLIP_CODE_C:uint = 0;
			const CLIP_CODE_W:uint = 1;
			const CLIP_CODE_E:uint = 2;
			const CLIP_CODE_S:uint = 4;
			const CLIP_CODE_N:uint = 8;
			
			const CLIP_CODE_SW:uint = 5;
			const CLIP_CODE_SE:uint = 6;
			const CLIP_CODE_NW:uint = 9;
			const CLIP_CODE_NE:uint = 10;
			
			//斜率
			var k:Number = (end.y - start.y)/(end.x - start.x);
			var krevese:Number = (end.x - start.x)/(end.y - start.y);
			//计算在X轴和Y轴上裁剪过后的值
			var xc1:int = start.x;
			var yc1:int = start.y;
			var xc2:int = end.x;
			var yc2:int = end.y;
			
			//算起点再哪个区域
			var p1Code:int = 0;
			//算终点再哪个区域
			var p2Code:int = 0;
			//start
			if(xc1 < clipRect.left)
			{
				p1Code |= CLIP_CODE_W;
			}else if(xc1 > clipRect.right)
			{
				p1Code |= CLIP_CODE_E;
			}
			
			if(yc1 < clipRect.bottom)
			{
				p1Code |= CLIP_CODE_N;
			}else if(yc1 > clipRect.top)
			{
				p1Code |= CLIP_CODE_S;
			}
			//end
			if(xc2 < clipRect.left)
			{
				p2Code |= CLIP_CODE_W;
			}else if(xc2 > clipRect.right)
			{
				p2Code |= CLIP_CODE_E;
			}
			
			if(yc2 < clipRect.bottom)
			{
				p2Code |= CLIP_CODE_N;
			}else if(yc2 > clipRect.top)
			{
				p2Code |= CLIP_CODE_S;
			}
			
			//这里有个小技巧，判断直线两个端点都落在 裁剪区域之外
			//		|						|
			//	1001|		1000			|1010
			//-------------------------------------
			//	0001|			0			|0010
			//		|						|
			//-------------------------------------
			//	0101|		0100			|0110
			//		|						|
			//以W为例，当两个端点落在  W-WN 或   W-WS 的时候这条直线在矩形外面,其它情况则与矩形有交点
			//可以看出 在外面的情况 有  p1Code & p2Code != 0 ，有部分落在里面的时候，有 p1Code & p2Code  = 0
			//所以我们先把直线在裁剪区域之外的排除
			if(p1Code & p2Code)
			{
				return 0;
			}
			//再判断两个端点完全在 裁剪矩形内的情况
			//完全在里面则无须裁剪
			if(p1Code == 0 &&　p2Code == 0)
			{
				return 1;
			}
			//处理一部分在里面的情况
			//先求出起始点在矩形上的映射
			switch(p1Code)
			{
				case CLIP_CODE_C:
					break;
				case CLIP_CODE_W:
					xc1 = clipRect.left;
					yc1 = start.y + k*(xc1 - start.x);
					break;
				case CLIP_CODE_E:
					xc1 = clipRect.right;
					yc1 = start.y + k*(xc1 - start.x);
					break;
				case CLIP_CODE_S:
					yc1 = clipRect.bottom;
					xc1 = start.x + krevese*(yc1 - start.y);
					break;
				case CLIP_CODE_N:
					yc1 = clipRect.top;
					xc1 = start.x + krevese*(yc1 - start.y);
					break;
				case CLIP_CODE_SW://有一个交点会落在外面，所以要判断两次, 取落在矩形上的那个点，画个图就知道了
					xc1 = clipRect.left;
					yc1 = start.y + k*(xc1 - start.x);
					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
					{
						yc1 = clipRect.bottom;
						xc1 = start.x + krevese*(yc1 - start.y);
					}
					break;
				case CLIP_CODE_SE:
					xc1 = clipRect.right;
					yc1 = start.y + k*(xc1 - start.x);
					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
					{
						yc1 = clipRect.bottom;
						xc1 = start.x + krevese*(yc1 - start.y);
					}
					break;
				case CLIP_CODE_NW:
					xc1 = clipRect.left;
					yc1 = start.y + k*(xc1 - start.x);
					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
					{
						yc1 = clipRect.top;
						xc1 = start.x + krevese*(yc1 - start.y);
					}
					break;
				case CLIP_CODE_NE:
					xc1 = clipRect.right;
					yc1 = start.y + k*(xc1 - start.x);
					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
					{
						yc1 = clipRect.top;
						xc1 = start.x + krevese*(yc1 - start.y);
					}
					break;
			}
			//再求出终点在矩形上的映射
			switch(p2Code)
			{
				case CLIP_CODE_C:
					break;
				case CLIP_CODE_W:
					xc2 = clipRect.left;
					yc2 = end.y + k*(xc2 - end.x);
					break;
				case CLIP_CODE_E:
					xc2 = clipRect.right;
					yc2 = end.y + k*(xc2 - end.x);
					break;
				case CLIP_CODE_S:
					yc2 = clipRect.bottom;
					xc2 = end.x + krevese*(yc2 - end.y);
					break;
				case CLIP_CODE_N:
					yc2 = clipRect.top;
					xc2 = end.x + krevese*(yc2 - end.y);
					break;
				case CLIP_CODE_SW://有一个交点会落在外面，所以要判断两次, 取落在矩形上的那个点，画个图就知道了
					xc2 = clipRect.left;
					yc2 = end.y + k*(xc2 - end.x);
					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
					{
						yc2 = clipRect.bottom;
						xc2 = end.x + krevese*(yc2 - end.y);
					}
					break;
				case CLIP_CODE_SE:
					xc2 = clipRect.right;
					yc2 = end.y + k*(xc2 - end.x);
					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
					{
						yc2 = clipRect.bottom;
						xc2 = end.x + krevese*(yc2 - end.y);
					}
					break;
				case CLIP_CODE_NW:
					xc2 = clipRect.left;
					yc2 = end.y + k*(xc2 - end.x);
					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
					{
						yc2 = clipRect.top;
						xc2 = end.x + krevese*(yc2 - end.y);
					}
					break;
				case CLIP_CODE_NE:
					xc2 = clipRect.right;
					yc2 = end.y + k*(xc2 - end.x);
					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
					{
						yc2 = clipRect.top;
						xc2 = end.x + krevese*(yc2 - end.y);
					}
					break;
			}
			//double check
			if((xc1 < clipRect.left) || (xc1 > clipRect.right) ||
				(xc2 < clipRect.left) || (xc2 > clipRect.right) ||
				(yc1 < clipRect.top) || (yc1 > clipRect.bottom) ||
				(yc2 < clipRect.top) || (yc2 > clipRect.bottom))
			{
				return 0;
			}
			
			start.x = xc1;
			start.y = yc1;
			end.x = xc2;
			end.y = yc2;
			
			return 1;
		}
		
		private function drawLine(start:Point, end:Point, color:uint):void
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
//-------------直线裁剪-----------------------------------------------			
//		private var bmd:BitmapData = new BitmapData(800,600, false, 0);
//		private var bmp:Bitmap = new Bitmap(bmd);
//
//		private var clip1:Rectangle = new Rectangle(100,100,100,100);
//		private var clip2:Rectangle = new Rectangle(200,200,200,200);
//		public function LineTest()
//		{
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			addChild(bmp);
//			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//		}
//		
//		protected function onEnterFrame(event:Event):void
//		{
//			var s:Point = new Point(Math.random()*600, Math.random()*800);
//			var e:Point = new Point(Math.random()*600, Math.random()*800);
//			var s1:Point = s.clone();
//			var e1:Point = e.clone();
//			if(clipLine(s1, e1, clip1))
//			{
//				drawLine(s1,e1, 0xffffff*Math.random());
//			}
//			
//			if(clipLine(s,e,clip2))
//			{
//				drawLine(s,e,0xffffff*Math.random());
//			}
//		}		
//		
//		/**
//		 * 
//		 * 
//		 * 看起点和终点属于下列哪个区域
//		 * 
//		 * 
//				 |							|
//			NW	 |			N				|	  NE
//				 |							|
//				 |							|
//		------------------------------------------------
//				 |							|
//				 |							|
//			W	 |			C				|     E
//				 |							|
//				 |							|
//		------------------------------------------------
//				 |							|
//			SW	 |			S				|	  SE
//				 |							|
//				 |							|
//		 
//		 * @param start
//		 * @param end
//		 * @param clipRect
//		 * 
//		 */		
//		private function clipLine(start:Point, end:Point, clipRect:Rectangle):int
//		{
//			const CLIP_CODE_C:uint = 0;
//			const CLIP_CODE_W:uint = 1;
//			const CLIP_CODE_E:uint = 2;
//			const CLIP_CODE_S:uint = 4;
//			const CLIP_CODE_N:uint = 8;
//			
//			const CLIP_CODE_SW:uint = 5;
//			const CLIP_CODE_SE:uint = 6;
//			const CLIP_CODE_NW:uint = 9;
//			const CLIP_CODE_NE:uint = 10;
//			
//			//斜率
//			var k:Number = (end.y - start.y)/(end.x - start.x);
//			var krevese:Number = (end.x - start.x)/(end.y - start.y);
//			//计算在X轴和Y轴上裁剪过后的值
//			var xc1:int = start.x;
//			var yc1:int = start.y;
//			var xc2:int = end.x;
//			var yc2:int = end.y;
//			
//			//算起点再哪个区域
//			var p1Code:int = 0;
//			//算终点再哪个区域
//			var p2Code:int = 0;
//			//start
//			if(xc1 < clipRect.left)
//			{
//				p1Code |= CLIP_CODE_W;
//			}else if(xc1 > clipRect.right)
//			{
//				p1Code |= CLIP_CODE_E;
//			}
//			
//			if(yc1 < clipRect.bottom)
//			{
//				p1Code |= CLIP_CODE_N;
//			}else if(yc1 > clipRect.top)
//			{
//				p1Code |= CLIP_CODE_S;
//			}
//			//end
//			if(xc2 < clipRect.left)
//			{
//				p2Code |= CLIP_CODE_W;
//			}else if(xc2 > clipRect.right)
//			{
//				p2Code |= CLIP_CODE_E;
//			}
//			
//			if(yc2 < clipRect.bottom)
//			{
//				p2Code |= CLIP_CODE_N;
//			}else if(yc2 > clipRect.top)
//			{
//				p2Code |= CLIP_CODE_S;
//			}
//			
//			//这里有个小技巧，判断直线两个端点都落在 裁剪区域之外
//			//		|						|
//			//	1001|		1000			|1010
//			//-------------------------------------
//			//	0001|			0			|0010
//			//		|						|
//			//-------------------------------------
//			//	0101|		0100			|0110
//			//		|						|
//			//以W为例，当两个端点落在  W-WN 或   W-WS 的时候这条直线在矩形外面,其它情况则与矩形有交点
//			//可以看出 在外面的情况 有  p1Code & p2Code != 0 ，有部分落在里面的时候，有 p1Code & p2Code  = 0
//			//所以我们先把直线在裁剪区域之外的排除
//			if(p1Code & p2Code)
//			{
//				return 0;
//			}
//			//再判断两个端点完全在 裁剪矩形内的情况
//			//完全在里面则无须裁剪
//			if(p1Code == 0 &&　p2Code == 0)
//			{
//				return 1;
//			}
//			//处理一部分在里面的情况
//			//先求出起始点在矩形上的映射
//			switch(p1Code)
//			{
//				case CLIP_CODE_C:
//					break;
//				case CLIP_CODE_W:
//					xc1 = clipRect.left;
//					yc1 = start.y + k*(xc1 - start.x);
//					break;
//				case CLIP_CODE_E:
//					xc1 = clipRect.right;
//					yc1 = start.y + k*(xc1 - start.x);
//					break;
//				case CLIP_CODE_S:
//					yc1 = clipRect.bottom;
//					xc1 = start.x + krevese*(yc1 - start.y);
//					break;
//				case CLIP_CODE_N:
//					yc1 = clipRect.top;
//					xc1 = start.x + krevese*(yc1 - start.y);
//					break;
//				case CLIP_CODE_SW://有一个交点会落在外面，所以要判断两次, 取落在矩形上的那个点，画个图就知道了
//					xc1 = clipRect.left;
//					yc1 = start.y + k*(xc1 - start.x);
//					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
//					{
//						yc1 = clipRect.bottom;
//						xc1 = start.x + krevese*(yc1 - start.y);
//					}
//					break;
//				case CLIP_CODE_SE:
//					xc1 = clipRect.right;
//					yc1 = start.y + k*(xc1 - start.x);
//					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
//					{
//						yc1 = clipRect.bottom;
//						xc1 = start.x + krevese*(yc1 - start.y);
//					}
//					break;
//				case CLIP_CODE_NW:
//					xc1 = clipRect.left;
//					yc1 = start.y + k*(xc1 - start.x);
//					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
//					{
//						yc1 = clipRect.top;
//						xc1 = start.x + krevese*(yc1 - start.y);
//					}
//					break;
//				case CLIP_CODE_NE:
//					xc1 = clipRect.right;
//					yc1 = start.y + k*(xc1 - start.x);
//					if(yc1 > clipRect.bottom || yc1 < clipRect.top)
//					{
//						yc1 = clipRect.top;
//						xc1 = start.x + krevese*(yc1 - start.y);
//					}
//					break;
//			}
//			//再求出终点在矩形上的映射
//			switch(p2Code)
//			{
//				case CLIP_CODE_C:
//					break;
//				case CLIP_CODE_W:
//					xc2 = clipRect.left;
//					yc2 = end.y + k*(xc2 - end.x);
//					break;
//				case CLIP_CODE_E:
//					xc2 = clipRect.right;
//					yc2 = end.y + k*(xc2 - end.x);
//					break;
//				case CLIP_CODE_S:
//					yc2 = clipRect.bottom;
//					xc2 = end.x + krevese*(yc2 - end.y);
//					break;
//				case CLIP_CODE_N:
//					yc2 = clipRect.top;
//					xc2 = end.x + krevese*(yc2 - end.y);
//					break;
//				case CLIP_CODE_SW://有一个交点会落在外面，所以要判断两次, 取落在矩形上的那个点，画个图就知道了
//					xc2 = clipRect.left;
//					yc2 = end.y + k*(xc2 - end.x);
//					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
//					{
//						yc2 = clipRect.bottom;
//						xc2 = end.x + krevese*(yc2 - end.y);
//					}
//					break;
//				case CLIP_CODE_SE:
//					xc2 = clipRect.right;
//					yc2 = end.y + k*(xc2 - end.x);
//					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
//					{
//						yc2 = clipRect.bottom;
//						xc2 = end.x + krevese*(yc2 - end.y);
//					}
//					break;
//				case CLIP_CODE_NW:
//					xc2 = clipRect.left;
//					yc2 = end.y + k*(xc2 - end.x);
//					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
//					{
//						yc2 = clipRect.top;
//						xc2 = end.x + krevese*(yc2 - end.y);
//					}
//					break;
//				case CLIP_CODE_NE:
//					xc2 = clipRect.right;
//					yc2 = end.y + k*(xc2 - end.x);
//					if(yc2 > clipRect.bottom || yc2 < clipRect.top)
//					{
//						yc2 = clipRect.top;
//						xc2 = end.x + krevese*(yc2 - end.y);
//					}
//					break;
//			}
//			//double check
//			if((xc1 < clipRect.left) || (xc1 > clipRect.right) ||
//				(xc2 < clipRect.left) || (xc2 > clipRect.right) ||
//				(yc1 < clipRect.top) || (yc1 > clipRect.bottom) ||
//				(yc2 < clipRect.top) || (yc2 > clipRect.bottom))
//			{
//				return 0;
//			}
//			
//			start.x = xc1;
//			start.y = yc1;
//			end.x = xc2;
//			end.y = yc2;
//			
//			return 1;
//		}
//		
//		private function drawLine(start:Point, end:Point, color:uint):void
//		{
//			bmd.lock();
//			var dx:int = end.x - start.x;
//			var dy:int = end.y - start.y;
//			
//			var x:int = start.x;
//			var y:int = start.y;
//			
//			var xInc:int;
//			var yInc:int;
//			var i:int;
//			
//			if(dx >=0)
//			{
//				xInc = 1;
//			}else
//			{
//				xInc = -1;
//				dx = -dx;//总共要走多少步
//			}
//			
//			if(dy >= 0)
//			{
//				yInc = 1;
//			}else
//			{
//				yInc = -1;
//				dy = -dy;
//			}
//			
//			//比较值的时候，都是按照第一象限来比较，只不过，步进的时候，按照 xInc, yInc 来步进
//			var k2dx:int = 2*dy;
//			var error2dx:int = k2dx - 1;
//			
//			var k2dy:int = 2*dx;
//			var error2dy:int = k2dy - 1;
//			
//			if(dx >= dy)//近X轴线
//			{
//				for(i = 0; i <= dx ; i++)
//				{
//					bmd.setPixel32(x,y, color);
//					if(error2dx > 0)
//					{
//						y += yInc;
//						error2dx = error2dx + k2dx - 2*dx;
//					}else
//					{
//						error2dx = error2dx + k2dx;
//					}
//					x += xInc;
//				}
//			}else//近Y轴线
//			{
//				for(i = 0; i <= dy ; i++)
//				{
//					bmd.setPixel32(x,y, color);
//					if(error2dy > 0)
//					{
//						x += xInc;
//						error2dy = error2dy + k2dy - 2*dy;
//					}else
//					{
//						error2dy = error2dy + k2dy;
//					}
//					y += yInc;
//				}
//			}
//			
//			bmd.unlock();
//		}
//-------------画线测试 bresenham-----------------------------------------------		
		/*private var bmd:BitmapData = new BitmapData(800,600, false, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var error_factor:Number = 0.5;
		public function LineTest()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addChild(bmp);
			
			draw_help3(new Point(0,300), new Point(800,300), 0xffffff);
			draw_help3(new Point(400,0), new Point(400,600), 0xffffff);
			draw_help3(new Point(400,300), new Point(500,500),0x00ffff);
			draw_help3(new Point(400,300), new Point(500,400),0x00ff00);
			draw_help3(new Point(400,300), new Point(300,500),0xffff00);
			draw_help3(new Point(400,300), new Point(300,400),0x0000ff);
			
			draw_help3(new Point(100,600), new Point(800,10),0xff0000);
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
		}*/
	}
}