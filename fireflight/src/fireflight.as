package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.FFParticle;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class fireflight extends Sprite
	{
		[Embed(source="./assets/dot.png")]
		private var Dot:Class;
		private var bm:Bitmap=  new Dot();
		private var sp:Sprite = new Sprite();
		private var p:FFParticle = new FFParticle();
		private var a:Number;
		private var plist:Vector.<FFParticle> = new Vector.<FFParticle>;
		private var slist:Vector.<Sprite> = new Vector.<Sprite>;
		
		public function fireflight()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.graphics.lineStyle(2, 0xff0000);
			this.graphics.moveTo(400,0);
			this.graphics.lineTo(400,600);
			for(var i:int = 0; i < 500; i++)
			{
				var p:FFParticle = new FFParticle();
				p.init();
				plist.push(p);
				var bm:Bitmap = new Dot();
				var sp:Sprite = new Sprite();
				bm.x = -16;
				bm.y = -16;
				sp.addChild(bm);
				addChild(sp);
				sp.x = p.position.x;
				sp.y = p.position.y;
				sp.width = p.curSize;
				sp.height = p.curSize;
				slist.push(sp);
			}
			
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var d:Number = (getTimer() - a)/1000;
			for(var i:int = 0; i < plist.length; i++)
			{
				if(plist[i].lifeTime(d) == false)
				{
					plist[i].init();
				}
				slist[i].x = plist[i].position.x;
				slist[i].y = plist[i].position.y;
				slist[i].width = plist[i].curSize;
				slist[i].height = plist[i].curSize;
				plist[i].update(d);
			}
			a = getTimer();
		}	
//----------------------------------------------------------------		
//		[Embed(source="./assets/dot.png")]
//		private var Dot:Class;
//		private var bm:Bitmap=  new Dot();
//		private var sp:Sprite = new Sprite();
//		private var p:FFParticle = new FFParticle();
//		private var a:Number;
//		private var plist:Vector.<FFParticle> = new Vector.<FFParticle>;
//		private var slist:Vector.<Sprite> = new Vector.<Sprite>;
//		
//		public function fireflight()
//		{
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			
//			for(var i:int = 0; i < 500; i++)
//			{
//				var p:FFParticle = new FFParticle();
//				p.init();
//				plist.push(p);
//				var bm:Bitmap = new Dot();
//				var sp:Sprite = new Sprite();
//				bm.x = -16;
//				bm.y = -16;
//				sp.addChild(bm);
//				addChild(sp);
//				sp.x = p.position.x;
//				sp.y = p.position.y;
//				sp.width = p.curSize;
//				sp.height = p.curSize;
//				slist.push(sp);
//			}
//			
//			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			a = getTimer();
//		}
//		
//		protected function onEnterFrame(event:Event):void
//		{
//			var d:Number = (getTimer() - a)/1000;
//			for(var i:int = 0; i < plist.length; i++)
//			{
//				if(plist[i].lifeTime(d) == false)
//				{
//					plist[i].init();
//				}
//				slist[i].x = plist[i].position.x;
//				slist[i].y = plist[i].position.y;
//				slist[i].width = plist[i].curSize;
//				slist[i].height = plist[i].curSize;
//				plist[i].update(d);
//			}
//			a = getTimer();
//		}
//----------------------------------------------------------------		
//		[Embed(source="./assets/dot.png")]
//		private var Dot:Class;
//		private var bm:Bitmap=  new Dot();
//		private var sp:Sprite = new Sprite();
//		private var p:FFParticle = new FFParticle();
//		private var a:Number;
//		
//		public function fireflight()
//		{
//			addChild(sp);
//			bm.x = -bm.width/2;
//			bm.y = -bm.height/2;
//			sp.addChild(bm);
//			
//			p.init();
//			p.velocity.setTo(0, -100);
//			p.position.setTo(400, 550);
//			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			a = getTimer();
//		}
//		
//		protected function onEnterFrame(event:Event):void
//		{
//			var d:Number = (getTimer() - a)/1000;
//			p.update(d);
//			sp.width = p.curSize;
//			sp.height = p.curSize;
//			sp.x = p.position.x;
//			sp.y = p.position.y;
//			a = getTimer();
//		}
	}
}