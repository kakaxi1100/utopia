package datastructure.tree
{
	public class BinaryTreeNode
	{
		public var left:BinaryTreeNode;
		public var right:BinaryTreeNode;
		public var data:Object;
		public function BinaryTreeNode()
		{
		}
		
		//将node节点插入到这个节点的左节点
		//这个node的有一边的节点必须为空,否则左边的节点将被覆盖
		public function insertLeft(node:BinaryTreeNode):void
		{
			if(node.left != null)
			{
				trace("此节点左节点不为空, 请先清空再赋值!");
				return;
			}
			
			node.left = this.left; //其实这个左右应该是可以选择的
			this.left = node;
		}
		
		//将node节点插入到这个节点的右节点
		//这个node的有一边的节点必须为空,否则右边的节点将被覆盖
		public function insertRight(node:BinaryTreeNode):void
		{
			if(node.right != null)
			{
				trace("此节点右节点不为空, 请先清空再赋值!");
				return;
			}
			
			node.right = this.right; //其实这个左右应该是可以选择的
			this.right = node;
		}
		
		public function isLeaf():Boolean
		{
			return left == right == null
		}
	}
}