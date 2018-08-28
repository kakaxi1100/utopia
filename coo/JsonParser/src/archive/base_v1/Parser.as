package archive.base_v1
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
				throw Error("line" + token.linNo + " :格式错误!必须以 { 开头");
			}
			
			mASTree = nestedCurlyValue();
			
			token = getToken();
			if(token.type != TokenType.CLOSE_CURLY)
			{
				throw Error("line" + token.linNo + " :格式错误!必须以 } 结尾");
			}
			
			trace("解析成功!");
		}
		
		public function nestedCurlyValue():ASTree
		{
			var nodeList:Vector.<ASTree> = new Vector.<ASTree>();
			var commaList:Vector.<Token> = new Vector.<Token>();
			var node:ASTree;
			var hasMore:Boolean = false;
			var token:Token;
			do{
				node = item();
				nodeList.push(node);
				token = getToken(true);
				//trace(token);
				if(token && token.type == TokenType.COMMA)
				{
					var comma:Token = getToken();//跳过逗号
					commaList.push(comma);
					hasMore = true;
				}else{
					hasMore = false;
				}
			}while(hasMore)
			//开始构建语法树
			while(nodeList.length > 1)
			{
				var left:ASTree = nodeList.shift();
				var right:ASTree = nodeList.shift();
				var tree:ASTree = new ASTree(commaList.shift());
				tree.left = left;
				tree.right = right;
				nodeList.unshift(tree);
			}
			
			return nodeList[0];
		}
		
		public function item():ASTree
		{
			var left:ASTree;
			var right:ASTree;
			var tree:ASTree;
			var key:Token = getToken();

			if(key.type != TokenType.STRING)
			{
				throw Error("line" + key.linNo + " Key 必须为字符串类型!当前类型为: " + key.value);
			}
			left = new Leaf(key);
			
			var token:Token = getToken();

			if(token.type != TokenType.COLON)
			{
				throw Error("line" + token.linNo + "缺少冒号!");
			}
			tree = new ASTree(token);
			
			right = parseValue();
			
			tree.left = left;
			tree.right = right;
			
			return tree;
		}
		
		private function nestedBracketValue():ASTree
		{
			var nodeList:Vector.<ASTree> = new Vector.<ASTree>();
			var commaList:Vector.<Token> = new Vector.<Token>();
			var node:ASTree;
			var hasMore:Boolean = false;
			var token:Token;
			do{
				node = parseValue();
				nodeList.push(node);
				token = getToken(true);
				//trace(token);
				if(token && token.type == TokenType.COMMA)
				{
					var comma:Token = getToken();//跳过逗号
					commaList.push(comma);
					hasMore = true;
				}else{
					hasMore = false;
				}
			}while(hasMore)
			//开始构建语法树
			while(nodeList.length > 1)
			{
				var left:ASTree = nodeList.shift();
				var right:ASTree = nodeList.shift();
				var tree:ASTree = new ASTree(commaList.shift());
				tree.left = left;
				tree.right = right;
				nodeList.unshift(tree);
			}
			
			return nodeList[0];
		}
		
		private function parseValue():ASTree
		{
			var right:ASTree;
			var token:Token = getToken();

			if(token.type == TokenType.STRING)
			{
				right = new Leaf(token);
			}else if(token.type == TokenType.NUMBER)
			{
				right = new Leaf(token);
			}else if(token.type == TokenType.OPEN_CURLY)
			{
				right = nestedCurlyValue();
				token = getToken();
				
				if(token.type != TokenType.CLOSE_CURLY)
				{
					throw Error("line" + token.linNo + "格式错误!必须以 } 结尾");
				}
			}else if(token.type == TokenType.OPEN_BRACKET)
			{
				right = nestedBracketValue();
				token = getToken();
				
				if(token.type != TokenType.CLOSE_BRACKET)
				{
					throw Error("line" + token.linNo + "格式错误!必须以 ] 结尾");
				}
			}else
			{
				throw Error("line" + token.linNo + "错误的值格式!");
			}
			
			return right;
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
		
		public function toString():String
		{
			return mASTree.traverseSelf();
		}

		public function get ast():ASTree
		{
			return mASTree;
		}

	}
}