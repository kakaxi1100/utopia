package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vo.PayLoad;
	
	[SWF(frameRate="60",width="800",height="600",backgroundColor="0xcccccc")]
	public class FlyTest extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800,600, true, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		
		private var pl:PayLoad = new PayLoad(); 
		public function FlyTest()
		{
			addChild(bmp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//初始化承载器
			pl.color = 0x6AC62E;
			pl.posx = 400;
			pl.posy = 300;
			//添加第一个粒子
			var vx:Number = Math.random()*3;
			var vy:Number = 2+Math.random()*6;
			var life:Number = 1+2*Math.random();
			pl.addParticle(vx, vy, life);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			
		}
	}
}