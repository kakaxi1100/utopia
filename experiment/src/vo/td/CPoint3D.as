package vo.td
{
	public class CPoint3D
	{
		private var mX:Number;
		private var mY:Number;
		private var mZ:Number;
		
		private static const Degree:Number = 180 / Math.PI;
		private static const Radian:Number = Math.PI / 180;
		public function CPoint3D(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			mX = x;
			mY = y;
			mZ = z;
		}
		
		public function rotateXYZ(a:Number, b:Number, c:Number):void
		{
			var cosa:Number = Math.cos(a * Radian);
			var sina:Number = Math.sin(a * Radian);
			
			var cosb:Number = Math.cos(b * Radian);
			var sinb:Number = Math.sin(b * Radian);
			
			var cosc:Number = Math.cos(c * Radian);
			var sinc:Number = Math.sin(c * Radian);
			
			//先绕X轴旋转
			var ry:Number = cosa * mY - sina * mZ;
			var rz:Number = sina * mY + cosa * mZ;
			//在绕Y轴旋转
			var rx:Number = sinb * rz + cosb * mX;
			mZ = cosb * rz - sinb * mX;
			//最后绕Z轴旋转
			mX = cosc * rx - sinc * ry;
			mY = sinc * rx + cosc * ry;
		}
		
		public function rotateX(a:Number):void
		{
			var cosa:Number = Math.cos(a * Radian);
			var sina:Number = Math.sin(a * Radian);
			
			var ry:Number = cosa * mY - sina * mZ;
			var rz:Number = sina * mY + cosa * mZ;
			
			mY = ry;
			mZ = rz;
		}
		
		public function rotateY(a:Number):void
		{
			var cosa:Number = Math.cos(a * Radian);
			var sina:Number = Math.sin(a * Radian);
			
			var rz:Number = cosa * mZ - sina * mX;
			var rx:Number = sina * mZ + cosa * mX;
			
			mX = rx;
			mZ = rz;
		}
		
		public function rotateZ(a:Number):void
		{
			var cosa:Number = Math.cos(a * Radian);
			var sina:Number = Math.sin(a * Radian);
			
			var rx:Number = cosa * mX - sina * mY;
			var ry:Number = sina * mX + cosa * mY;
			
			mX = rx;
			mY = ry;
		}
		
		public function clone():CPoint3D
		{
			return new CPoint3D(mX, mY, mZ);
		}
		
		public function get x():Number
		{
			return mX;
		}

		public function set x(value:Number):void
		{
			mX = value;
		}

		public function get y():Number
		{
			return mY;
		}
		
		public function set y(value:Number):void
		{
			mY = value;
		}
		
		public function get z():Number
		{
			return mZ;
		}
		
		public function set z(value:Number):void
		{
			mZ = value;
		}
	}
}