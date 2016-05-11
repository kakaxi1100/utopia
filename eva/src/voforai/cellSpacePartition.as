package voforai
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import base.EVector;

	public class CellSpacePartition
	{
		//所有的cell
		private var mCells:Vector.<Cell>;
		//邻居列表,每次计算都要更新这个值
		private var mNeighbors:Vector.<Vehicle>
		//世界的大小
		private var mWorldWidth:Number;
		private var mWorldHeight:Number;
		//cell的行列总值
		private var mCols:int;
		private var mRows:int;
		
		private var mCellW:Number;
		private var mCellH:Number;
		
		public function CellSpacePartition(PW:Number, PH:Number, pCols:int, pRows:int)
		{
			mWorldWidth = PW;
			mWorldHeight = PH;
			
			mRows = pRows;
			mCols = pCols;
			
			mCellW = mWorldWidth / mCols;
			mCellH = mWorldHeight / mRows;
			
			mCells = new Vector.<Cell>();
			//注意这个值
			//每次计算一个新的target都会更新里面的列表
			//为了避免push和remove 的开销,原书中用了一个maxEntity来表示最大的存储数
			//这里我还是采用push和remove
			mNeighbors = new Vector.<Vehicle>();
			
			//注意cell的顺序
			//是先排的列后排的行, 这个顺序会影响到后面 postionToIndex 方法的实现
			for(var i:int = 0; i < mRows; i++)
			{
				for(var j:int = 0; j < mCols; j++)
				{
					var cell:Cell = new Cell(j*mCellW, i*mCellH, mCellW, mCellH);
					mCells.push(cell);
				}
			}
		}
		
		/**
		 *传入实体的postion返回的是cell的index 
		 * @param pos
		 * @return 
		 * 
		 */		
		public function postionToIndex(pos:EVector):int
		{
			var row:int = Math.floor(pos.y / mCellH);//先计算出在哪行
			var col:int = Math.floor(pos.x / mCellW);//再计算处在哪列
			
			var index:int = row + col*mRows;//计算出在cell的index
			
			return index;
		}
		
		public function addEntity(v:Vehicle):void
		{
			var index:int = postionToIndex(v.position);
			mCells[index].plist.push(v);
			v.cellIndex = index;
			v.cellPlaceIndex = mCells[index].plist.length - 1;
		}
		
		public function updateEntity(v:Vehicle):void
		{
			var newIndex:int = postionToIndex(v.position);
			if(newIndex == v.cellIndex) return;
			mCells[v.cellIndex].plist.splice(v.cellPlaceIndex);
			//移除了一个之后,后面的所有索引应该都减去1
			for(var i:int = v.cellPlaceIndex; i < mCells.length; i++)
			{
				mCells[v.cellIndex].plist[i].cellPlaceIndex -= 1;
			}
			
			mCells[newIndex].plist.push(v);
			v.cellIndex = newIndex;
			v.cellPlaceIndex = mCells[newIndex].plist.length - 1;
		}
		
		/**
		 *给定一个位置和查询盒范围, 就出邻居 
		 * @param targetPos
		 * @param queryRadius
		 * 
		 */		
		public function calculateNeighbors(targetPos:EVector, queryRadius:Number):void
		{
			//清空邻居列表
			while(mNeighbors.length > 0){
				mNeighbors.pop();
			}
			//先构造查询盒
			var queryBox:Rectangle = new Rectangle(targetPos.x - queryRadius, targetPos.y - queryRadius, queryRadius, queryRadius);
			for(var i:int = 0; i < mCells.length; i++)
			{
				var tempCell:Cell = mCells[i];
				//检测与之相交的cell
				//假如不相交,就继续检测下一个
				if(tempCell.aabb.intersects(queryBox) == false) continue;
				//如果相交就进一步检测
				for(var j:int = 0; j < tempCell.plist.length; j++)
				{
					var tempVehicle:Vehicle = tempCell.plist[j];
					//算出目标点到当前实体的距离
					//为了避免new 就不用 EVector 来计算了
					var minusX:Number = tempVehicle.x - targetPos.x;
					var minusY:Number = tempVehicle.y - targetPos.y;
					var distSq:Number = minusX*minusX + minusY*minusY;
					//在范围内
					if(distSq < queryRadius*queryRadius)
					{
						mNeighbors.push(tempVehicle);
					}
				}
			}
		}
			
		public function RenderCells(g:Graphics):void
		{
			for(var i:int = 0; i < mCells.length; i++)
			{
				var temp:Cell = mCells[i];
				g.clear();
				g.lineStyle(1);
				g.drawRect(temp.aabb.x, temp.aabb.y, temp.aabb.width, temp.aabb.height;
			}
		}
	}
}