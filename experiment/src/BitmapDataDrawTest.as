package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BitmapDataDrawTest extends Sprite
	{
		[Embed(source="assets/surge.png")]
		private var Surge:Class;
		
		
		public function BitmapDataDrawTest()
		{
			super();
			
			var source:Bitmap = new Surge();
			
			var dest:Bitmap = new Bitmap(new BitmapData(800, 600, false, 0));
			
//			addChild(source);
			addChild(dest);
			
			var m:Matrix = new Matrix();
//			m.translate(20,20);
			m.scale(1,2);
			
			dest.bitmapData.draw(source, m, null, null, new Rectangle(20,0,800,600)); 
		}
	}
}