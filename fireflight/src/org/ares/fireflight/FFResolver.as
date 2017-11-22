package org.ares.fireflight
{
	public class FFResolver
	{
		private static var mContactInfo:FFContactInfo = new FFContactInfo();

		private static var mTemp1:FFVector = new FFVector();
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
		
		public static function resolveInterpenetration(b1:FFRigidBody, b2:FFRigidBody):void
		{
			var dist:Number = mContactInfo.penetration/2;
			var move:FFVector = mContactInfo.normal.mult(dist, mTemp1);
			b1.position.plusEquals(move);
			b2.position.minusEquals(move);
		}
		
		public function resolveVelocity():void
		{
			
		}
	}
}