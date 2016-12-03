package vo
{

	public class CVector3D
	{
		private var mX:Number;
		private var mY:Number;
		private var mZ:Number;
		
		private static const Degree:Number = 180 / Math.PI;
		private static const Radian:Number = Math.PI / 180;
		public function CVector3D(x:Number, y:Number, z:Number)
		{
			this.mX = x;
			this.mY = y;
			this.mZ = z;
		}
		
		public function plus(v:CVector3D):void
		{
			this.mX += v.mX;
			this.mY += v.mY;
			this.mZ += v.mZ;
		}
		
		public function plusNew(v:CVector3D):CVector3D
		{
			return new CVector3D(this.mX + v.mX, this.mY + v.mY, this.mZ + v.mZ);
		}
		
		public function minus(v:CVector3D):void
		{
			this.mX -= v.mX;
			this.mY -= v.mY;
			this.mZ -= v.mZ;
		}
		
		public function minusNew(v:CVector3D):CVector3D
		{
			return new CVector3D(this.mX - v.mX, this.mY - v.mY, this.mZ - v.mZ);
		}
		
		public function negate():void
		{
			this.mX = -this.mX;
			this.mY = -this.mY;
			this.mZ = -this.mZ;
		}
		
		public function negateNew():CVector3D
		{
			return new CVector3D(-this.mX, -this.mY, -this.mZ);
		}
		
		public function scale(s:Number):void
		{
			this.mX *= s;
			this.mY *= s;
			this.mZ *= s;
		}
		
		public function scaleNew(s:Number):CVector3D
		{
			return new CVector3D(this.mX * s, this.mY * s, this.mZ * s);
		}
		
		public function getLength():Number
		{
			return Math.sqrt(this.mX * this.mX + this.mY * this.mY + this.mZ * this.mZ);
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
		
		//判断两向量夹角的关系
		public function dot(v:CVector3D):Number
		{
			return this.mX * v.mX + this.mY * v.mY + this.mZ * v.mZ;
		}
		
		//三维向量的叉积有点意思啊
		//计算连个向量的叉积会得到第三个向量
		//这个新向量与前两个向量是垂直的并且满足关系
		//向量积|c|=|a×b|=|a| |b|sin<a,b>
		//即c的长度在数值上等于以a，b，夹角为θ组成的平行四边形的面积。
		//而c的方向垂直于a与b所决定的平面，c的指向按右手定则从a转向b来确定。
		//*运算结果c是一个伪向量。这是因为在不同的坐标系中c可能不同
		//一个简单的确定满足“右手定则”的结果向量的方向的方法是这样的：若坐标系是满足右手定则的，当右手的四指从a以不超过180度的转角转向b时，竖起的大拇指指向是c的方向。
		public function cross(v:CVector3D):CVector3D
		{
			var cx:Number = this.mY * v.mZ - this.mZ * v.mY;
			var cy:Number = this.mZ * v.mX - this.mX * v.mZ;
			var cz:Number = this.mX * v.mY - this.mY * v.mX;
			
			return new CVector3D(cx, cy, cz);
		}
		
		//计算物体的透视到屏幕上，要缩放的比例
		//原理：viewDist 可以理解为 眼睛到 屏幕的距离
		//　mZ 是屏幕到物体的坐标
		//所以根据相似三角形 可以得到， 物理到屏幕的缩放比例为: viewDist / mZ + viewDist
		//还不懂，那就去看笔记吧
		public function getPerspective(viewDist:Number = 300):Number
		{
			return viewDist / (this.mZ + viewDist);
		}
		
		//将三维点投影到二维屏幕
		public function persProject():void
		{
			var p:Number = getPerspective();
			mX *= p;
			mY *= p;
			mZ = 0;
		}
		//将三维点投影到二维屏幕
		public function persProjectNew():CVector3D
		{
			var p:Number = getPerspective();
			return new CVector3D(mX * p, mY * p, 0);
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
		
		public function rotateXTrig(cosa:Number, sina:Number):void
		{		
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
		
		public function rotateYTrig(cosa:Number, sina:Number):void
		{	
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
		
		public function rotateZTrig(cosa:Number, sina:Number):void
		{		
			var rx:Number = cosa * mX - sina * mY;
			var ry:Number = sina * mX + cosa * mY;
			
			mX = rx;
			mY = ry;
		}
		
		public function rotateXY(a:Number, b:Number):void
		{
			var cosa:Number = Math.cos(a * Radian);
			var sina:Number = Math.sin(a * Radian);
			
			var cosb:Number = Math.cos(b * Radian);
			var sinb:Number = Math.sin(b * Radian);
			
			//先绕X轴旋转, 再绕Y轴旋转
			var rz:Number = sina * mY + cosa * mZ;
			mY =  cosa * mY - sina * mZ;
			
			mZ = cosb * rz - sinb * mX;
			mX = sinb * rz + cosb * mX;
		}
		
		public function rotateXYTrig(cosa:Number, sina:Number, cosb:Number, sinb:Number):void
		{
			var rz:Number = sina * mY + cosa * mZ;
			mY =  cosa * mY - sina * mZ;
			
			mZ = cosb * rz - sinb * mX;
			mX = sinb * rz + cosb * mX;
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
		
		public function rotateXYZTrig(cosa:Number, sina:Number, cosb:Number, sinb:Number, cosc:Number, sinc:Number):void
		{
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
		
		//通过点积公式推导
		public function angleBetween(v:CVector3D):Number
		{
			var dp:Number = this.dot(v);
			var cosa:Number = dp / (this.getLength() * v.getLength());
			
			return Math.acos(cosa) * Degree;
		}
		
		public function equals(v:CVector3D):Boolean
		{
			return (v.mX == mX && v.mY == mY && v.mZ == mZ);	
		}
		
		public function reset(x:Number, y:Number, z:Number):void
		{
			mX = x;
			mY = y;
			mZ = z;
		}
		
		public function clone():CVector3D
		{
			return new CVector3D(mX, mY, mZ);
		}
		
		
		public function toString():String
		{
			var rx:String = mX.toPrecision(3);
			var ry:String = mY.toPrecision(3);
			var rz:String = mZ.toPrecision(3);
			return "( " + rx + ", " + ry + ", " + rz + " )";
		}
		
		public function get x():Number
		{
			return mX;
		}
		
		public function get y():Number
		{
			return mY;
		}
		public function get z():Number
		{
			return mZ;
		}
	}
}