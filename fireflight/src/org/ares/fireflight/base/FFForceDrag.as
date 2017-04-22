package org.ares.fireflight.base
{
	/**
	 *公式
	 * 
	 * f = -v*(k1*|v| + k2*|v|*|v|) 
	 * 
	 * 随着速度越快
	 * 粒子收到的阻力越大
	 * @author juli
	 * 
	 */	
	public class FFForceDrag extends FFForceBase
	{
		public static var NAME:String;
		private var mK1:Number;
		private var mK2:Number;
		private var mTemp:FFVector = new FFVector();//临时存储 避免额外开销
		public function FFForceDrag(name:String, k1:Number, k2:Number)
		{
			super(name);
			
			mK1 = k1;
			mK2 = k2;
			NAME = name;
		}
		
		override public function update(d:Number):void
		{
			var o:FFParticle;
			for(var i:int = 0; i < mPList.length; i++)
			{
				o = mPList[i];
				o.velocity.clone(mTemp);
				
				var dragCoeff:Number = mTemp.magnitude();
				dragCoeff = mK1 * dragCoeff + mK2 * dragCoeff * dragCoeff;
				
				mTemp.normalizeEquals();
				
				mTemp.multEquals(-dragCoeff);
				
				o.addForce(mTemp);
			}
		}
	}
}