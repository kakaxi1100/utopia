/**
 *“仿射变换”就是：“线性变换”+“平移”。
 * 
 * 
 * 1 线性变换
 * 线性变换从几何直观有三个要点：
 * 变换前是直线的，变换后依然是直线
 * 直线比例保持不变
 * 变换前是原点的，变换后依然是原点
 * 
 * 2 仿射变换
 * 仿射变换从几何直观只有两个要点：
 * 变换前是直线的，变换后依然是直线
 * 直线比例保持不变
 * 少了原点保持不变这一条。
 * 比如平移 
 * 
 * 
 * http://blog.csdn.net/pathuang68/article/details/6991867
 * https://en.wikipedia.org/wiki/Transformation_matrix
 * 
 * 
 */

package
{
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="120", backgroundColor="0")]
	public class AffineTransformation extends Sprite
	{
		public function AffineTransformation()
		{
			super();
		}
	}
}