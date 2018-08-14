package base
{
	/**
	 *解析首先要规定语法
	 * EOF为结束条件
	 * statement："EOF" | expresstion statement
	 * expresstion: Num OP Num ;
	 * OP:+
	 * Num:0~9*
	 * 
	 *  
	 * @author juli
	 * 
	 */	
	public class Parser
	{
		public var currentToken:Token;
		public var lexer:Lexer;
		public function Parser()
		{
		}
		
		public function parse(l:Lexer):void
		{
			lexer = l;
			statement();
		}
		
		private function statement():void
		{
			currentToken = lexer.getNextToken();
			//推出条件
			if(currentToken == null)
			{
				return;
			}
			if(currentToken is TokenIdentifer)
			{
				if((currentToken as TokenIdentifer).text == Token.EOF)
				{
					return;
				}
			}
			
			//如果不是 EOF或者空就走了另一条分支
			express();
			statement();
		}
		
		private function express():void
		{
			if(testNum())
			{
				currentToken = lexer.getNextToken();
				if(testOP())
				{
					currentToken = lexer.getNextToken();
					if(testNum())
					{
						currentToken = lexer.getNextToken();
						if(testSemicolon())
						{
							
						}
					}
				}
			}
		}
		
		private function testNum():Boolean
		{
			var boo:Boolean = (currentToken is TokenNumber)
			return boo;
		}
		
		private function testOP():Boolean
		{
			var boo:Boolean = (currentToken is TokenIdentifer)
			return boo;
		}
		
		private function testSemicolon():Boolean
		{
			var boo:Boolean = (currentToken is TokenIdentifer)
			return boo;
		}
		
		private function testEOF():Boolean
		{
			return false;
		}
	}
}