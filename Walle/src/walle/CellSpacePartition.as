package walle
{
	import flash.geom.Rectangle;
	
	import voforai.Cell;
	

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
		}
		
		/**
		 *传入实体的postion返回的是cell的index 
		 * @param pos
		 * @return 
		 * 
		 */		
		public function postionToIndex(pos:FFVector):int
		{
			var row:int = Math.floor(pos.y / (mCellH - 1));//先计算出在哪行
			var col:int = Math.floor(pos.x / (mCellW - 1));//再计算处在哪列
			
			var index:int = row * mCols + col;//计算出在cell的index
			
			return index;
		}
		
		
		public function calculateNeighbors(targetPos:FFVector, queryRadius:Number):void
		{
			//清空邻居列表
			while(mNeighbors.length > 0){
				mNeighbors.pop();
			}
			
			//先构造查询盒
			var queryBox:Rectangle = new Rectangle(targetPos.x - queryRadius, targetPos.y - queryRadius, queryRadius*2, queryRadius*2);
			for(var i:int = 0; i < mCells.length; i++)
			{
				var curtCell:Cell = mCells[i];
				//检测与之相交的cell
				//假如不相交,就继续检测下一个
				if(!curtCell.aabb.intersects(queryBox)) continue;
				//如果相交就进一步检测
				for(var j:int = 0; j < curtCell.plist.length; j++)
				{
					
				}
			}
		}
	}
}