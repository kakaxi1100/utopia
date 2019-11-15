package walle
{
	/**
	 * 邻接矩阵图结构
	 *  
	 * 有一个顶点数组和一个边的邻接矩阵
	 * 
	 * @author juli
	 * 
	 */	
	public class GraphicsMatrix
	{
		//顶点列表
		public var vlist:Array;
		//边列表
		public var eMatrix:Array;
		public function GraphicsMatrix()
		{
			vlist = [];
			eMatrix = [];
		}
		
		//深度优先遍历
		public function depthFirstSearch():void
		{
			
		}
		
		//广度优先遍历
		public function breadthFirstSearch():void
		{
			
		}
		
		public function setEdgeWeight(i:int, j:int, weight:int):void
		{
			eMatrix[i][j].weight = weight;
			eMatrix[j][i].weight = weight;
		}
		
		public function extend(node:GraphicsNode):void
		{
			vlist.push(node);
			var index:int = eMatrix.length;
			eMatrix[index] = [];
			for(var i:int = 0; i < eMatrix.length; i++)
			{
				eMatrix[i][index] = new GraphicsEdge();
			}
			
			for(var j:int = 0; j <= index; j++)
			{
				eMatrix[index][j] = new GraphicsEdge();
			}
		}
		
		public function remove(node:GraphicsNode):void
		{
			var index:int = -1;
			for(var i:int = 0; i < vlist.length; i++)
			{
				if(node == vlist[i])
				{
					vlist.splice(i, 1);
					index = i;
					//这里删除列
//					for(var j:int = 0; j < eMatrix[i].length; j++)
//					{
//						eMatrix[i].splice(j--, 1);
//					}
					eMatrix.splice(i, 1);
					break;
				}
			}
			
			if(index >= 0)
			{
				//这里删除行里面对应的点
				for(i = 0; i < eMatrix.length; i++)
				{
					eMatrix[i].splice(index, 1);
				}
			}
		}
	}
}