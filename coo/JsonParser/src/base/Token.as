package base
{
	public class Token
	{
		protected var pLineNo:uint;
		protected var pType:int;
		protected var pValue:String;
		
		public function Token(line:uint, type:int, value:String)
		{
			pLineNo = line;
			pType = type;
			pValue = value;
		}
		
		public function get type():int
		{
			return pType;
		}
		
		public function get lineNo():uint
		{
			return pLineNo;
		}
		
		public function get value():String
		{
			return pValue;
		}
		
		public function toString():String
		{
			return pValue;
		}
	}
}