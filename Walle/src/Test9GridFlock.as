package
{
	import com.sociodox.theminer.TheMiner;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import walle.Car;
	import walle.CellSpacePartition;
	import walle.FFVector;
	import walle.SteeringBehaviors;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	public class Test9GridFlock extends Sprite
	{
		private var target:FFVector = new FFVector();
		private var wanderContainer:Sprite = new Sprite();
		
		private var list:Array = [];
		private var listI:Array = [];
		
		private var text:TextField = new TextField();
		public function Test9GridFlock()
		{
			super();
			
			addChild(new TheMiner());
						
			addChild(text);
			text.text = "1";
			text.y = 100;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			CellSpacePartition.getInstance().init(stage.stageWidth, stage.stageHeight, 10, 10);
			
			
			for(var i:int = 0; i < 1; i++)
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
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
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
			SteeringBehaviors.flock_grid(listI);
//			SteeringBehaviors.flock_truncate(listI);
			update(0.0166 * 10);
		}
		
		private function update(dt:Number):void
		{
//			SteeringBehaviors.wander(list[0].intelligent);
			for(var i:int = 0; i < list.length; i++)
			{
				var car:Car = list[i];
				car.udpate(dt);
			}
			
			this.render();
		}
		
		private function render():void
		{
			this.graphics.clear();
			CellSpacePartition.getInstance().renderCells(this.graphics);
		}
	}
}