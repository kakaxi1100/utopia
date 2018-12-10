package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0")]
	public class Mode7Test extends Sprite
	{
		[Embed(source="assets/race.jpg")]
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
		
		private var screenWidth:Number = 800;
		private var screenHeight:Number = 600;
 		public function Mode7Test()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			addChild(raceMap);
			caculatePoint();
			draw();
			sampling();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
			
			for(var y:int = 0; y < screenHeight; y++)
			{
				startY = (y / screenHeight)*(farY1 - cY) + cY;
				endY = (y / screenHeight)*(farY2 - cY) + cY;
				
				startX = (farX1 - cX)/(farY1 - cY)*(startY - cY) + cX;
				endX = (farX2 - cX)/(farY2 - cY)*(endY - cY) + cX;
				this.graphics.lineStyle(2, 0xffff00);
				this.graphics.moveTo(startX, startY);
				this.graphics.lineTo(endX, endY);
				
				for(var x:int = 0; x < screenWidth; x++)
				{
					
					
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