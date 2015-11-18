package org.ares.vernalbreeze
{
	/**
	 *粒子承载器
	 * 承载器可以是一个矩形范围，粒子坐标是相对于承载起坐标的
	 * 对应一个规则，和这个规则下有多少个粒子 
	 * @author JuLi
	 * 
	 */	
	public class VBPayload
	{
		//粒子对应的规则
		private var mRule:VBFireworkRule;
		//粒子的数量
		private var mParticleCount:int;
		//粒子的集合
		private var mParticles:Array;
		//粒子工厂
		private var mParticlesFactory:VBFireworkFactory;
		public function VBPayload(prule:VBFireworkRule, pparticleCount:int, pparticlesFactory:VBFireworkFactory)
		{
			mRule = prule;
			mParticleCount = pparticleCount;
			mParticlesFactory = pparticlesFactory;
			mParticles = [];
		}
		
		public function update(duration:Number):void
		{
			for(var i:int = 0; i<mParticles.length; i++)
			{
				if(mParticles[i].update(duration))
				{
					//一旦生命结束就放到池中
				}
			}
			// 假如所有粒子都运行完毕，要返回true or false， 来告诉发射器，这次发射结束
			// 让发射器来判断是否需要再次发射。
		}
		
		public function createParticle(px:Number, py:Number):void
		{
			for(var i:int = 0; i < mParticleCount; i++)
			{
				//需要从池中取
				var temp:VBFirework = mParticlesFactory.create();
				temp.position.setTo(px, py); 
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

		/*public function get particleCount():int
		{
			return mParticleCount;
		}

		public function set particleCount(value:int):void
		{
			mParticleCount = value;
		}*/
	}
}