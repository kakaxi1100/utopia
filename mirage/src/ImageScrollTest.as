package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="120", backgroundColor="0xcccccc")]
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
//			sinMove();
//			zWave();
//			drawSin1();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dest.bitmapData.lock();
			dest.bitmapData.fillRect(dest.bitmapData.rect,0);
//			sinMove();
			a += 0.5;
//			drawSin();
			zWave();
			dest.bitmapData.unlock();
		}
		
		private function drawSin1():void
		{
			var x:Number = 0, y:Number = 0;
			for(var r:int = 0; r < bg.height; r++)
			{
				for(var c:int = 0; c < bg.width; c++)
				{
					y = x + 5 * Math.sin(0.01 * x);
					x += 1;
					dest.bitmapData.setPixel32(x, y, 0xFFFFFF);
				}
			}
		}
		
		private function drawSin():void
		{
			var x:Number = 0, y:Number = 0;
			for(var r:int = 0; r < bg.height; r++)
			{
				x += Math.PI* 4 /bg.height ;
				y = Math.sin(x + a);
				for(var c:int = 0; c < bg.width; c++)
				{
//					trace(y);
//					dest.bitmapData.setPixel32(x, y, 0xFFFFFF);
					dest.bitmapData.setPixel32(c, r, bg.bitmapData.getPixel32(c,r/y));
				}
			}
		}
		
		private var b:Number = 0;
		private function zWave():void
		{
			var x:int = 0, y:Number = 0;
			for(var r:int = 0; r < bg.height; r++)
			{
				y = r +  5 * Math.sin(b + a);
				b += Math.PI  * 4/ bg.height;
				if(y < 0 || y > bg.height){
					y = r;
				}
				for(var c:int = 0; c < bg.width; c++)
				{
					dest.bitmapData.setPixel32(c, r, bg.bitmapData.getPixel32(c,y));
				}
			}
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