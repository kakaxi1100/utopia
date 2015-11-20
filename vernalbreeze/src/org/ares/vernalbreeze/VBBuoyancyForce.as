package org.ares.vernalbreeze
{
	/**
	 *浮力分为3种情况
	 * 完全没入，完全浮出，和部分没入
	 * @author JuLi
	 * 
	 */	
	public class VBBuoyancyForce implements IVBForce
	{
		//物体沉下的最大深度
		private var mMaxDepth:Number;
		//物体的体积
		private var mVolume:Number
		//水线的高度
		private var mWaterHeight:Number;
		//液体的密度
		private var mLiquidDensity:Number;
		
		public function VBBuoyancyForce(maxDepth:Number, volume:Number, waterHeight:Number, liquidDensity:Number = 1000)
		{
			mMaxDepth = maxDepth;
			mVolume = volume;
			mWaterHeight = waterHeight;
			mLiquidDensity = liquidDensity;
		}
		
		public function update(p:VBParticle, duration:Number):void
		{
			//计算浸没的深度
			var depth:Number = p.position.y;
			//假如物体已经完全浮出水面，则无需计算浮力
			if(depth >= mWaterHeight + mMaxDepth)//超出水面
			{
				return;
			}
			var force:VBVector = new VBVector();
			//检查是否完全没入
			if(depth <= mWaterHeight - mMaxDepth)
			{
				force.y = mLiquidDensity * mVolume;
			}
			else//部分没入
			{
				force.y = mLiquidDensity * mVolume * (depth - mMaxDepth - mWaterHeight) / (2 * mMaxDepth);
			}
			p.addForce(force);
		}
	}
}



























