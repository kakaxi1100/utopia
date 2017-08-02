package org.ares.archive.fireflight_v2
{
	import org.ares.archive.fireflight_v2.FFParticle;
	import org.ares.archive.fireflight_v2.FFVector;
	
	public class FFContact
	{
		private var mName:String;
		//碰撞是在两个粒子间发生
		private var mParticles:Vector.<FFParticle> = new Vector.<FFParticle>(2);
		//恢复系数
		private var mRestitution:Number;
		//碰撞法线,必须是标准化的哦
		private var mContactNormal:FFVector;
		//渗透距离,小于0 代表两物体没有碰撞，渗透距离=0表示两物体才刚刚接触，渗透距离>0表示两物体渗透
		private var mPenetration:Number;
		
		//临时存储数据
		private var mTemp1:FFVector = new FFVector();
		private var mTemp2:FFVector = new FFVector();
		private var mTemp3:FFVector = new FFVector();
		private var mTemp4:FFVector = new FFVector();
		private var mTemp5:FFVector = new FFVector();
		private var mTemp6:FFVector = new FFVector();
		private var mTemp7:FFVector = new FFVector();
		
		public function FFContact(p1:FFParticle = null, p2:FFParticle = null, name:String = null)
		{
			mName = name;
			mParticles[0] = p1;
			mParticles[1] = p2;
			mRestitution = 1;
		}
			
		public function destory():void
		{
			mParticles[0] = mParticles[1] = null;
			mContactNormal = null;
			mRestitution = 1;
			mPenetration = 0;
		}
		
		/**
		 *解决碰撞问题 
		 * 
		 */		
		public function resolve(duration:Number):void
		{
			resolveVelocity(duration);
			resolveInterpenetration(duration);
		}
		
		/**
		 *计算分离速度 
		 * 注意此速度是相对速度，相对于另外一个粒子的速度
		 * 动量的计算公式，两个物体碰撞后他们满足
		 * ma*va0 + mb*vb0 = ma*va1 + mb*vb1
		 * ma*Δva = mb*Δvb
		 * Δva+Δvb = Δv
		 * Δva = Δv*mb/(ma+mb)
		 * Δvb = Δv*ma/(ma+mb)
		 */		
		public function caculateSeparatingVelocity():Number
		{
			var relativeVelocity:FFVector = mParticles[0].velocity.clone(mTemp1);//不能改变原速度
			if(mParticles[1] != null)
			{
				// 计算相对速度
				// 是0粒子相对于1粒子的速度
				relativeVelocity.minusEquals(mParticles[1].velocity);
			}
			//这个速度在碰撞法线上的投影
			//因为碰撞法线是一个两球碰撞之后的矢量, 如果会产生碰撞,那么粒子现在的速度肯定是与之相反的
			//它代表碰撞前的分离速度
			return relativeVelocity.scalarMult(mContactNormal);
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
			var totalInverseMass:Number = mParticles[0].inverseMass;
			if(mParticles[1] != null)
			{
				totalInverseMass += mParticles[1].inverseMass;//(ma+mb)/(ma*mb)
			}
			//假如物体都是无限质量的
			if(totalInverseMass <= 0)
			{
				return;
			}
			//p(ma*mb)/(ma + mb)
			var movePerIMass:FFVector = mContactNormal.mult(mPenetration/totalInverseMass, mTemp5);
			//改变粒子的位置,粒子1跟法向相同
			mParticles[0].position.plusEquals(movePerIMass.mult(mParticles[0].inverseMass, mTemp6));
			if(mParticles[1] != null)
			{
				//粒子2跟法向相反
				mParticles[1].position.minusEquals(movePerIMass.mult(mParticles[1].inverseMass, mTemp7));
			}
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
			//如果大于0表示物体不会发生碰撞
			if(separatingVelocity > 0)
			{
				return;
			}
			//计算碰撞后的分离速度
			var newSeparatingVelocity:Number = -separatingVelocity * mRestitution;
			//处理静态碰撞, 预计算一下帧的情况
			//估算一下, 加速度下一帧会产生的速度.
			//1.计算加速度所产生的分离速度
			var accCausedVelocity:FFVector = mParticles[0].acceleration.clone(mTemp1);
			if(mParticles[1] != null)
			{
				accCausedVelocity.minusEquals(mParticles[1].acceleration);
			}
			var accCausedSepVelocity:Number = accCausedVelocity.scalarMult(mContactNormal)*duration;
			//假如这个速度是与粒子碰撞之后是反向的, 这时才需要处理静态碰撞
			if(accCausedSepVelocity < 0)
			{
				//2.比较碰撞后的速度和下一帧产生的速度的大小
				newSeparatingVelocity += accCausedSepVelocity*mRestitution;
				//3.如果反弹的速度比向下的还小, 那么他就静止了, 即没有反弹速度, 也可以说反弹速度为0
				if(newSeparatingVelocity < 0)
				{
					newSeparatingVelocity = 0;
				}
			}
			//计算出速度的总的变化量
			var deltaVelocity:Number = newSeparatingVelocity - separatingVelocity;
			//计算出总的质量，用 逆质量代替 (ma + mb)/(ma*mb)
			var totalInverseMass:Number = mParticles[0].inverseMass;
			if(mParticles[1] != null)//如果没有另一个物体的话，就是碰到了质量无限大的物体上，比如地面，墙面等
			{
				totalInverseMass += mParticles[1].inverseMass;
			}
			//假如物体都是无限质量的，则无不会产生冲量
			if(totalInverseMass <= 0) return;
			//计算出物体的冲量 Δv*ma*mb/(ma+mb)
			var impluse:Number = deltaVelocity / totalInverseMass;
			//计算冲量的方向
			var implusePerIMass:FFVector = mContactNormal.mult(impluse, mTemp2);
			//计算粒子的世界速度
			mParticles[0].velocity.plusEquals(implusePerIMass.mult(mParticles[0].inverseMass, mTemp3));
			//计算另一个粒子的速度 冲量方向与第一个粒子相反
			if(mParticles[1] != null)
			{
				mParticles[1].velocity.plusEquals(implusePerIMass.mult(-mParticles[1].inverseMass, mTemp4));
			}
		}

		public function get firstParticle():FFParticle
		{
			return mParticles[0];
		}

		public function set firstParticle(v:FFParticle):void
		{
			mParticles[0] = v;
		}
		
		public function get secondParticle():FFParticle
		{
			return mParticles[1];
		}
		
		public function set secondParticle(v:FFParticle):void
		{
			mParticles[1] = v;
		}
		
		public function get name():String
		{
			return mName;
		}

		public function get contactNormal():FFVector
		{
			return mContactNormal;
		}

		public function set contactNormal(value:FFVector):void
		{
			mContactNormal = value;
		}

		public function get restitution():Number
		{
			return mRestitution;
		}

		public function set restitution(value:Number):void
		{
			mRestitution = value;
		}

		public function get penetration():Number
		{
			return mPenetration;
		}

		public function set penetration(value:Number):void
		{
			mPenetration = value;
		}


	}
}