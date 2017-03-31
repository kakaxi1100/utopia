package
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import utils.BEasing;
	import utils.BTweenBase_Achive;
	import utils.BTweenManger_Achive;
	
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
			bg.y = 200;
			addChild(bg);
			
//----------------test-------------------------------------------------------------------------------------------------------
			addChild(bg1)
//			TweenMax.to(bg1, 3, {x:700, y:500, ease:Bounce.easeInOut});
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			BTweenManger.getInstance().addQueue(new BTweenBase(3000, bg, {x:700, y:500}, false, BEasing.easeInOutBounce));
//---------------------------------------------------------------------------------------------------------------------------
//			dt = getTimer();
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			BTweenManger_Achive.getInstance().addQueue(new BTweenBase_Achive(3000, bg, {x:700, y:0}, false, BEasing.easeInOutCirc))
//									  .addQueue(new BTweenBase_Achive(3000, bg, {y:500}, false, BEasing.easeInOutBack))
//									  .addQueue(new BTweenBase_Achive(3000, bg, {x:0}, false, BEasing.easeInOutElastic))
//									  .addQueue(new BTweenBase_Achive(3000, bg, {y:0}, false, BEasing.easeInOutBounce))
//									  .addParallel(new BTweenBase(3000, bg, {x:400, y:300}))
//									  .addParallel(new BTweenBase(3000, bg1, {x:400, y:300}));
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
//			BTweenManger.getInstance().updateQueue(dt);
			BTweenManger_Achive.getInstance().update(dt);
			dt = getTimer();
		}
	}
}