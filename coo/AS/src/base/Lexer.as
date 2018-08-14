package base
{
	import utils.ParseString;

	public class Lexer
	{
		//用来匹配单词
		//数字和+号  三个分组, 第一个分组是 整个表达式,第二个分组是数字,第三个分组是符号
		public static const reg:RegExp = /(0|[1-9][0-9]*)|(\+|;)/g;
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
		
		//从每一行中读取单词
		public function readline():void
		{
			var i:int = 0;
			var line:String;
			var group:Object;
			var prev:int;
			var cur:int;
			var len:int;
			var diff:int;
			var error:String;
			var token:Token;
			for(i = 0;  i < allLines.length; i++)
			{
				line = allLines[i];
				do
				{
					group = reg.exec(line);
					if(group != null)//假如group不为空就说明匹配到了值
					{
						cur = reg.lastIndex;
						len = group[0].length;
						trace(group);
					}else{//假如group为空有两种可能,第一个到底了, 第二个匹配错了
						cur = line.length;
						len = 0;
						if(prev != line.length)//如果是匹配错的情况,那么表示之前的lastIndex不可能和 length相等
						{
							//出错
	//						trace("未匹配位置:", prev, "未匹配字符:", s.substr(prev, cur-prev));
						}
					}
					diff = cur - prev - len;
					trace("diff:",diff);
					if(diff != 0)//又字符跳过
					{
						error = line.substr(prev, diff);
						trace("未匹配位置:", prev, "未匹配字符:", error);
						error = ParseString.trim(error);
						if(error == "")
						{
							
						}else{
							throw Error("未匹配位置: " + prev + ", 未匹配字符: " + error);
						}
					}
					//转化为token
					if(group)
					{
						if(group[1])
						{
							token = new TokenNumber(i, group[1]);
							addToken(token);
						}else if(group[2])
						{
							token = new TokenIdentifer(i, group[2]);
							addToken(token);
						}
					}
					prev = cur;
				}while(group != null)//如果没有错误就直接跳到下一行
			}
			token = new TokenIdentifer(i, "EOF");
			addToken(token);
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