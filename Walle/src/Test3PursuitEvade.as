package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import walle.Car;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class Test3PursuitEvade extends Sprite
	{
		private var car1:Car = new Car();
		private var car2:Car = new Car();
		private var target:FFVector = new FFVector();
		public function Test3PursuitEvade()
		{
			super();
			
			this.addChild(car1);
			car1.intelligent.maxSpeed = 25;
			car1.intelligent.maxForce = 10;
			car1.intelligent.position.setTo(100, 100);
			this.addChild(car2);
			car2.intelligent.position.setTo(400, 300);
			
			
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
			//car1追逐者, car2是躲避者
			SteeringBehaviors.evade(car1.intelligent, car2.intelligent);
			SteeringBehaviors.seek(car1.intelligent, car2.intelligent.position);
			
//			SteeringBehaviors.pursuit(car1.intelligent, car2.intelligent);
//			SteeringBehaviors.wander(car2.intelligent);
			
			car1.udpate(0.0166 * 10);
			car2.udpate(0.0166 * 10);
		}
	}
}