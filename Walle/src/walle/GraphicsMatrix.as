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
		public function breadthFirstSearch(firstNode:GraphicsNode = null):void	
		{
			if(!firstNode)
			{
				firstNode = this.vlist[0];
			}
			this.bfs(firstNode);
		}
		//这个和树的的层次遍历一样,用队列就可以解决这个问题了, 只是多了一个检查列表, 图的所有遍历都需要有检查列表
		private function bfs(firstNode:GraphicsNode):void
		{	
			var checked:Array = [];
			var queue:Array = [];
			queue.push(firstNode);
			while(queue.length > 0)
			{
				var node:GraphicsNode = queue.shift();
				trace(node);
				checked.push(node);
				//遍历node
				//1. 得到node的在vlist中的index
				var index:int = getNodeIndex(node);
				if(index >= 0)
				{
					for(var i:int = 0; i < this.eMatrix[index].length; i++)
					{
						if(this.eMatrix[index][i].weight > 0)//表示与另一个点有链接
						{
							var temp:GraphicsNode = this.vlist[i];
							if(checked.indexOf(temp) == -1 && queue.indexOf(temp) == -1)//这个点还没被检查过,并且也不在检查队列中
							{
								queue.push(temp);
							}
						}
					}
				}
			}
		}
		
		//广度优先遍历
		public function depthFirstSearch(firstNode:GraphicsNode = null):void
		{
			if(!firstNode)
			{
				firstNode = this.vlist[0];
			}
			this.dfs(firstNode);
		}
		//深度搜索其实和广度搜索差不多, 只不过他需要一个parent列表可以用来回溯
		private function dfs(firstNode:GraphicsNode):void
		{
			//已检查列表
			var checked:Array = [];
			//待访问列表
			var visit:Array = [];
			visit.push(firstNode);
			while(visit.length > 0)
			{
				//1. 找最深
				var node:GraphicsNode = visit[visit.length - 1];
				var index:int = getNodeIndex(node);
				
				//如果权重一样, 那么就找第一个点
				for(var i:int = 0; i < this.eMatrix[index].length; i++)
				{
					var temp:GraphicsNode = this.vlist[i];
					if(this.eMatrix[index][i].weight > 0)//表示与另一个点有链接
					{
						if(checked.indexOf(temp) == -1 && visit.indexOf(temp) == -1)//这个点还没被检查过,并且也不在检查队列中
						{
							visit.push(temp);
							//找到了最邻近点后就要开始找下一个点
							index = i;
							i = 0;
						}
					}
				}
				
				//找到了最后一点, 开始访问
				var crt:GraphicsNode = visit.pop();
				trace(crt);
				checked.push(crt);
			}
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
		
		public function getNodeIndex(node:GraphicsNode):int
		{
			for(var i:int = 0; i < this.vlist.length; i++)
			{
				if(node == this.vlist[i])
				{
					return i;
				}
			}
			
			return -1;
		}
	}
}