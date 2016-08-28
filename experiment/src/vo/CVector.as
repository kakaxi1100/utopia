package vo
{
	public class CVector
	{
		private var mX:Number;
		private var mY:Number;
		
		private static const Degree:Number = 180 / Math.PI;
		private static const Radian:Number = Math.PI / 180;
		public function CVector(x, y)
		{
			mX = x;
			mY = y;
		}
		
		public function plus(v:CVector):void
		{
			this.mX += v.mX;
			this.mY += v.mY;
		}
		
		public function plusNew(v:CVector):CVector
		{
			return new CVector(this.mX + v.mX, this.mY + v.mY);
		}
		
		public function minus(v:CVector):void
		{
			this.mX -= v.mX;
			this.mY -= v.mY;
		}
		
		public function minusNew(v:CVector):CVector
		{
			return new CVector(this.mX - v.mX, this.mY - v.mY);
		}
		
		public function negate():void
		{
			this.mX = -this.mX;
			this.mY = -this.mY;
		}
		
		public function negateNew():CVector
		{
			return new CVector(-this.mX, -this.mY);
		}
		
		public function scale(s:Number):void
		{
			this.mX *= s;
			this.mY *= s;
		}
		
		public function scaleNew(s:Number):CVector
		{
			return new CVector(this.mX * s, this.mY * s);
		}
		
		public function getLength():Number
		{
			return Math.sqrt(this.mX * this.mX + this.mY * this.mY);
		}
		
		public function setLength(l:Number):void
		{
			var r:Number = getLength();
			if(r)
			{
				this.scale(l/r);
			}else{
				this.mX = l; //当方向为0时，默认为x轴正向
			}
		}
		
		public function getAngle():Number//返回度数
		{
			return Math.atan2(this.mY, this.mX) * Degree;
		}
		
		public function setAngle(a:Number):void //输入要求是度数
		{
			var r:Number = getLength();
			this.mX = r*Math.cos(a * Radian);
			this.mY = r*Math.sin(a * Radian);
		}
		
		public function roate(a:Number):void //兄弟, 还记得这个坐标转换的推导吗？
		{
			var cosa:Number = Math.cos(a * Radian);
			var sina:Number = Math.sin(a * Radian);
			
			var rx:Number = cosa * mX - sina * mY;
			var ry:Number = sina * mX + cosa * mY;
			
			mX = rx;
			mY = ry;
		}
		
		public function roateNew(a:Number):CVector
		{
			var v:CVector = new CVector(this.mX, this.mY);
			v.roate(a);
			return v;
		}
		
		//斜率
		public function slop():Number
		{
			if(this.mX != 0){
				return this.mY / this.mX;
			}
			return Number.MAX_VALUE;
		}
		
		//判断两向量夹角的关系
		public function dot(v:CVector):Number
		{
			return this.mX * v.mX + this.mY * v.mY;
		}
		
		public function getNormal():CVector//取得法向量
		{
			return new CVector(-this.mY, this.mX);
		}
		
		//验证垂直
		public function isPerpTo(v:CVector):Boolean
		{
			return (dot(v) == 0);
		}
		
		//通过点积公式推导
		public function angleBetween(v:CVector):Number
		{
			var dp:Number = this.dot(v);
			var cosa:Number = dp / (this.getLength() * v.getLength());
			
			return Math.acos(cosa) * Degree;
		}
		
		public function equals(v:CVector):Boolean
		{
			return (v.mX == mX && v.mY == mY);	
		}
		
		public function reset(x:Number, y:Number):void
		{
			mX = x;
			mY = y;
		}
		
		public function clone():CVector
		{
			return new CVector(mX, mY);
		}
		
		public function toString():String
		{
			var rx:String = mX.toPrecision(3);
			var ry:String = mY.toPrecision(3);
			return "( " + rx + ", " + ry + " )";
		}

		public function get x():Number
		{
			return mX;
		}
		
		public function get y():Number
		{
			return mY;
		}
	}
}