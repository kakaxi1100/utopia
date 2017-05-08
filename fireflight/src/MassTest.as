package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class MassTest extends Sprite
	{
		private var shot:Shot = new Shot(0xFF00);
		private var dt:Number;
		public function MassTest()
		{
			super();
			shot.setXY(10,10);
			addChild(shot);
			changeType("LASER");
			dt = getTimer();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function changeType(type:String):void
		{
			switch(type)
			{
				case "PISTOL":
					shot.p.mass = 2;
					shot.p.velocity.setTo(35,0);
					shot.p.acceleration.setTo(0,1);
					shot.p.damping = 1;
					break;
				case "ARTILLERY":
					shot.p.mass = 200;
					shot.p.velocity.setTo(30,40);
					shot.p.acceleration.setTo(20,1);
					shot.p.damping = 1;
					break;
				case "FIREBALL":
					shot.p.mass = 1;
					shot.p.velocity.setTo(10,0);
					shot.p.acceleration.setTo(0,0.6);
					shot.p.damping = 1;
					break;
				case "LASER":
					shot.p.mass = 0.1;
					shot.p.velocity.setTo(100,0);
					shot.p.acceleration.setTo(0,0);
					shot.p.damping = 0.99;
					break;
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			shot.update(dt/1000);
			dt = getTimer();
		}
	}
}