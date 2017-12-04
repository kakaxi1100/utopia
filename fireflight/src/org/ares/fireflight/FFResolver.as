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
		 * 刚体速度解决方案
		 * 
		 * ma, mb = A,B的质量
		 * Rap, Rbp = A,B中心点到碰撞点P的距离
		 * Wa1, Wb1 = 碰撞前 A,B 的角速度
		 * Wa2, Wb2 = 碰撞后 A,B 的角速度
		 * Va1, Vb1 = 碰撞前 A,B 的线速度
		 * Va2, Vb2 = 碰撞后 A,B 的线速度
		 * Vap1,Vbp1 = 碰撞前 A,B中心点到P的线速度+A,B线性速度
		 * Vap2,Vbp2 = 碰撞后 A,B中心点到P的线速度+A,B线性速度
		 * Vab1 = 碰撞前 A,B 在P点的相对速度
		 * Vab2 = 碰撞后 A,B 在P点的相对速度
		 * N = 碰撞法线
		 * e = 恢复系数
		 * j = 前后动量的变化量
		 * 
		 * 计算公式:
		 * 
		 * 1. Vap1=Va1 + Wa1 * Rap
		 * 2. Vap2=Va2 + Wa2 * Rap
		 * 3. Vbp1=Va1 + Wa1 * Rbp
		 * 4. Vbp2=Vb2 + Wa2 * Rbp
		 * 
		 * 5. Vab1=Vap1 - Vbp1
		 * 6. Vab2=Vap2 - Vbp2
		 *  
		 * 将①②③④代入⑤⑥得到:
		 * 7. Vab1 = Va1 + Wa1 * Rap - Vb1 - Wb1 * Rbp
		 * 8. Vab2 = Va2 + Wa2 * Rap - Vb2 - Wb2 * Rbp
		 * 
		 * 然后根据碰撞后的速度等于碰撞后的速度乘以恢复系数(在碰撞法线上!)可得:
		 * 9. Vab2·N = -eVab1·N  (0<=e<=1)
		 * 
		 * 10. ma*va1 + mb*vb1 = ma*va2 + mb*vb2 
		 * 11. j = ma*Va2 - maVa1 = -(mb*Vb2 - mb*Vb1)    
		 * 12. Va2 = Va1 + j*N/ma
		 * 13. Vb2 = Vb1 - j*N/mb
		 * 
		 * 同理可以推导出 Wa2和Wb2
		 * Ia = ma*Rap²
		 * Ib = ma*Rbp²
		 * 
		 * ma = Ia / Rap²
		 * mb = Ib / Rbp²
		 * 
		 * 则A,B到P点单独的线速度为
		 * Vap1单独 = Wa1 * Rap Vap2单独 = Wa2 * Rap
		 * Vbp1单独 = Wb1 * Rbp Vbp2单独 = Wb2 * Rbp
		 * 根据动量守恒 同 12,13可得
		 * Vap1单独 = Vap2单独 + j*N/ma
		 * 14. Wa2 * Rap = Wa1 * Rap + j*N*Rap²/Ia  =>  Wa2 = Wa1 + (Rap*j*N)/Ia
		 * 15. Wb2 * Rbp = Wb1 * Rbp + j*N*Rbp²/Ib  =>  Wb2 = Wb1 + (Rbp*j*N)/Ib
		 * 
		 * 将7,8,12,13,14,15,代入9可得:
		 * 
		 * 16. j =  (−(1 + e) Vab1·N)/(1⁄ma + 1⁄mb + (Rap × N)2 ⁄ Ia + (Rbp × N)2 ⁄ Ib)
		 *
		 * 通过16反代入 12,13,14,15可求出对应的A,B当前线速度和角速度
		 * 
		 * 公式补充:
		 * (A × B) · C = (B × C) · A
		 * (A × B) × A · B = (A × B) · (A × B) = (A × B)2
		 * n · n = 1 
		 * 
		 * 
		 */		
		public static function resolveVelocity(b1:FFRigidBody, b2:FFRigidBody):void
		{
			
		}
		
//		/**
//		 * 这个是针对粒子的, 刚体的需要另行计算
//		 * 
//		 * 接近速度就是两个物体相互接近的速度或者说,就是两个物体的相对速度（有时也指两物体在质心系中的速度）
//		 * 分离速度就是两个物体相互远离的速度也是两个物体的相对速度,但是方向与之前相反.
//		 * v1和v0是反向的 
//		 * 
//		 * 动量的计算公式，两个物体碰撞后他们满足
//		 * 注意va vb是包含了方向的
//		 * ma*va0 + mb*vb0 = ma*va1 + mb*vb1
//		 * ① ma*Δva = -mb*Δvb
//		 * ② Δva+Δvb = Δv
//		 * 将②带入到①可得
//		 * Δva = Δv*mb/(ma+mb)
//		 * Δvb = Δv*ma/(ma+mb)
//		 * 
//		 * 恢复系数
//		 * e = - v1 / v0
//		 * v1 = -v0 * e
//		 * 
//		 */		
//		public static function resolveVelocity(b1:FFRigidBody, b2:FFRigidBody):void
//		{
//			//现在的信息是以b1为标准的
//			//计算碰撞前的总速度
//			//1.计算两个物体的相对速度, 注意这个方向
//			var relativeVelocity:FFVector = b1.velocity.minus(b2.velocity, mTemp1);
//			//2.计算相对速度在法线上的投影
//			var relativeSpeed:Number = relativeVelocity.scalarMult(mContactInfo.normal);
//			//碰撞法线 与 当前速度(在法相方向上的投影)如果不一致,那么他们不会发生碰撞, 也就不需要解决速度问题
//			//分为同向和相向
//			if(relativeSpeed >= 0)
//			{
//				return;
//			}
//			//3.计算分离后的速度
//			var separatingSpeed:Number = -relativeSpeed * mContactInfo.restitution;
//			//4.计算总速度
//			var totalSpeed:Number = separatingSpeed - relativeSpeed;
//			//5.计算总质量的倒数(为了之后方便计算)  (ma + mb)/(ma * mb)
//			var totalInverseMass:Number = b1.inverseMass + b2.inverseMass;
//			//6.计算Δva和Δvb
//			var deltaSpeed1:Number = totalSpeed * b1.inverseMass / totalInverseMass;
//			var deltaSpeed2:Number = totalSpeed * b2.inverseMass / totalInverseMass;
//			//7.计算va1 和 vb1
//			//v1是朝着当前的normal方向, v2是朝着当前normal方向的反方向
//			var deltaV1:FFVector = mContactInfo.normal.mult(deltaSpeed1, mTemp1);
//			b1.velocity.plusEquals(deltaV1);
//			
//			var deltaV2:FFVector = mContactInfo.normal.mult(-deltaSpeed2, mTemp1);
//			b2.velocity.plusEquals(deltaV2);
//		}
	}
}