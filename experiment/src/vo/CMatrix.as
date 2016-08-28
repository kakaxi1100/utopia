package vo
{
	public class CMatrix
	{
		private var mMatrix:Vector.<Vector.<Number>>;
		private var mCols:uint;
		private var mRows:uint;
		public function CMatrix(rows:uint, cols:uint)
		{
			mCols = cols;
			mRows = rows;
			mMatrix = new Vector.<Vector.<Number>>(rows);
			for(var r:uint = 0; r < rows; ++r)
			{
				mMatrix[r] = new Vector.<Number>(cols);
				for(var c:uint = 0; c < cols; ++c)
				{
					mMatrix[r][c] = 0;
				}
			}
		}
		
		public function getElement(r:uint, c:uint):Number
		{
			return mMatrix[r][c];
		}
		
		public function fillMatrix(list:Array):void
		{
			for(var i:int = 0; i < list.length; ++i)
			{
				var r:uint = i / mCols >> 0;
				var c:uint = i % mCols;
				mMatrix[r][c] = list[i];
			}
		}
	}
}