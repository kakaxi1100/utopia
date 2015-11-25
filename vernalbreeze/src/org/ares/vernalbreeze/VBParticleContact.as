package org.ares.vernalbreeze
{
	/**
	 *两个粒子之间碰撞 
	 * 这里只讨论两个粒子相对对撞
	 * 并且在一条线上
	 * @author JuLi
	 * 
	 */	
	public class VBParticleContact
	{
		//碰撞的两个粒子
		private var mParticle:Vector.<VBParticle>;
		//恢复系数
		private var mRestiution:Number;
		//记录速度方向就是这个粒子朝另一个粒子运动的方向
		private var mContactNormal:VBVector;
		public function VBParticleContact()
		{
			mParticle = new Vector.<VBParticle>(2);
		}
		
		/**
		 *计算分离速度 
		 * 注意此速度是相对速度，相对于另外一个粒子的速度
		 */		
		public function caculateSeparatingVelocity():Number
		{
			var relativeVelocity:VBVector = mParticle[0].velocity;//这个是
			if(mParticle[1] != null)
			{
				// 因为两个粒子的速度是相对而不是相向的，所以用减法
				relativeVelocity.minusEquals(mParticle[1].velocity);
			}
			//分离速度和方向的点积
			//因为是两球对撞所以速度和位置的方向是相反的
			//所以这个速度是负的
			return relativeVelocity.scalarMult(mContactNormal);
		}
		
		public function resolveVelocity():void
		{
			//找到碰撞前的分离速度（是相对于另一个粒子的）
			var separatingVelocity:Number = caculateSeparatingVelocity();
			//检查分离速度是否大于0
			//如果大于0表示物体连在一起了运动了
			//就不再处理下面情况
			if(separatingVelocity > 0)
			{
				//此时是完全非弹性碰撞
				return;
			}
			//计算碰撞后的分离速度
			var newSeparatingVelocity:Number = -separatingVelocity * mRestiution;
			//计算出速度的总的变化量
			var deltaVelocity:Number = newSeparatingVelocity - separatingVelocity;
			//计算出总的质量，用 逆质量代替
			var totalInverseMass:Number = mParticle[0].inverseMass;
			if(mParticle[1] != null)//如果没有另一个物体的话，就是碰到了质量无限大的物体上，比如地面，墙面等
			{
				totalInverseMass += mParticle[1].inverseMass;
			}
			//假如物体都是无限质量的，则无不会产生冲量
			if(totalInverseMass <= 0) return;
			//计算出物体的冲量
			var impluse:Number = deltaVelocity / totalInverseMass;
			//计算冲量的方向
			var implusePerIMass:VBVector = mContactNormal.mult(impluse);
			//计算粒子的世界速度
			mParticle[0].velocity = mParticle[0].velocity.plus(implusePerIMass.multEquals(mParticle[0].inverseMass));
			//计算另一个粒子的速度
			if(mParticle[1] != null)
			{
				mParticle[1].velocity = mParticle[1].velocity.plus(implusePerIMass.multEquals(mParticle[1].inverseMass));
			}
		}
	}
}












