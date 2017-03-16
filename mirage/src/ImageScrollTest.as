package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0xcccccc")]
	public class ImageScrollTest extends Sprite
	{
		[Embed(source="assets/timg.jpg")]
		private var Background:Class;
		
		private var bg:Bitmap = new Background();
		
		private var dest:Bitmap = new Bitmap(new BitmapData(800,600,false,0));
		public function ImageScrollTest()
		{
			super();
			addChild(dest);
//			incline();
			sinMove();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dest.bitmapData.lock();
//			dest.bitmapData.fillRect(dest.bitmapData.rect,0);
			sinMove();
			a += 1;
			dest.bitmapData.unlock();
		}
		
		private var a:Number = 0;
		private function sinMove():void
		{
			var x:int, y:int;
			for(var r:int = 0; r < bg.height; r++)
			{
				y = r + 50;
				for(var c:int = 0; c < bg.width; c++)
				{
					x = 50 + c + 50*Math.sin(0.01*r + a); 
					dest.bitmapData.setPixel32(x, y, bg.bitmapData.getPixel32(c,r));
				}
			}
		}
		
		private function incline():void
		{
			var dx:int, dy:int;
			for(var j:int = 0; j < bg.height; j++)
			{
				dy = j;			
				for(var i:int = 0; i < bg.width; i++)
				{
					dx = i + dy;
					if(dx < bg.width){
						dest.bitmapData.setPixel32(dx, dy, bg.bitmapData.getPixel32(i,j));
					}
				}
			}
		}
	}
}