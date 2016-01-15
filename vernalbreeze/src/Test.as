package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
		
//		public function Test()
//		{
//			
//		}
//---------------------------------------------------------------------------		
		//测试两线段相交
		/*private var a:VBVector;
		private var b:VBVector;
		private var c:VBVector;
		private var d:VBVector;
		private var p:VBVector;;
		public function Test()
		{
			a = new VBVector(350,200);
			b = new VBVector(100,180);
			c = new VBVector(150,200);
			d = new VBVector(60, 90);
			p = new VBVector();
			
			DrawUtil.drawLine(this.graphics, a,b,2,0xffff00);
			DrawUtil.drawLine(this.graphics, c,d,2,0x00ffff);
			
			VBMathUtil.intersectionSegmentSegment(a,b,c,d,p);
			DrawUtil.drawRim(this.graphics, p, 5, 2, 0xff0000);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			c.setTo(stage.mouseX, stage.mouseY);
			VBMathUtil.intersectionSegmentSegment(a,b,c,d,p);
			
			this.graphics.clear();
			DrawUtil.drawLine(this.graphics, a,b,2,0xffff00);
			DrawUtil.drawLine(this.graphics, c,d,2,0x00ffff);
			DrawUtil.drawRim(this.graphics, p, 5, 2, 0xff0000);
		}*/
//------------------------------------------------------------------------------------		
		//测试点到三角形的最近点
		/*private var a:VBVector;
		private var b:VBVector;
		private var c:VBVector;
		private var p:VBVector;
		private var q:VBVector;
		public function Test()
		{
			a = new VBVector(300,100);
			b = new VBVector(50,80);
			c = new VBVector(150,200);
			
			p = new VBVector(150,30);
			
			q = VBMathUtil.closestPtPointTriangle(p,a,b,c);
			
			DrawUtil.drawRim(this.graphics, p, 5, 2, 0x00ffff);
			DrawUtil.drawRim(this.graphics, q, 5, 2);
			DrawUtil.drawTriangle(this.graphics, a,b,c, 2, 0xffff00);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			p.setTo(stage.mouseX, stage.mouseY);
			q = VBMathUtil.closestPtPointTriangle(p,a,b,c);
			this.graphics.clear();
			DrawUtil.drawRim(this.graphics, p, 5, 2, 0x00ffff);
			DrawUtil.drawRim(this.graphics, q, 5, 2);
			DrawUtil.drawTriangle(this.graphics, a,b,c, 2, 0xffff00);
		}*/
//------------------------------------------------------------------------------------		
		//测试OBB上离指定点最近的点,和最近距离计算
		/*private var obb:VBOBB = new VBOBB();
		private var orgVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var convexVexs:Vector.<VBVector> = new Vector.<VBVector>();
		
		private var p:VBVector = new VBVector();
		private var q:VBVector;
		private var key:int = 0;
		public function Test()
		{
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(key == 0) return;
			p.setTo(stage.mouseX, stage.mouseY);
			q = VBMathUtil.closestPtPointOBB(p, obb);
			trace(VBMathUtil.squareDistancePointOBB(p, obb));
			
			this.graphics.clear();
			DrawUtil.drawRim(this.graphics, p, 5, 2, 0x00ffff);
			DrawUtil.drawRim(this.graphics, q, 5, 2, 0xff0000);

			DrawUtil.drawPolygon(this.graphics, convexVexs, 2, 0xffff00);
			DrawUtil.drawOBB(this.graphics,obb,2,0x00ff00);
		} 
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.M:
					VBMathUtil.convexVolume(orgVexs,convexVexs);
					obb.updateOBB(convexVexs);
					DrawUtil.drawPolygon(this.graphics, convexVexs, 2, 0xffff00);
					DrawUtil.drawOBB(this.graphics,obb,2,0x00ff00);
					break;
				case Keyboard.N:
					orgVexs = new Vector.<VBVector>;
					convexVexs = new Vector.<VBVector>;
					this.graphics.clear();
					break;
				case Keyboard.SPACE:
					key = key^1;
					break;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var temp:VBVector = new VBVector(stage.mouseX, stage.mouseY);
			orgVexs.push(temp);
			DrawUtil.drawRim(this.graphics,temp, 5, 2, 0x00ffff); 
		}*/
//-----------------------------------------------------------------------------		
		//测试AABB上离指定点最近的点,和最近距离计算
		/*private var pdot:VBVector = new VBVector();
		private var qdot:VBVector;
		private var aabb:VBAABB = new VBAABB();
		private var vexs:Vector.<VBVector> = new Vector.<VBVector>;
		public function Test()
		{
			vexs.push(new VBVector(100,110),new VBVector(150,180),new VBVector(200,230),new VBVector(250,300));
			aabb.updateAABB(vexs);
			DrawUtil.drawAABB(this.graphics, aabb,2);
			
			pdot.setTo(260,260);
			qdot = VBMathUtil.closestPtPointAABB(pdot, aabb);
			DrawUtil.drawRim(this.graphics, pdot, 5, 2, 0x00ff00);
			DrawUtil.drawRim(this.graphics, qdot, 5, 2, 0xff0000);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			pdot.setTo(stage.mouseX, stage.mouseY);
			qdot = VBMathUtil.closestPtPointAABB(pdot, aabb);
			this.graphics.clear();
			DrawUtil.drawAABB(this.graphics, aabb,2);
			DrawUtil.drawRim(this.graphics, pdot, 5, 2, 0x00ff00);
			DrawUtil.drawRim(this.graphics, qdot, 5, 2, 0xff0000);
			trace(VBMathUtil.squareDistancePointAABB(pdot, aabb));
		}*/
//-----------------------------------------------------------------------------		
		//测试线段上离指定点最近的点,和最近距离计算
		/*private var adot:VBVector = new VBVector();
		private var bdot:VBVector = new VBVector();
		private var cdot:VBVector = new VBVector();
		private var ddot:VBVector;
		public function Test()
		{
			adot.setTo(100,100);
			bdot.setTo(150,260);
			cdot.setTo(49,80);
			
			DrawUtil.drawLine(this.graphics, adot, bdot, 2, 0xffffff);
			DrawUtil.drawRim(this.graphics, cdot, 5, 2, 0x00ff00);
			
			ddot = VBMathUtil.closestPtPointSegment(cdot,adot,bdot);
			DrawUtil.drawRim(this.graphics, ddot, 5, 2, 0xff0000);
			trace(VBMathUtil.squareDistancePointSegment(adot,bdot,cdot));
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			cdot.x = stage.mouseX;
			cdot.y = stage.mouseY;
			this.graphics.clear();
			DrawUtil.drawLine(this.graphics, adot, bdot, 2, 0xffffff);
			DrawUtil.drawRim(this.graphics, cdot, 5, 2, 0x00ff00);
			
			ddot = VBMathUtil.closestPtPointSegment(cdot,adot,bdot);
			DrawUtil.drawRim(this.graphics, ddot, 5, 2, 0xff0000);
			trace(VBMathUtil.squareDistancePointSegment(adot,bdot,cdot));
		}*/

//-----------------------------------------------------------------------------		
		//OBB 相交测试
		//先绘制 A 的点，然后按下按键B 再绘制B点
		//绘制完后 按下 M 建， 计算 OBB
		//最后按下 空格键，旋转两个图形
		/*private var obb1:VBOBB = new VBOBB();
		private var obb2:VBOBB = new VBOBB();
		
		private var sp1:Sprite = new Sprite();
		private var sp2:Sprite = new Sprite();
		private var curSP:Sprite = sp1;
		
		private var obbsp1:Sprite = new Sprite();
		private var obbsp2:Sprite = new Sprite();
		
		private var orgVexs1:Vector.<VBVector> = new Vector.<VBVector>();//本地坐标
		private var orgVexs2:Vector.<VBVector> = new Vector.<VBVector>();
		private var curOrg:Vector.<VBVector> = orgVexs1;

		private var convexVexs1:Vector.<VBVector> = new Vector.<VBVector>();
		private var convexVexs2:Vector.<VBVector> = new Vector.<VBVector>();
		private var curConvex:Vector.<VBVector> = convexVexs1;
		
		private var newVexs1:Vector.<VBVector>;
		private var newVexs2:Vector.<VBVector>;
		
		private var degrees:Number = Math.PI/180;
		private var key:int = 0;
		private var isAuto:Boolean = false;
		
		private var sp1rotation:Number = 0;
		private var sp2rotation:Number = 0;
		public function Test()
		{
			addChild(sp1);
			sp1.x = 200;
			sp1.y = 160;
			addChild(sp2);
			sp2.x = 300;
			sp2.y = 260;
			
			addChild(obbsp1);
			addChild(obbsp2);
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.graphics.beginFill(0xff0000,1);
			this.graphics.drawCircle(sp1.x, sp1.y, 5);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawCircle(sp2.x, sp2.y, 5);
			this.graphics.endFill();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(key == 0) return;
			//开始旋转
			if(isAuto)
			{
				sp1rotation += 1;
				sp2rotation += 1;
			}
			//计算旋转点坐标
			updateOBB();
			//清空画布
			sp1.graphics.clear();
			sp2.graphics.clear();
			obbsp1.graphics.clear();
			obbsp2.graphics.clear();
			
			//画顶点
			for(var i:int = 0; i< newVexs1.length; i++)
			{
				DrawUtil.drawRim(sp1.graphics,newVexs1[i], 5, 2, 0x00ffff); 
			}
			for(i = 0; i< newVexs2.length; i++)
			{
				DrawUtil.drawRim(sp2.graphics,newVexs2[i], 5, 2, 0xff00ff); 
			}
			//画凸体
			DrawUtil.drawPolygon(sp1.graphics, newVexs1, 2, 0xffff00);
			DrawUtil.drawPolygon(sp2.graphics, newVexs2, 2, 0xffff00);
			//转换成世界坐标,这里可以简化，其实轴向和半宽半高都一样，就是中心点的位置需要转成世界坐标的位置
			//计算OBB
			var temp1vexs:Vector.<VBVector> = new Vector.<VBVector>;
			var temp2vexs:Vector.<VBVector> = new Vector.<VBVector>;
			for(i = 0; i < newVexs1.length; i++)
			{	
				var temp1:VBVector = new VBVector();
				temp1.x = newVexs1[i].x + sp1.x;
				temp1.y = newVexs1[i].y + sp1.y;
				temp1vexs.push(temp1)
			}
			for(i = 0; i < newVexs2.length; i++)
			{
				var temp2:VBVector = new VBVector();
				temp2.x = newVexs2[i].x + sp2.x;
				temp2.y = newVexs2[i].y + sp2.y;
				temp2vexs.push(temp2);
			}
			obb1.updateOBB(temp1vexs);
			obb2.updateOBB(temp2vexs);
			//画OBB
			if(obb1.hitTestOBB(obb2))
			{
				DrawUtil.drawOBB(obbsp1.graphics,obb1,2,0xff0000);
				DrawUtil.drawOBB(obbsp2.graphics,obb2,2,0xff0000);
			}else
			{
				DrawUtil.drawOBB(obbsp1.graphics,obb1,2,0x00ff00);
				DrawUtil.drawOBB(obbsp2.graphics,obb2,2,0x00ff00);
			}
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.A://切换到 A 图形
					curSP = sp1;
					curOrg = orgVexs1;
					curConvex = convexVexs1;
					break;
				case Keyboard.B://切换到 B 图形
					curSP = sp2;
					curOrg = orgVexs2;
					curConvex = convexVexs2;
					break;
				case Keyboard.M:// 计算凸体
//					convexVexs1.push(new VBVector(0, 0), new VBVector(0,30), new VBVector(60,0));
//					convexVexs2.push(new VBVector(0,0), new VBVector(0,30),  new VBVector(60,0));
					VBMathUtil.convexVolume(orgVexs1,convexVexs1);
					VBMathUtil.convexVolume(orgVexs2,convexVexs2);
					//画凸体
					DrawUtil.drawPolygon(sp1.graphics, convexVexs1, 2, 0xffff00);
					DrawUtil.drawPolygon(sp2.graphics, convexVexs2, 2, 0xffff00);
					//转换成世界坐标
					//计算OBB
					var temp1vexs:Vector.<VBVector> = new Vector.<VBVector>;
					var temp2vexs:Vector.<VBVector> = new Vector.<VBVector>;
					for(var i:int = 0; i <convexVexs1.length; i++ )
					{	
						var temp1:VBVector = new VBVector();
						temp1.x = convexVexs1[i].x + sp1.x;
						temp1.y = convexVexs1[i].y + sp1.y;
						temp1vexs.push(temp1)
					}
					for(i = 0; i < convexVexs2.length; i++)
					{
						var temp2:VBVector = new VBVector();
						temp2.x = convexVexs2[i].x + sp2.x;
						temp2.y = convexVexs2[i].y + sp2.y;
						temp2vexs.push(temp2);
					}
					
					obb1.updateOBB(temp1vexs);
					obb2.updateOBB(temp2vexs);
					//画OBB
					if(obb1.hitTestOBB(obb2))
					{
						DrawUtil.drawOBB(obbsp1.graphics,obb1,2,0xff0000);
						DrawUtil.drawOBB(obbsp2.graphics,obb2,2,0xff0000);
					}else
					{
						DrawUtil.drawOBB(obbsp1.graphics,obb1,2,0x00ff00);
						DrawUtil.drawOBB(obbsp2.graphics,obb2,2,0x00ff00);
					}
					break;
				case Keyboard.N://rest
					key = 0;
					sp1rotation = sp2rotation = 0;
					
					orgVexs1= new Vector.<VBVector>();
					orgVexs2= new Vector.<VBVector>();
					curOrg= orgVexs1;
					
					convexVexs1= new Vector.<VBVector>();
					convexVexs2= new Vector.<VBVector>();
					curConvex= convexVexs1;

					sp1.graphics.clear();
					sp2.graphics.clear();
					curSP = sp1;
					obbsp1.graphics.clear();
					obbsp2.graphics.clear();
					break;
				case Keyboard.SPACE://开始和停止旋转
					key = key^1;
					isAuto = true;
					break;
				case Keyboard.LEFT:
					key = 1;
					isAuto = false;
					//这里有陷阱，它本来旋转了90度，算出的点是旋转90度之后的点，在+上这个旋转的度数，显示的就是180度
					//所以不能直接rotation+
//					sp1.rotation += 90;
//					sp2.rotation += 90;
					sp1rotation += 90;
					sp2rotation += 90;
					onEnterFrame(null);
					break;
				case Keyboard.RIGHT:
					key = 1;
					isAuto = false;
					sp1rotation -= 90;
					sp2rotation -= 90;
					onEnterFrame(null);
					break;
			}
		}
		
		
		//图形执行旋转操作之后
		// 轴向变了
		// 中心点的位置也变了 
		// 根据旋转矩阵具体变化如下
		// 
		// |cosq -sinq| |x|
		// |sinq  cosq|*|y|
		//
		private function updateOBB():void
		{
			newVexs1 = new Vector.<VBVector>();
			newVexs2 = new Vector.<VBVector>();
			var v:VBVector;
			for(var i:int = 0; i < convexVexs1.length; i++)
			{
				v = new VBVector();
				v.x = Math.cos(sp1rotation*degrees)*convexVexs1[i].x - Math.sin(sp1rotation*degrees)*convexVexs1[i].y;
				v.y = Math.sin(sp1rotation*degrees)*convexVexs1[i].x + Math.cos(sp1rotation*degrees)*convexVexs1[i].y;
				newVexs1.push(v);
			}
			for(i = 0; i < convexVexs2.length; i++)
			{
				v = new VBVector();
				v.x = Math.cos(sp2rotation*degrees)*convexVexs2[i].x - Math.sin(sp2rotation*degrees)*convexVexs2[i].y;
				v.y = Math.sin(sp2rotation*degrees)*convexVexs2[i].x + Math.cos(sp2rotation*degrees)*convexVexs2[i].y;
				newVexs2.push(v);
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var temp:VBVector = new VBVector(curSP.mouseX, curSP.mouseY);
			curOrg.push(temp);
			if(curSP == sp1)
			{
				DrawUtil.drawRim(curSP.graphics,temp, 5, 2, 0x00ffff); 
			}else
			{
				DrawUtil.drawRim(curSP.graphics,temp, 5, 2, 0xff00ff); 
			}
		}*/
//-----------------------------------------------------------------------------		
		//包围圆相交测试
		/*private var rim1:VBRim = new VBRim();
		private var rim2:VBRim = new VBRim();
		//顶点集1
		private var vx1:Vector.<VBVector> = new Vector.<VBVector>;
		//顶点集2
		private var vx2:Vector.<VBVector> = new Vector.<VBVector>;
		//图形1
		private var sp1:Sprite = new Sprite();
		//图形2
		private var sp2:Sprite = new Sprite();
		
		private var degrees:Number = Math.PI/180;
		public function Test()
		{
			addChild(sp1);
			sp1.x = 200;
			sp1.y = 100;
			addChild(sp2);
			sp2.x = 260;
			sp2.y = 160;
			
			vx1.push(new VBVector(0,0), new VBVector(40,0), new VBVector(40,80), new VBVector(0,80));
			for(var i:int = 0, j:int = 1; j < vx1.length; i++,j++)
			{
				DrawUtil.drawLine(sp1.graphics, vx1[i], vx1[j], 1, 0xffffff);
			}
			DrawUtil.drawLine(sp1.graphics, vx1[j - 1], vx1[0], 1, 0xffffff);
			
			vx2.push(new VBVector(0,0), new VBVector(80,0), new VBVector(80,40), new VBVector(0,40));
			for(i = 0, j = 1; j < vx1.length; i++,j++)
			{
				DrawUtil.drawLine(sp2.graphics, vx2[i], vx2[j], 1, 0xffffff);
			}
			DrawUtil.drawLine(sp2.graphics, vx2[j - 1], vx2[0], 1, 0xffffff);
			
			changeToWorld();
			rim1.updateRim(vx1);
			rim2.updateRim(vx2);
			
			DrawUtil.drawRim(this.graphics, rim1.c, rim1.r);
			DrawUtil.drawRim(this.graphics, rim2.c, rim2.r);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var key:Boolean = false;
		protected function onEnterFrame(event:Event):void
		{
			if(key) return;
			sp1.rotation += 1;
			sp2.rotation += 1;
			
			changeToWorld();
			rim1.updateRim(vx1);
			rim2.updateRim(vx2);
			
			this.graphics.clear();
			if(rim1.hitTestRim(rim2))
			{
				//				key = true;
				DrawUtil.drawRim(this.graphics, rim1.c, rim1.r, 2);
				DrawUtil.drawRim(this.graphics, rim2.c, rim2.r, 2);
			}else
			{
				DrawUtil.drawRim(this.graphics, rim1.c, rim1.r, 2, 0xffff00);
				DrawUtil.drawRim(this.graphics, rim2.c, rim2.r, 2, 0xffff00);
			}
		}
		
		//转变为世界坐标系
		private function changeToWorld():void
		{
			calculateVX();
			for(var i:int = 0; i < 4; i++)
			{
				vx1[i].x += sp1.x;
				vx1[i].y += sp1.y;
				
				vx2[i].x += sp2.x;
				vx2[i].y += sp2.y;
			}
		}
		
		//计算出每个顶点的位置
		//旋转矩阵公式
		// |cosθ, -sinθ| |x|
		// |sinθ, cosθ |*|y| 	
		private function calculateVX():void
		{
			vx1[0].y = Math.sin(sp1.rotation*degrees)*0 + Math.cos(sp1.rotation*degrees)*0;
			vx1[0].x = Math.cos(sp1.rotation*degrees)*0 - Math.sin(sp1.rotation*degrees)*0;
			
			vx1[1].y = Math.sin(sp1.rotation*degrees)*40 + Math.cos(sp1.rotation*degrees)*0;
			vx1[1].x = Math.cos(sp1.rotation*degrees)*40 - Math.sin(sp1.rotation*degrees)*0;
			
			vx1[2].y = Math.sin(sp1.rotation*degrees)*40 + Math.cos(sp1.rotation*degrees)*80;
			vx1[2].x = Math.cos(sp1.rotation*degrees)*40 - Math.sin(sp1.rotation*degrees)*80;
			
			vx1[3].y = Math.sin(sp1.rotation*degrees)*0 + Math.cos(sp1.rotation*degrees)*80;
			vx1[3].x = Math.cos(sp1.rotation*degrees)*0 - Math.sin(sp1.rotation*degrees)*80;
			
			vx2[0].y = Math.sin(sp2.rotation*degrees)*0 + Math.cos(sp2.rotation*degrees)*0;
			vx2[0].x = Math.cos(sp2.rotation*degrees)*0 - Math.sin(sp2.rotation*degrees)*0;
			
			vx2[1].y = Math.sin(sp2.rotation*degrees)*80 + Math.cos(sp2.rotation*degrees)*0;
			vx2[1].x = Math.cos(sp2.rotation*degrees)*80 - Math.sin(sp2.rotation*degrees)*0;
			
			vx2[2].y = Math.sin(sp2.rotation*degrees)*80 + Math.cos(sp2.rotation*degrees)*40;
			vx2[2].x = Math.cos(sp2.rotation*degrees)*80 - Math.sin(sp2.rotation*degrees)*40;
			
			vx2[3].y = Math.sin(sp2.rotation*degrees)*0 + Math.cos(sp2.rotation*degrees)*40;
			vx2[3].x = Math.cos(sp2.rotation*degrees)*0 - Math.sin(sp2.rotation*degrees)*40;	
		}*/
//-----------------------------------------------------------------------------		
		//AABB相交测试
		/*private var aabb1:VBAABB = new VBAABB();
		private var aabb2:VBAABB = new VBAABB();
		//顶点集1
		private var vx1:Vector.<VBVector> = new Vector.<VBVector>;
		//顶点集2
		private var vx2:Vector.<VBVector> = new Vector.<VBVector>;
		//图形1
		private var sp1:Sprite = new Sprite();
		//sp1 轴向 相对于世界坐标系
		private var sp1e0:VBVector = new VBVector();
		private var sp1e1:VBVector = new VBVector();
		//图形2
		private var sp2:Sprite = new Sprite();
		//sp2 轴向 相对于世界坐标系
		private var sp2e0:VBVector = new VBVector();
		private var sp2e1:VBVector = new VBVector();
		
		private var degrees:Number = Math.PI/180;
		public function Test()
		{
			addChild(sp1);
			sp1.x = 200;
			sp1.y = 100;
			addChild(sp2);
			sp2.x = 260;
			sp2.y = 160;
			
			vx1.push(new VBVector(0,0), new VBVector(40,0), new VBVector(40,80), new VBVector(0,80));
			sp1e0 = vx1[1].minus(vx1[0]);
			sp1e0.normalizeEquals();
			sp1e1 = vx1[3].minus(vx1[0]);
			sp1e1.normalizeEquals();
			for(var i:int = 0, j:int = 1; j < vx1.length; i++,j++)
			{
				DrawUtil.drawLine(sp1.graphics, vx1[i], vx1[j], 1, 0xffffff);
			}
			DrawUtil.drawLine(sp1.graphics, vx1[j - 1], vx1[0], 1, 0xffffff);
			
			
			vx2.push(new VBVector(0,0), new VBVector(80,0), new VBVector(80,40), new VBVector(0,40));
			sp2e0 = vx2[1].minus(vx2[0]);
			sp2e0.normalizeEquals();
			sp2e1 = vx2[3].minus(vx2[0]);
			sp2e1.normalizeEquals();
			for(i = 0, j = 1; j < vx1.length; i++,j++)
			{
				DrawUtil.drawLine(sp2.graphics, vx2[i], vx2[j], 1, 0xffffff);
			}
			DrawUtil.drawLine(sp2.graphics, vx2[j - 1], vx2[0], 1, 0xffffff);
			
			changeToWorld();
			aabb1.updateAABB(vx1);
			aabb2.updateAABB(vx2);
			
			DrawUtil.drawAABB(this.graphics, aabb1,2);
			DrawUtil.drawAABB(this.graphics, aabb2,2);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var key:Boolean = false;
		protected function onEnterFrame(event:Event):void
		{
			if(key) return;
			sp1.rotation += 1;
			sp2.rotation += 1;
			
			changeToWorld();
			aabb1.updateAABB(vx1);
			aabb2.updateAABB(vx2);
			
			this.graphics.clear();
			if(aabb1.hitTestAABB(aabb2))
			{
//				key = true;
				DrawUtil.drawAABB(this.graphics, aabb1,2,0xff0000);
				DrawUtil.drawAABB(this.graphics, aabb2,2,0xff0000);
			}else
			{
				DrawUtil.drawAABB(this.graphics, aabb1,2);
				DrawUtil.drawAABB(this.graphics, aabb2,2);
			}
		}
		
		//将顶点坐标转换成世界坐标
		private function changeToWorld():void
		{
			updatee0e1();
			calculateVX();
			for(var i:int = 0; i<4; i++)
			{
				vx1[i].x += sp1.x;
				vx1[i].y += sp1.y;
				vx2[i].x += sp2.x;
				vx2[i].y += sp2.y;
			}
		}
		
		//根据旋转的角度计算轴向
		private function updatee0e1():void
		{
			sp1e0.setTo(Math.cos(sp1.rotation*degrees), Math.sin(sp1.rotation*degrees));
			sp1e1.setTo(-sp1e0.y, sp1e0.x);
			sp2e0.setTo(Math.cos(sp2.rotation*degrees), Math.sin(sp2.rotation*degrees));
			sp2e1.setTo(-sp2e0.y, sp2e0.x);
		}
		
		private function calculateVX():void
		{
			vx1[0].setTo(0,0);
			vx1[1] = sp1e0.mult(40);
			vx1[2] = sp1e0.mult(40).plus(sp1e1.mult(80));
			vx1[3] = sp1e1.mult(80);
			
			vx2[0].setTo(0,0);
			vx2[1] = sp2e0.mult(80);
			vx2[2] = sp2e0.mult(80).plus(sp2e1.mult(40));
			vx2[3] = sp2e1.mult(40);
		}*/
//-----------------------------------------------------------------------------		
		//OBB (完整代码，正确版本)
		/*private var cur:VBVector;
		private var convexVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var orgVexs:Vector.<VBVector> = new Vector.<VBVector>();
		private var sp:Sprite = new Sprite();
		private var sp2:Sprite = new Sprite();
		public function Test()
		{
//			convexVexs.push(new VBVector(0,0), new VBVector(0,100), new VBVector(100,100));
			addChild(sp);
			addChild(sp2);
//			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
//		private var key:Boolean;
//		protected function onEnterFrame(event:Event):void
//		{
//			if(key)
//			{
//				sp.rotation += 1;
//			}
//		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
//					key = true;
					VBMathUtil.convexVolume(orgVexs,convexVexs);
					for(var i:int = 0; i < convexVexs.length; i++)
					{
						var next:int = i+1;
						if(next >= convexVexs.length)
						{
							next = 0;
						}
						DrawUtil.drawLine(sp.graphics, convexVexs[i],convexVexs[next],2);
					}
					
					var testOBB:VBOBB = new VBOBB();
					//trace(rotatingRectangle(testOBB));
					testOBB.updateOBB(convexVexs);
					trace(testOBB);
					//求四个顶点的值
					//1.在世界坐标系下求出半宽和半高对于OBB轴向的矢量值
					var tempW:VBVector = testOBB.x.mult(testOBB.halfWidth);//计算宽度的向量
					var tempH:VBVector = testOBB.y.mult(testOBB.halfHeight);//计算高度的向量
					//2.此时根据根据半宽和半高在 e0-e1 轴向上的矢量和既可以算出四个顶点 相对于世界坐标（0，0）的位置
					var a:VBVector = new VBVector(tempW.x + tempH.x, tempW.y + tempH.y);
					var b:VBVector = new VBVector(-tempW.x + tempH.x, -tempW.y + tempH.y);
					var c:VBVector = new VBVector(-tempW.x - tempH.x, -tempW.y - tempH.y);
					var d:VBVector = new VBVector(tempW.x - tempH.x, tempW.y - tempH.y);
					trace(a,b,c,d);
					//3.再加上中心点在世界坐标的位置求出各点的世界坐标
					a.plusEquals(testOBB.center);
					b.plusEquals(testOBB.center);
					c.plusEquals(testOBB.center);
					d.plusEquals(testOBB.center);
					trace(a,b,c,d);
					DrawUtil.drawLine(sp.graphics, a, b, 2, 0xffff00);
					DrawUtil.drawLine(sp.graphics, b, c, 2, 0xffff00);
					DrawUtil.drawLine(sp.graphics, c, d, 2, 0xffff00);
					DrawUtil.drawLine(sp.graphics, d, a, 2, 0xffff00);
					break;
				case Keyboard.DOWN://清除点
//					key = false;
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
			DrawUtil.drawRim(sp.graphics,temp, 5); 
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
					obb.halfWidth = (maxe0 - mine0)*0.5;
					obb.halfHeight = (maxe1 - mine1)*0.5;
					obb.x = e0;
					obb.y = e1;
				}
			}
			return minArea;
		}*/
//-----------------------------------------------------------------------------		
		//OBB初步代码 (有错误 ，正确见上面版本)
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
//			abs.graphics.drawRect(ab.shape.x, ab.shape.y, ab.shape.width, ab.shape.height);
			DrawUtil.drawAABB(abs.graphics, ab);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		//转变为世界坐标系
		private function changeToWorld():void
		{
			for(var i:int = 0; i < vx.length; i++)
			{
				vx[i].x += sp.x;
				vx[i].y += sp.y;
			}
		}
		
		//计算出每个顶点的位置
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
//			abs.graphics.drawRect(ab.shape.x, ab.shape.y, ab.shape.width, ab.shape.height);
			DrawUtil.drawAABB(abs.graphics, ab);
		}*/	
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