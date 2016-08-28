/***
 * 
 * 任意四边行扭曲
 * 
 * 由于插值方法原因 只能缩小图片扭曲，而不能放大，放大的时候会出现空点，主要是由于缩放时的插值方法没有弄对
 * 
 * 其实不止是四边形
 * 只要知道任意形状都可以用这个思路，思路具体见笔记
 * 
 * ****/

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import graphics.Circle;
	
	import vo.CMatrix;
	import vo.CVector;
	
	[SWF(width="640", height="480", frameRate="30")]
	public class EffectTest extends Sprite
	{
		[Embed(source="assets/2.png")]
		private var Background:Class;
		
		[Embed(source="assets/11.png")]
		private var Arena:Class;
//----------更普遍的扭曲--------------------------------------------------------------		
		private var b:Bitmap = new Background();
		private var empty:Bitmap = new Bitmap(new BitmapData(640, 480,false));
		private var empty2:Bitmap = new Bitmap(new BitmapData(640,480));
		private var vertexs:Vector.<CVector> = new Vector.<CVector>();
		private var c1:Circle = new Circle(0xff00, 10);
		private var c2:Circle = new Circle(0xff00, 10);
		private var c3:Circle = new Circle(0xff00, 10);
		private var c4:Circle = new Circle(0xff00, 10);
		private var isMouseDown:Boolean =false;
		private var target:Object;
		public function EffectTest()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addChild(empty);
//			addChild(empty2);
			// 半梯形
//			vertexs.push(new CVector(160, 0), new CVector(640, 0), new CVector(0, 480), new CVector(640, 480));
//			half_trapezoid();
			
			//梯形
//			vertexs.push(new CVector(160, 100), new CVector(480, 100), new CVector(0, 300), new CVector(640, 300));
//			trapezoid(vertexs, b.bitmapData, empty.bitmapData);
			
			//垂直梯形
//			vertexs.push(new CVector(50, 160), new CVector(480, 100), new CVector(50, 320), new CVector(480, 300));
//			vertical_trapezoid(vertexs, b.bitmapData, empty.bitmapData);
			
			//激动人心的时刻 两步法
			//任意四边形
//			vertexs.push(new CVector(320, 160), new CVector(480, 240), new CVector(160, 320), new CVector(640, 480));
//			random_quadrangle_two(vertexs, b.bitmapData, empty.bitmapData);//这个变形出来的图形与预料的会有很大不符合
			
			//网上的扭曲算法
			//国外用了什么几何算法求比例, 什么breshmen算法划线, 都比不上国内大大的算法厉害啊！！
			//请收下我的膝盖！！
			//其实是一种梯形算法的改进
			//
			// 第一, 算出左右两边的斜率, 这样就能知道每行怎么步进了
			//第二, 根据每行左右两边的点, 可以算出这行的斜率, 这样我只要知道原图中每一行, 怎么映射到一个斜线行就行了
			//一行直线怎么映射到一段斜线上也很简单
			//分成xy两个份量来求, y值改变了多少求比率, x改变了多少求比率
//			vertexs.push(new CVector(320, 160), new CVector(480, 240), new CVector(160, 320), new CVector(640, 480));
//			random_quadrangle(vertexs, b.bitmapData, empty.bitmapData);
			
			//控制4个点
			addChild(c1);
			addChild(c2);
			addChild(c3);
			addChild(c4);
			vertexs.push(new CVector(0, 0), new CVector(640, 0), new CVector(0, 480), new CVector(640, 480));
			c1.x = vertexs[0].x;
			c1.y = vertexs[0].y;
			c2.x = vertexs[1].x;
			c2.y = vertexs[1].y;
			c3.x = vertexs[2].x;
			c3.y = vertexs[2].y;
			c4.x = vertexs[3].x;
			c4.y = vertexs[3].y;
			random_quadrangle(vertexs, b.bitmapData, empty.bitmapData);
			
			c1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			c2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			c3.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			c4.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
//			c1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			c2.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			c3.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			c4.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
//			c1.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			c2.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			c3.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			c4.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(target == null) return;
			target.x = stage.mouseX;
			target.y = stage.mouseY;
			
			switch(target)
			{
				case c1:
					vertexs[0].reset(stage.mouseX, stage.mouseY);
					break;
				case c2:
					vertexs[1].reset(stage.mouseX, stage.mouseY);
					break;
				case c3:
					vertexs[2].reset(stage.mouseX, stage.mouseY);
					break;
				case c4:
					vertexs[3].reset(stage.mouseX, stage.mouseY);
					break;
			}
			empty.bitmapData.fillRect(empty.bitmapData.rect, 0);
			random_quadrangle(vertexs, b.bitmapData, empty.bitmapData);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			isMouseDown = false;
			target = null;
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if(isMouseDown){
				switch(event.target)
				{
					case c1:
						vertexs[0].reset(stage.mouseX, stage.mouseY);
						break;
					case c2:
						vertexs[1].reset(stage.mouseX, stage.mouseY);
						break;
					case c3:
						vertexs[2].reset(stage.mouseX, stage.mouseY);
						break;
					case c4:
						vertexs[3].reset(stage.mouseX, stage.mouseY);
						break;
				}
				empty.bitmapData.fillRect(empty.bitmapData.rect, 0);
				random_quadrangle(vertexs, b.bitmapData, empty.bitmapData);
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			isMouseDown = true;
			target = event.target;
		}
		
		private function random_quadrangle(vertexs:Vector.<CVector>,source:BitmapData, dest:BitmapData):void
		{
			//偏移量
			var offsetLeftX:Number, offsetLeftY:Number;
			var offsetRightX:Number, offsetRightY:Number;	
			var leftPointX:Number, leftPointY:Number;
			var rightPointX:Number, rightPointY:Number;
			
			offsetLeftX = (vertexs[2].x - vertexs[0].x)/480; //平均每行左边X要走多少步
			offsetLeftY = (vertexs[2].y - vertexs[0].y)/480; //平均每行左边Y要走多少步
			offsetRightX = (vertexs[3].x - vertexs[1].x)/480;//平均每行右边X要走多少步
			offsetRightY = (vertexs[3].y - vertexs[1].y)/480;//平均每行右边X要走多少步
			
			leftPointX = vertexs[0].x;
			leftPointY = vertexs[0].y;
			rightPointX = vertexs[1].x;
			rightPointY = vertexs[1].y;
			
			//当前斜线段的X,Y的比例
			var hDX:Number, hDY:Number;
			
			//颜色分量, 要放的点
			var color:uint;
			var tx:Number, ty:Number;
			for(var i:int = 0; i < 480; i++)
			{
				hDX = (rightPointX - leftPointX) / 640;
				hDY = (rightPointY - leftPointY) / 640;
				
				tx = leftPointX;
				ty = leftPointY;
				for(var j:int = 0; j < 640; j++)
				{
					color = source.getPixel32(j, i);
					dest.setPixel32(int(tx), int(ty), color);
					tx += hDX;
					ty += hDY;
				}
				
				leftPointX += offsetLeftX;
				leftPointY += offsetLeftY;
				rightPointX += offsetRightX;
				rightPointY += offsetRightY;
			}
		}
		
		//任意四边形 二步法
		//任意四边形,可以放两步来计算
		//平行梯形和垂直梯形
		private function random_quadrangle_two(vertexs:Vector.<CVector>,source:BitmapData, dest:BitmapData):void
		{
			
			var tempVertexs:Vector.<CVector> = new Vector.<CVector>();
			for(var i:int = 0; i < vertexs.length; ++i)
			{
				tempVertexs[i] = vertexs[i];
			}
			
			//先把四边形转化为平行梯形
			//求四条边的斜率(按从上往下, 从左往右走)
			var temp1:CVector = vertexs[2].minusNew(vertexs[0]);
			var temp2:CVector = vertexs[3].minusNew(vertexs[1]);
			var temp3:CVector = vertexs[1].minusNew(vertexs[0]);
			var temp4:CVector = vertexs[3].minusNew(vertexs[2]);
			
			var tempVec:CVector;
			var tempX:Number, tempY:Number;
			//平行梯形
			//上边延长线的与四边矩形的交点
			//这里是知道Y求X坐标 所以注意斜率的计算
			if(vertexs[0].y > vertexs[1].y)
			{
				//左边需要延长
				//将点2做为原点, 计算点 0 到点2的直线
				//这里需要推导一下,或者看笔记
				tempX = temp1.x / temp1.y * (vertexs[1].y - vertexs[0].y);
				tempX += vertexs[0].x;//转化为世界坐标系
				tempVec = new CVector(tempX, vertexs[1].y);
				tempVertexs[0] = tempVec;
			}else{
				//右边需要延长
				tempX = temp2.x / temp2.y * (vertexs[0].y - vertexs[1].y);
				tempX += vertexs[1].x;//转化为世界坐标系
				tempVec = new CVector(tempX, vertexs[0].y);
				tempVertexs[1] = tempVec;
			}
			
			//下边延长线的与四边矩形的交点
			if(vertexs[2].y > vertexs[3].y)
			{
				//右边需要延长
				tempX =  -temp2.x / -temp2.y * (vertexs[2].y - vertexs[3].y); 
				tempX += vertexs[3].x;//转化为世界坐标系
				tempVec = new CVector(tempX, vertexs[2].y);
				tempVertexs[3] = tempVec;
			}else{
				//左边需要延长
				tempX = -temp1.x / -temp1.y * (vertexs[3].y - vertexs[2].y);
				tempX += vertexs[2].x;//转化为世界坐标系
				tempVec = new CVector(tempX, vertexs[3].y);
				tempVertexs[2] = tempVec;
			}
			trapezoid(tempVertexs, source, dest);
			
			//垂直梯形
			//要将已经平行梯形化的图像做为输入, 但是顶点还是原图的顶点
			for(var i:int = 0; i < vertexs.length; ++i)
			{
				tempVertexs[i] = vertexs[i];
			}
			if(vertexs[0].x > vertexs[2].x)
			{
				//上边向左延长
				tempY = temp3.y / temp3.x *(vertexs[2].x - vertexs[0].x);
				tempY += vertexs[0].y;
				tempVec = new CVector(vertexs[2].x, tempY);
				tempVertexs[0] = tempVec;
			}else{
				//下边向左延长
				tempY = temp4.y / temp4.x *(vertexs[0].x - vertexs[2].x);
				tempY += vertexs[2].y;
				tempVec = new CVector(vertexs[0].x, tempY);
				tempVertexs[2] = tempVec;
			}
			
			if(vertexs[1].x > vertexs[3].x)
			{
				//下边向右延长
				tempY = -temp4.y / -temp4.x *(vertexs[1].x - vertexs[3].x);
				tempY += vertexs[3].y;
				tempVec = new CVector(vertexs[1].x, tempY);
				tempVertexs[3] = tempVec;
			}else{
				//上边向右延长
				tempY = -temp3.y / -temp3.x *(vertexs[3].x - vertexs[1].x);
				tempY += vertexs[1].y;
				tempVec = new CVector(vertexs[3].x, tempY);
				tempVertexs[1] = tempVec;
			}
//			vertical_trapezoid(tempVertexs, source, dest);
			vertical_trapezoid(tempVertexs, empty.bitmapData, empty2.bitmapData);
		}
		
		//    垂直梯形
		//   感觉萌萌哒
		//
		//   0  1
		//      .    
		//	   ..	
		//	  ...
		//	 .... 
		//	 ....
		//	 ....
		//	  ...  
		//	   ..	
		//      .
		//   2  3
		private function vertical_trapezoid(vertexs:Vector.<CVector>, source:BitmapData, dest:BitmapData):void
		{
			//整个梯形就需要算两个斜率, 上边和下边的
			var temp1:CVector = vertexs[1].minusNew(vertexs[0]);
			var temp2:CVector = vertexs[3].minusNew(vertexs[2]);
			//计算斜率
			var slop1:Number = temp1.y / temp1.x;//因为这里是要计算每走一步y,x变化多少
			var slop2:Number = temp2.y / temp2.x;
			//每行偏移量
			var offsetY0:Number = vertexs[0].y;//左端点
			var offsetY1:Number = vertexs[2].y;//右端点
			var offsetX:Number = vertexs[0].x;
			//每行的长度
			var len:Number = offsetY1 - offsetY0;
			//向量比例, 用来插值用
			var ratio:Number = len / 480;
			var ratioX:Number = (vertexs[1].x - vertexs[0].x)/640;
			//描点
			var x:int, y:int, tempX:int;
			var color:uint;
			for(var i:int = 0; i < 640; ++i)
			{
				tempX = x;
				for(var j:int = 0; j < 480; ++j)
				{
					x = offsetX + ratioX * i;
					y = offsetY0 + ratio * j;
					color = source.getPixel32(i, j);
					dest.setPixel32(x, y, color);
				}
				if(x - tempX >= 1){
					offsetY0 += slop1;
					offsetY1 += slop2;
					len = offsetY1 - offsetY0;
					ratio = len / 480;
				}
			}
		}	
		
		
		//          梯形
		//        感觉萌萌哒
		//
		//       0       1
		//       .........
		//		...........
		//	   .............
		//	  ...............
		//	 .................
		//   2               3
		private function trapezoid(vertexs:Vector.<CVector>, source:BitmapData, dest:BitmapData):void
		{
			//整个梯形就需要算两个斜率, 左边和右边的
			var temp1:CVector = vertexs[2].minusNew(vertexs[0]);
			var temp2:CVector = vertexs[3].minusNew(vertexs[1]);
			//计算斜率
			var slop1:Number = temp1.x / temp1.y;//因为这里是要计算每走一步y,x变化多少
			var slop2:Number = temp2.x / temp2.y;
			//每行偏移量
			var offsetX0:Number = vertexs[0].x;//左端点
			var offsetX1:Number = vertexs[1].x;//右端点
			var offsetY:Number = vertexs[0].y;
			//每行的长度
			var len:Number = offsetX1 - offsetX0;
			//向量比例, 用来插值用
			var ratio:Number = len / 640;
			var ratioY:Number = (vertexs[2].y - vertexs[0].y) / 480;
			//描点
			var x:int, y:int, tempY:int;
			var color:uint;
			for(var i:int = 0; i < 480; ++i)
			{
				tempY = y;
				for(var j:int = 0; j < 640; ++j)
				{
					x = offsetX0 + ratio * j;
					y = offsetY + ratioY * i;
					color = source.getPixel32(j, i);
					dest.setPixel32(x, y, color);
				}
				//y每走一步X的变化量 而不是i
				if(y - tempY >= 1){
					offsetX0 += slop1;
					offsetX1 += slop2;
					len = offsetX1 - offsetX0;
					ratio = len / 640;
				}
			}
		}			
		
		
		//         半梯形
		//        感觉萌萌哒
		//
		//       0       1
		//       .........
		//		..........
		//	   ...........
		//	  ............
		//	 .............
		//   2           3
		private function half_trapezoid():void
		{
			//把原点移动到图像第一个行偏移点的X轴的位置, 然后计算出图像最后一行
			//求扭曲图像的以左上角为坐标原点的时候, 左下角的坐标
			var temp:CVector = vertexs[2].minusNew(vertexs[0]);
			//计算斜率
			var slop:Number = 1/temp.slop();//因为这里是要计算每走一步y,x变化多少
			//每行偏移量
			var offsetX:Number = vertexs[0].x;
			//每行的长度
			var len:Number = 640 - offsetX;
			//向量比例, 用来插值用
			var ratio:Number = len / 640;
			//描点
			var x:int, y:int;
			var color:uint;
			for(var i:int = 0; i < 480; ++i)
			{
				for(var j:int = 0; j < 640; ++j)
				{
					x = offsetX + ratio * j;
					y = i;
					color = b.bitmapData.getPixel32(j, i);
					empty.bitmapData.setPixel32(x, y, color);
				}
				offsetX += slop;
				len = 640 - offsetX;
				ratio = len / 640;
			}
		}	
//---------------------扭曲-------------------------------------------------		
//		private var b:Bitmap = new Background();
//		private var empty:Bitmap = new Bitmap(new BitmapData(640, 480));
//		public function EffectTest()
//		{
//			super();
//			addChild(empty);
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			
//			var m:CMatrix = new CMatrix(2,2);
//			m.fillMatrix([0.5, 0, 0, 1]);
//			var m2:CMatrix = new CMatrix(2,2);
//			m2.fillMatrix([1.5, 0, 0, 1]);
//			
//			for(var i:int = 0; i < 640; ++i)
//			{
//				for(var j:int = 0; j < 480; ++j)
//				{
//					var v:CVector = new CVector(i, j);
//					var x:int = 0;
//					var y:int = 0;
//					if(i < 320){
//						v = MatrixMultiVector(v, m2);
//						x = v.x;
//						y = v.y;
//					}else{
//						v = new CVector(i - 320, j);
//						v = MatrixMultiVector(v, m);
//						x = v.x + 480;
//						y = v.y;
//					}
//					var color:uint = b.bitmapData.getPixel32(x, y);
//					empty.bitmapData.setPixel32(i, j, color);
//				}
//			}
//		}
//		
//		//改变UV矩阵
//		private function MatrixMultiVector(v:CVector, m:CMatrix):CVector
//		{
//			var e0:Number = v.x * m.getElement(0,0) + v.y * m.getElement(1,0);
//			var e1:Number = v.x * m.getElement(0,1) + v.y * m.getElement(1,1);
//			return new CVector(e0, e1);
//		}
//------------------纵深--------------------------------------------------------------
//		private var s:Bitmap = new Arena();
//		private var empty:Bitmap = new Bitmap(new BitmapData(640, 480));
//		private const PIC_UP_WIDTH:int = 960;
//		private const PIC_DOWN_WIDTH:int = 1920;
//		public function EffectTest()
//		{
//			super();
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			addChild(empty);
//			//计算斜率
//			var slope:Number = (PIC_DOWN_WIDTH - PIC_UP_WIDTH)*0.5/480;
//			//从下往上走
//			var offset:int = slope;
//			for(var j:int = 480; j >= 0; j--)
//			{
//				//j每走一步x就要前进一个斜率的步长
//				offset = Math.floor(slope*(480 - j));
//				empty.bitmapData.copyPixels(s.bitmapData, new Rectangle(offset, j, 640, 1),new Point(0, j));	
//			}
//		}
//------------------波浪---------------------------------------------------------------
//		private var b:Bitmap = new Background();
//		private const swing:int = 40;
//		private const W:int = 20;
//		private var empty:Bitmap = new Bitmap(new BitmapData(640 + swing, 480));
//		public function EffectTest()
//		{
//			super();
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			
//			addChild(empty);
//			
//			//图片倾斜
////			var offset:int = 0;
////			for(var i:int = 0; i <= 480; i++)
////			{
////				offset = i;
////				empty.bitmapData.copyPixels(b.bitmapData, new Rectangle(0, i, 640, 1),new Point(offset, i));
////			}
//			
//			//图片波浪
////			for(var j:int = 0; j <= 480; j++)
////			{
////				var i:int = Math.floor(swing*Math.sin(j/W));
////				empty.bitmapData.copyPixels(b.bitmapData, new Rectangle(0, j, 640, 1),new Point(i, j));
////			}
//			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
//		}
//		
//		private var t:Number = 0;
//		protected function onEnterframe(event:Event):void
//		{
//			empty.bitmapData.fillRect(empty.bitmapData.rect, 0);
//			for(var j:int = 0; j <= 480; j++)
//			{
//				var i:int = Math.floor(swing*Math.sin(j/W + t));
//				empty.bitmapData.copyPixels(b.bitmapData, new Rectangle(0, j, 640, 1),new Point(i, j));
//			}
//			t+=0.3;
//		}
	}
}






























