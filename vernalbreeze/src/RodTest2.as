package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import org.ares.vernalbreeze.VBParticle;
	import org.ares.vernalbreeze.VBParticleContact;
	import org.ares.vernalbreeze.VBParticleRod;
	import org.ares.vernalbreeze.VBVector;
	
	import test.shape.MassPoint;
	
	[SWF(frameRate="60", backgroundColor="0",height="600",width="800")]
	public class RodTest2 extends Sprite
	{
		private var startTime:Number = 0;
		private var lastTime:Number = 0;
		
		private var rod0:VBParticleRod = new VBParticleRod();
		private var rod1:VBParticleRod = new VBParticleRod();
		
		private var contact0:VBParticleContact = new VBParticleContact();
		private var contact1:VBParticleContact = new VBParticleContact();
		
		private var p0:VBParticle = new VBParticle();
		private var p1:VBParticle = new VBParticle();
		
		private var s0:MassPoint = new MassPoint();
		private var s1:MassPoint = new MassPoint();
		
		public function RodTest2()
		{
			super();
			
			addChild(s0);
			addChild(s1);
			
			p0.init();
			p1.init();
			
			p0.position.setTo(200,200);
			p1.position.setTo(240,200);
			
			rod0.length = 40;
			rod0.particle[0] = p0;
			rod0.particle[1] = p1;
			rod0.fillContact(contact0, 1);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHd);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onKeyUpHd(event:KeyboardEvent):void
		{
			//p0.acceleration.plusEquals(new VBVector(60,0));
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					p1.velocity.minusEquals(new VBVector(100,0));
					break;
				case Keyboard.RIGHT:
					p1.velocity.plusEquals(new VBVector(100,0));
					break;
				case Keyboard.UP:
					p1.velocity.minusEquals(new VBVector(0,10));
					break;
				case Keyboard.DOWN:
					p1.velocity.plusEquals(new VBVector(0,1));
					break;
				case Keyboard.SPACE:
					p1.velocity.plusEquals(new VBVector(100,100));
					break;
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			lastTime = getTimer()/1000;
			var duration:Number = lastTime - startTime;
			startTime = lastTime;
			p0.integrate(duration);
			p1.integrate(duration);
			if(rod0.fillContact(contact0, 1) == 1)
			{
				contact0.resolve(duration);
			}
			
			s0.x = p0.position.x;
			s0.y = p0.position.y;
			s1.x = p1.position.x;
			s1.y = p1.position.y;
		}
	}
}