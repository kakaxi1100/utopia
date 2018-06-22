package base
{
	import utils.ParseString;

	public class Lexer
	{
		public static const reg:RegExp = /([0-9]+)|([A-Za-z_][A-Za-z_0-9]*|==|<=)/g;
		public var queue:Vector.<Token> = new Vector.<Token>();
		private var allLines:Array;
		//由于AS的限制这里暂时用lines代替
		//raw 原始文本
		public function Lexer(raw:String)
		{
			var lines:Array = ParseString.getTrimLines(raw);
			allLines = lines;
		}
		
		//从每一行中读取单词
		public function readline():void
		{
			var i:int = 0;
			for(i = 0;  i < allLines.length; i++)
			{
				
			}
		}
		
		//把token加入到queue中
		public function addToken():void
		{
			
		}
	}
}