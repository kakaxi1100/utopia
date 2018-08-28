package base
{

	public class Leaf extends ASTree
	{
		public function Leaf(token:Token)
		{
			super(token);
		}
		
		override public function insert(child:ASTree):void
		{
			throw Error("叶子节点不可以插入子节点");
		}
	}
}