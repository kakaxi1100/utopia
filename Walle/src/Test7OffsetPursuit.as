package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import walle.Car;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class Test7OffsetPursuit extends Sprite
	{
		private var car1:Car = new Car();
		private var car2:Car = new Car();
		private var car3:Car = new Car(0XFF00FF);
		private var car4:Car = new Car();
		private var car5:Car = new Car();
		private var car6:Car = new Car();
		
		private var offset1:FFVector = new FFVector();
		private var offset2:FFVector = new FFVector();
		private var offset4:FFVector = new FFVector();
		private var offset5:FFVector = new FFVector();
		private var offset6:FFVector = new FFVector();
		
		private var target:FFVector = new FFVector(400, 300);
		public function Test7OffsetPursuit()
		{
			super();
			
			this.addChild(car1);
			car1.intelligent.position.setTo(100, 100);
			car1.intelligent.maxForce = 10;
			offset1.setTo(-50, -50);
			
			this.addChild(car2);
			car2.intelligent.position.setTo(700, 500);
			car2.intelligent.maxForce = 10;
			offset2.setTo(-50, 50);
			
			this.addChild(car3);
			car3.intelligent.maxSpeed = 12;
			car3.intelligent.position.setTo(400, 300);
			
			this.addChild(car4);
			car4.intelligent.position.setTo(200, 200);
			car4.intelligent.maxForce = 10;
			offset4.setTo(-100, -100);
			
			this.addChild(car5);
			car5.intelligent.position.setTo(300, 300);
			car5.intelligent.maxForce = 10;
			offset5.setTo(-100, 0);
			
			this.addChild(car6);
			car6.intelligent.position.setTo(400, 400);
			car6.intelligent.maxForce = 10;
			offset6.setTo(-100, 100);
			
			
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
			
			SteeringBehaviors.offsetPursuit(car3.intelligent, car1.intelligent, offset1);
			SteeringBehaviors.offsetPursuit(car3.intelligent, car2.intelligent, offset2);
			SteeringBehaviors.offsetPursuit(car3.intelligent, car4.intelligent, offset4);
			SteeringBehaviors.offsetPursuit(car3.intelligent, car5.intelligent, offset5);
			SteeringBehaviors.offsetPursuit(car3.intelligent, car6.intelligent, offset6);
			
//			SteeringBehaviors.arrive(car3.intelligent, target);
			SteeringBehaviors.wander(car3.intelligent);
			
			car1.udpate(0.0166 * 10);
			car2.udpate(0.0166 * 10);
			car3.udpate(0.0166 * 10);
			car4.udpate(0.0166 * 10);
			car5.udpate(0.0166 * 10);
			car6.udpate(0.0166 * 10);
		}
	}
}