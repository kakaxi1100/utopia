package walle
{
	
	

	public class SteeringBehaviors
	{
		public static var tempV1:FFVector = new FFVector();
		public static var tempV2:FFVector = new FFVector();
		public static var tempV3:FFVector = new FFVector();
		
		public function SteeringBehaviors()
		{
		}
		
		public static function seek(source:Intelligent, target:FFVector):void
		{
			var dir:FFVector = target.minus(source.position, tempV1);
			var desiredVelocity:FFVector = dir.mult(source.maxSpeed, dir);
			
			var force:FFVector = desiredVelocity.minus(source.velocity, tempV1);
			source.addForce(force);
		}
		
		public static function flee(source:Intelligent, target:FFVector):void
		{
			var dir:FFVector = source.position.minus(target, tempV1);
			
			if(dir.magnitudeSquare() < source.panicDisSq)
			{
				var desiredVelocity:FFVector = dir.mult(source.maxSpeed, dir);
				var force:FFVector = desiredVelocity.minus(source.velocity, tempV1);
				source.addForce(force);
			}
		}
		
		public static function arrive(source:Intelligent, target:FFVector):void
		{
			var dir:FFVector = target.minus(source.position, tempV1);
			var dist:Number = dir.magnitude();
			var desiredVelocity:FFVector;
			//注意这个0是可调的, 主要用于什么位置停止arrive
			if(dist >= 100 )
			{
				desiredVelocity = dir.normalize(dir).mult(source.maxSpeed, dir);
			}else
			{
				desiredVelocity = dir.normalize(dir).mult(source.maxSpeed * dist/100, dir);
			}
			
			var force:FFVector = desiredVelocity.minus(source.velocity, tempV2);
			source.addForce(force);
		}
		
		public static function wander(source:Intelligent):void
		{
			//计算圆心的世界坐标
			var center:FFVector = source.head.mult(source.wanderDist, tempV1);
			//计算抖动偏移量
			var offset:FFVector = tempV2.setTo(Utils.randomBinomial() * source.wanderJitter, Utils.randomBinomial() * source.wanderJitter);
			//将之前的点加上偏移量,得到偏移的点
			var targetPos:FFVector = source.wanderTarget.plus(offset, source.wanderTarget);
			//将偏移的点投影到圆上
			targetPos.minus(center, targetPos);
			targetPos.normalize(targetPos);
			targetPos.mult(source.wanderRadius, targetPos);
			targetPos.plus(center, targetPos);
			source.addForce(targetPos);
		}
		
		public static function pursuit(source:Intelligent, dest:Intelligent):void
		{
			var dir:FFVector = dest.position.minus(source.position, tempV1);
			//首先计算追逐者和被追者得角度，假如被追着面向追逐者，则追逐者不需要再计算被追着将要到达得位置（因为可能这个位置再追逐者背后，造成追逐者在此帧反向）
			//现在将20°角的范围规定为正面
			//用点击计算角度
			//这两个 θ 即角度范围,注意是 二三象限
			//----------------------------------
			//			
			//				E
			//			     ↙   ↑   ↘
			//			 ↙ θ	↑ θ	↘
			//		        ↙       	↑	     ↘
			//				P
			//
			//----------------------------------
			var relativeHeading:Number = source.head.scalarMult(dest.head);
			//face > 0 表示 p 是朝向 e 得
			var face:Number = dir.scalarMult(source.head);
			if(face > 0 && relativeHeading < -0.95)//acos(0.95) = 18°
			{
				seek(source, dest.position);
			}else
			{
				//这里就是找到最佳点
				//lookAheadTime 得意思是从 v 走到 t 需要走多少个 maxSpeed 
				//即所需要得时间
				//这个值正比于两者得距离，反比于两者得速度和
				var lookAheadTime:Number = dir.magnitude()/(source.maxSpeed + dest.velocity.magnitude());
				//如果需要考虑转向时间, 可以加这个
//				lookAheadTime += turnAroundTime(source, dest.position);
				
				//那么要追踪得点为
				var futurePostion:FFVector = dest.position.plus(dest.velocity.mult(lookAheadTime, tempV2), tempV2);//速度乘以时间等于距离
				seek(source, futurePostion);
			}
		}
		
		//lookAheadTime可以加上一个智能体转向的时间, 因为智能体转向也需要时间, 如果不加上这个时间的话 ,那么预测的时间实际是变相减少的
		public static function turnAroundTime(source:Intelligent, target:FFVector):Number
		{
			var dir:FFVector = target.minus(source.position, tempV1);
			dir.normalize(dir);
			var face:Number = source.head.scalarMult(dir);
			//假如是正对, face = 1 那么不需要转向, 返回0, 如果是 在反面 face = -1, 需要最大转向
			var coefficient:Number = 0.5;
			
			return (face - 1) * (-coefficient);
		}
		
		public static function evade(pursuer:Intelligent, evader:Intelligent):void
		{
			var dir:FFVector = pursuer.position.minus(evader.position, tempV1);
			var lookAheadTime:Number = dir.magnitude()/(evader.maxSpeed + pursuer.velocity.magnitude());
			var futurePostion:FFVector = pursuer.position.plus(pursuer.velocity.mult(lookAheadTime, tempV2), tempV2);//速度乘以时间等于距离
			flee(evader, futurePostion);
		}
	}
}