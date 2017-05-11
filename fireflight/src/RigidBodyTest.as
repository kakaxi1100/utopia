package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
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
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_RIGHT;
			
			c.setXY(150,180);
			c.p.rotationInertia = c.p.mass * (50*50)/12; 
			addChild(c);

			FFRigidForceManager.getIntsance().registerForce(new FFRigidForceAnchoredSpring("A", new FFVector(50, 0), new FFVector(200, 200),4,100))
											 .registerForce(new FFRigidForceAnchoredSpring("A2", new FFVector(-50, 0), new FFVector(100, 200),3,100))
											 .registerForce(new FFRigidForceAnchoredSpring("A3", new FFVector(0, 0), new FFVector(150, 100),4,500))
			FFRigidForceManager.getIntsance().getForce("A").addRigidBody(c.p);
			FFRigidForceManager.getIntsance().getForce("A2").addRigidBody(c.p);
			FFRigidForceManager.getIntsance().getForce("A3").addRigidBody(c.p);
				
			dt = getTimer();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private var a:Boolean = false;
		protected function onKeyUp(event:KeyboardEvent):void
		{
			a = true;
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(!a) return;
			dt = getTimer() - dt;
			dt /= 1000;
			dt = 0.016;
			FFRigidForceManager.getIntsance().updateForce(dt);
			c.update(dt);
			dt = getTimer();
			drawAll();
		}
		
		private var temp:FFVector = new FFVector(50, 0);
		private var temp2:FFVector = new FFVector(-50, 0);
		private var temp3:FFVector = new FFVector(0, 0);
		private function drawAll():void
		{
			temp.setTo(50, 0);
			c.p.changeLocalToWorld(temp);

			temp2.setTo(-50, 0);
			c.p.changeLocalToWorld(temp2);
			
			temp3.setTo(0, 0);
			c.p.changeLocalToWorld(temp3);
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xffffff);
			
			this.graphics.drawCircle(200,200, 10);
			this.graphics.drawCircle(150,100, 10);
			this.graphics.drawCircle(100,200, 10);
			
			this.graphics.moveTo(200,200);
			this.graphics.lineTo(temp.x, temp.y);
			
			this.graphics.moveTo(150,100);
			this.graphics.lineTo(temp3.x, temp3.y);
			
			this.graphics.moveTo(100,200);
			this.graphics.lineTo(temp2.x, temp2.y);
			
			
		}
	}
}