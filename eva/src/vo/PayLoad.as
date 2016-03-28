package vo
{
	public class PayLoad
	{	
		private var mHead:Particle;
		
		public var plist:Vector.<Particle> = new Vector.<Particle>();
		
		private var gs:IGenerationStrategy;
		public function PayLoad(head:Particle = null, generation:IGenerationStrategy = null)
		{
			mHead = head;
			gs = generation;
		}
		
		public function update(duration:Number):void
		{
			/*generate particles*/
			if(gs != null)
			{
				gs.generation(this);
			}
			/*filter & transform apply on bitmap*/
			var len:uint = 0;
			while(len < plist.length)
			{
				plist[len].update(duration);
				len++;
			}
			mHead.update(duration);
			
		}
		
		public function addParticle(posx:Number, posy:Number,vx:Number, vy:Number, life:Number, color:uint):Particle
		{
			var p:Particle = new Particle();
			p.init();
			p.position.setTo(posx, posy);
			p.velocity.setTo(vx, vy);
			p.damping = 0.99;
			p.lifespan = life;
			p.color = color;
			plist.push(p);

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