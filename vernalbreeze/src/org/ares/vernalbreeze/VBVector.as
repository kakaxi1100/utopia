package org.ares.vernalbreeze
{
	public class VBVector
	{
		public var x:Number;
		public var y:Number;
		
		public function VBVector(px:Number = 0, py:Number = 0)
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
		public function plus(v:VBVector):VBVector 
		{
			return new VBVector(x + v.x, y + v.y); 
		}
		/**
		 * 矢量相加
		 * 改变原始值
		 * @param v
		 * @return 
		 * 
		 */		
		public function plusEquals(v:VBVector):VBVector 
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
		public function minus(v:VBVector):VBVector 
		{
			return new VBVector(x - v.x, y - v.y);    
		}
		/**
		 *矢量相减 
		 * 改变原始值
		 * @param v
		 * @return 
		 * 
		 */	
		public function minusEquals(v:VBVector):VBVector 
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
		public function mult(s:Number):VBVector 
		{
			return new VBVector(x * s, y * s);
		}
		/**
		 *数乘 
		 * 改变原始值
		 * @param s
		 * @return 
		 * 
		 */
		public function multEquals(s:Number):VBVector {
			x *= s;
			y *= s;
			return this;
		}
		
		/**
		 *加上一个被缩放过的矢量 
		 * 
		 */		
		public function plusScaledVector(v:VBVector, scale:Number):void
		{
			x += v.x * scale;
			y += v.y * scale;
		}
		
		/**
		 *点积（标积） 
		 * @param v
		 * @return 
		 * 
		 */		
		public function scalarMult(v:VBVector):Number 
		{
			return x * v.x + y * v.y;
		}
		/**
		 *叉积（矢积） 
		 * @param v
		 * @return 
		 * 
		 */		
		public function vectorMult(v:VBVector):Number 
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
		 *标准化矢量 
		 * @return 
		 * 
		 */		
		public function normalize():VBVector 
		{
			var m:Number = magnitude();
			if (m == 0) return null;
			return mult(1 / m);
		}
		
		public function setTo(px:Number, py:Number):void
		{
			x = px;
			y = py;
		}
		
		public function clone():VBVector
		{
			return new VBVector(this.x, this.y);
		}
		
		public function toString():String 
		{
			return "( "+x + " , " + y +" )";
		}
	}
}