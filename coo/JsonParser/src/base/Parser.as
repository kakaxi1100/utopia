package base
{

	/**
	 *语法规范
	 * 没有处理 { 空 }的情况
	 * 
	 * program => { nestedValue } | { 空 }
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
	 * 生成的语法树为
	 * 
	 * 
	 *  
	 * @author Ares
	 * 
	 */	
	public class Parser
	{
		private var mLexer:Lexer;
		private var mASTree:ASTree;
		public function Parser(lexer:Lexer)
		{
			mLexer = lexer;
		}
		
		public function parse():void
		{
			var token:Token = getToken();
			if(token.type != TokenType.OPEN_CURLY)
			{
				throw Error("line" + token.lineNo + " :格式错误!必须以 { 开头");
			}
			
			mASTree = new Composite(token);
			
			nestedCurlyValue(mASTree);
			
			token = getToken();
			if(token.type != TokenType.CLOSE_CURLY)
			{
				throw Error("line" + token.lineNo + " :格式错误!必须以 } 结尾");
			}
		}
		
		private function nestedCurlyValue(rootNode:ASTree):ASTree
		{
			var nestNode:ASTree = rootNode;
			var node:ASTree;
			var hasMore:Boolean = false;
			var token:Token;
			do{
				node = item();
				nestNode.insert(node);
				
				token = getToken(true);
				if(token && token.type == TokenType.COMMA)
				{
					var comma:Token = getToken();//跳过逗号
					hasMore = true;
				}else{
					hasMore = false;
				}
			}while(hasMore)
			
			return nestNode;
		}
		
		private function item():ASTree
		{
			var keyNode:ASTree;
			var valueNode:ASTree;
			var node:ASTree;
			var token:Token;
			
			var key:Token = getToken();
			if(key.type != TokenType.STRING)
			{
				throw Error("line" + key.lineNo + " Key必须为字符串类型!当前类型为: " + key.value);
			}
			if(key.value == "")
			{
				throw Error("line" + key.lineNo + " Key不能为空!");
			}
			keyNode = new Leaf(key);
			
			token = getToken();
			if(token.type != TokenType.COLON)
			{
				throw Error("line" + token.lineNo + "缺少冒号!");
			}
			node = new BinaryNode(token);// :
			
			valueNode = parseValue();
			
			node.insert(keyNode);
			node.insert(valueNode);
			
			return node;
		}
		
		private function nestedBracketValue(rootNode:ASTree):ASTree
		{
			var nestNode:ASTree = rootNode;
			var node:ASTree;
			var hasMore:Boolean = false;
			var token:Token;
			do{
				node = parseValue();
				nestNode.insert(node);
				
				token = getToken(true);
				if(token && token.type == TokenType.COMMA)
				{
					var comma:Token = getToken();//跳过逗号
					hasMore = true;
				}else{
					hasMore = false;
				}
			}while(hasMore)
			
			return nestNode;
		}
		
		private function parseValue():ASTree
		{
			var valueNode:ASTree;
			
			var token:Token = getToken();
			if(token.type == TokenType.STRING)
			{
				valueNode = new Leaf(token);
			}else if(token.type == TokenType.NUMBER)
			{
				valueNode = new Leaf(token);
			}else if(token.type == TokenType.OPEN_CURLY)
			{
				valueNode = new Composite(token);
				
				nestedCurlyValue(valueNode);
				
				token = getToken();
				if(token.type != TokenType.CLOSE_CURLY)
				{
					throw Error("line" + token.lineNo + "格式错误!必须以 } 结尾");
				}
			}else if(token.type == TokenType.OPEN_BRACKET)
			{
				valueNode = new Composite(token);
				nestedBracketValue(valueNode);
				
				token = getToken();
				if(token.type != TokenType.CLOSE_BRACKET)
				{
					throw Error("line" + token.lineNo + "格式错误!必须以 ] 结尾");
				}
			}else
			{
				throw Error("line" + token.lineNo + "错误的值格式!");
			}
			
			return valueNode;
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
				throw Error("line" + mLexer.lookLast().lineNo + "单词未定义!");
			}
			
			return token;
		}
		
		public function toString():String
		{
			return mASTree.toString();
		}

		public function get ast():ASTree
		{
			return mASTree;
		}

	}
}