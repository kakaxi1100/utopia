package base
{
	public class EVector
	{
		public var x:Number;
		public var y:Number;
		
		public function EVector(px:Number = 0, py:Number = 0)
		{
			x = px;
			y = py;
		}
		/**
		 *矢量相加
		 * 不改变原始值，产生一个新值 
		 * @param v
		 * @return 
		 * 
		 */		
		public function plus(v:EVector):EVector 
		{
			return new EVector(x + v.x, y + v.y); 
		}
		/**
		 * 矢量相加
		 * 改变原始值
		 * @param v
		 * @return 
		 * 
		 */		
		public function plusEquals(v:EVector):EVector 
		{
			x += v.x;
			y += v.y;
			return this;
		}
		/**
		 *矢量相减 
		 * 不改变原始值，产生一个新值 
		 * @param v
		 * @return 
		 * 
		 */		
		public function minus(v:EVector):EVector 
		{
			return new EVector(x - v.x, y - v.y);    
		}
		/**
		 *矢量相减 
		 * 改变原始值
		 * @param v
		 * @return 
		 * 
		 */	
		public function minusEquals(v:EVector):EVector 
		{
			x -= v.x;
			y -= v.y;
			return this;
		}
		
		/**
		 *数乘 
		 * 不改变原始值，产生一个新值 
		 * @param s
		 * @return 
		 * 
		 */		
		public function mult(s:Number):EVector 
		{
			return new EVector(x * s, y * s);
		}
		/**
		 *数乘 
		 * 改变原始值
		 * @param s
		 * @return 
		 * 
		 */
		public function multEquals(s:Number):EVector {
			x *= s;
			y *= s;
			return this;
		}
		
		/**
		 *加上一个被缩放过的矢量 
		 * 
		 */		
		public function plusScaledVector(v:EVector, scale:Number):void
		{
			x += v.x * scale;
			y += v.y * scale;
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
		public function scalarMult(v:EVector):Number 
		{
			return x * v.x + y * v.y;
		}
		/**
		 *叉积（矢积） 
		 * 叉积即几何意义：1，求面积 3，求一个矢量相对于另一个矢量的位置（顺时针方向或逆时针方向）
		 * 1.|A|·|B|·sinα
		 * 2.|x1 y1|
		 *   |x2 y2|= x1*y2 - x2*y1
		 * @param v
		 * @return 
		 * 
		 */		
		public function vectorMult(v:EVector):Number 
		{
			return x * v.y - y * v.x;
		}
		/**
		 *大小 
		 * @return 
		 * 
		 */		
		public function magnitude():Number 
		{
			return Math.sqrt(x * x + y * y);
		}
		/**
		 *大小平方 其实就是点击
		 * @return 
		 * 
		 */		
		public function magnitudeSq():Number 
		{
			return x * x + y * y;
		}
		/**
		 *计算两点之间的距离 
		 * @param v
		 * @return 
		 * 
		 */		
		public function distance(v:EVector):Number
		{
			return this.minus(v).magnitude();
		}
		/**
		 *距离平方 
		 * @param v
		 * @return 
		 * 
		 */		
		public function distanceSq(v:EVector):Number
		{
			return this.minus(v).magnitudeSq();
		}
		/**
		 *标准化矢量 
		 * 不改变原始值，产生一个新值 
		 * @return 
		 * 
		 */		
		public function normalize():EVector 
		{
			var m:Number = magnitude();
			if (m == 0) return new EVector();
			return mult(1 / m);
		}
		
		/**
		 *标准化矢量 
		 * 改变原始值
		 * @return 
		 * 
		 */		
		public function normalizeEquals():EVector 
		{
			var m:Number = magnitude();
			if (m == 0) return new EVector();
			return multEquals(1 / m);
		}
		
		/**
		 *判断两个向量是否相等 
		 * @param v
		 * @return 
		 * 
		 */		
		public function equal(v:EVector):Boolean
		{
			return (this.x == v.x && this.y == v.y);
		}
		
		public function setTo(px:Number, py:Number):void
		{
			x = px;
			y = py;
		}
		
		/**
		 *置零 
		 * 
		 */		
		public function zero():void
		{
			x = 0;
			y = 0;
		}
		
		/**
		 *截断 
		 * @param value
		 * 
		 */		
		public function truncate(value:Number):void
		{
			length = Math.min(length, value);
		}
		
		/**
		 *设置长度 
		 * @return 
		 * 
		 */		
		public function get length():Number
		{
			return magnitude();
		}
		
		public function set length(value:Number):void
		{
			var a:Number = angle;
			
			x = Math.cos(a)*value;
			y = Math.sin(a)*value;	
		}
		
		/**
		 *角度 
		 * @return 
		 * 
		 */		
		public function get angle():Number
		{
			return Math.atan2(y, x);
		}
		
		public function set angle(value:Number):void
		{
			var len:Number = magnitude();
			x = Math.cos(value)*len;
			y = Math.sin(value)*len;
		}
		
		public function clear():void
		{
			x = y = 0;
		}
		
		public function clone():EVector
		{
			return new EVector(this.x, this.y);
		}
		
		public function toString():String 
		{
			return "( "+ x + " , " + y +" )";
		}
	}
}