package voforai
{
	import base.EVector;

	public class SteeringBehaviors
	{
		public function SteeringBehaviors()
		{
		}
		/**
		 * @param v
		 * @param t
		 * 
		 */		
		public static function seek(v:Vehicle, t:EVector):void
		{
			var direct:EVector = t.minus(v.position);
			direct.normalizeEquals();
			direct.multEquals(v.maxSpeed);
//			v.velocity.setTo(direct.x, direct.y);
			v.addForce(direct.minusEquals(v.velocity));
		}
	}
}