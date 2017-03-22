package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import utils.MMatrix;
	
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
			var scaleTo:Number = 1, offSet:Number = 0;
			
			//因为最小的卷积核为 3x3 矩阵所以假如图片宽或高的像素不到3个，则无法使用卷积
			var mk:MMatrix = new MMatrix(3, 3);
			mk.fillMatrix([1,1,1,1,1,1,1,1,1]);
			
			//图像最外一圈无法使用卷积, 因为边界的问题, 所以最外面一圈只是copy原图的像素
			var mc:MMatrix = new MMatrix(3,3);
			
			var destM:MMatrix = new MMatrix(3,3);
			var left:int = 1, top:int = 1, bottom:int = src.height - 1, right:int = src.width - 1;
			for(var c:int = left; c < right; c++)
			{	
				for(var r:int = top; r < bottom; r++)
				{
					mc.matrix[0][0] = src.getPixel32(c - 1, r - 1);
					mc.matrix[1][0] = src.getPixel32(c - 1, r);
					mc.matrix[2][0] = src.getPixel32(c - 1, r + 1);
					
					mc.matrix[0][1] = src.getPixel32(c, r - 1);
					mc.matrix[1][1] = src.getPixel32(c, r);
					mc.matrix[2][1] = src.getPixel32(c, r + 1);
					
					mc.matrix[0][2] = src.getPixel32(c + 1, r - 1);
					mc.matrix[1][2] = src.getPixel32(c + 1, r);
					mc.matrix[2][2] = src.getPixel32(c + 1, r + 1);
					
					mk.multip(mc, destM);
					var pixel:uint = destM.getSum() * scaleTo + offSet;
					if(pixel < 0) {
						pixel = 0;
					}else if(pixel > 255)
					{
						pixel = 255;
					}
					dest.setPixel32(c, r, pixel);
				}
			}
			
		}
	}
}