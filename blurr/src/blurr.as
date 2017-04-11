package
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import utils.BAction;
	import utils.BActionParallel;
	import utils.BActionQueue;
	import utils.BEasing;
	import utils.BTweenBase;
	import utils.BTweenBase_Achive;
	import utils.BTweenManger;
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
			bg.y = 0;
			addChild(bg);
			
//			addChild(bg1);
			dt = getTimer();
			
//----------------test-------------------------------------------------------------------------------------------------------
//-----------------------串行-------------------------------------------------------------------------------------------------
			var action:BActionQueue = new BActionQueue(-1);
			action.addTween(new BTweenBase(500, bg, {scaleX:0.5, scaleY:0.5}, BEasing.easeInCirc))
				  .addTween(new BTweenBase(500, bg, {scaleX:2, scaleY:2}, BEasing.easeOutBack))
				  .addTween(new BTweenBase(500, bg, {scaleX:1, scaleY:1}, BEasing.easeInOutBack))
//				  .addTween(new BTweenBase(3000, bg1, {x:400, y:300}, BEasing.easeInOutBack));
				  
			BTweenManger.getInstance().add(action);
//--------------------------------------------------------------------------------------------------------------------------
//-----------------------并行------------------------------------------------------------------------------------------------
//			var action1:BActionParallel = new BActionParallel(1);
//			action1.addTween(new BTweenBase(3000, bg, {y:500}, BEasing.easeInOutBack))
//				  .addTween(new BTweenBase(3000, bg, {y:0}, BEasing.easeInOutBack))
//				  .addTween(new BTweenBase(3000, bg1, {x:0, y:300}, BEasing.easeInOutBack));
//			
//			BTweenManger.getInstance().add(action1);
//--------------------------------------------------------------------------------------------------------------------------
//			BTweenManger.getInstance().add(action1).add(action);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);			
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			BTweenManger.getInstance().update(dt);
			dt = getTimer();
		}
	}
}