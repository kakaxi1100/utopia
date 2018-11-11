package common
{
	/**
	 * 由于采用的 uint 所以只能  bitmask 32位
	 * 如果你要更多位的话,你可以用一个BitMask数组
	 * 
	 * @author juli
	 * 
	 */	
	public class BitMask
	{
		private var mMask:uint;
		
		public function setMask(m:uint):void
		{
			mMask = m;
		}
		
		public function getMask():uint
		{
			return mMask;
		}
		
		public function addMask(m:uint):void
		{
			mMask |= m;
		}
		
		public function removeMask(m:uint):void
		{
			mMask ^= m;
		}
		
		public function hasMask(m:uint):Boolean
		{
			return ((mMask | m) == mMask);
		}
		
		public function equalMask(m:uint):Boolean
		{
			return mMask == m;
		}
		
		public function toString():String
		{
			return mMask.toString(2);
		}
	}
}