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
		private var cX:Number = 0;
		private var cY:Number = 0;
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
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			cA += 0.01;

			caculatePoint();
			draw();
		}
		
		private function caculatePoint():void
		{
			var angle:Number = fov * 0.5;
			farX1 = Math.cos(angle + cA) * far;
			farY1 = Math.sin(angle + cA) * far;
			farX2 = Math.cos(-angle + cA) * far;
			farY2 = Math.sin(-angle + cA) * far;;
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