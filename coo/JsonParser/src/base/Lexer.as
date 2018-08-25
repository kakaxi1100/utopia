package base
{
	import flash.filesystem.FileStream;

	public class Lexer
	{
		//单词列表
		public var tokenList:Vector.<Token> = new Vector.<Token>();
		
		private var mStream:FileStream;
		private var mLineNo:uint;
		
		private static const TABLE_CODE:uint = 9; //\t
		private static const ENDOFLINE_CODE:uint = 13; //\r
		private static const NEWLINE_CODE:uint = 10; //\n
		private static const SPACE_CODE:uint = 32;//空格
		private static const SLASH_CODE:uint = 47;// /
		
		public function Lexer(stream:FileStream)
		{
			mStream = stream;
			mLineNo = 1;
		}
		
		private function read():void
		{
			var char:uint;
			while(mStream.bytesAvailable > 0)
			{
				//1.先排除空白 即空格和制表符
				char = mStream.readByte();
				if(char == TABLE_CODE || char == SPACE_CODE)
				{
					continue;
				}else if(char == ENDOFLINE_CODE)//判断是否为换行符
				{
					//进入endoflinestate
					stateEndOfLine();
				}else if(char == SLASH_CODE)
				{
					//进入注释状态
					stateSlash();
				}
			}
		}
		
		private function stateSlash():void
		{
			
		}
		
		private function stateEndOfLine():void
		{
			var char:uint = mStream.readByte();
			if(char == NEWLINE_CODE)
			{
				//新的一行
				++mLineNo;
			}else{
				
				throw Error("line"+mLineNo+ ": 未识别的行尾!");
			}
		}
		
	}
}