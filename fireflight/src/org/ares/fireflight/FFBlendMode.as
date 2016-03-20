package org.ares.fireflight
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
		public static function add(topPixel:uint, bottomPixel:uint):uint
		{
			var a:uint = alpha(topPixel) + alpha(bottomPixel);
			var r:uint = red(topPixel) + red(bottomPixel);
			var g:uint = green(topPixel) + green(bottomPixel);
			var b:uint = blue(topPixel) + blue(bottomPixel);
			
			return setPixel(a<0xFF?a:0xFF, r<0xFF?r:0xFF, g<0xFF?g:0xFF, b<0xFF?b:0xFF);
		}
		
		/**
		 *变暗模式
		 * 两个像素值之间取最小值返回 
		 * 在显示对象原色和背景颜色中选择相对较暗的颜色（具有较小值的颜色）。此设置通常用于叠加类型。
		 * @param topPixel
		 * @param bottomPixel
		 * @return 
		 * 
		 */		
		public static function darken(topPixel:uint, bottomPixel:uint):uint
		{
			var a:uint = alpha(topPixel) < alpha(bottomPixel) ? alpha(topPixel):alpha(bottomPixel);
			var r:uint = red(topPixel) < red(bottomPixel) ? red(topPixel):red(bottomPixel);
			var g:uint = green(topPixel) < green(bottomPixel) ? green(topPixel):green(bottomPixel);
			var b:uint = blue(topPixel) < blue(bottomPixel) ? blue(topPixel):blue(bottomPixel);
			return setPixel(a,r,g,b);
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
		private static function setPixel(a:uint, r:uint, g:uint, b:uint):uint
		{
			return a<<24+r<<16+g<<8+b;
		}
		/**
		 *取得颜色值 
		 * @return 
		 * 
		 */		
		private static function getPixel(p:uint):Color
		{
			var c:Color = new Color();
			c.alpha = alpha(p);
			c.red = red(p);
			c.green = green(p);
			c.blue = blue(p);
			return c;
		}
		/**
		 *取得像素alpha值 
		 * @param pixel
		 * @return 
		 * 
		 */		
		private static function alpha(pixel:uint):uint
		{
			return pixel>>24;
		}
		/**
		 *取得像素红色值 
		 * @param pixel
		 * @return 
		 * 
		 */		
		private static function red(pixel:uint):uint
		{
			return (pixel>>16)&0xFF;
		}
		/**
		 *取得像素绿色值
		 * @param pixel
		 * @return 
		 * 
		 */		
		private static function green(pixel:uint):uint
		{
			return (pixel>>8)&0xFF;
		}
		/**
		 *取得像素蓝色值 
		 * @param pixel
		 * @return 
		 * 
		 */		
		private static function blue(pixel:uint):uint
		{
			return pixel&0xFF;
		}
	}
}
class Color
{
	public var alpha:uint;
	public var red:uint;
	public var green:uint;
	public var blue:uint;
}