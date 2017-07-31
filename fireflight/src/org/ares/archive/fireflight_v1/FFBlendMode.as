package org.ares.archive.fireflight_v1
{
	public class FFBlendMode
	{
		public function FFBlendMode()
		{
		}
		
		/**
		 *正常混合
		 * 就是直接返回上层的像素值 
		 * @param topPixel
		 * @param bottomPixel
		 * @return 
		 * 
		 */		
		public static function normal(topPixel:uint, bottomPixel:uint):uint
		{
			return topPixel;
		}
		/**
		 * 颜色相加
		 *将显示对象的原色值添加到它的背景颜色中，上限值为 0xFF。此设置通常用于使两个对象间的加亮溶解产生动画效果。
		 * 例如，如果显示对象的某个像素的 RGB 值为 0xAAA633，背景像素的 RGB 值为 0xDD2200，
		 * 则显示像素的结果 RGB 值为 0xFFC833（因为 0xAA + 0xDD > 0xFF，0xA6 + 0x22 = 0xC8，且 0x33 + 0x00 = 0x33）。 
		 * @param topPixel
		 * @param bottomPixel
		 * @return 
		 * 
		 */		
		public static function add(topPixel:uint, bottomPixel:uint):FFColor
		{
			var tp:FFColor = getPixel(topPixel);
			var bp:FFColor = getPixel(bottomPixel);
			
			var a:uint = tp.alpha + bp.alpha;
			var r:uint = tp.red + bp.red;
			var g:uint = tp.green + bp.green;
			var b:uint = tp.blue + bp.blue;
			
			return setPixel(a<0xFF?a:0xFF, r<0xFF?r:0xFF, g<0xFF?g:0xFF, b<0xFF?b:0xFF);
		}
		
		/**
		 * 正片叠加
		 *将显示对象的原色值与背景颜色的原色值相乘，然后除以 0xFF 进行标准化，从而得到较暗的颜色。此设置通常用于阴影和深度效果。
		 * 例如，如果显示对象中一个像素的某个原色（例如红色）与背景中对应的像素颜色的值均为 0x88，则相乘结果为 0x4840。除以 0xFF 
		 * 将得到该原色的值 0x48，这是比显示对象或背景颜色暗的阴影。 
		 * 下面我们把这个公式稍加变形：topPixel*(bottomPixel/255),
		 * 由于bottomPixel永远大于等于0小于等于255，
		 * topPixel永远乘以一个0到1之间的数值，始终小于等于原来的值，所以该效果同样是使图像变暗
		 * @param topPixel
		 * @param bottomPixel
		 * @return 
		 * 
		 */		
		public static function multiply(topPixel:uint, bottomPixel:uint):uint
		{
			return (topPixel*bottomPixel/0xff);
		}
		
		/**
		 *设置像素颜色信息 
		 * @param a
		 * @param r
		 * @param g
		 * @param b
		 * @return 
		 * 
		 */		
		private static function setPixel(a:uint, r:uint, g:uint, b:uint):FFColor
		{
			return new FFColor(a,r,g,b);
		}
		/**
		 *取得颜色值 
		 * @return 
		 * 
		 */		
		private static function getPixel(p:uint):FFColor
		{
			var c:FFColor = new FFColor(p);
			return c;
		}
	}
}