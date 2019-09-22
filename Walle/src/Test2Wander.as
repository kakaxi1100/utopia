package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import walle.Car;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	public class Test2Wander extends Sprite
	{
		private var car:Car = new Car();
		private var target:FFVector = new FFVector();
		private var needEnterFrame:Boolean = true;
		
		private var wanderContainer:Sprite = new Sprite();
		public function Test2Wander()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addChild(car);
			car.intelligent.position.setTo(100, 100);
			this.addChild(wanderContainer);
			
			
			if(needEnterFrame)
			{
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}else
			{
				car.intelligent.velocity.setTo(0, 1);
				SteeringBehaviors.wander(car.intelligent);
				car.udpate(0.0166 * 10);
			}
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
			SteeringBehaviors.wander(car.intelligent);
			car.udpate(0.0166 * 10);
			drawWander();
		}
		
		private function drawWander():void
		{
			this.wanderContainer.graphics.clear();
			this.wanderContainer.graphics.lineStyle(1, 0x00FF00);
			this.wanderContainer.graphics.drawCircle( car.intelligent.head.x * car.intelligent.wanderDist + car.intelligent.position.x, 
													  car.intelligent.head.y * car.intelligent.wanderDist + car.intelligent.position.y, 
													  car.intelligent.wanderRadius);
			
			this.wanderContainer.graphics.lineStyle(1, 0xFFFF00);
			this.wanderContainer.graphics.drawCircle(car.intelligent.wanderTarget.x + car.intelligent.position.x, 
													 car.intelligent.wanderTarget.y + car.intelligent.position.y, 
													 2);
			
		}
	}
}