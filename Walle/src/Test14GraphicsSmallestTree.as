package
{
	import flash.display.Sprite;
	
	import walle.GraphicsMatrix;
	import walle.GraphicsNode;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	public class Test14GraphicsSmallestTree extends Sprite
	{
		private var gm:GraphicsMatrix;
		private var nlist:Array = [];
		public function Test14GraphicsSmallestTree()
		{
			super();
			
			gm = new GraphicsMatrix();
			
			for(var i:int = 0; i < 7; i++)
			{
				var node:GraphicsNode = new GraphicsNode();
				node.data = i;
				gm.extend(node);
			}
			
			gm.setEdgeWeight(0, 1, 2);
			gm.setEdgeWeight(0, 2, 4);
			gm.setEdgeWeight(0, 3, 1);
			
			gm.setEdgeWeight(1, 4, 10);
			gm.setEdgeWeight(1, 3, 3);
			
			gm.setEdgeWeight(2, 3, 2);
			gm.setEdgeWeight(2, 5, 5);
			
			gm.setEdgeWeight(3, 4, 7);
			gm.setEdgeWeight(3, 5, 8);
			gm.setEdgeWeight(3, 6, 4);
			
			gm.setEdgeWeight(4, 6, 6);
			
			gm.setEdgeWeight(5, 6, 1);
			
			//输出的内容不一样, 是因为树的顶点表达的方式不一样, 但是路径(生成树)是一样的
//			gm.prim(0);
//			gm.kruskal();
			gm.Astar(1, 5);
		}
	}
}