package base
{
	public class JsonKey
	{
		private var mKey:String;
		public function JsonKey(key:String)
		{
			mKey = key;
		}
		
		public function getValue():String
		{
			return mKey;
		}
		
		public function toString():String
		{
			return mKey;
		}
	}
}