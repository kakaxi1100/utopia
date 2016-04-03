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
	
	import voforparticle.GSGFix;
	import voforparticle.IGenerationStrategy;
	import voforparticle.IInitStrategy;
	import voforparticle.ISGMoveUp;
	import voforparticle.ParticleEmitter;
	import voforparticle.ParticleSimpleManager;
	import voforparticle.PayloadManager;
	
	[SWF(frameRate="60",width="800",height="600",backgroundColor="0")]
	public class FlyTest4 extends Sprite
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
		
		private var isgMoveUp:IInitStrategy = ISGMoveUp.getInstance();
		private var gsgFix:IGenerationStrategy = GSGFix.getInstance();
		private var emitter:ParticleEmitter = new ParticleEmitter(isgMoveUp);
		
		public function FlyTest4()
		{
			super();
			
			addChild(bmp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
			
			emitter.posX = 400;
			emitter.posY = 550;
			
			var yellow:ColorTransform = new ColorTransform(1,1,0,1,255,255,0,0);
			dotBmp.bitmapData.colorTransform(dotBmp.bitmapData.rect, yellow);
//			addChild(dotBmp);
			dotBmp.x = 100;
			dotBmp.y = 100;
			
			emitter.emit();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			emitter.posX = stage.mouseX;
			emitter.posY = stage.mouseY;
			
			var d:Number = (getTimer() - a)/1000;

			PayloadManager.getInstance().updateSimple();
			//here to render
//			bmd.applyFilter(bmd, bmd.rect, origin, blur);
			bmd.colorTransform(bmd.rect, darken);
			ParticleSimpleManager.getInstance().render(bmd,dotBmp.bitmapData);
			//update the data
			ParticleSimpleManager.getInstance().update();
			
			a = getTimer();
		}
	}
}