package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import vo.Base;
	import vo.td.Objective;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0xcccccc")]
	public class WireframeNew extends Sprite
	{
		private var uloader:URLLoader;
		private var back:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
		private var triangle:Objective;
		public function WireframeNew()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.BOTTOM_RIGHT;
			
			//将0点坐标变为左下角
			back.scaleY = -1;
			back.y += back.height;
			addChild(back);
			
			var request:URLRequest = new URLRequest("configs/triangle.plg");
			uloader = new URLLoader();
			uloader.addEventListener(Event.COMPLETE, onLoaderComplete);
			uloader.load(request);
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var s:String = uloader.data as String;
			triangle = Base.parseObjective(s);
			
			triangle.drawBitmap(back.bitmapData);
		}
	}
}