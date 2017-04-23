package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.base.FFFForceGravity;
	import org.ares.fireflight.base.FFForceAnchoredSpring;
	import org.ares.fireflight.base.FFForceBungee;
	import org.ares.fireflight.base.FFForceDrag;
	import org.ares.fireflight.base.FFForceManager;
	import org.ares.fireflight.base.FFVector;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class SpringTest extends Sprite
	{
		private var shot:Shot = new Shot();
		private var shot2:Shot = new Shot();
		private var dt:Number;
		public function SpringTest()
		{
			super();
			shot.setXY(220,100);
			addChild(shot);
			
			shot2.setXY(100,100);
			addChild(shot2);
			
			changeType("PISTOL");
			dt = getTimer();
			
			this.graphics.lineStyle(1);
			this.graphics.beginFill(0xFFFF00);
			this.graphics.drawCircle(100,100,10);
			this.graphics.endFill();
			FFForceManager.getIntsance().registerForce(new FFForceAnchoredSpring("A", new FFVector(100, 100),0.1,110));
			FFForceManager.getIntsance().registerForce(new FFForceBungee("B", shot2.p, 0.1, 110));
			
			FFForceManager.getIntsance().getForce("B").addParticle(shot.p);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function changeType(type:String):void
		{
			switch(type)
			{
				case "PISTOL":
					shot.p.mass = 1;
					shot.p.velocity.setTo(0,0);
					shot2.p.mass = 1;
					shot2.p.velocity.setTo(50,0);
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
			FFForceManager.getIntsance().updateForce(dt/1000);
			shot.update(dt/1000);
//			shot2.update(dt/1000);
			trace(shot.p.position);
			dt = getTimer();
		}
	}
}