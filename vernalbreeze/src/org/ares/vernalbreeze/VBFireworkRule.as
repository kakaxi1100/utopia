package org.ares.vernalbreeze
{
	/**
	 *粒子对应的规则 
	 * 如果rule需要扩展把这个当作基类就可以
	 * @author JuLi
	 * 
	 */	
	public class VBFireworkRule
	{
		private var minAge:Number;
		private var maxAge:Number;
		private var minVelocity:VBVector;
		private var maxVelocity:VBVector;
		private var mDamping:Number;
		public function VBFireworkRule()
		{
			init();
		}
		
		/**
		 *将规则赋值给粒子 
		 * @param firework
		 * 
		 */		
		public function wrap(firework:VBFirework):void
		{
			firework.age = Math.random()*(maxAge - minAge) + minAge;
			var vx:Number = Math.random()*(maxVelocity.x - minVelocity.x) + minVelocity.x;
			var vy:Number = Math.random()*(maxVelocity.y - minVelocity.y) + minVelocity.y;
			firework.velocity.setTo(vx, vy);
			firework.damping = mDamping;
		}
		
		/**
		 *设置规则参数 
		 * @param pminAge
		 * @param pmaxAge
		 * @param pminVelocity
		 * @param pmaxVelocity
		 * @param pdamping
		 * 
		 */		
		public function setParameters(pminAge:Number, pmaxAge:Number, pminVelocity:VBVector, pmaxVelocity:VBVector, pdamping:Number):void
		{
			minAge = pminAge;
			maxAge = pmaxAge;
			minVelocity = pminVelocity;
			maxVelocity = pmaxVelocity;
			mDamping = pdamping;
		}
		
		/**
		 *初始化规则 
		 * 
		 */		
		public function init():void
		{
			minAge = 0;
			maxAge = 100;
			minVelocity = new VBVector();
			maxVelocity = new VBVector(100,100);
			mDamping = 0.9;
		}
	}
}