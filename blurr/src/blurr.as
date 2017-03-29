package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import utils.BEasing;
	import utils.BTweenBase;
	import utils.BTweenManger;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class blurr extends Sprite
	{
		[Embed(source="assets/surge.png")]
		private var Background:Class;
		
		private var bg:Bitmap = new Background();
		private var bg1:Bitmap = new Background();
		private var dt:Number;
		public function blurr()
		{
			bg.x = 0;
			bg.y = 500;
			addChild(bg);
			addChild(bg1)
			
//			TweenMax.to(bg1, 3, {x:700, y:500, ease:Linear.easeNone});
			
			dt = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			BTweenManger.getInstance().addQueue(new BTweenBase(3000, bg, {x:700, y:0}, false, BEasing.easeInOutCirc))
									  .addQueue(new BTweenBase(3000, bg, {y:500}, false, BEasing.easeInOutBack))
									  .addQueue(new BTweenBase(3000, bg, {x:10}, false, BEasing.easeInOutElastic));
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			BTweenManger.getInstance().updateQueue(dt);
			dt = getTimer();
		}
	}
}