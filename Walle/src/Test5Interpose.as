package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import walle.Car;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class Test5Interpose extends Sprite
	{
		private var car1:Car = new Car();
		private var car2:Car = new Car();
		private var car3:Car = new Car();
		private var target:FFVector = new FFVector();
		public function Test5Interpose()
		{
			super();
			
			this.addChild(car1);
			car1.intelligent.position.setTo(100, 100);
			this.addChild(car2);
			car2.intelligent.position.setTo(800, 600);
			
			this.addChild(car3);
			car3.intelligent.position.setTo(400, 300);
			
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			target.setTo(event.stageX, event.stageY);
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawCircle(event.stageX,event.stageY,2);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			
			SteeringBehaviors.wander(car1.intelligent);
			SteeringBehaviors.wander(car2.intelligent);
			SteeringBehaviors.interpose(car1.intelligent, car2.intelligent, car3.intelligent);
			
			car1.udpate(0.0166 * 10);
			car2.udpate(0.0166 * 10);
			car3.udpate(0.0166 * 10);
		}
	}
}