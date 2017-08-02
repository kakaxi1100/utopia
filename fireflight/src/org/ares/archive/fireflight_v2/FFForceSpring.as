package org.ares.archive.fireflight_v2
{
	import org.ares.archive.fireflight_v2.FFForceBase;
	import org.ares.archive.fireflight_v2.FFParticle;
	import org.ares.archive.fireflight_v2.FFVector;

	/**
	 *弹力发生器 
	 * 
	 * 根据胡克定律
	 * f = -k*Δl
	 * 
	 * 弹簧意味着有两个端
	 * 
	 * 所以还需要记录另一端粒子的信息
	 * 
	 * 注意
	 * 假如other值改变,会影响这个力下的所有粒子, 即这个力下的所有粒子都共享一个 other 值
	 * 
	 * 可以创建多个弹力来对应不同的粒子
	 * 
	 * 弹力发生器 只改变当前粒子的力, 并不改变other 粒子！
	 * 如果需要改变两个粒子的力,则需要创建两个弹力， 并且互相指认
	 * 
	 * @author juli
	 * 
	 */	
	public class FFForceSpring extends FFForceBase
	{
		//另一端粒子的信息
		private var other:FFParticle;
		//弹性系数
		private var mK:Number;
		//静止长度
		private var mRestLength:Number;
		
		private var mTemp:FFVector = new FFVector();
		public function FFForceSpring(name:String, p:FFParticle, k:Number, l:Number)
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
				magnitude -= mRestLength;
				magnitude *= mK;
				//计算方向
				mTemp.normalizeEquals();
				mTemp.multEquals(-magnitude);
				o.addForce(mTemp);
			}
		}
	}
}