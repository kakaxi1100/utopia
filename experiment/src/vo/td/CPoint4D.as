package vo.td
{
	import vo.CMatrix;

	public class CPoint4D
	{
		private var mX:Number;
		private var mY:Number;
		private var mZ:Number;
		private var mW:Number;
		
		private var mMatrix:CMatrix;
		public function CPoint4D(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 1)
		{
			mX = x;
			mY = y;
			mZ = z;
			mW = w;
			mMatrix = new CMatrix(1, 4);
			mMatrix.matrix[0][0] = mX;
			mMatrix.matrix[0][1] = mY;
			mMatrix.matrix[0][2] = mZ;
			mMatrix.matrix[0][3] = mW;
		}
		
		public function scalarMultip(n:Number):void
		{
			this.mX *= n;
			this.mY *= n;
			this.mZ *= n;
		}
		
		public function length():Number
		{
			return Math.sqrt(this.mX*this.mX + this.mY*this.mY + this.mZ*this.mZ);
		}
		
		public function normal():void
		{
			scalarMultip(1/length());
		}
		
		public function dot(v:CPoint4D):Number
		{
			return this.mX * v.mX + this.mY * v.mY + this.mZ * v.mZ;
		}
		
		public function cross(v:CPoint4D, p:CPoint4D = null):CPoint4D
		{
			if(p == null){
				p = new CPoint4D();
			}
			
			var cx:Number = this.mY * v.mZ - this.mZ * v.mY;
			var cy:Number = this.mZ * v.mX - this.mX * v.mZ;
			var cz:Number = this.mX * v.mY - this.mY * v.mX;
			
			p.x = cx;
			p.y = cy;
			p.z = cz;
			
			return p;
		}
		
		public function plusNew(v:CPoint4D, p:CPoint4D = null):CPoint4D
		{
			if(p == null){
				p = new CPoint4D();
			}
			p.x = this.mX + v.mX;
			p.y = this.mY + v.mY;
			p.z = this.mZ + v.mZ;
			return p;
		}
		
		public function minusNew(v:CPoint4D, p:CPoint4D = null):CPoint4D
		{
			if(p == null){
				p = new CPoint4D();
			}
			p.x = this.mX - v.mX;
			p.y = this.mY - v.mY;
			p.z = this.mZ - v.mZ;
			return p;
		}
		
		public function copy(p:CPoint4D):void
		{
			this.x = p.x;
			this.y = p.y;
			this.z = p.z;
			this.w = p.w;
		}
		
		public function clone():CPoint4D
		{
			return new CPoint4D(mX, mY, mZ);
		}
		
		public function get x():Number
		{
			return mX/mW;
		}
		
		public function set x(value:Number):void
		{
			mX = value;
		}
		
		public function get y():Number
		{
			return mY/mW;
		}
		
		public function set y(value:Number):void
		{
			mY = value;
		}
		
		public function get z():Number
		{
			return mZ/mW;
		}
		
		public function set z(value:Number):void
		{
			mZ = value;
		}
		
		public function get w():Number
		{
			return mW;
		}
		
		public function set w(value:Number):void
		{
			mW = value;
		}
		
		public function toString():String
		{
			return "( " + mX + ", " + mY + ", " + mZ + ", " + mW + " )";
		}

		
		public function mergeFromeMatrix(mt:CMatrix):void
		{
			mX = mt.matrix[0][0];
			mY = mt.matrix[0][1];
			mZ = mt.matrix[0][2];
			mW = mt.matrix[0][3];
		}
		
		public function get matrix():CMatrix
		{
			mMatrix.matrix[0][0] = mX;
			mMatrix.matrix[0][1] = mY;
			mMatrix.matrix[0][2] = mZ;
			mMatrix.matrix[0][3] = mW;
			return mMatrix;
		}

	}
}