package base
{
	public class ASTree
	{
		public var info:Token;
		public var left:ASTree;
		public var right:ASTree;
		
		private var mString:String;
		public function ASTree(token:Token = null)
		{
			info = token;
		}
		
		public function insert(left:ASTree, right:ASTree):void
		{
			
		}
		
		public function get value():String
		{
			return info.value;
		}
		
		public function traverseSelf():String
		{
			mString = "";
			traverseMid(this);
			
			return mString;
		}
		
		private function traverseMid(node:ASTree):void
		{
			if(node == null)
			{
				return;
			}
			traverseMid(node.left);
			mString += node.toString() + " ";
			traverseMid(node.right);
		}

		public function toString():String
		{
			return info.value;
		}
	}
}