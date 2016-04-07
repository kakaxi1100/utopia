package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import base.EVector;
	
	import voforai.SteeringBehaviors;
	import voforai.Vehicle;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class AutoTest extends Sprite
	{
		private var v:Vehicle = new Vehicle();
		private var a:Number;
		private var empty:EVector = new EVector(0,0);
		public function AutoTest()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.align = StageAlign.TOP_LEFT;
			
			v.position.setTo(0,0);
			v.velocity.length = 100;
			v.velocity.angle = 0;
			v.draw();
			addChild(v);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			trace("aa");
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(this.mouseX,this.mouseY,2);
			this.graphics.endFill();
			
			empty.setTo(this.mouseX, this.mouseY);
//			SteeringBehaviors.seek(v, empty);
//			v.draw();
//			v.update(15/1000);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var d:Number = (getTimer() - a)/1000;
//			empty.setTo(stage.mouseX, stage.mouseY);
			SteeringBehaviors.seek(v, empty);
			v.update(d);
//			this.graphics.clear();
//			this.graphics.lineStyle(2, 0xff0000);
//			this.graphics.moveTo(400, 300);
//			this.graphics.lineTo(v.velocity.x - 400, v.velocity.y-300);
//			trace(v.velocity);
			a = getTimer();
		}
	}
}