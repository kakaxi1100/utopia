package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import walle.Car;
	import walle.FFVector;
	import walle.Path;
	import walle.SteeringBehaviors;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class Test6FollowPath extends Sprite
	{
		private var car:Car = new Car();
		private var path:Path = new Path();
		private var target:FFVector = new FFVector();
		public function Test6FollowPath()
		{
			super();
			
			path.loop = false;
			
			path.list = [
							new FFVector(100, 100),
							new FFVector(200, 300),
							new FFVector(150, 260),
							new FFVector(400, 200),
							new FFVector(600, 20),
							new FFVector(80, 400)
			];
			path.arriveList = [10, 10, 10, 10, 10, 10];
			
			this.drawPath();
			
			this.addChild(car);
			car.intelligent.position.setTo(0, 0);
			car.intelligent.maxForce = 8;
			car.intelligent.maxSpeed = 12;
			
			
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
			SteeringBehaviors.followPath(car.intelligent, path);
			car.udpate(0.0166 * 10);
		}
		
		public function drawPath():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(2, 0);
			this.graphics.drawCircle(this.path.list[0].x, this.path.list[0].y, this.path.arriveList[0]);
			this.graphics.moveTo(this.path.list[0].x, this.path.list[0].y);
			for(var i:int = 1; i < this.path.list.length; i++)
			{
				var p:FFVector = path.list[i];
				this.graphics.lineTo(p.x, p.y);
				this.graphics.drawCircle(p.x, p.y, this.path.arriveList[i]);
			}
		}
	}
}