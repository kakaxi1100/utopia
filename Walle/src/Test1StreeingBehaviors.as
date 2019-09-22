package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import walle.Car;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class Test1StreeingBehaviors extends Sprite
	{
		private var car:Car = new Car();
		private var target:FFVector = new FFVector();
		public function Test1StreeingBehaviors()
		{
			super();
			
			this.addChild(car);
			car.intelligent.position.setTo(100, 100);
			
			
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
//			SteeringBehaviors.seek(car.intlligent, 	target);
//			SteeringBehaviors.flee(car.intlligent, 	target);
			SteeringBehaviors.arrive(car.intelligent, 	target);
			car.udpate(0.0166 * 10);
		}
	}
}