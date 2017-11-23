package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.ares.fireflight.FFRBCircle;
	import org.ares.fireflight.FFRigidBody;
	import org.ares.fireflight.FFVector;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class newEngineTest extends Sprite
	{
		private var mSpeed:Number = 10;
		private var objs:Vector.<FFRigidBody> = new Vector.<FFRigidBody>();
		public function newEngineTest()
		{
			super();
			
			createBodies();
			objs[0].name = "circle red";
			objs[0].mass = 10;
			objs[0].velocity.setTo(0, 2);
			objs[0].position.setTo(320, 100);
			objs[1].name = "circle green";
			objs[1].mass = 10;
			objs[1].position.setTo(350, 250);
			drawObjs();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			moving();
		}
		
		private function moving():void
		{
			var i:int;
			for(; i < objs.length; i++)
			{
				objs[i].position.plusEquals(objs[i].velocity);
			}
			test();
			drawObjs();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			var keyPressed:Boolean = true;
			switch(event.keyCode)
			{
				case Keyboard.UP:
				{
					objs[0].position.plusEquals(new FFVector(0, -mSpeed));
					break;
				}
				case Keyboard.DOWN:
				{
					objs[0].position.plusEquals(new FFVector(0, mSpeed));
					break;
				}
				case Keyboard.LEFT:
				{
					objs[0].position.plusEquals(new FFVector(-mSpeed, 0));
					break;
				}
				case Keyboard.RIGHT:
				{
					objs[0].position.plusEquals(new FFVector(mSpeed, 0));
					break;
				}
				default:
				{
					keyPressed = false;
					break;
				}
			}
			
			if(keyPressed)
			{
				test();
				drawObjs();
			}
		}
		
		private function test():void
		{
			var i:int;
			var j:int;
			for(; i < objs.length; i++)
			{
				for(j = i + 1; j < objs.length; j++)
				{
					objs[i].test(objs[j]);
				}
			}
		}
		
		
		private function createBodies():void
		{
			var i:int;
			for(; i < 2; i++)
			{
				var c:FFRBCircle = new FFRBCircle();
				objs.push(c);
			}
		}
		
		private function drawObjs():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			
			objs[0].draw(this.graphics, 0xff0000);
			objs[1].draw(this.graphics, 0x00ff00);
		}
	}
}