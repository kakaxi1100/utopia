package walle
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	

	public class CellSpacePartition
	{
		//所有的cell
		private var mCells:Array;
		//邻居列表,每次计算都要更新这个值
		private var mNeighbors:Array;
		//世界的大小
		private var mWorldWidth:Number;
		private var mWorldHeight:Number;
		//cell的行列总值
		private var mCols:int;
		private var mRows:int;
		
		private var mCellW:Number;
		private var mCellH:Number;
		
		private var mNodeCache:Array;
		private var mCacheIndex:int;
		
		private static var instance:CellSpacePartition = null;
		public function CellSpacePartition()
		{
			
		}
		public static function getInstance():CellSpacePartition
		{
			return instance ||= new CellSpacePartition();
		}
		
		public function init(pW:Number, pH:Number, pCols:int, pRows:int):void
		{
			mWorldWidth = pW;
			mWorldHeight = pH;
			
			mRows = pRows;
			mCols = pCols;
			
			mCellW = mWorldWidth / mCols;
			mCellH = mWorldHeight / mRows;
			
			mCells = [];
			//注意这个值
			//每次计算一个新的target都会更新里面的列表
			//为了避免push和remove 的开销,原书中用了一个maxEntity来表示最大的存储数
			//这里我还是采用push和remove
			mNeighbors = [];
			
			//注意cell的顺序
			//是先排的列后排的行, 这个顺序会影响到后面 postionToIndex 方法的实现
			for(var i:int = 0; i < mRows; i++)
			{
				for(var j:int = 0; j < mCols; j++)
				{
					var cell:Cell = new Cell(j * mCellW, i * mCellH, mCellW, mCellH);
					mCells.push(cell);
				}
			}
			
			mNodeCache = [];
			for(var k:int = 0; k < 200; k++)
			{
				mNodeCache.push(new IntelligentNode());
			}
		}
		
		/**
		 *传入实体的postion返回的是cell的index 
		 * @param pos
		 * @return 
		 * 
		 */		
		public function postionToIndex(pos:FFVector):int
		{
			var row:int = Math.floor(pos.y / mCellH);//先计算出在哪行
			var col:int = Math.floor(pos.x / mCellW);//再计算处在哪列
			
			// y = 600, cellH = 60 600/60 = 10?  row是 0~9
			if(row > mRows - 1){
				row = mRows - 1;
			}
			if(col > mCols - 1){
				col = mCols - 1;
			}
			
			var index:int = row * mCols + col;//计算出在cell的index
			
			return index;
		}
		
		public function update(list:Array):void
		{
			var i:int = 0;
			var cell:Cell;
			mCacheIndex = 0;
			for(i = 0; i < mCells.length; i++)
			{
				cell = mCells[i];
				cell.clear();
				
			}
			
			for(i = 0; i < list.length; i++)
			{
				var source:Intelligent = list[i];
				var index:int = postionToIndex(source.position);
				cell = mCells[index];
				cell.insertNode(source, mNodeCache[mCacheIndex]);//这里不用cache的效率也是一样的
				mCacheIndex++;
				if(mCacheIndex >= mNodeCache.length)
				{
					for(var j:int = 0; j < 50; j++){
						mNodeCache.push(new IntelligentNode());
					}
				}
			}
		}
		
		
		public function calculateNeighbors(targetPos:FFVector, queryRadius:Number):Array
		{
			//清空邻居列表
			while(mNeighbors.length > 0){
				mNeighbors.pop();
			}
			
			//先构造查询盒
			var queryBox:Rectangle = new Rectangle(targetPos.x - queryRadius, targetPos.y - queryRadius, queryRadius * 2, queryRadius * 2);
			for(var i:int = 0; i < mCells.length; i++)
			{
				var curtCell:Cell = mCells[i];
				//检测与之相交的cell
				//假如不相交,就继续检测下一个
				if(!curtCell.aabb.intersects(queryBox)) continue;
				//如果相交就进一步检测
				var curtNode:IntelligentNode = curtCell.link.begin();
				while(curtNode.next)
				{
					var curt:Intelligent = curtNode.next.data;
					//算出目标点到当前实体的距离
					var minusX:Number = curt.position.x - targetPos.x;
					var minusY:Number = curt.position.y - targetPos.y;
					var distSq:Number = minusX * minusX + minusY * minusY;
					//在范围内
					if(distSq < queryRadius * queryRadius)
					{
						mNeighbors.push(curt);
					}
					
					curtNode = curtNode.next;
				}
			}
			
			return mNeighbors;
		}
		
		public function renderCells(g:Graphics):void
		{
			for(var i:int = 0; i < mCells.length; i++)
			{
				var temp:Cell = mCells[i];
				g.lineStyle(1);
				g.drawRect(temp.aabb.x, temp.aabb.y, temp.aabb.width, temp.aabb.height);
			}
		}
	}
}