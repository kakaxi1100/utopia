package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class BlurImageTest extends Sprite
	{
		[Embed(source="assets/timg.jpg")]
		private var Background:Class;
		
		private var bg:Bitmap = new Background();
		public function BlurImageTest()
		{
			super();
			trace(bg.bitmapData.height, bg.bitmapData.width)
		}
		
		private function blur(src:BitmapData, dest:BitmapData):void
		{
			//因为最小的卷积核为 3x3 矩阵所以假如图片宽或高的像素不到3个，则无法使用卷积
			
			//图像最外一圈无法使用卷积, 因为边界的问题, 所以最外面一圈只是copy原图的像素
			
			var left:int = 1, top:int = 1, bottom:int = src.height - 1, right:int = src.width - 1;
			for(var c:int = left; c < right; c++)
			{
				for(var r:int = top; r < bottom; r++)
				{
					
				}
			}
			
		}
	}
}