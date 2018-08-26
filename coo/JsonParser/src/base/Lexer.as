package base
{
	import flash.filesystem.FileStream;
	/**
	 *
	 * 合法的单词有
	 * 
	 * { } => 花括号
	 * [ ] => 中括号
	 * // => 单行注释
	 * / * * / => 多少注释
	 * 整型和浮点 => 数字
	 * " " => 字符串
	 * , => 逗号
	 * : => 冒号
	 *  
	 * @author Ares
	 * 
	 */
	public class Lexer
	{
		//单词列表
		private var mTokenList:Vector.<Token> = new Vector.<Token>();
		
		private var mStream:FileStream;
		private var mLineNo:uint;
		private var mIndex:uint = 0;
		private var mPeekIndex:uint = 0;
		private var mCharBuff:Vector.<uint> = new Vector.<uint>();//缓存char
		
		private static const TABLE_CODE:uint = 9; // \t
		private static const ENDOFLINE_CODE:uint = 13; // \r
		private static const NEWLINE_CODE:uint = 10; // \n
		private static const SPACE_CODE:uint = 32;// 空格
		private static const SLASH_CODE:uint = 47;// /
		private static const STAR_CODE:uint = 42;// *
		private static const QUOTATION_CODE:uint = 34;// "
		private static const OPENCURLY_CODE:uint = 123;// {
		private static const CLOSECURLY_CODE:uint = 125;// }
		private static const OPENBRACKET_CODE:uint = 91;// [
		private static const CLOSEBRACKET_CODE:uint = 93;// ]
		private static const COMMA_CODE:uint = 44;// ,
		private static const COLON_CODE:uint = 58;// :
		private static const DOT_CODE:uint = 46;// .
		private static const ZERO_CODE:uint = 48;// 0
		private static const NINE_CODE:uint = 57;// 9
		
		
		public function Lexer(stream:FileStream)
		{
			mStream = stream;
			mLineNo = 1;
		}

		/**
		 *读取下一个token 
		 * @return 
		 * 
		 */		
		public function next():Token
		{
			var token:Token;
			if(mIndex >= mTokenList.length)
			{
				return null;
			}
			token = mTokenList[mIndex];
			mPeekIndex = mIndex;
			mIndex = mIndex + 1;
			return token;
		}
		/**
		 *预读下一个token
		 * @return 
		 * 
		 */		
		public function peek():Token
		{
			var token:Token;
			var tempIndex:int = mPeekIndex + 1;
			if(tempIndex >= mTokenList.length)
			{
				return null;
			}
			token = mTokenList[tempIndex];
			return token;
		}
		/**
		 *查看最后一个元素 
		 * @return 
		 * 
		 */		
		public function lookLast():Token
		{
			if(mTokenList.length == 0)
			{
				throw Error("空白文件无法解析!");
			}
			return mTokenList[mTokenList.length - 1];
		}
		
		public function read():void
		{
			stateNormal();
			clearCharBuff();
			mStream.close();
		}
		
		public function length():uint
		{
			return mTokenList.length;
		}
		
		private function stateNormal():void
		{
			var char:uint;
			var token:Token;
			var value:String;
			while(mStream.bytesAvailable > 0)
			{
				//1.先排除空白 即空格和制表符
				char = getChar();
				if(char == TABLE_CODE || char == SPACE_CODE)
				{
					continue;
				}else if(char == ENDOFLINE_CODE)//判断是否为换行符
				{
					//当进入到换行符的时候
					stateEndOfLine();
				}else if(char == SLASH_CODE)
				{
					char = getChar();
					if(char == SLASH_CODE)// /
					{
						//进入注释状态
						stateOneLineComment();
					}else if(char == STAR_CODE)// *
					{
						stateMutipleLinesComment();
					}
				}else if(char == QUOTATION_CODE)
				{
					//进入引号状态
					stateQuotation();
				}else if(char >= ZERO_CODE && char <= NINE_CODE)
				{
					//进入数字状态
					mCharBuff.push(char);
					stateInt();
				}else if(char == DOT_CODE)
				{
					//浮点状态
					mCharBuff.push(char);
					stateFloat();
				}else if(char == OPENBRACKET_CODE)
				{
					token = new TokenIdentity(mLineNo, TokenType.OPEN_BRACKET, "[");
					mTokenList.push(token);
				}else if(char == OPENCURLY_CODE)
				{
					token = new TokenIdentity(mLineNo, TokenType.OPEN_CURLY, "{");
					mTokenList.push(token);
				}else if(char == CLOSEBRACKET_CODE)
				{
					token = new TokenIdentity(mLineNo, TokenType.CLOSE_BRACKET, "]");
					mTokenList.push(token);
				}else if(char == CLOSECURLY_CODE)
				{
					token = new TokenIdentity(mLineNo, TokenType.CLOSE_CURLY, "}");
					mTokenList.push(token);
				}else if(char == COMMA_CODE)
				{
					token = new TokenIdentity(mLineNo, TokenType.COMMA, ",");
					mTokenList.push(token);
				}else if(char == COLON_CODE)
				{
					token = new TokenIdentity(mLineNo, TokenType.COLON, ":");
					mTokenList.push(token);
				}else
				{
					clearCharBuff();
					throw Error("line"+mLineNo+ ": 未识别的标识符 "+ String.fromCharCode(char) +" 码值: " + char);
				}
			}
		}
		
		private function getChar():uint
		{
			var char:uint;
			if(mCharBuff.length > 0)
			{
				char = mCharBuff.pop();
			}else{
				char = mStream.readByte();
			}
			
			return char;
		}
		
		private function stateInt():void
		{
			var char:uint;
			while(mStream.bytesAvailable > 0)
			{
				char = mStream.readByte();
				if(char >= ZERO_CODE && char <= NINE_CODE )
				{
					mCharBuff.push(char);					
				}else if(char == DOT_CODE)
				{
					mCharBuff.push(char);
					stateFloat();
				}else{
					//生成整型token
					var value:String="";
					while(mCharBuff.length > 0)
					{
						value += String.fromCharCode(mCharBuff.shift());
					}
					var token:Token = new TokenNumber(mLineNo, TokenType.NUMBER, value);
					mTokenList.push(token);
					
					//最后一个字符要读入
					mCharBuff.push(char);
					stateNormal();
				}
			}
		}
		
		private function stateFloat():void
		{
			var char:uint;
			while(mStream.bytesAvailable > 0)
			{
				char = mStream.readByte();
				if(char >= ZERO_CODE && char <= NINE_CODE )
				{
					mCharBuff.push(char);
				}else{
					//生成浮点型token
					var value:String="";
					while(mCharBuff.length > 0)
					{
						value += String.fromCharCode(mCharBuff.shift());
					}
					var token:Token = new TokenNumber(mLineNo, TokenType.NUMBER, value);
					mTokenList.push(token);
					
					//最后一个字符要读入
					mCharBuff.push(char);
					stateNormal();
				}
			}
		}
		
		private function stateQuotation():void
		{
			var char:uint;
			while(mStream.bytesAvailable > 0)
			{
				char = mStream.readByte();
				if(char != QUOTATION_CODE)// "
				{
					mCharBuff.push(char);
				}else{
					//生成字符串token
					var value:String="";
					while(mCharBuff.length > 0)
					{
						value += String.fromCharCode(mCharBuff.shift());
					}
					var token:Token = new TokenString(mLineNo, TokenType.STRING, value);
					mTokenList.push(token);
					
					stateNormal();
				}
			}
		}
		
		private function stateMutipleLinesComment():void
		{
			var char:uint;
			while(mStream.bytesAvailable > 0)
			{
				char = getChar();
				if(char == STAR_CODE)// *
				{
					char = getChar();
					if(char == SLASH_CODE)// /
					{
						stateNormal();
					}
				}
			}
		}
		
		/**
		 *单行注释
		 * 直到行尾才结束 
		 * 
		 */		
		private function stateOneLineComment():void
		{
			var char:uint;
			while(mStream.bytesAvailable > 0)
			{
				char = getChar();
				if(char == ENDOFLINE_CODE)
				{
					stateEndOfLine();
				}
			}
		}
		
		private function stateEndOfLine():void
		{
			var char:uint = getChar();
			if(char == NEWLINE_CODE)
			{
				//新的一行
				++mLineNo;
				stateNormal();
			}else{
				throw Error("line"+mLineNo+ ": 未识别的行尾!");
			}
		}
		
		private function clearCharBuff():void
		{
			while(mCharBuff.length > 0)
			{
				mCharBuff.pop();
			}
		}
		
		public function toString():String
		{
			return mTokenList.join(" ");
		}
	}
}