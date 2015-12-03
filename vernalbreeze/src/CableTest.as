package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import org.ares.vernalbreeze.VBAnchoredSpringForce;
	import org.ares.vernalbreeze.VBParticle;
	import org.ares.vernalbreeze.VBParticleCable;
	import org.ares.vernalbreeze.VBParticleContact;
	import org.ares.vernalbreeze.VBParticleRod;
	import org.ares.vernalbreeze.VBVector;
	
	import test.shape.MassPoint;

	[SWF(frameRate="60", backgroundColor="0",height="300",width="300")]
	public class CableTest extends Sprite
	{
		private var startTime:Number = 0;
		private var lastTime:Number = 0;
		
		private var p0:VBParticle = new VBParticle();
		private var p1:VBParticle = new VBParticle();
		private var p2:VBParticle = new VBParticle();
		
		private var s0:MassPoint = new MassPoint();
		private var s1:MassPoint = new MassPoint();
		private var s2:MassPoint = new MassPoint();
		
		private var contact0:VBParticleContact = new VBParticleContact();
		private var contact1:VBParticleContact = new VBParticleContact();
		
		private var cable0:VBParticleCable = new VBParticleCable();
		private var rod0:VBParticleRod = new VBParticleRod();
		
		public function CableTest()
		{
			super();
			
			addChild(s0);
			addChild(s1);
			addChild(s2);
			
			p0.init();
			p1.init();	
			p2.init();
			
			//将一端固定
			p0.mass = Number.MAX_VALUE;
//			p1.damping = 0.9;
			
			p0.position.setTo(100,100);
			p1.position.setTo(100,140);
			p2.position.setTo(100,180);
			//根据物体的质量来绘图
			s0.scaleX = s0.scaleY = 1//p0.mass;
			s1.scaleX = s1.scaleY = p1.mass;
			s0.x = p0.position.x;
			s0.y = p0.position.y;
			s1.x = p1.position.x;
			s1.y = p1.position.y;
			s2.x = p2.position.x;
			s2.y = p2.position.y;
			
			cable0.particle[0] = p0;
			cable0.particle[1] = p1;
			cable0.maxLength = 40;
			cable0.restitution = 1;
			cable0.fillContact(contact0,1);
			
			rod0.particle[0] = p1;
			rod0.particle[1] = p2;
			rod0.length = 40;
			rod0.fillContact(contact1, 1);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHd);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onKeyUpHd(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					p2.velocity.plusEquals(new VBVector(-80, 0));
					break;
				case Keyboard.RIGHT:
					p2.velocity.plusEquals(new VBVector(80, 0));
					break;
				case Keyboard.UP:
					p1.addForce(new VBVector(0,-500));
//					p1.velocity.plusEquals(new VBVector(0,100));
//					p1.acceleration.plusEquals(new VBVector(0,-100));
					break;
				case Keyboard.DOWN:
//					p1.position.plusEquals(new VBVector(0,10));
					p1.velocity.plusEquals(new VBVector(0,80));
					break;
				case Keyboard.SPACE:
					break;
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0xffffff);
			this.graphics.moveTo(p0.position.x, p0.position.y);
			this.graphics.lineTo(p1.position.x, p1.position.y);
			this.graphics.moveTo(p1.position.x, p1.position.y);
			this.graphics.lineTo(p2.position.x, p2.position.y);
			
			lastTime = getTimer()/1000;
			var duration:Number = lastTime - startTime;
			startTime = lastTime;
//			p1.addForce(new VBVector(0, 500));
//			p2.addForce(new VBVector(0, 500));
			p0.integrate(duration);
			p1.integrate(duration);
			p2.integrate(duration);
			if(cable0.fillContact(contact0, 1) == 1)
			{
				contact0.resolve(duration);
			}
			if(rod0.fillContact(contact1, 1) == 1)
			{
				contact1.resolve(duration);
			}
			s0.x = p0.position.x;
			s0.y = p0.position.y;
			s1.x = p1.position.x;
			s1.y = p1.position.y;
			s2.x = p2.position.x;
			s2.y = p2.position.y;
		}
	}
}