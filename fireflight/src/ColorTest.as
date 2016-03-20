package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class ColorTest extends Sprite
	{
		[Embed(source="./assets/dot.png")]
		private var Dot:Class;
		private var bm:Bitmap=  new Dot();
		private var test:Bitmap = new Dot();
		private var a:Number;
		private var ct1:ColorTransform = new ColorTransform();
		public function ColorTest()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
			
			test.x = 400;
			test.y = 150;
			
//			test.bitmapData.fillRect(test.bitmapData.rect, 0x22ffff00);
			
			ct1.redMultiplier = 0;
			ct1.greenMultiplier = 0;
			ct1.blueMultiplier = 0;
			ct1.redOffset = 255;
			ct1.greenOffset = 0;
			ct1.blueOffset = 0;
//			ct1.alphaOffset = 0;
//			test.bitmapData.draw(test.bitmapData, null, ct1);
			test.bitmapData.colorTransform(test.bitmapData.rect,ct1);
			
//			bm.x = 400;
//			bm.y = 200;
			addChild(test);
//			addChild(bm);
//			Mouse.hide();
//			var ct:ColorTransform = new ColorTransform();
//			ct.redOffset = 0;
//			ct.greenOffset = -255;
//			ct.blueOffset = -255;
//			ct.alphaOffset = 0;
//			bm.bitmapData.draw(bm.bitmapData, null, ct,);
			
			
		}
		private var count:uint = 0;
		protected function onEnterFrame(event:Event):void
		{
			var d:Number = (getTimer() - a)/1000;
			
//			test.x = stage.mouseX;
//			test.y = stage.mouseY;
//			ct1.redOffset -= 0.01;
			ct1.redOffset -= 1;
			ct1.greenOffset += 1;
//			trace(ct1);
			test.bitmapData.colorTransform(test.bitmapData.rect, ct1);
//			
			a = getTimer();
		}	
	}
}