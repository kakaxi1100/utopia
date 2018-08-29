package base
{
	public class JsonValue
	{
		public static const TYPE_STRING:int = 1;
		public static const TYPE_NUMBER:int = 2;
		public static const TYPE_OBJECT:int = 3;
		public static const TYPE_ARRAY:int = 4;
		
		public function JsonValue()
		{
		}
		
		public function getType():int
		{
			return 0;
		}
	}
}