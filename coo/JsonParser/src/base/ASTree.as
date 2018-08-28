package base
{

	public class ASTree
	{
		public var info:Token;
		public var children:Vector.<ASTree>;
		
		private var mString:String;
		public function ASTree(token:Token = null)
		{
			info = token;
		}
		
		public function insert(child:ASTree):void
		{
			children.push(child);
		}

		public function toString():String
		{
			return info.value;
		}
	}
}