package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class DisplacemantTest extends Sprite
	{
		[Embed(source="assets/base_0005_twirl.png")]
		private var Twirl:Class;
		
		private var reference:Bitmap = new Bitmap(new BitmapData(256,256));
		private var distort:Bitmap = new Twirl();
		private var displace:Bitmap = new Bitmap(new BitmapData(256,256));
		
		public function DisplacemantTest()
		{
			super();
			addChild(displace);
			var i:int;
			var j:int;
			for (i=0;i<256;i++) {
				for (j=0;j<256;j++) {
					reference.bitmapData.setPixel(i,j,i<<16|j<<8);
				}
			}
			
			var factor:Number = 0.5;
			for (i=0;i<256;i++) {
				for (j=0;j<256;j++) {
					//middle the difference to prevent overflow
					var dx:Number = ((distort.bitmapData.getPixel(i,j) >> 16 & 0xff) - (reference.bitmapData.getPixel(i,j) >> 16 & 0xff))*factor+0x80;
					
					var dy:Number = ((distort.bitmapData.getPixel(i,j) >> 8 & 0xff) - (reference.bitmapData.getPixel(i,j) >> 8 & 0xff))*factor+0x80;
					
					displace.bitmapData.setPixel(i, j, 
						(dx << 16)|(dy<<8)|0x80 //0x80 is not necessary, but using a visual grey as 'no displacement' is satisfying:)
					);
				}
			}
		}
	}
}