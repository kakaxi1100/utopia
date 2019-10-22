package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import walle.Car;
	import walle.Circle;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	import walle.Utils;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class Test4ObstacleAvoidance extends Sprite
	{
		private var car:Car = new Car();
		private var target:FFVector = new FFVector();
		private var clist:Array = [];
		public function Test4ObstacleAvoidance()
		{
			super();
			
			this.addChild(car);
			car.intelligent.position.setTo(200, 340);
			car.intelligent.velocity.setTo(10, 0);
			
			for(var i:int = 0; i < 10; i++)
			{
//				var c:Circle = new Circle(100);
//				c.x = (stage.stageWidth - c.radius) * 0.5;
//				c.y = (stage.stageHeight - c.radius) * 0.5;
				
				var c:Circle = new Circle(Math.random()*40 + 20);
				c.x = Utils.randomRange(c.radius, stage.stageWidth - c.radius);
				c.y = Utils.randomRange(c.radius, stage.stageHeight - c.radius);
				clist.push(c);
			}
			
//			SteeringBehaviors.avoid(car.intelligent, clist);
//			car.udpate(0.0166 * 10);
//			this.draw();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			for(var i:int = 0; i < clist.length; i++)
			{
				var c:Circle = clist[i];
				c.x = Utils.randomRange(c.radius, stage.stageWidth - c.radius);
				c.y = Utils.randomRange(c.radius, stage.stageHeight - c.radius);
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			target.setTo(event.stageX, event.stageY);
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawCircle(event.stageX,event.stageY,2);
			
			SteeringBehaviors.avoid(car.intelligent, clist, this.graphics);
			car.udpate(0.0166 * 10);
			this.draw();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			this.graphics.clear();
			
//			SteeringBehaviors.arrive(car.intelligent, target);
			SteeringBehaviors.wander(car.intelligent);
			SteeringBehaviors.avoid(car.intelligent, clist, this.graphics);
			car.udpate(0.0166 * 10);
			
			this.draw();
		}
		
		private function draw():void
		{
			this.graphics.lineStyle(1, 0);
			for(var i:int = 0; i < clist.length; i++)
			{
				this.graphics.drawCircle(clist[i].x, clist[i].y, clist[i].radius);
			}
		}
	}
}