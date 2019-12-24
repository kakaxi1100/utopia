package walle
{
	import flash.display.Graphics;
	
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
		
		//是否有向图
		public var isDirected:Boolean = false;
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
		
		//A* 寻路其实和dijkstra一样的,就是计算代价的方式不一样, 这样选取节点的方式就不一样
		//A* 的代价计算方式是, F = G + H
		//G: 起点到当前点的代价
		//H: 当前点到终点的代价
		public function Astar(start:int, end:int):void
		{
			var checked:Array = [];
			var left:Array = [];
			var temp:Object = {"index":start, "G":0, "H":0, "F":0, "P":null};
			//初始化
			checked.push(temp);
			for(var i:int = 0; i < this.eMatrix[start].length; i++)
			{
				if(this.eMatrix[start][i].weight > 0 && this.eMatrix[start][i].weight != 999999999)
				{
					temp = {"index":i, "G":this.eMatrix[start][i].weight};
					temp["H"] = 0;
					temp["F"] = temp["G"] + temp["H"];
					temp["P"] = checked[0];
					left.push(temp);
				}
			}
			left.sortOn("F", Array.NUMERIC);
			
			//循环取得代价最低的点
			while(left.length > 0)
			{
				var inChecked:Boolean = false;
				var inLeft:Boolean = false;
				var node:Object = left.shift();
				checked.push(node);
				//找到了终点
				if(node["index"] == end)
				{
					while(node)
					{
						trace(node["index"]);
						node = node["P"];
					}
					
					break;
				}
				//添加node的邻接点, 如果node的邻接点已经在left里面，那么就计算一下新的F值, 因为G值有可能更新了, 注意H值是不变的
				for(i = 0; i < this.eMatrix[node["index"]].length; i++)
				{
					inChecked = false;
					inLeft = false;
				
					if(this.eMatrix[node["index"]][i].weight <= 0 || this.eMatrix[node["index"]][i].weight == 999999999)
					{
						continue;
					}
					
					for(var j:int = 0; j < checked.length; j++)
					{
						//假如已经加入到了checked列表中
						if(checked[j]["index"] == i)
						{
							inChecked = true;
							break;
						}
					}
					if(inChecked) continue;
					
					for(j = 0; j < left.length; j++)
					{
						//假如已经加入到了left列表中
						if(left[j]["index"] == i)
						{
							inLeft = true;
							//重新计算G值
							if(node["G"] + this.eMatrix[node["index"]][i].weight < left[j]["G"])
							{
								left[j]["G"] = node["G"] + this.eMatrix[node["index"]][i].weight;
								left[j]["F"] = left[j]["G"] + left[j]["H"];
								left[j]["P"] = node;
							}
							break;
						}
					}
					
					if(!inLeft)
					{
						temp = {"index":i, "G":this.eMatrix[node["index"]][i].weight};
						temp["H"] = 0;
						temp["F"] = temp["G"] + temp["H"];
						temp["P"] = node;
						left.push(temp);
					}
				}
				//排序left列表
				left.sortOn("F", Array.NUMERIC);
			}
		}
		
		
		
		//最小生成树算法
		//这个算法和dijkstra算法有两个不同点:
		//1. 它每次只是选取当前节点的最小值, 而不需要从根节点累加计算更新最小值
		//2. 最后要生成一棵树, 所以要有一个记录父节点的值, 哪一个让它值变小的, 哪一个就是它的父节点
		public function prim(rootIndex:int):void
		{
			var tree:Array = [];
			//已经收录的点,因为不能形成环路
			var temp:Object = {"index":rootIndex, "dist":0, "prev":-1};
			var checked:Array = [temp];
			var left:Array = [];
			var index:int = rootIndex;
			//最小值为第一个点
			var miniIndex:int = 0;
			var miniValue:uint = 99999;
			var crtIndex:uint = rootIndex;
			var loopIndex:uint = 0;
			for(var i:int = 0; i < this.eMatrix[index].length; i++)
			{
				if(i == index) continue;
				var weight:int = this.eMatrix[index][i].weight;
				temp = {"index": i};
				temp["dist"] = weight;
				temp["prev"] = rootIndex;
				if(weight <= miniValue)
				{
					miniValue = weight;
					miniIndex = left.length;
					crtIndex = i;
				}
				left.push(temp);
			}
			
			//2. 循环计算最短路径
			while(left.length > 0)
			{
				//把最短的点放到已检查列表中
				var shortest:Object = left.splice(miniIndex, 1)[0];
				checked.push(shortest);
				if(!tree[shortest["prev"]])
				{
					tree[shortest["prev"]] = [];
				}
				tree[shortest["prev"]].push(crtIndex);
				
				miniIndex = 0;
				miniValue = 99999;
				//更新left列表 , crtIndex 是当前的
				for(i = 0; i < left.length; i++)
				{
					temp = left[i];
					var crtWeight:int = this.eMatrix[crtIndex][temp.index].weight;
					if(crtWeight < temp.dist)
					{
						temp.dist = crtWeight;
						temp["prev"] = crtIndex;
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
			
			var s:String = "";
			for(i = 0; i < tree.length; i++)
			{
				if(!tree[i]) continue;
				
				s += "[" + i + "]";
				for(var j:int = 0; j < tree[i].length; j++)
				{
					if(!tree[i][j]) continue;
					s += "->" + tree[i][j];
				}
				
				s += "\n";
			}
			
			trace(s);
		}
		
		//克鲁斯卡尔算法
		//是对边进行计算,每次去权值最小的边, 并且这个边的加入不会构成回路
		//回路的计算用并查集, 开始的时候, 所有的点都是单独的并查集, 如果两个点分别在两个集合里面, 
		//那么它不会形成环路, 那么当这两个点的边加入的时候可以合并这个两个点所在的集合成一个大的集合
		//如果两个点在一个集合里面, 那么这两个点会形成一条环路
		public function kruskal():void
		{
			var tree:Array = [];
			var checkList:Array = [];
			//1.先对整个边进行排序
			var edgeList:Array = [];
			var tempList:Array = [];
			var temp:Object;
			
			for(var i:int = 0; i < this.vlist.length; i++)
			{
				checkList[i] = [];
				checkList[i].push(i);
			}
			
			for(i = 0; i < this.eMatrix.length; i++)
			{
				for(var j:int = i + 1; j < this.eMatrix[i].length; j++)
				{
					var weight:int = this.eMatrix[i][j].weight;
					if(weight == 999999999)
					{ 
						continue;
					}
					temp = {"n1":i, "n2":j, "weight":weight};
					edgeList.push(temp);
				}
			}
			
			edgeList.sortOn("weight", Array.NUMERIC);
			//2. 每次取出最小边, 看取出边是否形成环路, 如果形成环路,那么就放弃这条边
			//判断是否形成环路可以用并查集, 看两个顶点是否同时存在与已查的边集合中, 如通都存在那么必然形成环路
			while(edgeList.length > 0)
			{
				var edge:Object = edgeList.shift();
				var n1Index:int, n2Index:int;
		
				for(i = 0; i < checkList.length; i++)
				{
					if(!checkList[i]) continue;
					if(checkList[i].indexOf(edge["n1"]) > -1)
					{
						n1Index = i;
					}
					
					if(checkList[i].indexOf(edge["n2"]) > -1)
					{
						n2Index = i;
					}
				}
				
				if(n1Index != n2Index)
				{
					//这条边有效
					checkList[n1Index] = checkList[n1Index].concat(checkList[n2Index]);
					checkList.splice(n2Index, 1);		
					
					if(edge["n1"] < edge["n2"])
					{
						if(!tree[edge["n1"]])
						{
							tree[edge["n1"]] = [];
						}
						tree[edge["n1"]].push(edge["n2"]);
					}else{
						if(!tree[edge["n2"]])
						{
							tree[edge["n2"]] = [];
						}
						tree[edge["n2"]].push(edge["n1"]);
					}
				}
			}
			
			var s:String = "";
			for(i = 0; i < tree.length; i++)
			{
				if(!tree[i]) continue;
				
				s += "[" + i + "]";
				for(j = 0; j < tree[i].length; j++)
				{
					if(!tree[i][j]) continue;
					s += "->" + tree[i][j];
				}
				
				s += "\n";
			}
			
			trace(s);
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
		
		//拓扑排序 必须是有向无环图
		//https://www.cnblogs.com/bigsai/p/11489260.html
		//非常简单, 就是把图按照依赖的先后顺序变成一个线性序列
		//思路:
		//每次找到入度为 0 的点, 然后取出这个点到线性序列中, 在删除这个点连接的边, 直到取出最后一个点为止
		//如果过程中找不到入度为 0 的点, 那说明有环, 那么无解
		//这个写的太丑陋了！！！！！
		public function topsort():void
		{
			//1.先初始化, 找到每个点的入度, 收录入度为0的点
			var nlist:Array = [];
			for(var i:int = 0; i < this.vlist.length; i++)
			{
				nlist[i] = 0;		
			}
			
			for(i = 0; i < this.vlist.length; i++)
			{
				for(var j:int = 0; j < this.eMatrix[i].length; j++)
				{
					if(this.eMatrix[i][j].weight > 0 && this.eMatrix[i][j].weight != 999999999){
						//计算每个点入度
						nlist[j]++;
					}
				}
			}
			trace("n", nlist);
			//2.找到为0的点, 随机选一个作为开头
			var sortList:Array = [];
			var isEnd:Boolean = true;
			do{
				isEnd = true;
				for(i = 0; i < nlist.length; i++)
				{
					if(nlist[i] == 0){
						sortList.push(i);
						nlist[i] = -1;
						for(j = 0; j < this.eMatrix[i].length; j++)
						{
							if(this.eMatrix[i][j].weight > 0 && this.eMatrix[i][j].weight != 999999999){
								nlist[j]--;
							}
						}
						isEnd = false;
						break;
					}
				}
				trace("n", nlist);
			}while(!isEnd);
			trace("s", sortList);
		}
		
		//关键路径 AOE网 
		//https://www.bilibili.com/video/av17396966/ 清华大学出版社, 数据结构 C++版
		//关键路径不只一条,重要的是找到关键活动, 即不按期完成就会影响整个工程完成的活动
		//关键活动有关的量:
		// ① 事件最早发生的时间 (顶点) ve
		// ② 事件最晚发生的时间 (顶点) vl
		// ③ 活动最早开始的时间  (边)  ee
		// ④ 活动最晚开始的时间  (边)  el
		// 假如活动最晚开始时间和最早开始时间相等, 说明这个活动不能有任何推迟, 那么这个活动就是一个关键活动
		// 我们可以从 ①② 得到 ③④
		// 最终我们比较 ③ee和④el中相等的活动, 就是关键活动
		//
		//关键路径是就完全无法缩短或者延长的顶点
		//关键活动就是这些活动的时间长短会直接影响工期的长短
		//为什么要有关键活动?
		//因为布置任务的时候,一般都是以关键活动形式呈现的, 比如 美术4天, 程序6天, 策划3天...
		//现在这个只求关键路径, 关键活动求也很简单, 自己思考一下吧!
		public function keyroad():void
		{
			var ve:Array = [];
			var vl:Array = [];
			for(var i:int = 0; i < this.vlist.length; i++)
			{
				ve[i] = 0;
				vl[i] = 999999999;
			}
			//根据拓扑排序首先找到入度为0的点
			//1.先初始化, 找到每个点的入度, 收录入度为0的点
			var nlist:Array = [];
			for(i = 0; i < this.vlist.length; i++)
			{
				nlist[i] = 0;		
			}
			
			for(i = 0; i < this.vlist.length; i++)
			{
				for(var j:int = 0; j < this.eMatrix[i].length; j++)
				{
					if(this.eMatrix[i][j].weight > 0 && this.eMatrix[i][j].weight != 999999999){
						//计算每个点入度
						nlist[j]++;
					}
				}
			}
			trace("n", nlist);
			//2.找到为0的点, 随机选一个作为开头
			var isEnd:Boolean = true;
			do{
				isEnd = true;
				for(i = 0; i < nlist.length; i++)
				{
					if(nlist[i] == 0){//假如入度为0,那么就取出这个点
						nlist[i] = -1;
						
						for(j = 0; j < this.eMatrix[i].length; j++)
						{
							if(this.eMatrix[i][j].weight > 0 && this.eMatrix[i][j].weight != 999999999)
							{
								nlist[j]--;
								if(ve[j] < ve[i] + this.eMatrix[i][j].weight)
								{
									ve[j] = ve[i] + this.eMatrix[i][j].weight;
								}
							}
						}
						isEnd = false;
						break;
					}
				}
			}while(!isEnd);
			trace("ve", ve);
			vl[vl.length - 1] = ve[ve.length - 1];
			for(j = ve.length - 1; j >=0 ; j--)
			{
				for(i = ve.length - 1; i>=0; i--)
				{
					if(this.eMatrix[i][j].weight > 0 && this.eMatrix[i][j].weight != 999999999)
					{
						if(vl[i] > vl[j] - this.eMatrix[i][j].weight)
						{
							vl[i] = vl[j] - this.eMatrix[i][j].weight;
						}
					}
				}
			}
			trace("le", vl);
			
			var road:Array = [];
			for(i = 0; i < ve.length; i++)
			{
				if(ve[i] == vl[i])
				{
					road.push(i);
				}
			}
			
			trace("road", road);
			//根据 ve和vl 可以继续求得 ee和el这里就不再赘述!
		}
		
		public function setEdgeWeight(i:int, j:int, weight:int):void
		{
			eMatrix[i][j].weight = weight;
			//假如是有向的就只设置一个边
			if(!isDirected)
			{
				eMatrix[j][i].weight = weight;
			}
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