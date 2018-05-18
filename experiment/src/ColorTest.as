package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;

	public class ColorTest extends Sprite
	{
		[Embed(source="assets/surge.png")]
		private var Surge:Class;
		
		public function ColorTest()
		{
			super();
			
//------------图像反转---------------------------------------------			
			var b:Bitmap = new Surge();
			addChild(b);
			var a:Bitmap = new Surge();
			a.x = 50;
			addChild(a);
			for(var i:int = 0; i < 75; i++)
			{
				for(var j:int = 0; j < 45; j++)
				{
					var color:uint = a.bitmapData.getPixel(j, i);
					var blue:uint = color & 0x0000ff;
					var green:uint = (color & 0x00ff00) >> 8;
					var red:uint = (color & 0xff0000)>>16;
					color = green << 16 | blue << 8 | red;
					a.bitmapData.setPixel(j, i, color);
				}
			}
			
//			var temp:ColorTransform = new ColorTransform();
//			trace(a.transform.colorTransform);
//			temp.blueMultiplier *= -1;
//			temp.redMultiplier *= -1;
//			temp.greenMultiplier *= -1;
//			temp.blueOffset = 255 - temp.blueOffset;
//			temp.redOffset = 255 - temp.redOffset;
//			temp.greenOffset = 255 - temp.greenOffset;
			
//			temp.blueMultiplier = temp.redMultiplier;
//			temp.blueOffset = temp.redOffset;
//			
//			a.transform.colorTransform = temp;
			//var t:Transform = new Transform(a);
			//t.colorTransform = new ColorTransform(
		}
	}
}