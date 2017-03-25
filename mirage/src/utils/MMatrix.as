package utils
{
	[SWF(width="800", height="600", frameRate="120", backgroundColor="0xcccccc")]
	public class MMatrix
	{
		private var mMatrix:Vector.<Vector.<Number>>;
		private var mCols:uint;
		private var mRows:uint;
		public function MMatrix(rows:uint, cols:uint)
		{
			mCols = cols;
			mRows = rows;
			mMatrix = new Vector.<Vector.<Number>>(rows);
			setToZero();
		}
		
		public function setToZero():void
		{
			for(var r:uint = 0; r < this.mRows; ++r)
			{
				mMatrix[r] = new Vector.<Number>(this.mCols);
				for(var c:uint = 0; c < this.mCols; ++c)
				{
					mMatrix[r][c] = 0;
				}
			}
		}
		
		public function getElement(r:uint, c:uint):Number
		{
			return mMatrix[r][c];
		}
		
		//超过长度的会被填0
		public function fillMatrix(list:Array):void
		{
			for(var i:int = 0; i < list.length; ++i)
			{
				var r:uint = i / mCols >> 0;
				var c:uint = i % mCols;
				mMatrix[r][c] = list[i];
			}
		}
		
		public function normal():void
		{
			if(mRows != mCols) throw Error("矩阵行列不等, 不符合规范化条件!");
			for(var r:int = 0; r < mRows; r++)
			{
				mMatrix[r][r] = 1;
			}
		}
		
		/**
		 *求所有元素加起来的和 
		 * @return 
		 * 
		 */		
		public function getSum():Number
		{
			var sum:Number = 0;
			for(var r:uint = 0; r < this.mRows; ++r)
			{
				for(var c:uint = 0; c < this.mCols; ++c)
				{
					sum += mMatrix[r][c];
				}
			}
			
			return sum;
		}
		
		/**
		 * 矩阵相乘把结果记录在 original 中 
		 * @param m
		 * @param original
		 * @return 
		 * 
		 */		
		public function multip(m:MMatrix, original:MMatrix = null):MMatrix
		{
			if(this.mCols != m.mRows) throw Error("行列值不符合乘法规则!");
			
			var inner:uint = this.mCols;//必须相等的值（此矩阵的行和m矩阵的列）
			var temp:MMatrix;
			if(original == null)
			{
				temp = new MMatrix(this.mRows, m.mCols);
			}
			else
			{
				temp = original;
			}
			
			
			for(var r:int = 0; r < this.mRows; r++)//this矩阵的第几行
			{
				for(var c:int = 0; c < inner; c++)//this矩阵的第几列
				{
					for(var j:int = 0; j < m.mCols; j++)
					{
						temp.mMatrix[r][j] += this.getElement(r, c) * m.getElement(c, j);
					}
				}
			}
			
			return temp;
		}
		
		public function get matrix():Vector.<Vector.<Number>>
		{
			return mMatrix;
		}
		
		public function set matrix(value:Vector.<Vector.<Number>>):void
		{
			mMatrix = value;
		}
		
		
	}
}