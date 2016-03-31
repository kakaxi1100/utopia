package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import vo.IGenerationStrategy;
	import vo.IInitStrategy;
	import vo.ParticleEmitter;
	import vo.ParticleManager;
	import vo.ParticleSimpleManager;
	import vo.PayloadManager;
	import vo.ScatterGSG;
	import vo.UpwardISG;
	
	[SWF(frameRate="30",width="800",height="600",backgroundColor="0")]
	public class FlyTest2 extends Sprite
	{
		private var a:Number;
		private var blur:BlurFilter = new BlurFilter(4,4,1);
		private var darken:ColorTransform = new ColorTransform(1,1,1,1,80,80,80,-10);
		private var origin:Point = new Point();
		
		private var bmd:BitmapData = new BitmapData(800,600,true,0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var uisg:IInitStrategy = new UpwardISG;
		private var gisg:IGenerationStrategy = new ScatterGSG;
		private var emitter:ParticleEmitter = new ParticleEmitter(5, uisg, gisg);
		public function FlyTest2()
		{
			super();
			
			addChild(bmp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
			
			emitter.posX = 400;
			emitter.posY = 550;
			emitter.addStrategy(uisg, gisg);
			emitter.addStrategy(uisg, gisg);
		}
		
		private var count:int = 1000;
		protected function onEnterFrame(event:Event):void
		{
//			var fps:uint =1000/(getTimer() - a); 
//			if(fps > stage.frameRate) fps = stage.frameRate;
//			trace(fps);
			var d:Number = (getTimer() - a)/1000;
			
			if(count > 100)
			{
				emitter.emit();
				count = 0;
			}
			count++;
			
//			PayloadManager.getInstance().update(d);
			PayloadManager.getInstance().updateSimple();
			//here to render
			bmd.applyFilter(bmd, bmd.rect, origin, blur);
			bmd.colorTransform(bmd.rect, darken);
//			ParticleManager.getInstance().render(bmd);
			ParticleSimpleManager.getInstance().render(bmd);
			//update the data
//			ParticleManager.getInstance().update(d);
			ParticleSimpleManager.getInstance().update();
			
			a = getTimer();
		}
	}
}











