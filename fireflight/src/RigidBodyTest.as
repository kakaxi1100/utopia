package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.base.FFForceAnchoredSpring;
	import org.ares.fireflight.base.FFForceDrag;
	import org.ares.fireflight.base.FFRigidForceAnchoredSpring;
	import org.ares.fireflight.base.FFRigidForceManager;
	import org.ares.fireflight.base.FFVector;
	
	import test.Square;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RigidBodyTest extends Sprite
	{
		private var c:Square = new Square(0xFFFFFF, 100, 20);
		private var dt:Number;
		public function RigidBodyTest()
		{
			super();
			
			c.setXY(150,180);
			c.p.rotationInertia = c.p.mass * (100*100)/12; 
			addChild(c);

			FFRigidForceManager.getIntsance().registerForce(new FFRigidForceAnchoredSpring("A", new FFVector(50, 0), new FFVector(200, 200),4,100));
			FFRigidForceManager.getIntsance().getForce("A").addRigidBody(c.p);
				
			dt = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			dt /= 1000;
			dt = 0.016;
			FFRigidForceManager.getIntsance().updateForce(dt);
			c.update(dt);
			dt = getTimer();
		}
	}
}