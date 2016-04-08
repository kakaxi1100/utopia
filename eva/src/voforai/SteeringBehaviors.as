package voforai
{
	import base.EVector;

	public class SteeringBehaviors
	{
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
			direct.normalizeEquals();
			direct.multEquals(v.maxSpeed);
			v.addForce(direct.minusEquals(v.velocity));
		}
		
		public static function arrive(v:Vehicle, t:EVector):void
		{
			var direct:EVector = t.minus(v.position);
			var dist:Number = direct.magnitude();
			direct.normalizeEquals();
			if(dist < 200){
				direct.multEquals(v.maxSpeed*dist/200);
			}else{
				direct.multEquals(v.maxSpeed);
			}
			v.addForce(direct.minusEquals(v.velocity));
		}
		/**
		 *p 追 e 
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
				var lookAheadTime:Number = direct.magnitude()/p.maxSpeed;
				//那么要追踪得点为
				var futurePostion:EVector = e.position.plus(e.velocity.mult(lookAheadTime));
				seek(p, futurePostion);
			}
		}
		
		/**
		 *e 逃避 p 
		 * 同追逐
		 * @param p
		 * @param e
		 * 
		 */		
		public static function evade(p:Vehicle, e:Vehicle):void
		{
			var direct:EVector = e.position.minus(p.position);
			var lookAheadTime:Number = direct.magnitude()/p.maxSpeed;
			//那么要追踪得点为
			var futurePostion:EVector = e.position.plus(e.velocity.mult(lookAheadTime));
			flee(p, futurePostion);
		}
	}
}