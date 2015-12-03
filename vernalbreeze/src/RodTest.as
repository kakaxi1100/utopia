package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	
	import org.ares.vernalbreeze.VBParticle;
	import org.ares.vernalbreeze.VBParticleContact;
	import org.ares.vernalbreeze.VBParticleRod;
	import org.ares.vernalbreeze.VBVector;
	
	import test.shape.MassPoint;

	[SWF(frameRate="60", backgroundColor="0",height="600",width="800")]
	public class RodTest extends Sprite
	{
		private var startTime:Number = 0;
		private var lastTime:Number = 0;
		private var rod0:VBParticleRod = new VBParticleRod();
		private var rod1:VBParticleRod = new VBParticleRod();
		private var rod2:VBParticleRod = new VBParticleRod();
		private var rod3:VBParticleRod = new VBParticleRod();
		private var rod4:VBParticleRod = new VBParticleRod();
		private var rod5:VBParticleRod = new VBParticleRod();
		
		private var contact0:VBParticleContact = new VBParticleContact();
		private var contact1:VBParticleContact = new VBParticleContact();
		private var contact2:VBParticleContact = new VBParticleContact();
		private var contact3:VBParticleContact = new VBParticleContact();
		private var contact4:VBParticleContact = new VBParticleContact();
		private var contact5:VBParticleContact = new VBParticleContact();

		private var p0:VBParticle = new VBParticle();
		private var p1:VBParticle = new VBParticle();
		private var p2:VBParticle = new VBParticle();
		private var p3:VBParticle = new VBParticle();

		
		private var s0:MassPoint = new MassPoint();
		private var s1:MassPoint = new MassPoint();
		private var s2:MassPoint = new MassPoint();
		private var s3:MassPoint = new MassPoint();
		public function RodTest()
		{
			super();
			addChild(s0);
			addChild(s1);
			addChild(s2);
			addChild(s3);
			
			p0.init();
			p1.init();
			p2.init();
			p3.init();
			//将质点连接起来
			rod0.particle[0] = p0;
			rod0.particle[1] = p1;
			rod1.particle[0] = p1;
			rod1.particle[1] = p2;
			rod2.particle[0] = p2;
			rod2.particle[1] = p3;
			rod3.particle[0] = p3;
			rod3.particle[1] = p0;
			rod4.particle[0] = p0;
			rod4.particle[1] = p2;
			rod5.particle[0] = p1;
			rod5.particle[1] = p3;
				
			//为连杆设置属性
			rod0.length = 40;
			rod1.length = 40;
			rod2.length = 40;
			rod3.length = 40;
			rod4.length = 56.5685;
			rod5.length = 56.5685;
			
			//为粒子设置属性
//			rod0.particle[0].mass = 1;
//			rod0.particle[1].mass = 1;
//			rod1.particle[1].mass = 1;
//			rod2.particle[1].mass = 1;
			
			p0.position.setTo(200,200);
			//rod0.particle[0].position = new VBVector(200, 200);
			s0.x = p0.position.x;
			s0.y = p0.position.y;
			//rod0.particle[1].position = new VBVector(240, 200);
			p1.position.setTo(240,200);
			s1.x = p1.position.x;
			s1.y = p1.position.y;
			
			p2.position.setTo(240,240);
			//rod1.particle[1].position = new VBVector(240, 240);
			s2.x = p2.position.x;
			s2.y = p2.position.y;
			
			p3.position.setTo(200,240);
			//rod2.particle[1].position = new VBVector(200, 240);
			s3.x = p3.position.x;
			s3.y = p3.position.y;
			
//			rod0.particle[0].velocity = new VBVector(0, 0);
//			rod0.particle[1].velocity = new VBVector(0, 0);
//			rod1.particle[1].velocity = new VBVector(0, 0);
//			rod2.particle[1].velocity = new VBVector(0, 0);
//			
//			rod0.particle[0].acceleration = new VBVector(0, 0);
//			rod0.particle[1].acceleration = new VBVector(0, 0);
//			rod1.particle[1].acceleration = new VBVector(0, 0);
//			rod2.particle[1].acceleration = new VBVector(0, 0);
//			
//			rod0.particle[0].damping = 1;
//			rod0.particle[1].damping = 1;
//			rod1.particle[1].damping = 1;
//			rod2.particle[1].damping = 1;

			//填充碰撞器
			rod0.fillContact(contact0, 1);
			rod1.fillContact(contact1, 1);
			rod2.fillContact(contact2, 1);
			rod3.fillContact(contact3, 1);
			rod4.fillContact(contact4, 1);
			rod5.fillContact(contact5, 1);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHd);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onKeyUpHd(event:KeyboardEvent):void
		{
//			p1.position.plusEquals(new VBVector(10,0)) ;
//			p1.velocity.plusEquals(new VBVector(80, 0));
//			p1.acceleration.plusEquals(new VBVector(80, 0));
//			p2.acceleration.plusEquals(new VBVector(80,0));
//			p3.acceleration.plusEquals(new VBVector(80,0));
		}
		
		protected function onEnterFrame(event:Event):void
		{
			lastTime = getTimer()/1000;
			var duration:Number = lastTime - startTime;
			startTime = lastTime;
			p0.integrate(duration);
			p1.integrate(duration);
			p2.integrate(duration);
			p3.integrate(duration);
			
			if(rod0.fillContact(contact0, 1) == 1)
			{
				contact0.resolve(duration);
			}
			if(rod1.fillContact(contact1, 1) == 1)
			{
				contact1.resolve(duration);
			}
			if(rod2.fillContact(contact2, 1) == 1)
			{
				contact2.resolve(duration);
			}
			if(rod3.fillContact(contact3, 1) == 1)
			{
				contact3.resolve(duration);
			}
			if(rod4.fillContact(contact4, 1) == 1)
			{
				contact4.resolve(duration);
			}
			if(rod5.fillContact(contact5, 1) == 1)
			{
				contact5.resolve(duration);
			}
			
			s0.x = rod0.particle[0].position.x;
			s0.y = rod0.particle[0].position.y;
			s1.x = rod0.particle[1].position.x;
			s1.y = rod0.particle[1].position.y;
			s2.x = rod1.particle[1].position.x;
			s2.y = rod1.particle[1].position.y;
			s3.x = rod2.particle[1].position.x;
			s3.y = rod2.particle[1].position.y;
		}
	}
}