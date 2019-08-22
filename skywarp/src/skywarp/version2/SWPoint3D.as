package skywarp.version2
{
	public class SWPoint3D
	{
		private var mX:Number;
		private var mY:Number;
		private var mZ:Number;
		
		private static const Degree:Number = 180 / Math.PI;
		private static const Radian:Number = Math.PI / 180;
		public function SWPoint3D(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			mX = x;
			mY = y;
			mZ = z;
		}
		
		public function dot(v:SWPoint3D):Number
		{
			return this.mX * v.mX + this.mY * v.mY + this.mZ * v.mZ;
		}
		
		//用左手还是右手判断取决于你用什么坐标系
		//原则是 i，j，k满足以下特点：
		//i=jxk；j=kxi；k=ixj；
		//kxj=–i；ixk=–j；jxi=–k；
		//ixi=jxj=kxk=0；（0是指0向量）
		public function cross(v:SWPoint3D, result:SWPoint3D = null):SWPoint3D
		{
			if(!result)
			{
				result = new SWPoint3D();
			}
			
			var cx:Number = this.mY * v.mZ - this.mZ * v.mY;
			var cy:Number = this.mZ * v.mX - this.mX * v.mZ;
			var cz:Number = this.mX * v.mY - this.mY * v.mX;
			
			result.setTo(cx, cy, cz)
			return result;
		}
		
		public function minus(v:SWPoint3D, result:SWPoint3D = null):SWPoint3D
		{
			if(!result)
			{
				result = new SWPoint3D();
			}
			result.setTo(this.mX - v.mX, this.mY - v.mY, this.mZ - v.mZ);
			return result;
		}	
		
		public function mult(number:Number, out:SWPoint3D = null):SWPoint3D 
		{
			if(out == null){
				out = new SWPoint3D(this.x * number, this.y * number, this.z * number);
			}else{
				out.setTo(this.x * number, this.y * number, this.z * number);
			}
			
			return out;
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
			
			var rx:Number = sina * mZ + cosa * mX;
			var rz:Number = cosa * mZ - sina * mX;
			
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
		
		public function setTo(x:Number, y:Number, z:Number):void
		{
			this.mX = x;
			this.mY = y;
			this.mZ = z;
		}
		
		public function magnitude():Number {
			return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
		}
		
		public function clone():SWPoint3D
		{
			return new SWPoint3D(mX, mY, mZ);
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
		
		public function toString():String
		{
			return "( " + mX + ", " + mY + ", " + mZ + " )";
		}
	}
}