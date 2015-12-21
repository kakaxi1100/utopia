package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	import org.ares.vernalbreeze.VBVector;
	
	import test.collision.VBAABB;
	import test.collision.VBRim;
	
	[SWF(frameRate="60", backgroundColor="0",height="400",width="550")]
	public class Test extends Sprite
	{
		/**
		 * 计算点是否在三角形内部
		 * 点  A,B,C 构成一个三角形
		 * 可以计算 MA*MC,MC*MB,MB*MA
		 * 看着三个叉积是否为正
		 * 如果 
		 * MA*MC >0， 说明 C在A的逆时针方向
		 * MC*MB >0， 说明 B在C的逆时针方向
		 * MB*MA >0， 说明 A在B的逆时针方向
		 * 如果三个都为正，或者都为负，则M在三角形区域内
		 * 如果有一个为0，另两个都是正或负，则M在三角形的边上
		 * 如果有一个为0，另外一正一负，则M在三角形的延长线上
		 * 如果有两个为0，则在三角形的顶点上
		 * 不可能出现三个0的情况
		*/
		private var a:VBVector = new VBVector();
		private var b:VBVector = new VBVector();
		private var c:VBVector = new VBVector();
		private var m:VBVector = new VBVector();
		
		public function Test()
		{
			
		}
		
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
		/*
		private var sr:Sprite = new Sprite;
		private var cr:Sprite = new Sprite;
		private var m:Matrix = new Matrix();
		private var t:Transform;
		public function Test()
		{
			super();
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLevelHd);
			stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			stage.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			stage.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
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
		
		protected function onMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("onmouup");
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace(stage.mouseX, stage.mouseY);
		}
		
		protected function onRollOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("roll over!!");
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("mouse over!!");
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("roll out!!");
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("mouse out!!");
		}
		
		protected function onMouseLevelHd(event:Event):void
		{
			trace("leave leave!!");
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
	}
}