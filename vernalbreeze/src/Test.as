package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.ui.Keyboard;
	
	import org.ares.vernalbreeze.VBMathUtil;
	import org.ares.vernalbreeze.VBVector;
	
	import test.collision.VBAABB;
	import test.collision.VBOBB;
	import test.collision.VBRim;
	import test.shape.DrawUtil;
	
	[SWF(frameRate="60", backgroundColor="0",height="400",width="550")]
	public class Test extends Sprite
	{
		//测试OBB
		private var cur:VBVector;
		private var convexVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var orgVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var sp:Sprite = new Sprite();
		private var sp2:Sprite = new Sprite();
		public function Test()
		{
			convexVexs.push(new VBVector(0,0), new VBVector(100,0), new VBVector(100,100), new VBVector(0,100));
			addChild(sp);
			addChild(sp2);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.SPACE:
					VBMathUtil.convexVolume(orgVexs,convexVexs);
					for(var i:int = 0; i < convexVexs.length; i++)
					{
						var next:int = i+1;
						if(next >= convexVexs.length)
						{
							next = 0;
						}
						DrawUtil.drawLine(sp.graphics, convexVexs[i],convexVexs[next]);
					}
					
					var testOBB:VBOBB = new VBOBB();
					rotatingRectangle(testOBB);
					trace("d");
					break;
				case Keyboard.DOWN://清除点
					convexVexs.length = 0;
					orgVexs.length = 0;
					this.graphics.clear();
					sp.graphics.clear();
					sp2.graphics.clear();
					break;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var temp:VBVector = new VBVector(stage.mouseX, stage.mouseY);
			orgVexs.push(temp);
			DrawUtil.drawRim(this.graphics,temp); 
		}
		
		private function cmp(v1:VBVector, v2:VBVector):Number
		{
			
			var v1c:VBVector = v1.minus(cur);
			var v2c:VBVector = v2.minus(cur);
			
			var v1v2:Number = v1c.vectorMult(v2c);
			//角的转向
			if(v1v2 < 0)
			{
				return 1;
			}else if(v1v2 == 0)
			{
				var v1len:Number = v1.distance(cur);
				var v2len:Number = v2.distance(cur);
				if(v1len > v2len)
				{
					return 1;
				}
			}
			
			return -1;
		}
		
		//排序极角
		private function stepOne():void
		{
			//先找Y值最小，X值最小的点
			for(var i:int = 0; i < orgVexs.length; i++)
			{
				if(orgVexs[i].y < cur.y)
				{
					cur = orgVexs[i];//找最低点
				}else if(orgVexs[i].y == cur.y)
				{
					if(orgVexs[i].x < cur.x)
					{
						cur = orgVexs[i];//找最左点
					}
				}
			}
			orgVexs.sort(cmp);
		}
		
		//计算凸点
		private function stepTow():void
		{
			//将头三个点先加入凸体
			for(var i:int = 0; i < 3; i++)
			{
				convexVexs.push(orgVexs[i]);
			}
			var index:int;
			while( i <= orgVexs.length)
			{
				index = convexVexs.length - 1;
				//当前点
				var cur:VBVector
				if(i == orgVexs.length)//计算最后一个点需要包含第一个点
				{
					cur = orgVexs[0];
				}else
				{
					cur = orgVexs[i];
				}
				//上一个点
				var pre:VBVector = convexVexs[index];
				//上上一点
				var prepre:VBVector = convexVexs[index - 1];
				//计算角的转向
				var ppp:VBVector = prepre.minus(pre);
				var cp:VBVector = cur.minus(prepre);
				
				var PC:Number = ppp.vectorMult(cp);
				//P在C的逆时针方向
				if(PC > 0)
				{
					convexVexs.pop();
				}else{//P在C的顺时针方向
					
					if(i != orgVexs.length)
					{
						convexVexs.push(cur);
					}
					i++;
				}
			}
		}
		
		//OBB 的中心，X轴和Y轴
		private function rotatingRectangle(obb:VBOBB):Number
		{
			var minArea:Number = Number.MAX_VALUE;
			//循环计算每条边
			for(var i:int = 0, j:int = convexVexs.length - 1; i < convexVexs.length; j = i, i++)
			{
				//计算e0轴 及 i-j轴作为的X轴和Y轴，此时 convexVexs[j] 点为坐标原点
				var e0:VBVector = convexVexs[i].minus(convexVexs[j]);
				//标准化
				e0.normalizeEquals();
				//计算e0的正交轴 e1作为Y轴,正交轴满足点积为0，此时 e1 已经是标准化向量（参考标准化公式） 
				var e1:VBVector = new VBVector(-e0.y, e0.x);
				
				//包围矩形的4个顶点
				var mine0:Number = 0, maxe0:Number = 0, mine1:Number = 0, maxe1:Number = 0;
				//计算每个点在 e0, e1 上的投影，找到矩形对应的4个顶点
				for(var k:int = 0; k < convexVexs.length; k++)
				{
					//计算每个点相对于  j 点的位置算出在 e0-e1 坐标系下该点的坐标（即转换了坐标系 e0-e1）
					var d:VBVector = convexVexs[k].minus(convexVexs[j]);
					//算出点在 e0 轴上的投影, 即 k 点 对于 e0 标准化向量的点积
					var dot:Number = d.scalarMult(e0);
					//找出在 e0 轴上最大, 最小点
					if(dot > maxe0)
					{
						maxe0 = dot;
					}else if(dot < mine0)
					{
						mine0 = dot;
					}
					
					//算出点在 e1 轴上的投影，即 k 点对于 e1 标准化向量的点积
					dot = d.scalarMult(e1);
					//找出在 e1 轴上的最大, 最小点
					if(dot > maxe1)
					{
						maxe1 = dot;
					}else if(dot < mine1)
					{
						mine1 = dot;
					}
				}
				//算出面积
				var area:Number = (maxe0 - mine0)*(maxe1 - mine1);
				if(area < minArea)
				{
					minArea = area;
					//中心点的算法
					//1.先对于 e0-e1 坐标系，则是 X 坐标是 ，e0 上 min+max 的一半，同理  Y 坐标是 e1 上 min+max 的一半
					//2.然后对于世界坐标系，则在加上 j 点的坐标，因为 j 点是原点
					var tempx:VBVector = e0.mult((mine0 + maxe0)).mult(0.5);
					var tempy:VBVector = e1.mult((mine1 + maxe1)).mult(0.5);
					obb.center = convexVexs[j].plus(tempx.plus(tempy));
					obb.x = e0;
					obb.y = e1;
					trace(minArea);
				}
			}
			return minArea;
		}
//-----------------------------------------------------------------------------		
		//OBB初步代码
		/*private var convexVexs:Vector.<VBVector> = new Vector.<VBVector>();
		public function Test()
		{
			
		}
		//旋转矩形,时间复杂度为 O(n2)
		//另外旋转卡尺算法 rotating Calipers，可以将时间复杂度降低到 O(nlogn)
		private function rotatingRectangle():Object
		{
			var minArea:Number = Number.MAX_VALUE;
			//循环计算每条边
			for(var i:int = 0, j:int = convexVexs.length - 1; i < convexVexs.length; j = i, i++)
			{
				//计算e0轴 及 i-j轴作为的X轴和Y轴，此时 convexVexs[j] 点为坐标原点
				var e0:VBVector = convexVexs[i].minus(convexVexs[j]);
				//标准化
				e0.normalizeEquals();
				//计算e0的正交轴 e1作为Y轴，此时 e1 已经是标准化向量（参考标准化公式） 
				var e1:VBVector = new VBVector(-e0.y, e0.x);
				
				//包围矩形的4个顶点
				var mine0:Number = 0, maxe0:Number = 0, mine1:Number = 0, maxe1:Number = 0;
				//计算每个点在 e0, e1 上的投影，找到矩形对应的4个顶点
				for(var k:int = 0; k < convexVexs.length; k++)
				{
					//计算每个点相对于  j 点的位置算出在 e0-e1 坐标系下该点的坐标（即转换了坐标系 e0-e1）
					var d:VBVector = convexVexs[k].minus(convexVexs[j]);
					//算出点在 e0 轴上的投影, 即 k 点 对于 e0 标准化向量的点积
					var dot:Number = d.scalarMult(e0);
					//找出在 e0 轴上最大, 最小点
					if(dot > maxe0)
					{
						maxe0 = dot;
					}else if(dot < mine0)
					{
						mine0 = dot;
					}
					
					//算出点在 e1 轴上的投影，即 k 点对于 e1 标准化向量的点积
					dot = d.scalarMult(e1);
					//找出在 e1 轴上的最大, 最小点
					if(dot > maxe1)
					{
						maxe1 = dot;
					}else if(dot < mine1)
					{
						mine1 = dot;
					}
				}
			}
			//TODO 
			//这里可以缓存最小面积，避免重复计算
			//----------
			//接着返回4个顶点
			var obj:Object = new Object();
			obj.one = mine0;
			obj.two = maxe0;
			obj.three = maxe1;
			obj.four = mine1;
			
			return obj;
		}*/
//-----------------------------------------------------------------------------	
		
		//判断角度左拐还是右拐
		/*private var a:VBVector = new VBVector();
		private var b:VBVector = new VBVector();
		private var c:VBVector = new VBVector();
		public function Test()
		{
			a.x = 100; a.y = 100;
			b.x = 100; b.y = -100;
			c.x = 200; c.y = 200;
			
			var AC:VBVector = a.minus(c);
			var BC:VBVector = b.minus(c);
			
			var AB:Number = AC.vectorMult(BC);
			trace(AB);
		}*/
//-----------------------------------------------------------------------------		
		
		//计算凸体 Graham算法（完整版）
		/*private var cur:VBVector;
		private var convexVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var orgVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var sp:Sprite = new Sprite();
		public function Test()
		{
			addChild(sp);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.SPACE:
					VBMathUtil.convexVolume(orgVexs,convexVexs);
					for(var i:int = 0; i < convexVexs.length; i++)
					{
						var next:int = i+1;
						if(next >= convexVexs.length)
						{
							next = 0;
						}
						DrawUtil.drawLine(this.graphics, convexVexs[i],convexVexs[next]);
					}
					break;
				case Keyboard.LEFT://逐步计算头部
					if(orgVexs.length < 3) return;
					cur = orgVexs[0];
					stepOne();
					//将头三个点先加入凸体
					for(k = 0; k < 3; k++)
					{
						convexVexs.push(orgVexs[k]);
					}
					DrawUtil.drawLine(this.graphics, convexVexs[0], convexVexs[1]);
					this.graphics.lineTo(convexVexs[2].x, convexVexs[2].y);
					break;
				case Keyboard.RIGHT://开始逐步
					stepTest();
					sp.graphics.clear();
					for(var i:int = 0; i < convexVexs.length; i++)
					{
						var next:int = i+1;
						if(next >= convexVexs.length)
						{
							next = 0;
						}
						DrawUtil.drawLine(sp.graphics, convexVexs[i],convexVexs[next]);
					}
					break;
				case Keyboard.UP://绘制点
					//如果少于三个点，则无法计算
					if(orgVexs.length < 3) return;
					cur = orgVexs[0];
					stepOne();
					stepTow();
					for(var i:int = 0; i < convexVexs.length; i++)
					{
						var next:int = i+1;
						if(next >= convexVexs.length)
						{
							next = 0;
						}
						DrawUtil.drawLine(this.graphics, convexVexs[i],convexVexs[next]);
					}
					break;
				case Keyboard.DOWN://清除点
					convexVexs.length = 0;
					orgVexs.length = 0;
					this.graphics.clear();
					sp.graphics.clear();
					break;
			}
		}
		private var k:int;
		private function stepTest():void
		{
			var index:int;
			if( k <= orgVexs.length)
			{
				index = convexVexs.length - 1;
				//当前点
				var cur:VBVector
				if(k == orgVexs.length)//计算最后一个点需要包含第一个点
				{
					cur = orgVexs[0];
				}else
				{
					cur = orgVexs[k];
				}
				//上一个点
				var pre:VBVector = convexVexs[index];
				//上上一点
				var prepre:VBVector = convexVexs[index - 1];
				//计算角的转向
				var ppp:VBVector = prepre.minus(pre);
				var cp:VBVector = cur.minus(prepre);
				
				var PC:Number = ppp.vectorMult(cp);
				//角的转向
				if(PC > 0)
				{
					convexVexs.pop();
				}else{//P在C的顺时针方向
					
					if(k != orgVexs.length)
					{
						convexVexs.push(cur);
					}
					k++;
				}
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var temp:VBVector = new VBVector(stage.mouseX, stage.mouseY);
			orgVexs.push(temp);
			DrawUtil.drawRim(this.graphics,temp); 
		}
		
		private function cmp(v1:VBVector, v2:VBVector):Number
		{
			
			var v1c:VBVector = v1.minus(cur);
			var v2c:VBVector = v2.minus(cur);
			
			var v1v2:Number = v1c.vectorMult(v2c);
//			//假如v1c是cur点
//			if(v1c.magnitude() == 0)
//			{
//				return -1;
//			}else if(v2c.magnitude() == 0)//假如v2c是cur点
//			{
//				return 1;
//			}
			//角的转向
			if(v1v2 < 0)
			{
				return 1;
			}else if(v1v2 == 0)
			{
				var v1len:Number = v1.distance(cur);
				var v2len:Number = v2.distance(cur);
				if(v1len > v2len)
				{
					return 1;
				}
			}
			
			return -1;
		}
		
		//排序极角
		private function stepOne():void
		{
			//先找Y值最小，X值最小的点
			for(var i:int = 0; i < orgVexs.length; i++)
			{
				if(orgVexs[i].y < cur.y)
				{
					cur = orgVexs[i];//找最低点
				}else if(orgVexs[i].y == cur.y)
				{
					if(orgVexs[i].x < cur.x)
					{
						cur = orgVexs[i];//找最左点
					}
				}
			}
			orgVexs.sort(cmp);
		}
		
		//计算凸点
		private function stepTow():void
		{
			//将头三个点先加入凸体
			for(var i:int = 0; i < 3; i++)
			{
				convexVexs.push(orgVexs[i]);
			}
			var index:int;
			while( i <= orgVexs.length)
			{
				index = convexVexs.length - 1;
				//当前点
				var cur:VBVector
				if(i == orgVexs.length)//计算最后一个点需要包含第一个点
				{
					cur = orgVexs[0];
				}else
				{
					cur = orgVexs[i];
				}
				//上一个点
				var pre:VBVector = convexVexs[index];
				//上上一点
				var prepre:VBVector = convexVexs[index - 1];
				//计算角的转向
				var ppp:VBVector = prepre.minus(pre);
				var cp:VBVector = cur.minus(prepre);
				
				var PC:Number = ppp.vectorMult(cp);
				//P在C的逆时针方向
				if(PC > 0)
				{
					convexVexs.pop();
				}else{//P在C的顺时针方向
					
					if(i != orgVexs.length)
					{
						convexVexs.push(cur);
					}
					i++;
				}
			}
		}*/
		
//-----------------------------------------------------------------------------		
		//计算凸体 Graham算法 （这个版本有问题，看上面的算法）
		/*private var cur:VBVector;
		private var convexVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var orgVexs:Vector.<VBVector> = new Vector.<VBVector>();
		public function Test()
		{
			this.graphics.lineStyle(1,0xff0000);
			
			var v1:VBVector = new VBVector(100,100);
			var v2:VBVector = new VBVector(50,60);
			var v3:VBVector = new VBVector(20,150);
			var v4:VBVector = new VBVector(100,30);
			var v5:VBVector = new VBVector(70,90);
			var v6:VBVector = new VBVector(80,80);
			
			drawDot(v1);
			drawDot(v2);
			drawDot(v3);
			drawDot(v4);
			drawDot(v5);
			drawDot(v6);
			
			orgVexs.push(v1,v2,v3,v4,v5,v6);
			//如果少于三个点，则无法计算
			if(orgVexs.length < 3) return;
			cur = orgVexs[0];
			stepOne();
			stepTow();
			
			for(var i:int = 0; i < convexVexs.length; i++)
			{
				var next:int = i+1;
				if(next >= convexVexs.length)
				{
					next = 0;
				}
				drawLine(convexVexs[i],convexVexs[next]);
			}
		}

		private function drawDot(v:VBVector):void
		{
			this.graphics.lineStyle(1,0xff0000);
			this.graphics.drawCircle(v.x,v.y,5);
		}
		
		private function drawLine(v1:VBVector, v2:VBVector):void
		{
			this.graphics.lineStyle(1,0x00ff00);
			this.graphics.moveTo(v1.x, v1.y);
			this.graphics.lineTo(v2.x, v2.y);
		}
		
		private function cmp(v1:VBVector, v2:VBVector):Boolean
		{

			var v1c:VBVector = v1.minus(cur);
			var v2c:VBVector = v2.minus(cur);
			
			var v1v2:Number = v1c.vectorMult(v2c);
			//角的转向
			if(v1v2 < 0)
			{
				return true;
			}else if(v1v2 == 0)
			{
				var v1len:Number = v1c.distance(cur);
				var v2len:Number = v2c.distance(cur);
				return v1len > v2len;
			}

			return false;
		}

		//排序极角
		private function stepOne():void
		{
			//先找Y值最小，X值最小的点
			
			for(var i:int = 0; i < orgVexs.length; i++)
			{
				if(orgVexs[i].y < cur.y)
				{
					cur = orgVexs[i];//找最低点
				}else if(orgVexs[i].y == cur.y)
				{
					if(orgVexs[i].x < cur.x)
					{
						cur = orgVexs[i];//找最左点
					}
				}
			}
			orgVexs.sort(cmp);
//			//极角排序
//			for(i = 0; i < orgVexs.length; i++)
//			{
//				if(orgVexs[i] == cur)
//				{
//					continue;
//				}
//				var temp:VBVector = orgVexs[i].minus(cur);
//				var angle:Number = Math.atan2(temp.y, temp.x);
//			}
		}
		
		//计算凸点
		private function stepTow():void
		{
			
			//将头三个点先加入凸体
			for(var i:int = 0; i < 3; i++)
			{
				convexVexs.push(orgVexs[i]);
			}
			var index:int;
			while( i <= orgVexs.length)
			{
				index = convexVexs.length - 1;
				//当前点
				var cur:VBVector
				if(i == orgVexs.length)//计算最后一个点需要包含第一个点
				{
					cur = orgVexs[0];
				}else
				{
					cur = orgVexs[i];
				}
				//上一个点
				var pre:VBVector = convexVexs[index];
				//上上一点
				var prepre:VBVector = convexVexs[index - 1];
				//计算角的转向
				var ppp:VBVector = prepre.minus(pre);
				var cp:VBVector = cur.minus(pre);
				
				var PC:Number = ppp.vectorMult(cp);
				//角的转向
				if(PC < 0)
				{
					convexVexs.pop();
				}
				if(i != orgVexs.length)
				{
					convexVexs.push(cur);
				}
				i++;
			}
			
//			if(i == orgVexs.length)
//			{
//				index = convexVexs.length - 1;
//				//当前点
//				var cur:VBVector = orgVexs[0];
//				//上一个点
//				var pre:VBVector = convexVexs[index];
//				//上上一点
//				var prepre:VBVector = orgVexs[index - 1];
//				//计算角的转向
//				var ppp:VBVector = prepre.minus(pre);
//				var cp:VBVector = cur.minus(pre);
//				
//				var PC:Number = ppp.vectorMult(cp);
//				//角的转向
//				if(PC < 0)
//				{
//					convexVexs.pop();
//				}
//			}
		}*/
//-------------------------------------------------------------------------------------------		
/*//	计算点是否在三角形内部
//		 点  A,B,C 构成一个三角形
//		 可以计算 MA*MC,MC*MB,MB*MA
//		 看着三个叉积的符号关系
//		 如果 
//		 MA*MC >0， 说明 C在A的逆时针方向
//		 MC*MB >0， 说明 B在C的逆时针方向
//		 MB*MA >0， 说明 A在B的逆时针方向
//		 MA*MC <0， 说明 C在A的顺时针方向
//		 MC*MB <0， 说明 B在C的顺时针方向
//		 MB*MA <0， 说明 A在B的顺时针方向
//		 如果三个都为正，或者都为负，则M在三角形区域内
//		 如果有一个为0，另两个都是正或负，则M在三角形的边上
//		 如果有一个为0，另外一正一负，则M在三角形的延长线上
//		 如果有两个为0，则在三角形的顶点上
//		 不可能出现三个0的情况
		private var A:VBVector = new VBVector();
		private var B:VBVector = new VBVector();
		private var C:VBVector = new VBVector();
		private var M:VBVector = new VBVector();
		
		private var sp:Sprite = new Sprite();
		private var commands:Vector.<int>;
		private var datas:Vector.<Number>;
		private var crossAC:Number;
		private var crossCB:Number;
		private var crossBA:Number;
		public function Test()
		{
			addChild(sp);
			
			A.x = 0+100; A.y = -100+100;
			B.x = 100+100; B.y = 100+100;
			C.x = -100+100; C.y = 100+100;
			
			var MA:VBVector = A.minus(M);
			var MB:VBVector = B.minus(M);
			var MC:VBVector = C.minus(M);
			
			crossAC = MA.vectorMult(MC);
			crossCB = MC.vectorMult(MB);
			crossBA = MB.vectorMult(MA);
			
			commands = new Vector.<int>(4,true);
			commands[0] = GraphicsPathCommand.MOVE_TO;
			commands[1] = GraphicsPathCommand.LINE_TO;
			commands[2] = GraphicsPathCommand.LINE_TO;
			commands[3] = GraphicsPathCommand.LINE_TO;
			
			datas = new Vector.<Number>(8,true);
			datas[0] = A.x;
			datas[1] = A.y;
			datas[2] = C.x;
			datas[3] = C.y;
			datas[4] = B.x;
			datas[5] = B.y;
			datas[6] = A.x;
			datas[7] = A.y;
			
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawPath(commands,datas);

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			M.x = 500;
			M.y = 500;
			sp.graphics.beginFill(0xffff00);
			sp.graphics.drawCircle(M.x, M.y, 3);
			sp.graphics.endFill();
		}
		
		private var count:int = 200;
		protected function onEnterFrame(event:Event):void
		{
			M.x = stage.mouseX;
			M.y = stage.mouseY;
			sp.graphics.clear();
			sp.graphics.beginFill(0xffff00);
			sp.graphics.drawCircle(M.x, M.y, 3);
			sp.graphics.endFill();
			if(count < 0)
			{
//				M.x = Math.random()*50+50;
//				M.y = Math.random()*100+50;
				count = 100
				A.x = Math.random()*stage.width + 100;
				A.y = Math.random()*stage.height;
				B.x = Math.random()*stage.width + 50;
				B.y = Math.random()*stage.height + 50;
				C.x = Math.random()*stage.width;
				C.y = Math.random()*stage.height + 100;
				
				commands = new Vector.<int>(4,true);
				commands[0] = GraphicsPathCommand.MOVE_TO;
				commands[1] = GraphicsPathCommand.LINE_TO;
				commands[2] = GraphicsPathCommand.LINE_TO;
				commands[3] = GraphicsPathCommand.LINE_TO;
				
				datas = new Vector.<Number>(8,true);
				datas[0] = A.x;
				datas[1] = A.y;
				datas[2] = C.x;
				datas[3] = C.y;
				datas[4] = B.x;
				datas[5] = B.y;
				datas[6] = A.x;
				datas[7] = A.y;
			}
				
			var MA:VBVector = A.minus(M);
			var MB:VBVector = B.minus(M);
			var MC:VBVector = C.minus(M);
			
			crossAC = MA.vectorMult(MC);
			crossCB = MC.vectorMult(MB);
			crossBA = MB.vectorMult(MA);
			this.graphics.clear();
			if((crossAC >0 && crossCB >0 && crossBA >0) || (crossAC <0 && crossCB <0 && crossBA <0))
			{
				this.graphics.lineStyle(1, 0xff0000);
				this.graphics.drawPath(commands,datas);
			}else{
				this.graphics.lineStyle(1, 0x00ff00);
				this.graphics.drawPath(commands,datas);
			}
			count--;
		}*/
//-------------------------------------------------------------------------------------------		
		//计算三角形夹角，用余弦定理
		/*private var a:VBVector = new VBVector();
		private var b:VBVector = new VBVector();
		private var c:VBVector = new VBVector();
		public function Test()
		{
			a.x = 1;
			b.y = 1;
			b.x = -1;
			
			var db:Number = a.minus(c).magnitude();
			var da:Number = b.minus(c).magnitude();
			var dc:Number = a.minus(b).magnitude();
			
			//COSc
			var cosc:Number = (da*da+db*db-dc*dc)/(2*da*db);
			var nc:Number = Math.acos(cosc);
			var degreec:Number = nc*180/Math.PI;
			
			//COSb
			var cosb:Number = (da*da+dc*dc-db*db)/(2*da*dc);
			var nb:Number = Math.acos(cosb);
			var degreeb:Number = nb*180/Math.PI;
			
			//COSa
			var cosa:Number = (db*db+dc*dc-da*da)/(2*db*dc);
			var na:Number = Math.acos(cosa);
			var degreea:Number = na*180/Math.PI;
			
			trace(degreec, degreeb, degreea);
		}*/
//-------------------------------------------------------------------------------------------		
		//计算包围圆
		/*private var ab:VBRim = new VBRim();
		private var sp:Sprite = new Sprite();
		private var abs:Sprite = new Sprite();
		private var vx:Vector.<VBVector> = new Vector.<VBVector>();
		private var radian:Number = Math.PI/180;
		
		public function Test()
		{
			addChild(sp);
			addChild(abs);
			sp.x = 200;
			sp.y = 150;
			sp.graphics.lineStyle(1,0xffffff);
			sp.graphics.drawRect(0,0,50,100);
			vx.push(new VBVector(0,0), new VBVector(0,100), new VBVector(50,100), new VBVector(50,0));
			changeToWorld();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function changeToWorld():void
		{
			for(var i:int = 0; i < vx.length; i++)
			{
				vx[i].x += sp.x;
				vx[i].y += sp.y;
			}
		}
		
		private function calculateVX():void
		{
			vx[0].y = Math.sin(sp.rotation*radian)*0 + Math.cos(sp.rotation*radian)*0;
			vx[0].x = Math.cos(sp.rotation*radian)*0 - Math.sin(sp.rotation*radian)*0;
			
			vx[1].y = Math.sin(sp.rotation*radian)*0 + Math.cos(sp.rotation*radian)*100;
			vx[1].x = Math.cos(sp.rotation*radian)*0 - Math.sin(sp.rotation*radian)*100;
			
			vx[2].y = Math.sin(sp.rotation*radian)*50 + Math.cos(sp.rotation*radian)*100;
			vx[2].x = Math.cos(sp.rotation*radian)*50 - Math.sin(sp.rotation*radian)*100;
			
			vx[3].y = Math.sin(sp.rotation*radian)*50 + Math.cos(sp.rotation*radian)*0;
			vx[3].x = Math.cos(sp.rotation*radian)*50 - Math.sin(sp.rotation*radian)*0;
			
			changeToWorld();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			sp.rotation += 1;
			calculateVX();
			ab.update(vx);
			abs.graphics.clear();
			abs.graphics.lineStyle(2, 0xffff00);
			abs.graphics.drawCircle(ab.c.x, ab.c.y, ab.r);
		}*/
//-------------------------------------------------------------------------------------------		
		//计算AABB
		/*private var ab:VBAABB = new VBAABB();
		private var sp:Sprite = new Sprite();
		private var abs:Sprite = new Sprite();
		private var vx:Vector.<VBVector> = new Vector.<VBVector>();
		private var degrees:Number = Math.PI/180;
		public function Test()
		{
			addChild(sp);
			addChild(abs);
			sp.x = 200;
			sp.y = 150;
			sp.graphics.lineStyle(1,0xffffff);
			sp.graphics.drawRect(0,0,50,100);
			vx.push(new VBVector(0,0), new VBVector(0,100), new VBVector(50,100), new VBVector(50,0));
			changeToWorld();
			
			ab.updateAABB(vx);
			
			abs.graphics.lineStyle(2, 0xff0000);
			abs.graphics.drawRect(ab.shape.x, ab.shape.y, ab.shape.width, ab.shape.height);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function changeToWorld():void
		{
			for(var i:int = 0; i < vx.length; i++)
			{
				vx[i].x += sp.x;
				vx[i].y += sp.y;
			}
		}
		
		// |cosθ, -sinθ| |x|
		// |sinθ, cosθ |*|y|
		 	
		private function calculateVX():void
		{
			vx[0].y = Math.sin(sp.rotation*degrees)*0 + Math.cos(sp.rotation*degrees)*0;
			vx[0].x = Math.cos(sp.rotation*degrees)*0 - Math.sin(sp.rotation*degrees)*0;
			
			vx[1].y = Math.sin(sp.rotation*degrees)*0 + Math.cos(sp.rotation*degrees)*100;
			vx[1].x = Math.cos(sp.rotation*degrees)*0 - Math.sin(sp.rotation*degrees)*100;
			
			vx[2].y = Math.sin(sp.rotation*degrees)*50 + Math.cos(sp.rotation*degrees)*100;
			vx[2].x = Math.cos(sp.rotation*degrees)*50 - Math.sin(sp.rotation*degrees)*100;
			
			vx[3].y = Math.sin(sp.rotation*degrees)*50 + Math.cos(sp.rotation*degrees)*0;
			vx[3].x = Math.cos(sp.rotation*degrees)*50 - Math.sin(sp.rotation*degrees)*0;

			changeToWorld();
		}

		protected function onEnterFrame(event:Event):void
		{
			sp.rotation += 1;
			calculateVX();
			ab.updateAABB(vx);
			abs.graphics.clear();
			abs.graphics.lineStyle(1, 0xff0000);
			abs.graphics.drawRect(ab.shape.x, ab.shape.y, ab.shape.width, ab.shape.height);
		}	*/	
//-------------------------------------------------------------------------------------------		
		//带图形的旋转测试
		/*[Embed(source="test/assets/popular.png")]
		private var Image:Class;
		private var t:Bitmap;
		public function Test()
		{
			t = new Image();
			t.x = 100;
			t.y = 100;
			var rect:Rectangle = t.getBounds(this);
			addChild(t);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			t.rotation += 0.1;
			var rect:Rectangle = t.getBounds(this);
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		}*/
		
		/*private var cr:Sprite = new Sprite();
		private var sr:Sprite = new Sprite();
		public function Test()
		{
			cr.x = 200;
			cr.y = 200;
			cr.graphics.lineStyle(1,0xFFFFFF);
			cr.graphics.drawRect(-100,-50,200,100);
			
			addChild(cr);
			addChild(sr);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			cr.rotation += 0.1;
			
			var rect:Rectangle = cr.getBounds(this);
			sr.graphics.clear();
			sr.graphics.lineStyle(2, 0xff0000);
			sr.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		}*/
//-------------------------------------------------------------------------------------------		
		//旋转测试
		/*
		private var sr:Sprite = new Sprite;
		private var cr:Sprite = new Sprite;
		private var m:Matrix = new Matrix();
		private var t:Transform;
		public function Test()
		{
			super();
			
			sr.x = 100;
			sr.y = 100;
			cr.x = 200;
			cr.y = 200;
			addChild(sr);
			addChild(cr);
			
			sr.graphics.lineStyle(1, 0xff0000);
			sr.graphics.moveTo(-200, 0);
			sr.graphics.lineTo(200,0);
			sr.graphics.moveTo(0, -100);
			sr.graphics.lineTo(0, 100);
			
			cr.graphics.lineStyle(1,0xFFFFFF);
			cr.graphics.drawRect(-100,-50,200,100);
			
			sr.x = cr.x;
			sr.y = cr.y;
			
//			t = new Transform(cr);
//			m.translate(200,200)
			//m.rotate(0.5);
//			t.matrix = m;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onClick);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace(stage.mouseX, stage.mouseY);
		}
		
		private var angle:Number = 0;
		protected function onClick(event:MouseEvent):void
		{
			angle += 1;
			cr.rotation = angle;
//			m.rotate(angle);
		}
		
		protected function onEnterFrame(event:Event):void
		{
//			t.matrix = m;
			sr.x = cr.x;
			sr.y = cr.y;
			sr.rotation = cr.rotation;
		}*/
//-------------------------------------------------------------------------------------------
	}
}