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
		private var rod:VBParticleRod = new VBParticleRod();
		private var contact:VBParticleContact = new VBParticleContact();
		
		private var p0:MassPoint = new MassPoint();
		private var p1:MassPoint = new MassPoint();
		public function RodTest()
		{
			super();
			addChild(p0);
			addChild(p1);
			//先声明两个质点
			rod.particle[0] = new VBParticle();
			rod.particle[1] = new VBParticle();
			//为连杆设置属性
			rod.length = 50;
			//为粒子设置属性
			rod.particle[0].mass = 1;
			rod.particle[1].mass = 1;
			rod.particle[0].position = new VBVector(100, 100);
			p0.x = rod.particle[0].position.x;
			p0.y = rod.particle[0].position.y;
			rod.particle[1].position = new VBVector(150, 100);
			p1.x = rod.particle[1].position.x;
			p1.y = rod.particle[1].position.y;
			rod.particle[0].velocity = new VBVector(0, 0);
			rod.particle[1].velocity = new VBVector(0, 0);
			rod.particle[0].acceleration = new VBVector(0, 0);
			rod.particle[1].acceleration = new VBVector(0, 0);
			rod.particle[0].damping = 1;
			rod.particle[1].damping = 1;
			//填充碰撞器
			rod.fillContact(contact, 1);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHd);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onKeyUpHd(event:KeyboardEvent):void
		{
			rod.particle[1].position.x -= 2;
		}
		
		protected function onEnterFrame(event:Event):void
		{
			lastTime = getTimer()/1000;
			var duration:Number = lastTime - startTime;
			startTime = lastTime;
			if(rod.fillContact(contact, 1) == 1)
			{
				contact.resolve(duration);
				p0.x = rod.particle[0].position.x;
				p0.y = rod.particle[0].position.y;
				p1.x = rod.particle[1].position.x;
				p1.y = rod.particle[1].position.y;
			}
		}
	}
}