package org.ares.fireflight_v1.pool
{
	import org.ares.fireflight_v1.FFParticle;

	public class FFParticlePool
	{
		private var mPool:Vector.<FFParticle> = new Vector.<FFParticle>();

		private static var instance:FFParticlePool = null;
		public function FFParticlePool(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
		}
		public static function getInstance():FFParticlePool
		{
			return instance ||= new FFParticlePool(new O());
		}
		
		private var count:int = 0;
		public function createParticle():FFParticle
		{
			var p:FFParticle;
			if(mPool.length == 0)
			{
				p = new FFParticle();
				p.init();
				++count;
				trace("[Particle::] "+ count);
			}else
			{
				p = mPool.pop();
			}
			return p;
		}
		
		public function removeParticle(p:FFParticle):Boolean
		{
			p.destory();
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