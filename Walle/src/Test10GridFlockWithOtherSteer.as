package
{
	import com.sociodox.theminer.TheMiner;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import walle.Car;
	import walle.CellSpacePartition;
	import walle.Circle;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	import walle.Utils;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	public class Test10GridFlockWithOtherSteer extends Sprite
	{
		private var target:FFVector = new FFVector();
		private var wanderContainer:Sprite = new Sprite();
		
		private var list:Array = [];
		private var listI:Array = [];
		
		private var clist:Array = [];
		private var wolf:Car;
		
		private var isWolfOn:Boolean = false;
		private var isObstacleOn:Boolean = false;
		private var isPursuitOn:Boolean = false;
		
		private var text:TextField = new TextField();
		public function Test10GridFlockWithOtherSteer()
		{
			super();
			
			addChild(new TheMiner());
			
			addChild(text);
			text.text = "1";
			text.y = 100;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			CellSpacePartition.getInstance().init(stage.stageWidth, stage.stageHeight, 10, 10);
			
			var i:int = 0;
			for(i = 0; i < 1; i++)
			{
				var car:Car;
				if(i == 0)
				{
					car = new Car(0xFFFFFF);
					//					car.intelligent.velocity.setTo(100, 0);
				}else
				{
					car = new Car();
				}
				//				car.intelligent.position.setTo(Math.random() * 800, Math.random() * 600);
				car.intelligent.position.setTo(400 + i * 5, 300 + i * 5);
				//				car.intelligent.position.setTo(400, 300);
				list.push(car);
				listI.push(car.intelligent);
				addChild(car);
			}
			
			wolf = new Car(0XFF0000);
//			wolf.intelligent.velocity.setTo(Math.random() * 10, Math.random() * 10);
//			addChild(wolf);
			
			for(i = 0; i < 5; i++)
			{
//				var c:Circle = new Circle(100);
//				c.x = (stage.stageWidth - c.radius) * 0.5;
//				c.y = (stage.stageHeight - c.radius) * 0.5;
				
				var c:Circle = new Circle(Math.random() * 40 + 20);
				c.x = Utils.randomRange(c.radius, stage.stageWidth - c.radius);
				c.y = Utils.randomRange(c.radius, stage.stageHeight - c.radius);
				clist.push(c);
			}
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.SPACE:
				{
					isObstacleOn = !isObstacleOn;
					
					if(isObstacleOn)
					{
						for(var i:int = 0; i < clist.length; i++)
						{
							var c:Circle = clist[i];
							c.x = Utils.randomRange(c.radius + 20, stage.stageWidth - 20 - c.radius);
							c.y = Utils.randomRange(c.radius + 20, stage.stageHeight - 20 - c.radius);
						}
					}
					break;
				}
					
				case Keyboard.A:
				{
					isWolfOn = !isWolfOn;
					if(!isWolfOn)
					{
						if(this.contains(wolf))
						{
							removeChild(wolf);
							wolf.stop();
						}
					}else{
						wolf.start();
						addChild(wolf);
					}
					break;
				}
					
				case Keyboard.B:
				{
					isPursuitOn = !isPursuitOn;
					break;
				}
					
				default:
				{
					break;
				}
			}

		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			target.setTo(event.stageX, event.stageY);
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawCircle(event.stageX,event.stageY,2);
			
			var car:Car = new Car();
			addChild(car);
			car.intelligent.position.setTo(event.stageX + Math.random() * 10, event.stageY + Math.random() * 10);
			list.push(car);
			listI.push(car.intelligent);
			
			text.text = list.length.toString();
		}
		
		protected function onEnterFrame(event:Event):void
		{
//			SteeringBehaviors.arrive(list[0].intelligent, target);
//			SteeringBehaviors.calculate_truncate(listI);
//			SteeringBehaviors.flock(listI);
//			SteeringBehaviors.flock_truncate(listI);
			if(isWolfOn)
			{
				if(!isPursuitOn)
				{
					SteeringBehaviors.wander(wolf.intelligent);
				}else{
					SteeringBehaviors.pursuit(wolf.intelligent, list[0].intelligent);
				}
				SteeringBehaviors.avoid(wolf.intelligent, clist, this.graphics);
			}
			if(isObstacleOn)
			{
				for(var i:int = 0; i < list.length; i++)
				{
					var car:Car = list[i];
					SteeringBehaviors.avoid(car.intelligent, clist, this.graphics);
				}
			}
			SteeringBehaviors.flock_grid(listI);
			
			update(0.0166 * 10);
			
		}
		
		private function update(dt:Number):void
		{
			//			SteeringBehaviors.wander(list[0].intelligent);
			for(var i:int = 0; i < list.length; i++)
			{
				var car:Car = list[i];
				if(isWolfOn)
				{
					SteeringBehaviors.evade(wolf.intelligent, car.intelligent);
				}
				car.udpate(dt);
			}
			wolf.udpate(dt);
			this.render();
		}
		
		private function render():void
		{
			this.graphics.clear();
			CellSpacePartition.getInstance().renderCells(this.graphics);
			if(isObstacleOn)
			{
				this.graphics.lineStyle(1, 0);
				for(var i:int = 0; i < clist.length; i++)
				{
					this.graphics.drawCircle(clist[i].x, clist[i].y, clist[i].radius);
				}
			}
		}
	}
}