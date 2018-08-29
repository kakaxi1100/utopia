package base
{
	import flash.utils.Dictionary;

	//key 是 jsonKey , value 是 jsonVlaue
	public class JsonObject extends JsonValue
	{
		private var mDict:Dictionary = new Dictionary();
		public function JsonObject()
		{
			super();
		}
		
		public function insert(key:JsonKey, value:JsonValue):void
		{
			if(value.getType() == JsonValue.TYPE_NUMBER)
			{
				mDict[key.getValue()] = (value as JsonNumber).getValue();
			}else if(value.getType() == JsonValue.TYPE_STRING)
			{
				mDict[key.getValue()] = (value as JsonString).getValue();
			}else if(value.getType() == JsonValue.TYPE_OBJECT)
			{
				mDict[key.getValue()] = (value as JsonObject).getValue();
			}else if(value.getType() == JsonValue.TYPE_ARRAY)
			{
				mDict[key.getValue()] = (value as JsonArray).getValue();
			}
		}
		
		public function searchNumber(keyStr:String):Number
		{
			return mDict[keyStr];
		}
		
		public function searchString(keyStr:String):String
		{
			return mDict[keyStr];
		}
		
		public function searchObject(keyStr:String):Dictionary
		{
			return mDict[keyStr];
		}
		
		public function searchArray(keyStr:String):Array
		{
			return mDict[keyStr];
		}
		
		public function getValue():Dictionary
		{	
			return mDict;
		}
		
		override public function getType():int
		{
			return JsonValue.TYPE_OBJECT;
		}
		
		public function toString():String
		{
			var s:String = "{";
			var ob:String = "";
			var cb:String = "";
			for(var key:String in mDict)
			{
				if(mDict[key] is Array)
				{
					ob = "[";
					cb = "]"
				}
				s += key +":"+ ob + mDict[key].toString() + cb + ",";
			}
			
			if(s.charAt(s.length - 1) == ",")
			{
				s = s.substr(0, s.length - 1);
			}
			
			s += "}"
			return s;
		}
	}
}