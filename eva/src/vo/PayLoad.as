package vo
{
	public class PayLoad
	{
		public var color:uint = 0;
		
		private var mHead:Particle;
		
		public var plist:Vector.<Particle> = new Vector.<Particle>();
		public function PayLoad()
		{
		}
		
		public function addParticle(posx:Number, posy:Number,vx:Number, vy:Number, life:Number):Particle
		{
			var p:Particle = new Particle();
			p.init();
			p.position.setTo(posx, posy);
			p.velocity.setTo(vx, vy);
			p.damping = 0.99;
			p.lifespan = life;
			p.color = color;
			if(mHead == null)
			{
				mHead = p;
			}else{
				plist.push(p);
			}
			return p;
		}

		public function length():uint
		{
			return plist.length;
		}
		
		public function get head():Particle
		{
			return mHead;
		}
	}
}