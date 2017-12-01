package org.ares.fireflight
{
	public class FFResolver
	{
		private static var mContactInfo:FFContactInfo = new FFContactInfo();

		private static var mTemp1:FFVector = new FFVector();
		private static var mTemp2:FFVector = new FFVector();
		public static function resolve():void
		{
			
		}
		
		public static function setContactInfo(penetration:Number, normal:FFVector, start:FFVector, end:FFVector):void
		{
			mContactInfo.penetration = penetration;
			mContactInfo.normal = normal;
			mContactInfo.start = start;
			mContactInfo.end = end;
		}
		
		/**
		 *解决渗透问题 
		 * 两个物体渗透之后，需要反弹的距离是由它们的质量决定的
		 * pa = penetration * mb/(ma + mb)*dn
		 * pb =-penetration * ma/(ma + mb)*dn
		 */	
		public static function resolveInterpenetration(b1:FFRigidBody, b2:FFRigidBody):void
		{
			//(ma + mb)/(ma*mb)
			var totalInverseMass:Number = b1.inverseMass + b2.inverseMass;
			var penetration1:Number = mContactInfo.penetration * b1.inverseMass / totalInverseMass;
			var penetration2:Number = -mContactInfo.penetration * b2.inverseMass / totalInverseMass;
			
			var move1:FFVector = mContactInfo.normal.mult(penetration1, mTemp1);
			var move2:FFVector = mContactInfo.normal.mult(penetration2, mTemp2);
			
			b1.position.plusEquals(move1);
			b2.position.plusEquals(move2);
		}
		
		/**
		 * 
		 * 接近速度就是两个物体相互接近的速度或者说,就是两个物体的相对速度（有时也指两物体在质心系中的速度）
		 * 分离速度就是两个物体相互远离的速度也是两个物体的相对速度,但是方向与之前相反.
		 * v1和v0是反向的 
		 * 
		 * 动量的计算公式，两个物体碰撞后他们满足
		 * 注意va vb是包含了方向的
		 * ma*va0 + mb*vb0 = ma*va1 + mb*vb1
		 * ① ma*Δva = -mb*Δvb
		 * ② Δva+Δvb = Δv
		 * 将②带入到①可得
		 * Δva = Δv*mb/(ma+mb)
		 * Δvb = Δv*ma/(ma+mb)
		 * 
		 * 恢复系数
		 * e = - v1 / v0
		 * v1 = -v0 * e
		 * 
		 */		
		public static function resolveVelocity(b1:FFRigidBody, b2:FFRigidBody):void
		{
			//现在的信息是以b1为标准的
			//计算碰撞前的总速度
			//1.计算两个物体的相对速度, 注意这个方向
			var relativeVelocity:FFVector = b1.velocity.minus(b2.velocity, mTemp1);
			//2.计算相对速度在法线上的投影
			var relativeSpeed:Number = relativeVelocity.scalarMult(mContactInfo.normal);
			//碰撞法线 与 当前速度(在法相方向上的投影)如果不一致,那么他们不会发生碰撞, 也就不需要解决速度问题
			//分为同向和相向
			if(relativeSpeed >= 0)
			{
				return;
			}
			//3.计算分离后的速度
			var separatingSpeed:Number = -relativeSpeed * mContactInfo.restitution;
			//4.计算总速度
			var totalSpeed:Number = separatingSpeed - relativeSpeed;
			//5.计算总质量的倒数(为了之后方便计算)  (ma + mb)/(ma * mb)
			var totalInverseMass:Number = b1.inverseMass + b2.inverseMass;
			//6.计算Δva和Δvb
			var deltaSpeed1:Number = totalSpeed * b1.inverseMass / totalInverseMass;
			var deltaSpeed2:Number = totalSpeed * b2.inverseMass / totalInverseMass;
			//7.计算va1 和 vb1
			//v1是朝着当前的normal方向, v2是朝着当前normal方向的反方向
			var deltaV1:FFVector = mContactInfo.normal.mult(deltaSpeed1, mTemp1);
			b1.velocity.plusEquals(deltaV1);
			
			var deltaV2:FFVector = mContactInfo.normal.mult(-deltaSpeed2, mTemp1);
			b2.velocity.plusEquals(deltaV2);
			
			
			
		}
		
		
		
		
		
		
		
	}
}