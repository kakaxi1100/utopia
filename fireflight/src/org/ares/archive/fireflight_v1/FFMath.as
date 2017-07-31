package org.ares.archive.fireflight_v1
{
	public class FFMath
	{
		public function FFMath()
		{
		}
		
		public static function noise(x:Number):Number
		{
			x = (x<<13) ^ x;
			return ( 1.0 - ( (x * (x * x * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
//			return ( 1.0 - ( (x * (x * x * 13 + 17) + 1376312589) & 0x7fffffff) / 1073741824.0);
		}
		
		public static function Linear_Interpolate(a:Number, b:Number, x:Number):Number
		{
			return  a*(1-x) + b*x
		}
	}
}