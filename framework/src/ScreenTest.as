package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import display.DrawObject;
	import display.Layer;
	import display.Screen;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class ScreenTest extends Sprite
	{
		[Embed(source="assets/images/surge.png")]
		private var RedRabbit:Class;
		private var redRabbitData:BitmapData = (new RedRabbit() as Bitmap).bitmapData;
		
		[Embed(source="assets/images/timg.png")]
		private var Backgournd:Class;
		private var backgourndData:BitmapData = (new Backgournd() as Bitmap).bitmapData;
		
		private var drawObj:DrawObject;
		
		private var screen:Screen;
		private var layer:Layer;
		public function ScreenTest()
		{
			super();
			screen = new Screen();
			addChild(screen.canvas);
			
			layer = new Layer();
			layer.setCamera(100,100,50,50);
			
			drawObj = new DrawObject(backgourndData.clone());
			drawObj.x = 100;
			layer.addChild(drawObj);
			
			drawObj = new DrawObject(redRabbitData.clone());
			drawObj.x = 200;
			drawObj.y = 200;
			layer.addChild(drawObj);
			
			
			screen.addChild(layer);
			screen.draw();
		}
	}
}