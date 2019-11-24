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
		
		//Dijkstra
		//最短路径算法：迪杰斯特拉
		//思想是: 把所有能走的路都算一遍, 取其中最短的路径
		//实现方式:
		//有两个列表, 一个是已检查列表, 一个是待检查列表
		//每次都在待查列表中选取权值最小的节点到已检查列表, 然后根据新添加进来的点, 跟新待查列表中的权值
		//
		//例子：求 ①到②的最短路径
		//①----3------②
		// \         /
		//  \1     1/
		//	 \     /
		//	  \   /
		//     \ /
		//      ③
		//
		// step1:checked[①(0)], left[②(3), ③(1)]
		// step2:checked[①(0), ③(1)], left[②(1)]
		// step2:checked[①(0), ③(1), ②(1)], left[]
		//∴ ①到②的最短路径是  ①->③->② 当然如果你需要完整路径, 还要有一个 parent列表, 每当②的值发生变化时, 就将当前节点添加到其中
		public function dijkstra(start:int, end:int):void
		{
			//1. 初始化列表
			var parentlist:Array = [];
			var temp:Object = {"index":start, "dist":0};
			var checked:Array = [temp];
			var left:Array = [];
			var index:int = start;
			//最小值为第一个点
			var miniIndex:int = 0;
			var miniValue:uint = 99999;
			var crtIndex:uint = index;
			var loopIndex:uint = 0;
			for(var i:int = 0; i < this.eMatrix[index].length; i++)
			{
				if(i == index) continue;
				var weight:int = this.eMatrix[index][i].weight;
				temp = {"index": i};
				if( weight == 0)
				{
					trace("test");
					temp["dist"] = 99999999;
				}else{
					temp["dist"] = weight;
					if(weight <= miniValue)
					{
						miniValue = weight;
						miniIndex = left.length;
						crtIndex = i;
					}
				}
				left.push(temp);
			}
			
			//2. 循环计算最短路径
			while(left.length > 0)
			{
				//把最短的点放到已检查列表中
				var shortest:Object = left.splice(miniIndex, 1)[0];
				checked.push(shortest);
				
				miniIndex = 0;
				miniValue = 99999;
				//更新left列表 , crtIndex 是当前的
				for(i = 0; i < left.length; i++)
				{
					 temp = left[i];
					 var crtWeight:int = this.eMatrix[crtIndex][temp.index].weight;
					 if(crtWeight + shortest.dist < temp.dist)
					 {
						 temp.dist = crtWeight + shortest.dist;
						 //假如有一个点使得end更新了,那么这个点就是这个的parent之一
						 if(temp.index == end)
						 {
							 parentlist.push(crtIndex);
						 }
					 }
					 
					 if(temp.dist <= miniValue)
					 { 
						 miniValue = temp.dist;
						 miniIndex = i;
						 loopIndex = temp.index;
					 }
				}
				crtIndex = loopIndex;
			}
			
			var s:String = "" + start + "->";
			for(i = 0; i < parentlist.length; i++)
			{
				s += parentlist[i] + "->";
			}
			s += end;
			trace(s);
		}
		
		public function floyd(start:int, end:int):void
		{
			var dist:Array = [];
			var path:Array = [];
			//先初始化整个路径, 就是当 
			for(var i:int = 0; i < this.eMatrix.length; i++)
			{
				dist[i] = [];
				path[i] = [];
				for(var j:int = 0; j < this.eMatrix[i].length; j++)
				{
					var value:int = this.eMatrix[i][j].weight;
					dist[i][j] = value;
					path[i][j] = j;//因为path[0][3] = 3 代表 0-3只经过3点 3是顶点的索引
				}
			}
			
			
			for(var k:int = 0; k < dist.length; k++){
				for(i = 0; i < dist.length; i++)
				{
					for(j = 0; j < dist.length; j++)
					{
						if(dist[i][j] > (dist[i][k] + dist[k][j]))
						{
							dist[i][j] = dist[i][k] + dist[k][j];
							path[i][j] = path[i][k];
						}
					}
				}
			}
			
			k = path[start][end];
			var s:String = "" + start + "->";
			while(k != end)
			{
				s += k + "->";
				k = path[k][end];
			}
			s += end;
			trace(s);
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