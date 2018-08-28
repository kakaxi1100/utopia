package archive.base_v1
{

	public class Excuter
	{
		private var mJsonObj:ASTree;
		private var mParser:Parser;
		public function Excuter(parser:Parser)
		{
			mParser = parser;
		}
		
		public function excute():void
		{
			mJsonObj = generate(mParser.ast);
		}
		
		private function generate(node:ASTree):ASTree
		{
			//采用中序遍历
			if(node == null)
			{
				return null;
			}
			
			var left:ASTree;
			var right:ASTree;
			var composite:ASTree;
			
			left = generate(node.left);
			right = generate(node.right);
			//这个node是叶子节点
			if(left == null && right == null)
			{
				return node;
			}
			
			composite = new Composite();
			composite.insert(left, right);
			
			return composite;
		}
		
		public function toString():String
		{
			return mJsonObj.toString();
		}
	}
}