package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0")]
	public class Mode7Test extends Sprite
	{
		[Embed(source="assets/C1W.png")]
		private var Map:Class;
		private var raceMap:Bitmap = new Map();
		
		private var fov:Number = Math.PI / 2;
		private var far:Number = 100;
		private var cX:Number = 300;
		private var cY:Number = 300;
		private var cA:Number = 0;
		
		private var farX1:Number = 0;
		private var farY1:Number = 0;
		private var farX2:Number = 0;
		private var farY2:Number = 0;
		
		private var screenWidth:Number = 320;
		private var screenHeight:Number = 240;
		
		private var floor:Bitmap = new Bitmap(new BitmapData(screenWidth, screenHeight));
 		public function Mode7Test()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			addChild(raceMap);
			addChild(floor);
			
			caculatePoint();
			draw();
			sampling();
			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			cA += 0.01;

			caculatePoint();
			draw();
			sampling();
		}
		
		private function sampling():void
		{
			var sampleY:Number;
			var sampleX:Number;
			var startY:Number;
			var startX:Number;
			var endY:Number;
			var endX:Number;
			
			floor.bitmapData.fillRect(floor.bitmapData.rect, 0);
			for(var y:int = 0; y < screenHeight; y++)
			{
				var stepY:Number =  y / screenHeight;
				startY = stepY * (farY1 - cY) + cY;
				endY = stepY * (farY2 - cY) + cY;
				
				startX = stepY * (farX1 - cX) + cX;
				endX = stepY * (farX2 - cX) + cX;
				
				this.graphics.lineStyle(2, 0xffff00);
				this.graphics.moveTo(startX, startY);
				this.graphics.lineTo(endX, endY);
				
				for(var x:int = 0; x < screenWidth; x++)
				{
					var stepX:Number = x / screenWidth;
					sampleX = stepX * (endX - startX) + startX;
					sampleY = stepX * (endY - startY) + startY;
					floor.bitmapData.lock();
					floor.bitmapData.copyPixels(raceMap.bitmapData, new Rectangle(sampleX,sampleY,1,1), new Point(x, y));
					floor.bitmapData.unlock();
				}
			}
		}
		
		private function caculatePoint():void
		{
			var angle:Number = fov * 0.5;
			farX1 = cX + Math.cos(angle + cA) * far;
			farY1 = cY + Math.sin(angle + cA) * far;
			farX2 = cX + Math.cos(-angle + cA) * far;
			farY2 = cY + Math.sin(-angle + cA) * far;
		}
		
		private function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(2, 0xffffff);
			this.graphics.moveTo(cX, cY);
			this.graphics.lineTo(farX1, farY1);
			this.graphics.lineStyle(2, 0xff0000);
			this.graphics.lineTo(farX2, farY2);
			this.graphics.lineStyle(2, 0xff00);
			this.graphics.lineTo(cX, cY);
		}
	}
}