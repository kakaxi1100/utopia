package org.ares.vernalbreeze
{
	/**
	 *当两个物体相撞时如果有多个点接触，就会发生多次碰撞
	 * 我们必须按顺序来处理这些碰撞 
	 * 我们优先选取分离速度最大的碰撞来计算
	 * @author JuLi
	 * 
	 */	
	public class VBParticleContactResolver
	{
		//一次碰撞可能会引发另一次碰撞，
		//为了避免无限循环下去，所以需要设置一个阈值
		//最大迭代的次数
		private var mIterations:uint;
		//实际使用的迭代次数
		private var mIterationsUsed:uint;
		
		public function VBParticleContactResolver(iteration:uint)
		{
			mIterations = iteration;
		}
		
		public function set iterations(value:uint):void
		{
			mIterations = value;
		}
		
		public function resolveContacts(contactArray:Vector.<VBParticleContact>, duration:Number):void
		{
			mIterationsUsed = 0;
			while(mIterationsUsed < mIterations)
			{
				var max:Number = 0;
				var maxIndex:uint = contactArray.length;
				for(var i:int = 0; i < contactArray.length; i++)
				{
					var sepVel:Number = contactArray[i].caculateSeparatingVelocity();
					if(sepVel < max)
					{
						max = sepVel;
						maxIndex = i;
					}
				}
				contactArray[maxIndex].resolve(duration);
				mIterationsUsed++;
			}
		}
	}
}