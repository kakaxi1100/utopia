package vo
{
	import vo.td.CPoint4D;

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
		 *point4D * Martix, 最后得到的是一个 1x4 矩阵
		 *  把结果保存在 original 中
		 * 并且修改了 p 的原始值
		 * @param p
		 * @param original
		 * @return 
		 * 
		 */		
		public function multipPoint4D(p:CPoint4D, original:CMatrix = null):CMatrix
		{
			if(this.mCols != 4 || this.mRows != 4) throw Error("行列值不符合乘法规则!");
			var temp:CMatrix;
			
//			var mt4D:CMatrix = new CMatrix(1, 4);
//			mt4D.mMatrix[0][0] = p.x;
//			mt4D.mMatrix[0][1] = p.y;
//			mt4D.mMatrix[0][2] = p.z;
//			mt4D.mMatrix[0][3] = 1;
			
			temp = p.matrix.multip(this, original);
			
			p.mergeFromeMatrix(temp);
				
			return temp;
		}
		/**
		 * 矩阵相乘把结果记录在 original 中 
		 * @param m
		 * @param original
		 * @return 
		 * 
		 */		
		public function multip(m:CMatrix, original:CMatrix = null):CMatrix
		{
			if(this.mCols != m.mRows) throw Error("行列值不符合乘法规则!");
			
			var inner:uint = this.mCols;//必须相等的值（此矩阵的行和m矩阵的列）
			var temp:CMatrix;
			if(original == null)
			{
				temp = new CMatrix(this.mRows, m.mCols);
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