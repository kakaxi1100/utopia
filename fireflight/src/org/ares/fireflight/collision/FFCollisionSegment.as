package org.ares.fireflight.collision
{
	import org.ares.fireflight.FFVector;

	public class FFCollisionSegment
	{
		private var mStart:FFVector;
		private var mEnd:FFVector;
		
		//临时存储
		private var mTemp1:FFVector = new FFVector();
		private var mTemp2:FFVector = new FFVector();
		public function FFCollisionSegment(s:FFVector, e:FFVector)
		{
			mStart = s;
			mEnd = e;
		}
		
		/**
		 *线段方向 
		 * @param v
		 * @return 
		 * 
		 */		
		public function direction(v:FFVector = null):FFVector
		{
			mEnd.minus(mStart, mTemp1);
			mTemp1.normalizeEquals();
			
			if(v == null){
				v = new FFVector(mTemp1.x, mTemp1.y);
			}else{
				v.setTo(mTemp1.x, mTemp1.y);
			}
			
			return v;
		}

		public function get start():FFVector
		{
			return mStart;
		}

		public function set start(value:FFVector):void
		{
			start = value;
		}
		
		public function get end():FFVector
		{
			return mEnd;
		}

		public function set end(value:FFVector):void
		{
			mEnd = value;
		}
	}
}