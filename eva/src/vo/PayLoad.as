package vo
{
	public class PayLoad
	{
		public var posx:Number = 0;
		public var posy:Number = 0;
		public var color:uint = 0;
		
		private var plist:Vector.<Particle> = new Vector.<Particle>();
		public function PayLoad()
		{
		}
		
		public function addParticle(vx:Number, vy:Number, life:Number):void
		{
			var p:Particle = new Particle();
			p.init();
			p.position.setTo(posx, posy);
			p.velocity.setTo(vx, vy);
			p.damping = 0.99;
			p.lifespan = life;
			p.color = color;
			
			plist.push(p);
		}
	}
}