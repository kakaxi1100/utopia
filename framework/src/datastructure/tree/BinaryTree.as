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
	 * 
	 * 二叉树的表示方法有 链表表示法  和  数组表示法
	 * 链表表示法很简单, 无非就是左节点和右节点都是一个链表结构
	 * 
	 * 数组表示法是按以下方式表示的
	 * 根节点的下标位1  它的左子节点存在 2 * 1 = 2,  右子节点存在 2 * 1 + 1 = 3的位置
	 * 以此类推：
	 * 假如节点的下标位i, 那么
	 * 节点的左节点存储在下标为   2 * i的位置, 节点的右节点储存在下标位 2 * i + 1 的位置 
	 * 
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
		
		//按照完全二叉树的顺序插入节点
		public function insert(data:Object):void
		{
			var node:BinaryTreeNode = new BinaryTreeNode();
			node.data = data;
			if(mRoot == null)
			{
				mRoot = node;
			}
			//接着其实就是按照层序遍历的方式去找哪个节点是空的
			var queue:Array = [mRoot];
			var curtNode:BinaryTreeNode;
			do{
				curtNode = queue.pop();
				if(curtNode.left == null)//假如左边为空就插入左边
				{
					curtNode.left = node;
					break;
				}else if(curtNode.right == null)//假如右边为空就插入右边
				{
					curtNode.right = node;
					break;
				}else
				{
					//假如都不为空, 那么要继续往下找
					queue.push(curtNode.left, curtNode.right);
				}
			}while(curtNode != null /*&& queue.length > 0*/)//其实不需要判断长度, 因为它的叶子节点肯定为空啊
		}
		
		public function 
	}
}