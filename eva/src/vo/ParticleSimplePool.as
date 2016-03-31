package vo
{
	public class ParticleSimplePool
	{
		private var mPool:Vector.<ParticleSimple> = new Vector.<ParticleSimple>();
		private static var instance:ParticleSimplePool = null;
		public function ParticleSimplePool(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
		}
		public static function getInstance():ParticleSimplePool
		{
			return instance ||= new ParticleSimplePool(new O());
		}
		private var count:uint = 0;
		public function createParticle():ParticleSimple
		{
			var p:ParticleSimple;
			if(mPool.length == 0)
			{
				p = new ParticleSimple();
				p.init();
				trace(count++);
			}else
			{
				p = mPool.pop();
			}
			return p;
		}
		
		public function removeParticle(p:ParticleSimple):Boolean
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