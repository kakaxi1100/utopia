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
	public class Test8Flock extends Sprite
	{
		private var target:FFVector = new FFVector();
		private var wanderContainer:Sprite = new Sprite();
		
		private var list:Array = [];
		private var listI:Array = [];
		public function Test8Flock()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			for(var i:int = 0; i < 10; i++)
			{
				var car:Car = new Car();
				list.push(car);
				listI.push(car.intelligent);
				addChild(car);
			}
			
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
			SteeringBehaviors.calculate(listI);
			update(0.0166 * 10);
		}
		
		private function update(dt:Number):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var car:Car = list[i];
				SteeringBehaviors.wander(car.intelligent);
				car.udpate(dt);
			}
		}
	}
}