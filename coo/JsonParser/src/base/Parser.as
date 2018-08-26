package base
{
	/**
	 *语法规范
	 * 
	 * program => { nestedValue } | {空}
	 * 
	 * nestedCurlyValue => item | nestedValue , item
	 * 
	 * item => key : value
	 * 
	 * key => string
	 * 
	 * nestedBracketValue => value | nestedBracketValue, value
	 * 
	 * value => string | number | { nestedValue } | [ nestedBracketValue ]
	 * 
	 *  
	 * @author Ares
	 * 
	 */	
	public class Parser
	{
		private var mLexer:Lexer;
		public function Parser(lexer:Lexer)
		{
			mLexer = lexer;
		}
		
		public function parse():void
		{
			var token:Token = getToken();
			trace(token);
			if(token.type != TokenType.OPEN_CURLY)
			{
				throw Error("line" + token.linNo + " :格式错误!必须以 { 开头");
			}
			
			nestedCurlyValue();
			
			token = getToken();
			if(token.type != TokenType.CLOSE_CURLY)
			{
				throw Error("line" + token.linNo + " :格式错误!必须以 } 结尾");
			}
			
			trace("解析成功!");
		}
		
		public function nestedCurlyValue():void
		{
			var hasMore:Boolean = false;
			var token:Token;
			do{
				item();
				token = getToken(true);
				trace(token);
				if(token && token.type == TokenType.COMMA)
				{
					getToken();//跳过逗号
					hasMore = true;
				}else{
					hasMore = false;
				}
			}while(hasMore)
		}
		
		public function item():void
		{
			var key:Token = getToken();
			trace(key);
			if(key.type != TokenType.STRING)
			{
				throw Error("line" + key.linNo + " Key 必须为字符串!");
			}
			
			var token:Token = getToken();
			trace(token);
			if(token.type != TokenType.COLON)
			{
				throw Error("line" + token.linNo + "缺少冒号!");
			}
			
			parseValue();
		}
		
		private function nestedBracketValue():void
		{
			var hasMore:Boolean = false;
			var token:Token;
			do{
				parseValue();
				token = getToken(true);
				trace(token);
				if(token && token.type == TokenType.COMMA)
				{
					getToken();//跳过逗号
					hasMore = true;
				}else{
					hasMore = false;
				}
			}while(hasMore)
		}
		
		private function parseValue():void
		{
			var token:Token = getToken();
			trace(token);

			if(token.type == TokenType.STRING)
			{
				
			}else if(token.type == TokenType.NUMBER)
			{
				
			}else if(token.type == TokenType.OPEN_CURLY)
			{
				nestedCurlyValue();
				token = getToken();
				trace(token);
				if(token.type != TokenType.CLOSE_CURLY)
				{
					throw Error("line" + token.linNo + "格式错误!必须以 } 结尾");
				}
			}else if(token.type == TokenType.OPEN_BRACKET)
			{
				nestedBracketValue();
				token = getToken();
				trace(token);
				if(token.type != TokenType.CLOSE_BRACKET)
				{
					throw Error("line" + token.linNo + "格式错误!必须以 ] 结尾");
				}
			}else
			{
				throw Error("line" + token.linNo + "错误的值格式!");
			}
		}
		
		private function  getToken(peek:Boolean = false):Token
		{
			var token:Token;
			if(peek == false)
			{
				token = mLexer.next();
			}else
			{
				token = mLexer.peek();
			}
			if(token == null)
			{
				throw Error("line" + mLexer.lookLast().linNo + "单词未定义!");
			}
			
			return token;
		}
		
	}
}