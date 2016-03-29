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
	
	import vo.EVector;
	import vo.Particle;
	import vo.Payload;
	
	[SWF(frameRate="60",width="800",height="600",backgroundColor="0xcccccc")]
	public class FlyTest extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800,600, false, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var a:Number;
		private var blur:BlurFilter = new BlurFilter(4,4,1);
		private var darken:ColorTransform = new ColorTransform(1,1,1,0.86);
		private var origin:Point = new Point();
		private var pl:Payload = new Payload(new Particle()); 
		private var force:EVector = new EVector(0,20);
		private var sparkAlpha:uint = 0;
		private var sparkColor:uint = 0;
		public function FlyTest()
		{
			addChild(bmp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
			
			//添加第一个粒子
			var vx:Number = -100;
			var vy:Number = -100;
			var life:Number = 5;
			//初始化承载器
			pl.head.init();
			pl.head.color = 0x6AC62E;
			pl.head.position.setTo(800,300);
			pl.head.velocity.setTo(vx, vy);
			pl.head.lifespan = life;
			pl.head.damping = 0.99;
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var d:Number = (getTimer() - a)/1000;
			
			bmd.lock();
//			bmd.fillRect(bmd.rect, 0);
			
			if(pl.head.lifeTime(d) == true)
			{
				for(var i:int = 0; i < 2; i++)
				{
					var rd:Number = Math.random();
					var p:Particle = pl.addParticle(pl.head.position.x - rd*pl.head.velocity.x, 
													pl.head.position.y - rd*pl.head.velocity.y, 0,0,0,pl.head.color);
					p.velocity.setTo(0.2*Math.random()*2 - 1, 0.2*Math.random()*2 - 1);
					p.lifespan = Math.random()*2 + 1;
					p.color =  pl.head.color;
				}
			}
//			bmd.colorTransform(bmd.rect, darken);
			bmd.applyFilter(bmd, bmd.rect, origin, blur);
			for(i = 0; i < pl.length(); i++)
			{
				var s:Particle = pl.plist[i];
				if(s.lifeTime(d) == true)
				{
					s.update(d);
					sparkAlpha = 255*s.curLife/s.lifespan;
					sparkColor = (sparkAlpha<<24) | s.color;
					bmd.setPixel32(s.position.x, s.position.y, s.color);
				}
//				trace(sparkColor);
			}
			bmd.unlock();
			
			pl.head.addForce(force);
			pl.head.update(d);
			
			a = getTimer();
		}
	}
}