package base
{
	public class ASTree
	{
		public var info:Token;
		public var children:Vector.<ASTree>;
		
		public function ASTree(token:Token = null)
		{
			info = token;
		}
		
		public function insert(child:ASTree):void
		{
			
		}

		public function getFirst():ASTree
		{
			return children[0];
		}
		
		public function getLast():ASTree
		{
			return children[children.length - 1];
		}
		
		public function toString():String
		{
			return null;
		}
	}
}