package vo
{
	public class Payload
	{	
		private var mHead:Particle;
		
		private var mIS:IInitStrategy;
		private var mGS:IGenerationStrategy;
		public function Payload(mIS:IInitStrategy = null, generation:IGenerationStrategy = null)
		{
			mHead = ParticlePool.getInstance().createParticle();
			reset();
			mGS = generation;
		}
		
		public function reset():void
		{
			if(mIS != null)
			{
				mIS.reset(mHead);
			}else{
				mHead.init();
			}
		}
		
		public function update(duration:Number):Boolean
		{
			if(mHead.lifeTime(duration) == false)
			{
				PayloadManager.getInstance().removePayload(this);
				return false;
			}
			if(mGS != null)
			{
				mGS.generation(this);
			}
			mHead.update(duration);
			return true;
		}
	
		public function set generationStragegy(value:IGenerationStrategy):void
		{
			mGS = value;
		}

		public function get generationStragegy():IGenerationStrategy
		{
			return mGS;
		}
		
		public function set initStrategy(value:IInitStrategy):void
		{
			mIS = value;
		}
		
		public function get initStrategy():IInitStrategy
		{
			return mIS;
		}
	}
}