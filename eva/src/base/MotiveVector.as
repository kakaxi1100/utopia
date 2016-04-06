package base
{
	public class MotiveVector extends EVector
	{
		public function MotiveVector(px:Number=0, py:Number=0)
		{
			super(px, py);
		}
		
		/**
		 *截断 
		 * @param value
		 * 
		 */		
		public function truncate(value:Number):void
		{
			length = value;
		}
		
		/**
		 *设置长度 
		 * @return 
		 * 
		 */		
		public function get length():Number
		{
			return magnitude();
		}
		
		public function set length(value:Number):void
		{
			var len:Number = magnitude();
			if(value == 0 || len == 0)
			{
				x = y = 0;
				return;
			}
			
			var ratio:Number = value/len;
			x = ratio*x;
			y = ratio*y;	
		}
		
		/**
		 *角度 
		 * @return 
		 * 
		 */		
		public function get angle():Number
		{
			return Math.atan2(x, y);
		}
		
		public function set angle(value:Number):void
		{
			var len:Number = magnitude();
			x = Math.cos(value)*len;
			y = Math.sin(value)*len;
		}
	}
}