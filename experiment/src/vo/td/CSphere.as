package vo.td
{
	public class CSphere
	{
		private var mC:CPoint4D;
		private var mR:Number;
		
		public function CSphere(c:CPoint4D = null, r:Number = 0)
		{
			mC = c;
			mR = r;
		}
		
		
		public function get c():CPoint4D
		{
			return mC;
		}

		public function set c(value:CPoint4D):void
		{
			mC = value;
		}

		public function get r():Number
		{
			return mR;
		}

		public function set r(value:Number):void
		{
			mR = value;
		}


	}
}