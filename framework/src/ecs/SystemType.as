package ecs
{
	public class SystemType
	{
		public static const SYS_TYPE_TEST1:uint = mNewType;
		public static const SYS_TYPE_TEST2:uint = mNewType;
		
		
		private static var mMask:uint = 1;
		private static function get mNewType():uint
		{
			var temp:uint = mMask;
			mMask = mMask << 1;
			return mMask;
		}
	}
}