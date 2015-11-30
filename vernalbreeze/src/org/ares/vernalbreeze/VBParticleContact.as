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
		//接点法线方向
		//比如假如斜线碰到地面，
		//那么物体反弹后的方向是这个速度方向的法线方向
		private var mContactNormal:VBVector;
		//渗透距离
		//渗透距离小于0 代表两物体没有碰撞，渗透距离=0表示两物体才刚刚接触，渗透距离>0表示两物体渗透
		private var mPenetration:Number;
		public function VBParticleContact()
		{
			mParticle = new Vector.<VBParticle>(2);
		}
		
		/**
		 *解决碰撞问题 
		 * 
		 */		
		public function resolve(duration:Number):void
		{
			resolveVelocity(duration);
			resolveInterpenetration();
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
		
		/**
		 *计算碰撞后物体的世界速度 
		 * 
		 */		
		public function resolveVelocity(duration:Number):void
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
			//把由加速度产生的速度从这个分离速度中除去
			//剩下的才应该是冲量产生的速度
			//1.计算加速度所产生的分离速度
			var accCausedVelocity:VBVector = mParticle[0].acceleration;
			if(mParticle[1] != null)
			{
				accCausedVelocity.minusEquals(mParticle[1].acceleration);
			}
			var accCausedSepVelocity:Number = accCausedVelocity.scalarMult(mContactNormal)*duration;
			if(accCausedSepVelocity < 0)
			{
				//2.除去加速度产生的速度，就是冲量产生的速度
				newSeparatingVelocity += accCausedSepVelocity*mRestiution;
				//3.如果冲量产生的速度没有加速度产生的速度大，那么
				if(newSeparatingVelocity < 0)
				{
					newSeparatingVelocity = 0;
				}
			}
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
		/**
		 *解决渗透问题 
		 * 两个物体渗透之后，需要反弹的距离是由它们的质量决定的
		 * pa = mb/(ma + mb)*dn
		 * pb = -ma/(ma + mb)*dn
		 */		
		public function resolveInterpenetration(duration:Number):void
		{
			//物体没有接触
			if(mPenetration <= 0) return;
			//计算出物体的总质量
			var totalInverseMass:Number = mParticle[0].inverseMass;
			if(mParticle[1] != null)
			{
				totalInverseMass += mParticle[1].inverseMass;
			}
			//假如物体都是无限质量的
			if(totalInverseMass <= 0)
			{
				return;
			}
			//-p(ma*mb)/(ma + mb)
			var movePerIMass:VBVector = mContactNormal.mult(-mPenetration/totalInverseMass);
			//改变粒子的位置
			mParticle[0].position.plusEquals(movePerIMass.multEquals(mParticle[0].inverseMass));
			if(mParticle[1] != null)
			{
				//为什么不是负的，需要考察?????
				mParticle[1].position.plusEquals(movePerIMass.multEquals(mParticle[1].inverseMass));
			}
		}
	}
}
