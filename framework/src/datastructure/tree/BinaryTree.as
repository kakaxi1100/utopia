package datastructure.tree
{
	/**
	 * 首先root代表树的底部, 叶子节点代表头部
	 * 
	 * 树有几个概念
	 * 1. 节点的高度
	 * 		从当前节点往叶子节点树数, 所经历的边数  (这个可以看成是从下往上数, 高肯定是网上数)
	 * 2. 节点的深度
	 * 		从当前节点往根节点数，所经历的边数 (这个可以看成是从上往下数, 深肯定是往下数)
	 * 3. 节点的层数 
	 * 		节点的深度 + 1
	 * 
	 * @author juli
	 * 
	 */	
	public class BinaryTree
	{
		private var mRoot:BinaryTreeNode;
		public function BinaryTree()
		{
			
		}
	}
}