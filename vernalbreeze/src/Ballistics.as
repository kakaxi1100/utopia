package
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import org.ares.vernalbreeze.VBParticle;
	import org.ares.vernalbreeze.VBVector;
	
	import test.shape.Bullet;
	
	public class Ballistics extends Sprite
	{
		private var particle:VBParticle;
		private var bullet:Bullet;
		private var startTime:Number = 0;
		private var lastTime:Number = 0;
		
		private var mass:Number = 0.5;
		private var speed:Number = 80;
		private var acc:Number = 20;
		private var damping:Number = 1;
		public function Ballistics()
		{
			super();
			bullet = new Bullet();
			this.addChild(bullet);
		}
		
		public function fire():void
		{
			if(particle == null)
			{
				particle = new VBParticle();
				particle.mass = mass;
				particle.damping = damping;
				particle.forceAccum = new VBVector();
				particle.position = new VBVector();
				particle.velocity = new VBVector();
				particle.acceleration = new VBVector();
			}
			particle.position.setTo(50,50);
			bullet.x = particle.position.x;
			bullet.y = particle.position.y;
			particle.velocity.setTo(speed,0);
			particle.acceleration.setTo(0,acc);
			startTime = getTimer()/1000;
		}
		
		public function update():void
		{
			if(particle == null) return;
			lastTime = getTimer()/1000;
			var duration:Number = lastTime - startTime;
			startTime = lastTime;
			particle.integrate(duration);
			bullet.x = particle.position.x;
			bullet.y = particle.position.y;
		}
	}
}