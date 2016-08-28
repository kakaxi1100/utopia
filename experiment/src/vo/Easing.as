package vo
{
	public class Easing
	{
		//没有缓动就是线性缓动
		public static function liner(t:Number, c:Number, d:Number, b:Number):Number
		{
			return (t/d)*c + b;
		}
		
		//线性缓入
		public static function quadraticIn(t:Number, c:Number, d:Number, b:Number):Number
		{
			return (t/d)*c + b;
		}
		//线性缓出
		public static function quadraticOut(t:Number, c:Number, d:Number, b:Number):Number
		{
			return (t/d)*c + b;
		}
	}
}