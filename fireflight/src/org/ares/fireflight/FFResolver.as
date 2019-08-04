package org.ares.fireflight
{
	import flash.display.Graphics;

	public class FFResolver
	{
		private static var mContactInfo:FFContactInfo = new FFContactInfo();

		private static var mTemp1:FFVector = new FFVector();
		private static var mTemp2:FFVector = new FFVector();
		private static var mTemp3:FFVector = new FFVector();
		private static var mTemp4:FFVector = new FFVector();
		private static var mTemp5:FFVector = new FFVector();
		private static var mTemp6:FFVector = new FFVector();
		private static var mTemp7:FFVector = new FFVector();
		private static var mTemp8:FFVector = new FFVector();
		private static var mTemp9:FFVector = new FFVector();
		private static var mTemp10:FFVector = new FFVector();
		private static var mTemp11:FFVector = new FFVector();
		private static var mTemp12:FFVector = new FFVector();
		private static var mTemp13:FFVector = new FFVector();
		
		public static function resolve():void
		{
			
		}
		
		public static function draw(g:Graphics, color:uint = 0xFFFFFF):void
		{
			g.lineStyle(2, color);
			g.drawCircle(mContactInfo.contectPoint.x, mContactInfo.contectPoint.y, 1);
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
		 * 这个深度的解决是不精确的,如果需要精确的解决需要按时间回退,然后再执行检测, 会比较麻烦
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
			
			//计算碰撞点的位置
			mContactInfo.contectPoint = mContactInfo.end.plus(move2, mTemp1); 
			
//			var start:FFVector = mContactInfo.start.mult(b2.inverseMass / totalInverseMass, mTemp1);
//			var end:FFVector = mContactInfo.end.mult(b1.inverseMass / totalInverseMass, mTemp2);
//			trace("2---", start.plus(end, mTemp3));
		}
		
		/**
		 * 设两球的初始速度为 V1, V2 , 碰撞后的速度为 Va, Vb
		 * 两球受到的力均为F,且碰撞时间为Δt 注意：只在碰撞法线上会产生力
		 * 假定 V1方向是正方向 
		 *  
		 *	积分(-F*Δt)=M1*Va-M1*V1 ①
		 *	积分(F*Δt)=M2*Vb-M2*V2 ②
		 *	所以 ①+②得：
		 *	M1*Va+M2*Vb-(M1*V1+M2*V2)=0
		 *	即：
		 *	M1*Va+M2*Vb=M1*V1+M2*V2
		 * 
		 * 
		 * 	
		 *
		 * 刚体速度解决方案
		 * https://www.myphysicslab.com/engine2D/collision-en.html
		 * 
		 * ma, mb = A,B的质量
		 * Rap, Rbp = A,B中心点到碰撞点P的距离,这是一个矢量
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
		 * V = W x R 这里是叉乘, 不要问为什么, 物理公式就是这样定义的
		 * 
		 * 1. Vap1=Va1 + Wa1 x Rap
		 * 2. Vap2=Va2 + Wa2 x Rap
		 * 3. Vbp1=Va1 + Wa1 x Rbp
		 * 4. Vbp2=Vb2 + Wa2 x Rbp
		 * 
		 * 5. Vab1=Vap1 - Vbp1
		 * 6. Vab2=Vap2 - Vbp2
		 *  
		 * 将①②③④代入⑤⑥得到:
		 * 7. Vab1 = Va1 + Wa1 x Rap - Vb1 - Wb1 x Rbp
		 * 8. Vab2 = Va2 + Wa2 x Rap - Vb2 - Wb2 x Rbp
		 * 
		 * 然后根据碰撞后的速度等于碰撞后的速度乘以恢复系数(在碰撞法线上!)可得:
		 * (**这里是错误的, 不是只是在碰撞法线上 ,而是在整个系统中动量都守恒, 在碰撞法线上守恒是因为在不是法线的方向上速度没有变化,公式中相抵消了**)  
		 * 9. Vab2·N = -eVab1·N  (0<=e<=1) (这里有个问题是否 角速度产生的线速度 可以和 物体平动的速度分开计算)
		 * 
		 * (注意一下等式的成立都是建立在法线方向上的!) (**在整个系统中成立, 理由同上**)
		 * 
		 * 10. ma*va1 + mb*vb1 = ma*va2 + mb*vb2 
		 * 11. j = ma*Va2 - maVa1 = -(mb*Vb2 - mb*Vb1)    (不用这么想)
		 * 
		 * (其实可以这么想)
		 * 动量是速度改变的原因, J =mΔV ∴ V2 = V1 + J/m 角速度同理
		 * 
		 * 12. Va2 = Va1 + j/ma
		 * 13. Vb2 = Vb1 - j/mb
		 * 
		 * 
		 * 角速度的求解关键在下面, 角速度所产生的线速度的动量也守恒, 那么就可以用求粒子的那套来做了
		 * 同理可以推导出 Wa2和Wb2
		 * Ia = ma*Rap²
		 * Ib = mb*Rbp²
		 * 
		 * ma = Ia / Rap²
		 * mb = Ib / Rbp²
		 * 
		 * 则A,B到P点单独的线速度为
		 * Vap1单独 = Wa1 x Rap Vap2单独 = Wa2 x Rap
		 * Vbp1单独 = Wb1 x Rbp Vbp2单独 = Wb2 x Rbp
		 * 根据动量守恒 同 12,13可得
		 * Vap1单独 = Vap2单独 + j/ma
		 * 14. Wa2 x Rap = Wa1 x Rap + j * Rap²/Ia  =>  Wa2 = Wa1 + (Rap * j)/Ia (叉乘就是乘以了个sinθ而已, 所以可以两边相除)
		 * 15. Wb2 x Rbp = Wb1 x Rbp + j * Rbp²/Ib  =>  Wb2 = Wb1 + (Rbp * j)/Ib
		 * 
		 * 将7,8,12,13,14,15,代入9可得:
		 * 
		 * 16. j =  (−(1 + e) Vab1·N)/(1⁄ma + 1⁄mb + (Rap × N)²/Ia + (Rbp × N)²⁄Ib)
		 *
		 * 通过16反代入 12,13,14,15可求出对应的A,B当前线速度和角速度
		 * 
		 * 公式补充:
		 * (A × B) · C = (B × C) · A
		 * (A × B) × A · B = (A × B) · (A × B) = (A × B)2
		 * n · n = 1 
		 * 
		 * 点积运算法则:
		 * 交换律：A · B = B · A
		 * 分配律：A (B + C) = A B + A C
		 * 结合律：(mA) · B其中m是实数。
		 *	
		 * 同理:
		 * jT = ((-(1+e) Vab1·T)f)/(1⁄ma + 1⁄mb + (Rap × T)²/Ia + (Rbp × T)²⁄Ib)
		 * 
		 */		
		public static function resolveVelocity(b1:FFRigidBody, b2:FFRigidBody):void
		{
			//1. 先计算 Rap,和 Rbp
			var r1:FFVector = mContactInfo.contectPoint.minus(b1.position, mTemp1);
			var r2:FFVector = mContactInfo.contectPoint.minus(b2.position, mTemp2);
			
			//2. 计算亲和速度 Vp = V + W x R, 注意叉乘的方向 是与这个矢量成正交的
			var v1:FFVector = b1.velocity.plus(mTemp3.setTo(-1 * b1.angularVelocity * r1.y, b1.angularVelocity * r1.x), mTemp4);
			var v2:FFVector = b2.velocity.plus(mTemp3.setTo(-1 * b2.angularVelocity * r2.y, b2.angularVelocity * r2.x), mTemp5);
			//计算两个物体的相对速度, 注意这个方向
			var relativeVelocity:FFVector = v1.minus(v2, mTemp3);
			//计算相对速度在法线上的投影
			var relativeSpeed:Number = relativeVelocity.scalarMult(mContactInfo.normal);
			//碰撞法线 与 当前速度(在法相方向上的投影)如果不一致,那么他们不会发生碰撞, 也就不需要解决速度问题
			//分为同向和相向
			if(relativeSpeed >= 0)
			{
				return;
			}
			//3.计算jn
			//计算 R x N
			var r1crossN:Number = r1.vectorMult(mContactInfo.normal);
			var r2crossN:Number = r2.vectorMult(mContactInfo.normal);
			//计算分子
			var jnUp:Number = -(1 + mContactInfo.restitution) * relativeSpeed;
			//计算分母
			var jnDown:Number = b1.inverseMass + b2.inverseMass + r1crossN * r1crossN / b1.rotationInertia
								+  r2crossN * r2crossN / b2.rotationInertia;
			var jn:Number = jnUp / jnDown;
			//计算法线上的冲量
			var impulse:FFVector = mContactInfo.normal.mult(jn, mTemp6);
			
			//4.得到最终的线速度
			b1.velocity.plusEquals(impulse.mult(b1.inverseMass, mTemp7));
			b2.velocity.minusEquals(impulse.mult(b2.inverseMass, mTemp8));	
			//5.得到最终的角速度
			//由于法线上没有摩擦力, 所以理论上这个角速度是不会变的
			b1.angularVelocity += r1crossN * jn / b1.rotationInertia;
			b2.angularVelocity -= r2crossN * jn / b2.rotationInertia;
			
			//二.计算切线冲量 (摩擦力)
			//1.先计算切线方向, 切线上的速度 + 法线上速度 = 亲和速度
			var tangent:FFVector = relativeVelocity.minus(mContactInfo.normal.mult(relativeSpeed, mTemp9), mTemp10);
			//由于是摩擦力, 所以方向相反
			tangent = tangent.normalizeEquals().multEquals(-1);
			var relativeTangentSpeed:Number = relativeVelocity.scalarMult(tangent);
			//计算 R x T
			var r1crossT:Number = r1.vectorMult(tangent);
			var r2crossT:Number = r2.vectorMult(tangent);
			//计算分子
			var jtUp:Number = -(1 + mContactInfo.restitution) * relativeTangentSpeed * mContactInfo.friction;
			//计算分母
			var jtDown:Number = b1.inverseMass + b2.inverseMass + r1crossT * r1crossT / b1.rotationInertia
								+  r2crossT * r2crossT / b2.rotationInertia;
			var jt:Number = jtUp / jtDown;
			//摩擦力是物体的压力有关的,它是不能大于法线力的
			if(jt > jn){
				jt = jn;
			}
			//计算切线上的冲量
			impulse = tangent.mult(jt, mTemp11);
			//得到最终的切线速度
			b1.velocity.plusEquals(impulse.mult(b1.inverseMass, mTemp12));
			b2.velocity.minusEquals(impulse.mult(b2.inverseMass, mTemp13));	
			//得到最终的切线角速度
			b1.angularVelocity += r1crossT * jt / b1.rotationInertia;
			b2.angularVelocity -= r1crossT * jt / b2.rotationInertia;
		}
		
	}
}