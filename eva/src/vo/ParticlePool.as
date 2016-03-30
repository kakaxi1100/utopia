package vo
{
	public class ParticlePool
	{
		private var mPool:Vector.<Particle> = new Vector.<Particle>();
		//pointer the first abailable postion
//		private var mCursor:uint = 0;
		private static var instance:ParticlePool = null;
		public function ParticlePool(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
		}
		public static function getInstance():ParticlePool
		{
			return instance ||= new ParticlePool(new O());
		}
		
		public function createParticle():Particle
		{
			var p:Particle;
			if(mPool.length == 0)
			{
				p = new Particle();
				p.init();
//				mPool.push(p);
			}else
			{
				p = mPool.pop();
			}
			return p;
		}
		
		public function removeParticle(p:Particle):Boolean
		{
			mPool.push(p);
			return true;
		}
		
		public function unused():uint
		{
			return mPool.length;
		}
	}
}

class O
{
	
}