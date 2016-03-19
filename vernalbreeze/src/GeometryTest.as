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

	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class GeometryTest extends Sprite
	{
		public function GeometryTest()
		{
			
		}
//---------------多边形填充算法--------------------------------------------------		
//		public function GeometryTest()
//		{
//			
//		}	
//----------------------三角形填充----------------------------------------------
//		private var bmd:BitmapData = new BitmapData(800,600, false, 0);
//		private var bmp:Bitmap = new Bitmap(bmd);
////		private var clip:Rectangle = new Rectangle(120,150,40,30);
//		private var clip:Rectangle = new Rectangle(0,0,800,600);
////		private var clip:Rectangle = new Rectangle(80,0,70,600);
//		public function GeometryTest()
//		{
//			addChild(bmp);
////			flatBottom(new Point(100,200),new Point(50,100),new Point(150,100));
////			flatTop(new Point(50,100), new Point(150,100), new Point(100,0));
////			drawTriangle(new Point(30,200),new Point(50,80),new Point(150,90));
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//		}
//		private var count:int = 0;
//		protected function onEnterFrame(event:Event):void
//		{
//			if(count == 0)
//			{
//				bmd.fillRect(clip,0);
//				count = 10;
//				drawTriangle(new Point(Math.random()*800,300),new Point(Math.random()*800,500),new Point(Math.random()*800,200));
//			}
//			count--;
//		}
//		
//		public function drawTriangle(p1:Point, p2:Point, p3:Point):void
//		{
//			var x1:Number = p1.x, y1:Number = p1.y;
//			var x2:Number = p2.x, y2:Number = p2.y;
//			var x3:Number = p3.x, y3:Number = p3.y;
//			//三点共线 则不能成为三角形
//			if((x1 == x2 &&　x2 == x3) || (y1 == y2 && y2 == y3))
//			{
//				return;
//			}
//			
//			//让点按照 P1 P2 P3 的y值从大到小排序
//			var tempX:Number;
//			var tempY:Number;
//			if(y1 < y2)
//			{
//				tempX = x2;
//				x2 = x1;
//				x1 = tempX;
//				
//				tempY = y2;
//				y2 = y1;
//				y1 = tempY;
//			}
//			
//			if(y1 < y3)
//			{
//				tempX = x3;
//				x3 = x1;
//				x1 = tempX;
//				
//				tempY = y3;
//				y3 = y1;
//				y1 = tempY;
//			}
//			
//			if(y2 < y3)
//			{
//				tempX = x3;
//				x3 = x2;
//				x2 = tempX;
//				
//				tempY = y3;
//				y3 = y2;
//				y2 = tempY;
//			}
//			
//			//如果所有定点都在裁剪区域外则不能绘图
//			if(y3 > clip.bottom || y1 < clip.top || 
//				(x1 < clip.left && x2 < clip.left && x3 < clip.left) ||
//				(x1 > clip.right && x2 > clip.right && x3 > clip.right))
//			{
//				return;
//			}
//			
//			var temp1:Point = new Point(x1, y1);
//			var temp2:Point = new Point(x2, y2);
//			var temp3:Point = new Point(x3, y3);
//			//平顶
//			if(y1 == y2)
//			{
//				flatTop(temp1, temp2, temp3);
//			}else if(y2 == y3)//平底
//			{
//				flatBottom(temp1, temp2, temp3);
//			}else
//			{
//				//要求出 1-3边上的点new_x, 其中 2-new_x 可以将三角性分为平顶三角形和平底三角形
//				//公式画图可得，就是求 当走过 y2-y3 个步长时 ，x3 在 1-3边上 所走的距离
//				var newX:Number = x3 + (y2 - y3)*(x3 -x1)/(y3 - y1);
//				var tempNew:Point = new Point(newX, y2);
//				
//				flatTop(temp2, tempNew, temp3);
//				flatBottom(temp1, tempNew, temp2);
//			}
//		}
//		
//		//画平底即底边比顶点的Y值小
//		public function flatBottom(p1:Point, p2:Point, p3:Point):void
//		{
//			bmd.lock();
//			//指定p1为底点，p2-p3为平底
//			var x1:Number = p1.x, y1:Number = p1.y;
//			var x2:Number = p2.x, y2:Number = p2.y;
//			var x3:Number = p3.x, y3:Number = p3.y;
//			//保证 x2 是左斜边,x3是右斜边
//			if(x2 > x3)
//			{
//				var temp:Number = x2;
//				x2 = x3;
//				x3 = temp;
//			}
//			//计算斜率
//			var dxyLeft:Number = (x2 - x1)/(y2 - y1);//是通过Y的增加来求X的变化率，所以是斜率的倒数
//			var dxyRight:Number = (x3 - x1)/(y3 - y1);
//			
//			var xs:Number = x2;
//			var xe:Number = x3;
//			
//			if(y1 > clip.bottom)
//			{
//				xs = xs + dxyLeft*(-y1 + clip.bottom);//当前的点xs + 走过(-y1 + clip.top)步的变化率,就是需要的xs点
//				xe = xe + dxyRight*(-y1 + clip.bottom);//当前的点xe + 走过(-y1 + clip.top)步的变化率,就是需要的xe点
//				y1 = clip.bottom;
//			}
//			if(y3 < clip.top)
//			{
//				y3 = clip.top;
//			}
//			var y:int;
//			var x:int;
//			//假如x点都在裁剪区域内
//			if(x1 >= clip.left && x1 <= clip.right &&
//				x2 >= clip.left && x2 <= clip.right &&
//				x3 >= clip.left && x3 <= clip.right)
//			{
//				for(y = y3; y <= y1; y++)
//				{
//					//drawLine(new Point(xs, y), new Point(xe, y), 0x00ff00);
//					for(x = xs; x <= xe; x++)
//					{
//						bmd.setPixel32(x, y, 0xffffff*Math.random());
//					}
//					xs += dxyLeft;
//					xe += dxyRight;
//				}
//			}else//加入有x点不在裁剪区域内则每增加一步，就要判断x是否超出clip范围，如果超出则映射到对应的clip边上(当然也可以直接用这个else的所有内容，而不必写这个if-else, 写if-else 主要是为了让if更快)
//			{
//				var left:Number = xs;
//				var right:Number = xe;
//				for(y = y3; y <= y1; y++)
//				{
//					left = xs;
//					right = xe;
//					if(left < clip.left)
//					{
//						left = clip.left;
//						if(right < clip.left)
//						{
//							continue;
//						}
//					}
//					if(right > clip.right)
//					{
//						right = clip.right;
//						if(left > clip.right)
//						{
//							continue;
//						}
//					}
////					drawLine(new Point(left, y), new Point(right, y), 0x00ff00);
//					for(x = left; x <= right; x++)
//					{
//						bmd.setPixel32(x, y, 0xff0000);
//					}
//					xs += dxyLeft;
//					xe += dxyRight;
//				}
//			}
//			bmd.unlock();
//		}
//		
//		//画平顶即底边比顶点的Y值大
//		public function flatTop(p1:Point, p2:Point, p3:Point):void
//		{
//			bmd.lock();
//			//指定p3为底点，p1-p2为平顶
//			var x1:Number = p1.x, y1:Number = p1.y;
//			var x2:Number = p2.x, y2:Number = p2.y;
//			var x3:Number = p3.x, y3:Number = p3.y;
//			//保证 x1 是左斜边,x2是右斜边
//			if(x1 > x2)
//			{
//				var temp:Number = x1;
//				x1 = x2;
//				x2 = temp;
//			}
//			//计算斜率
//			var dxyLeft:Number = (x1 - x3)/(y1 - y3);//是通过Y的增加来求X的变化率，所以是斜率的倒数
//			var dxyRight:Number = (x2 - x3)/(y2 - y3);
//			var xs:Number = x3;//如果xs 或者 xe 是 int 型的话,需要加0.5 除去误差,相当于四舍五入到整点,比如1.8 +0.5 = 2.3 ≈ 2 , 1.2 + 0.5 = 1.7 ≈ 1
//			var xe:Number = x3;
//			
//			if(y3 < clip.top)
//			{
//				xs = xs + dxyLeft*(-y3 + clip.top);
//				xe = xe + dxyRight*(-y3 + clip.top);
//				y3 = clip.top;
//			}
//			
//			if(y1 > clip.bottom)
//			{
//				y1 = clip.bottom;
//			}
//			
//			var y:int;
//			var x:int;
//			//假如x点都在裁剪区域内
//			if(x1 >= clip.left && x1 <= clip.right &&
//				x2 >= clip.left && x2 <= clip.right &&
//				x3 >= clip.left && x3 <= clip.right)
//			{
//				for(y = y3; y <= y1; y++)
//				{
//					for(x = xs; x <= xe; x++)
//					{
//						bmd.setPixel32(x, y, 0xffffff*Math.random());
//					}
//					
//					xs += dxyLeft;
//					xe += dxyRight;
//				}
//			}else
//			{
//				var left:Number = xs;
//				var right:Number = xe;
//				for(y = y3; y <= y1; y++)
//				{
//					left = xs;
//					right = xe;
//					if(left < clip.left)
//					{
//						left = clip.left;
//						if(right < clip.left)
//						{
//							continue;
//						}
//					}
//					if(right > clip.right)
//					{
//						right = clip.right;
//						if(left > clip.right)
//						{
//							continue;
//						}
//					}
//					for(x = left; x <= right; x++)
//					{
//						bmd.setPixel32(x, y, 0xffff00);
//					}
//					
//					xs += dxyLeft;
//					xe += dxyRight;
//				}
//			}
//			bmd.unlock();
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
//---------画多边形测试-------------------------------		
//		private const CLIP_X:uint = 0;
//		private const CLIP_Y:uint = 0;
//		private const CLIP_H:uint = 600;
//		private const CLIP_W:uint = 800;
//		
//		private var bmd:BitmapData = new BitmapData(800,600, false, 0);
//		private var bmp:Bitmap = new Bitmap(bmd);
//		private var clip:Rectangle = new Rectangle(CLIP_X,CLIP_Y,CLIP_W,CLIP_H);
//		private var polygen:Poligen2D = new Poligen2D();
//		private var polygen2:Poligen2D = new Poligen2D();
//		public function GeometryTest()
//		{
//			stage.scaleMode = StageScaleMode.NO_SCALE;	
//			addChild(bmp);
//			
//			polygen.state = 1;
//			polygen.x0 = 100;
//			polygen.y0 = 100;
////			polygen.vlist.push(new Point(0 + CLIP_X,-20 + CLIP_Y), new Point(50+CLIP_X,-20+CLIP_Y), new Point(25+CLIP_X,5+CLIP_Y),
////				new Point(50+CLIP_X,30+CLIP_Y), new Point(-20+CLIP_X,30+CLIP_Y));
//			
//			polygen.vlist.push(new Point(0,0), new Point(50,0), new Point(25,25), new Point(50,50), new Point(0,50));
//			
//			drawPolygen2D(polygen);
//			
//			polygen2.state = 1;
//			polygen2.x0 = 200;
//			polygen2.y0 = 200;
//			
//			polygen2.vlist.push(new Point(0,0), new Point(50,0), new Point(25,25), new Point(50,50), new Point(0,50));
//			
//			drawPolygen2D(polygen2);
//		}
//		
//		private function drawPolygen2D(polygen:Poligen2D):int
//		{
//			var center:Point = new Point(polygen.x0, polygen.y0);
//			if(polygen.state)
//			{
//				var temp1:Point;
//				var temp2:Point;
//				for(var i:int = 0; i < polygen.vlist.length - 1; i++)
//				{
//					temp1 = polygen.vlist[i].add(center);
//					temp2 = polygen.vlist[i+1].add(center);
//					if(clipLine(temp1, temp2, clip))
//					{
//						drawLine(temp1, temp2, 0x00ff00);
//					}
//				}
//				temp1 = polygen.vlist[i].add(center);
//				temp2 = polygen.vlist[0].add(center);
//				if(clipLine(temp1, temp2, clip))
//				{
//					drawLine(temp1, temp2, 0x00ff00);
//				}
//				return 1;
//			}
//			return 0;
//		}
//		
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
//			var k:Number = 0;
//			if(end.x - start.x != 0)
//			{
//				k = (end.y - start.y)/(end.x - start.x);
//			}
//			var krevese:Number = 0;
//			if(end.y - start.y != 0){
//				krevese = (end.x - start.x)/(end.y - start.y);
//			}
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
//			if(yc1 < clipRect.top)
//			{
//				p1Code |= CLIP_CODE_N;
//			}else if(yc1 > clipRect.bottom)
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
//			if(yc2 < clipRect.top)
//			{
//				p2Code |= CLIP_CODE_N;
//			}else if(yc2 > clipRect.bottom)
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