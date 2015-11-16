package org.ares.vernalbreeze
{
	/**
	 *粒子承载器
	 * 对应一个规则，和这个规则下有多少个粒子 
	 * @author JuLi
	 * 
	 */	
	public class VBPayLoad
	{
		//粒子对应的规则
		private var mRule:VBFireworkRule;
		//粒子的数量
		private var mParticleCount:int;
		//粒子的集合
		private var mParticles:Array;
		//粒子工厂
		private var mParticlesFactory:VBFireworkFactory;
		public function VBPayLoad(prule:VBFireworkRule, pparticleCount:int, pparticlesFactory:VBFireworkFactory)
		{
			mRule = prule;
			mParticleCount = pparticleCount;
			mParticlesFactory = pparticlesFactory;
			mParticles = [];
		}
		
		public function createParticle():void
		{
			for(var i:int = 0; i < particleCount; i++)
			{
				var temp:VBFirework = mParticlesFactory.create();
				mRule.wrap(temp);
				mParticles.push(temp);
			}
		}

		public function get rule():VBFireworkRule
		{
			return mRule;
		}

		public function set rule(value:VBFireworkRule):void
		{
			mRule = value;
		}

		public function get particleCount():int
		{
			return mParticleCount;
		}

		public function set particleCount(value:int):void
		{
			mParticleCount = value;
		}


	}
}