package base
{

	public class Excuter
	{
		private var mJsonObj:JsonObject;
		private var mParser:Parser;
		public function Excuter(parser:Parser)
		{
			mParser = parser;
		}
		
		public function excute():void
		{
			mJsonObj = excuteNCV(mParser.ast);
		}
		
		//执行 nestCulyValue
		public function excuteNCV(node:ASTree):JsonObject
		{
			var jsonObj:JsonObject = new JsonObject();
			var i:int;
			for(i = 0; i < node.children.length; i++)
			{
				excuteItem(node.children[i], jsonObj);
			}
			
			return jsonObj;
		}
		
		public function excuteItem(node:ASTree, parent:JsonObject):void
		{
			var jsonKey:JsonKey;
			var jsonValue:JsonValue;
			jsonKey = excuteKey(node.getFirst());
			jsonValue = excuteValue(node.getLast());
			
			parent.insert(jsonKey, jsonValue);
		}

		private function excuteKey(node:ASTree):JsonKey
		{
			var jsonKey:JsonKey = new JsonKey(node.info.value);
			
			return jsonKey;
		}		
		
		private function excuteValue(node:ASTree):JsonValue
		{
			var jsonValue:JsonValue;
			if(node.info.type == TokenType.STRING)
			{
				jsonValue = new JsonString(node.info.value);
			}else if(node.info.type == TokenType.NUMBER)
			{
				jsonValue = new JsonNumber(parseFloat(node.info.value));
			}else if(node.info.type == TokenType.OPEN_CURLY)
			{
				jsonValue = excuteNCV(node);
			}else if(node.info.type == TokenType.OPEN_BRACKET)
			{
				jsonValue = excuteArray(node);
			}
			
			return jsonValue;
		}
		
		private function excuteArray(node:ASTree):JsonValue
		{
			var jsonArray:JsonValue = new JsonArray();
			var i:int;
			for(i = 0; i < node.children.length; i++)
			{
				var value:JsonValue = excuteValue(node.children[i]);
				(jsonArray as JsonArray).insert(value)
			}
			
			return jsonArray;
		}
		
		public function get jsonObject():JsonObject
		{
			return mJsonObj;
		}
		
		public function toString():String
		{
			return mJsonObj.toString();
		}
	}
}