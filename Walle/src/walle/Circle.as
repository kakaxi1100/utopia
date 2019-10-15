package walle
{
	public class Circle
	{
		private var mCenter:FFVector = new FFVector();
		private var mRadius:Number = 10;
		public function Circle(r:Number = 10, cx:Number = 0, cy:Number = 0)
		{
			mCenter.setTo(cx, cy);
			mRadius = r;
		}
		
		public function get center():FFVector
		{
			return mCenter;
		}
		
		public function get radius():Number
		{
			return mRadius;
		}
		
		
		public function get x():Number
		{
			return this.mCenter.x;
		}
		public function set x(value:Number):void
		{
			this.mCenter.x = value;
		}
		
		public function get y():Number
		{
			return this.mCenter.y;
		}
		public function set y(value:Number):void
		{
			this.mCenter.y = value;
		}
	}
}