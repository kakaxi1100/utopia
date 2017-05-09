package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.base.FFFForceGravity;
	import org.ares.fireflight.base.FFForceDrag;
	import org.ares.fireflight.base.FFForceManager;
	import org.ares.fireflight.base.FFVector;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class ForceTest extends Sprite
	{
		private var shot:Shot = new Shot(0xff00);
		private var shot2:Shot = new Shot(0x00ffff);
		private var dt:Number;
		public function ForceTest()
		{
			super();
			shot.setXY(10,10);
			addChild(shot);
			
			shot2.setXY(10,10);
			addChild(shot2);
			
			changeType("PISTOL");
			dt = getTimer();
			
			FFForceManager.getIntsance().registerForce(new FFFForceGravity("G", new FFVector(0, 20))).registerForce(new FFForceDrag("F", 0.01, 0.001));
			
			FFForceManager.getIntsance().getForce("G").addParticle(shot.p).addParticle(shot2.p);
			FFForceManager.getIntsance().getForce("F").addParticle(shot.p);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function changeType(type:String):void
		{
			switch(type)
			{
				case "PISTOL":
					shot.p.mass = 1;
					shot.p.velocity.setTo(50,0);
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
			shot2.update(dt/1000);
			dt = getTimer();
		}
	}
}