package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.FFRBCircle;
	import org.ares.fireflight.FFRigidForceAnchoredSpring;
	import org.ares.fireflight.FFRigidForceGravity;
	import org.ares.fireflight.FFRigidForceManager;
	import org.ares.fireflight.FFVector;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RigidBodySpringForceTest extends Sprite
	{
		private var circle1:FFRBCircle = new FFRBCircle(50);
		private var dt:Number;
		public function RigidBodySpringForceTest()
		{
			super();
			
			circle1.position.setTo(350, 250);
			circle1.draw();
			draw();
			
			
			FFRigidForceManager.getIntsance().registerForce(new FFRigidForceAnchoredSpring("A", new FFVector(-10, -10), new FFVector(300, 150),10,100))
											 .registerForce(new FFRigidForceAnchoredSpring("A1", new FFVector(10, -10), new FFVector(400, 150),100,100))
											 .registerForce(new FFRigidForceGravity("G", new FFVector(0, 10)))
											 .registerForce(new FFRigidForceGravity("W", new FFVector(100, 0)));
			FFRigidForceManager.getIntsance().getForce("A").addRigidBody(circle1);
			FFRigidForceManager.getIntsance().getForce("A1").addRigidBody(circle1);
			FFRigidForceManager.getIntsance().getForce("G").addRigidBody(circle1);
			FFRigidForceManager.getIntsance().getForce("W").addRigidBody(circle1);
			
			addChild(circle1.drawSprite);
			addChild(FFRigidForceManager.getIntsance().getForce("A").drawSprite);
			addChild(FFRigidForceManager.getIntsance().getForce("A1").drawSprite);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			dt /= 1000;
			dt = 0.016;
			FFRigidForceManager.getIntsance().updateForce(dt);
			circle1.integrate(dt);
			draw();
			dt = getTimer();
		}
		
		public function draw():void{
			circle1.drawSprite.x = circle1.position.x;
			circle1.drawSprite.y = circle1.position.y;
			circle1.drawSprite.rotation = circle1.angle;
		}
	}
}