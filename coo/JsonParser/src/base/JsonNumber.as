package base
{
	public class JsonNumber extends JsonValue
	{
		private var mNumber:Number;
		public function JsonNumber(num:Number)
		{
			super();
			mNumber = num;
		}
		
		public function getValue():Number
		{
			return mNumber;
		}
		
		override public function getType():int
		{
			return JsonValue.TYPE_NUMBER;
		}
		
		public function toString():String
		{
			return mNumber.toString();
		}
	}
}