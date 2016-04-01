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
	
	import vo.GSGMoveUp;
	import vo.IGenerationStrategy;
	import vo.IInitStrategy;
	import vo.ISGFix;
	import vo.ParticleEmitter;
	import vo.ParticleManager;
	import vo.ParticleSimpleManager;
	import vo.PayloadManager;
	import vo.ScatterGSG;
	import vo.UpwardISG;
	
	[SWF(frameRate="30",width="800",height="600",backgroundColor="0")]
	public class FlyTest3 extends Sprite
	{
		
		[Embed(source="./assets/dot.png")]
		private var Dot:Class;
		private var dotBmp:Bitmap = new Dot();
		
		private var a:Number;
		private var blur:BlurFilter = new BlurFilter(4,4,1);
		private var darken:ColorTransform = new ColorTransform(1,1,1,0.86);
		private var origin:Point = new Point();
		
		private var bmd:BitmapData = new BitmapData(800,600,true,0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var uisg:IInitStrategy = new UpwardISG;
		private var gisg:IGenerationStrategy = new ScatterGSG;
		private var isgFix:IInitStrategy = new ISGFix();
		private var sgsMoveUp:IGenerationStrategy = new GSGMoveUp();		
		private var emitter:ParticleEmitter = new ParticleEmitter(1, isgFix, sgsMoveUp);
		
		public function FlyTest3()
		{
			super();
			
			addChild(bmp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
			
			emitter.posX = 400;
			emitter.posY = 550;
			
			var yellow:ColorTransform = new ColorTransform(1,1,0,1,255,255,0,0);
			dotBmp.bitmapData.colorTransform(dotBmp.bitmapData.rect, yellow);
			addChild(dotBmp);
			dotBmp.x = 100;
			dotBmp.y = 100;
//			emitter.emit();
		}
		
		private var count:int = 1000;
		protected function onEnterFrame(event:Event):void
		{
			emitter.posX = stage.mouseX;
			emitter.posY = stage.mouseY;
			
			var d:Number = (getTimer() - a)/1000;
			
//			if(count > 100)
//			{
				emitter.emit();
//				count = 0;
//			}
//			count++;
			
//			PayloadManager.getInstance().update(d);
			PayloadManager.getInstance().updateSimple();
			//here to render
			bmd.applyFilter(bmd, bmd.rect, origin, blur);
			bmd.colorTransform(bmd.rect, darken);
//			ParticleManager.getInstance().render(bmd);
			ParticleSimpleManager.getInstance().render(bmd,dotBmp.bitmapData);
			//update the data
//			ParticleManager.getInstance().update(d);
			ParticleSimpleManager.getInstance().update();
			
			a = getTimer();
		}
	}
}











