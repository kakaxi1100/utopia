package org.ares.fireflight
{
	/**
	 *重力是速度乘以粒子的质量 
	 * @author juli
	 * 
	 */	
	public class FFFForceGravity extends FFForceBase
	{
		private var mGravity:FFVector;//重力
		private var mTemp:FFVector = new FFVector();//临时存储 避免额外开销
		public function FFFForceGravity(name:String, g:FFVector)
		{
			super(name);
			mGravity = g;
		}
		
		override public function update(d:Number):void
		{
			var o:FFParticle;
			for(var i:int = 0; i < mPList.length; i++)
			{
				o = mPList[i];
				if(o.hasFiniteMass() == false)
				{
					o.addForce(mGravity.clone(mTemp).multEquals(o.mass));
				}
			}
		}
	}
}