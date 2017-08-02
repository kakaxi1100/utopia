package org.ares.archive.fireflight_v2
{
	import org.ares.archive.fireflight_v2.FFForceBase;
	import org.ares.archive.fireflight_v2.FFParticle;
	import org.ares.archive.fireflight_v2.FFVector;

	/**
	 *橡皮筋模拟
	 * 就是长度小于静止长度的时候就不在给力了
	 * @author juli
	 * 
	 */	
	public class FFForceBungee extends FFForceBase
	{
		//另一端粒子的信息
		private var other:FFParticle;
		//弹性系数
		private var mK:Number;
		//静止长度
		private var mRestLength:Number;
		
		private var mTemp:FFVector = new FFVector();
		public function FFForceBungee(name:String, p:FFParticle, k:Number, l:Number)
		{
			super(name);
			
			other = p;
			mK = k;
			mRestLength = l;
		}
		
		override public function update(d:Number):void
		{
			var o:FFParticle;
			for(var i:int = 0; i < mPList.length; i++)
			{
				o = mPList[i];
				//算距离
				o.position.clone(mTemp);
				mTemp.minusEquals(other.position);
				var magnitude:Number = mTemp.magnitude();
				if(magnitude <= mRestLength) return;
				
				magnitude = mK * (magnitude - mRestLength);
				//计算方向
				mTemp.normalize();
				mTemp.multEquals(-magnitude);
				o.addForce(mTemp);
			}
		}
	}
}