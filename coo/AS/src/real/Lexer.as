package real
{
	import base.Token;
	
	import utils.ParseString;

	public class Lexer
	{
		//字符数组
		public var queue:Vector.<Token> = new Vector.<Token>();
		public var curtIndex:int;
		//所有经过trim后的文本
		private var allLines:Array;
		//由于AS的限制这里暂时用lines代替
		//raw 原始文本
		public function Lexer(raw:String)
		{
			allLines = ParseString.getTrimLines(raw);
			curtIndex = 0;
		}
		
		public function readLine():void
		{
			var i:int = 0;
			var line:String;
			var curChar:String;
			var charIndex:int;
			for(i = 0;  i < allLines.length; i++)
			{
				line = allLines[i];
				do
				{
					curChar = line[charIndex];

					++charIndex;
				}while(charIndex < line.length)
			}
		}
		
		public function letterState(index:int, line:String):void
		{
			var curIndex:int = index;
			var curChar:String = line[curIndex];
			var tempString:String;
			do{
				tempString += curChar;
				if(++curIndex >= line.length)
				{
					break;
				}
				curChar = line[curIndex];
				if(!isLetter(curChar) && !isDigit(curChar))
				{
					throw Error("未识别的符号: " + curChar);
				}
			}while(curIndex < line.length)
			//判断它是变量声明、保留字
			if(isReserved(tempString))
			{
				//添加到保留字中
			}else{
				//作为变量
			}
		}
		
		public function isReserved(str:String):Boolean
		{
			var reg:RegExp = /if|for/;
			return reg.test(str);
		}
		
		public function digitState():void
		{
			
		}
		
		public function isLetter(char:String):Boolean
		{
			var reg:RegExp = /[a-z][A-Z]/; 
			return reg.test(char);
		}
		
		public function isDigit(char:String):Boolean
		{
			var reg:RegExp = /[0-9]/; 
			return reg.test(char);
		}
		
		//获取下一个token
		public function getNextToken():Token
		{ 
			if(curtIndex < queue.length){
				return queue[curtIndex++];
			}
			
			return null;
		}
		
		//查看下一个token
		public function lookAhead():Token
		{
			var temIndex:int = curtIndex + 1;
			if(temIndex < queue.length){
				return queue[temIndex];
			}
			return null;
		}
		
		//把token加入到queue中
		public function addToken(t:Token):void
		{
			queue.push(t);
		}
	}
}