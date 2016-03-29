package vo
{
	public class ParticleManager
	{
		private var plist:Vector.<Particle>;
		private var mPool:ParticlePool;
		
		private static var instance:ParticleManager;
		public function ParticleManager(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
			
			plist = new Vector.<Particle>();
			mPool = ParticlePool.getInstance();
		}
		public static function getInstance():ParticleManager
		{
			return instance ||= new ParticleManager(new O());
		}
		
		public function removeParticle(p:Particle):Boolean
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(p == plist[i])
				{
					mPool.removeParticle(plist.splice(i, 1)[0]);
					return true;
				}
			}
			return false;
		}
		
		public function addParticle(p:Particle):void
		{
			plist.push(p);
		}
		
		public function update(duration:Number):void
		{
			var len:uint;
			while(len < plist.length)
			{
				plist[len].update(duration);
				len++;
			}
		}
		
	}
}
class O
{
	
}