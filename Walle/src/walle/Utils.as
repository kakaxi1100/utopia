package walle
{
	public class Utils
	{
		//随机数的二项式分布, 也就是越接近0的随机数越容易取得
		public static function randomBinomial():Number
		{
			return Math.random() - Math.random();
		}
	}
}