package base
{
	public class JsonArray extends JsonValue
	{
		private var mArray:Array = new Array();
		private var mFirstType:int = 0;
		public function JsonArray()
		{
			super();
		}
		
		public function insert(value:JsonValue):void
		{
			if(mFirstType == 0)
			{
				mFirstType = value.getType();
			}else{
				if(value.getType() != mFirstType)
				{
					throw Error("数组类型必须一致!");
				}
			}
			
			if(value.getType() == JsonValue.TYPE_NUMBER)
			{
				mArray.push((value as JsonNumber).getValue());	
			}else if(value.getType() == JsonValue.TYPE_STRING)
			{
				mArray.push((value as JsonString).getValue());	
			}else if(value.getType() == JsonValue.TYPE_OBJECT)
			{
				mArray.push((value as JsonObject).getValue());	
			}else if(value.getType() == JsonValue.TYPE_ARRAY)
			{
				mArray.push((value as JsonArray).getValue());	
			}
			
		}
		
		public function getValue():Array
		{
			return mArray;
		}
		
		override public function getType():int
		{
			return JsonValue.TYPE_ARRAY;
		}
		
		public function toString():String
		{
			var s:String = "[";
			for(var i:int = 0; i < mArray.length - 1; i++)
			{
				s += mArray[i].toString() + ",";
			}
			s += mArray[i].toString() + "]";
			return s;
		}
	}
}