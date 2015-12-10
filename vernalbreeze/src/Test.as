package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	[SWF(frameRate="60", backgroundColor="0",height="400",width="550")]
	public class Test extends Sprite
	{
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
			
			/*
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
			*/
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("onmouup");
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//trace(stage.mouseX, stage.mouseY);
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
		}
	}
}