package base
{	
	public class Composite extends ASTree
	{
		public function Composite(token:Token = null)
		{
			super(token);
			children = new Vector.<ASTree>();
		}
		
		override public function insert(child:ASTree):void
		{
			children.push(child);
		}
		
		override public function toString():String
		{
			var s:String = "";
			var last:String = "";
			if(info.type == TokenType.OPEN_CURLY)
			{
				s = "{";
				last = "}";
			}else if(info.type == TokenType.OPEN_BRACKET)
			{
				s = "[";
				last = "]";
			}

			for(var i:int = 0; i < children.length - 1; i++)
			{
				s += children[i].toString() + ",";
			}
			
			s += children[i].toString() + last;
			
			return s;
		}
	}
}