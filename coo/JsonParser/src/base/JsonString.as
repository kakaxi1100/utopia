package base
{
	public class JsonString extends JsonValue
	{
		private var mValue:String;
		public function JsonString(value:String)
		{
			super();
			mValue = value;
		}
		
		public function getValue():String
		{
			return mValue;
		}
		
		override public function getType():int
		{
			return JsonValue.TYPE_STRING;
		}
		
		public function toString():String
		{
			return mValue;
		}
	}
}