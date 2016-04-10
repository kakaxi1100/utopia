package voforai
{
	import base.EVector;

	public class SteeringBehaviors
	{
		public static var panicDistanceSq:Number = 100*100;
		public function SteeringBehaviors()
		{
		}
		public static function seek(v:Vehicle, t:EVector):void
		{
			var direct:EVector = t.minus(v.position);
			direct.normalizeEquals();
			direct.multEquals(v.maxSpeed);
			v.addForce(direct.minusEquals(v.velocity));
		}
		
		public static function flee(v:Vehicle, t:EVector):void
		{
			var direct:EVector = v.position.minus(t);
			//距离得平方
			var dist2:Number = direct.scalarMult(direct);
			if(dist2 < panicDistanceSq){
				direct.normalizeEquals();
				direct.multEquals(v.maxSpeed);
				v.addForce(direct.minusEquals(v.velocity));
			}
		}
		
		public static function arrive(v:Vehicle, t:EVector):void
		{
			var direct:EVector = t.minus(v.position);
			var dist:Number = direct.magnitude();
			direct.normalizeEquals();
			if(dist < 100){
				direct.multEquals(v.maxSpeed*dist/100);
			}else{
				direct.multEquals(v.maxSpeed);
			}
			v.addForce(direct.minusEquals(v.velocity));
		}
		/**
		 *p 追 e 
		 * Todo:
		 * 还可以考虑转向时间
		 * 
		 * @param v
		 * @param t
		 * 
		 */		
		public static function pursue(p:Vehicle, e:Vehicle):void
		{
			var direct:EVector = e.position.minus(p.position);
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
			var relativeHeading:Number = p.velocity.scalarMult(e.velocity);
			//face > 0 表示 p 是朝向 e 得
			var face:Number = direct.scalarMult(p.velocity);
			if(face >0 && relativeHeading < -0.95)//acos(0.95) = 18°
			{
				seek(p, e.position);
			}else{
				//这里就是找到最佳点
				//lookAheadTime 得意思是从 v 走到 t 需要走多少个 maxSpeed 
				//即所需要得时间
				//这个值正比于两者得距离，反比于两者得速度和
				var lookAheadTime:Number = direct.magnitude()/(p.maxSpeed + e.velocity.length);
				//那么要追踪得点为
				var futurePostion:EVector = e.position.plus(e.velocity.mult(lookAheadTime));
				seek(p, futurePostion);
			}
		}
		
		/**
		 *p 逃避 e 
		 * 同追逐
		 * @param p
		 * @param e
		 * 
		 */		
		public static function evade(p:Vehicle, e:Vehicle):void
		{
			var direct:EVector = e.position.minus(p.position);
			var lookAheadTime:Number = direct.magnitude()/(p.maxSpeed + e.velocity.length);
			//那么要逃避得点为
			var futurePostion:EVector = e.position.plus(e.velocity.mult(lookAheadTime));
			flee(p, futurePostion);
		}
		
//		private static var wonderAngle:Number = 0;
//		public static function wander(p:Vehicle, distance:Number, radius:Number, range:Number):void
//		{
//			//确定圆得位置, 这个圆是在速度方向得正前方
//			//这里所说得位置并不是圆实际得位置，而是圆计算位置
//			//即它并不必要在 vehicle 得 位置的前方,　它只要在 vehicle 朝向(即速度方向)上的前方即可,
//			//当它为0得时候，实际点是在世界坐标得远点, 但是计算得坐标相当于是 小车得原点
//			//看不懂？看不懂你他妈得自己画图就知道了。
//			var center:EVector = p.velocity.normalize().multEquals(distance);
//			//计算在圆上得点取, 以(0,0)为中心, radius为半径
//			var offset:EVector = new EVector();
//			offset.length = radius;
//			wonderAngle += Math.random()*2*range - range;//取值范围是 range 到  -range
//			offset.angle = wonderAngle;
//			var force:EVector = center.plusEquals(offset);
//			p.addForce(force);
//		}
		
		//用闭包这样可以把offset封装到里面
		public static var wander:Function = function():Function
		{
			var offset:EVector = new EVector();//注意这里是多辆小车同时共用这个变量, 但是这个变量只是用来过渡,所以没有问题, 所以才能够安心的使用闭包
			return function(p:Vehicle):void{
				//确定圆得位置, 这个圆是在速度方向得正前方
				//这里所说得位置并不是圆实际得位置，而是圆计算位置
				//即它并不必要在 vehicle 得 位置的前方,　它只要在 vehicle 朝向(即速度方向)上的前方即可,
				//当它为0得时候，实际点是在世界坐标得远点, 但是计算得坐标相当于是 小车得原点
				//看不懂？看不懂你他妈得自己画图就知道了。
				var center:EVector = p.velocity.normalize().multEquals(p.wanderDistance);
				//计算在圆上得点取, 以(0,0)为中心, radius为半径
				offset.setTo(0,0);
				offset.length = p.wanderRadius;
				p.wanderAngle += p.wanderRange*(Math.random()*2 - 1);//取值范围是 range 到  -range
				offset.angle = p.wanderAngle;
				//加上中心点的偏移距离即为世界坐标中的力
				var force:EVector = center.plusEquals(offset);
				p.addForce(force);
			};
			
		}();
		
		/**
		 *pi 插入到  p1 和 p2 之间 
		 * @param p1
		 * @param p2
		 * @param pi
		 */		
		public static function interpose(p1:Vehicle, p2:Vehicle, pi:Vehicle):void
		{
			//先算出两个智能体的中间位置
			var midPoint:EVector = p1.position.plus(p2.position).multEquals(0.5);
			//然后计算当前pi到达这个点所需要得最少的时间，即拥有最大速度
			var timeToReachMidPoint:Number = pi.position.distance( midPoint)/pi.maxSpeed;
			//用这个时间来预测 p1和p2 将要到达得位置
			//先计算出速度于这个时间乘积然后再加上现有的位置
			//分成两步些主要是为了节省变量
			var p1Arriving:EVector = p1.velocity.mult(timeToReachMidPoint);
			var p1Pos:EVector = p1Arriving.plusEquals(p1.position);
			
			var p2Arriving:EVector = p2.velocity.mult(timeToReachMidPoint);
			var p2Pos:EVector = p2Arriving.plusEquals(p2.position);
			
			//计算它们未来时间两个小车位置的中间点
			var temp:EVector = p1Pos.plusEquals(p2Pos).multEquals(0.5);
			midPoint.setTo(temp.x, temp.y);
			//然后小车 pi 抵达那个点
			arrive(pi, midPoint);
		}
		
		/**
		 *跟随路径 
		 * @param p
		 * 
		 */		
		public static function followPath(p:Vehicle):void
		{
			//注意这里请将path封装成一个类！！！
			//由于这个只是实验性质的测试，所以就写在这里
			//妈的我懒行了吧, 别唧唧歪歪的了.
			var dist:Number = p.position.distanceSq(p.path[p.cursor]);
			if(dist < p.wayPointSeekDistSq)
			{
				p.cursor++;
				if(p.cursor >= p.path.length)
				{
					p.cursor = 0;
				}
			}
			
			seek(p, p.path[p.cursor]);
		}
	}
}



















