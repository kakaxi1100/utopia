package walle
{
	public class FFVector
	{
		public var x:Number;
		public var y:Number;
		
		private static var mTempV1:FFVector = new FFVector();
		
		public function FFVector(px:Number = 0, py:Number = 0)
		{
			this.x = px;
			this.y = py;
		}
		
		//如果需要改变的是原值, 只需要将out设置为自己本身就可以了
		//var a = new FFVector();
		//a.plus(new FFVector(1,5), a);
		//a: FFVector {x: 1, y: 5}
		public function plus(v:FFVector, out:FFVector = null):FFVector 
		{
			if(out == null){
				out = new FFVector();
			}
			
			out.setTo(this.x + v.x, this.y + v.y);
			
			return out;
		}
		
		public function minus(v:FFVector, out:FFVector = null):FFVector 
		{
			if(out == null){
				out = new FFVector();
			}
			
			out.setTo(this.x - v.x, this.y - v.y);
			
			return out;
		}
		
		public function mult(number:Number, out:FFVector = null):FFVector 
		{
			if(out == null){
				out = new FFVector();
			}
			
			out.setTo(this.x * number, this.y * number);
			
			return out;
		}
		
		public function div(number:Number, out:FFVector = null):FFVector 
		{
			if(out == null){
				out = new FFVector();
			}
			
			
			out.setTo(this.x / number, this.y / number);
			
			return out;
		}
		
			
		public function plusScaledVector(v:FFVector, scale:Number):void
		{
			this.x += v.x * scale;
			this.y += v.y * scale;
		}
		
		/**
		 *点积（标积） 
		 * 点积的几何意义：1，求投影 2，计算锐角或者钝角
		 * 1.|A|·|B|·cosα
		 * 2.当两个向量的夹角是锐角的时,投影是正的 ;夹角是钝角,投影是负的 ;夹角是直角,投影是0
		 * @param v
		 * @return 
		 * 
		 */		
		public function scalarMult(v:FFVector):Number 
		{
			return this.x * v.x + this.y * v.y;
		}
		/**
		 *叉积（矢积、外积） 
		 * 叉积即几何意义：1，求面积 3，求一个矢量相对于另一个矢量的位置（顺时针方向或逆时针方向）
		 * 1.|A|·|B|·sinα
		 * 2.|x1 y1|
		 *   |x2 y2|= x1*y2 - x2*y1
		 * 3.得到的量方向是与两个矢量正交
		 * @param v
		 * @return 
		 * 
		 */		
		public function vectorMult(v:FFVector):Number 
		{
			return this.x * v.y - this.y * v.x;
		}
			
		public function rotate(theta:Number):void
		{
			var tempX:Number = this.x * Math.cos(theta) - this.y * Math.sin(theta);
			var tempY:Number = this.x * Math.sin(theta) + this.y * Math.cos(theta);
			
			this.setTo(tempX, tempY);
		}
		
		public function magnitude():Number 
		{
			return Math.sqrt(this.x * this.x + this.y * this.y);
		}
			
		public function magnitudeSquare():Number 
		{
			return this.x * this.x + this.y * this.y;
		}
		
			
		public function distance(v:FFVector):Number
		{
			return this.minus(v, mTempV1).magnitude();
		}
		
			
		public function distanceSquare(v:FFVector):Number
		{
			return this.minus(v, mTempV1).magnitudeSquare();
		}
		
		public function normalize(out:FFVector = null):FFVector {
			var m:Number = this.magnitude();
			if(out == null){
				out = new FFVector();
			}
			
			if (m == 0) {
				out.setTo(0, 0);
				return out;
			}
			return this.mult(1 / m, out);
		}
			
		public function truncate(num:Number):FFVector
		{
			if(this.magnitudeSquare() > num * num)
			{
				//如果大了就截断
				var vNormal:FFVector = this.normalize(this);
				vNormal.mult(num, this);
			}
			
			return this;
		}
		
		//正交基的另一个轴 perpendicular 垂直的意思
		public function perp(out:FFVector = null):FFVector
		{
			if(out == null){
				out = new FFVector();
			}
			
			out.setTo(-this.y, this.x);
			return out;
		}
		
		public function equal(v:FFVector):Boolean
		{
			return (this.x == v.x && this.y == v.y);
		}
		
		public function setTo(px:Number, py:Number):FFVector
		{
			this.x = px;
			this.y = py;
			
			return this;
		}
		
		public function isZero():Boolean
		{
			return this.x == 0 && this.y == 0;
		}
		
		public function clear():void
		{
			this.x = this.y = 0;
		}
		
		public function clone(out:FFVector = null):FFVector
		{
			if(out == null)
			{
				out = new FFVector();
			}
			
			out.setTo(this.x, this.y);
			
			return out
		}
		
		public function toString():String 
		{
			return "( "+ this.x + " , " + this.y +" )";
		}
	}
}