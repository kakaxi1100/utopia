package org.ares.fireflight.base
{
	/**
	 *一端固定的弹簧
	 * 和基本弹簧差不多, 只不过另一端是一个固定点 verctor替代了粒子的position 
	 * @author juli
	 * 
	 */	
	public class FFForceAnchoredSpring extends FFForceBase
	{
		//另一端粒子的信息
		private var mAnchor:FFVector;
		//弹性系数
		private var mK:Number;
		//静止长度
		private var mRestLength:Number;
		
		private var mTemp:FFVector = new FFVector();
		public function FFForceAnchoredSpring(name:String, a:FFVector, k:Number, l:Number)
		{
			super(name);
			
			mAnchor = a;
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
				mTemp.minusEquals(mAnchor);
				var magnitude:Number = mTemp.magnitude();
				magnitude -= mRestLength;
				if(magnitude < 0) magnitude = -magnitude;
				magnitude *= mK;
				//计算方向
				//这里感觉有点问题, 好像不管压缩还是伸长这个力都是同一个方向
				//根据测试结果, 确实它是用位置来判断方向的
				mTemp.normalizeEquals();
				mTemp.multEquals(-magnitude);
				o.addForce(mTemp);
			}
		}
	}
}