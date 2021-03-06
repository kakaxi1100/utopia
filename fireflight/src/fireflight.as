/**
 *8/4/2017
 * 
 * 物理引擎 第二阶段结束, 又要告别一个段落咯！
 * TODO：
 * 1. 粒子的组合 比如: ①---②
 * 	      这个例子中 中间的矩形 其实也是 一个 粒子 它也参与碰撞检测
 *    这个矩形可以是由 ①, ② 两个粒子生成的粒子
 * 	      这个矩形碰撞之后, 会得到一个速度, 这个速度会根据碰撞的位置按比例分配到  ①, ② 两个粒子上
 *    然后①---②会形成一个角度
 * 2. 或者直接用刚体的矩形呢 ? 应该也可以. 
 * 
 * 
 *  
 */
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.ares.archive.fireflight_v1.FFEmitter;
	import org.ares.archive.fireflight_v1.FFParticle;
	import org.ares.archive.fireflight_v1.manager.FFParticleManager;
	import org.ares.archive.fireflight_v1.manager.FFPayloadManager;
	import org.ares.archive.fireflight_v1.port.IRule;
	import org.ares.archive.fireflight_v1.test.RuleUp;
	
	[SWF(frameRate="30", backgroundColor="0",width="800",height="600")]
	public class fireflight extends Sprite
	{
		[Embed(source="./assets/dot.png")]
		private var Dot:Class;
		private var dotBmp:Bitmap = new Dot();
		
		private var bmd:BitmapData = new BitmapData(800,600,true,0);
		private var bmp:Bitmap=  new Bitmap(bmd);
		private var e:FFEmitter = new FFEmitter();
		private var r:IRule = RuleUp.getInstance();
		
		private var a:Number;
		private var blur:BlurFilter = new BlurFilter(4,4,1);
		private var darken:ColorTransform = new ColorTransform(1,1,1,0.86);
		private var origin:Point = new Point();
		
		public function fireflight()
		{
			addChild(bmp);
			
			e.rule = r;
//			e.emit(1, 400,580);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
		}
		private var count:uint = 100;
		protected function onEnterFrame(event:Event):void
		{
			var d:Number = (getTimer() - a)/1000;
			if(count > 100 )
			{
				count = 0;
				e.emit(1, 400,580);
			}
			count++;
			FFPayloadManager.getInstance().update(d);//这里已经产生了粒子
			
			bmd.applyFilter(bmd, bmd.rect, origin, blur);
//			bmd.colorTransform(bmd.rect, darken);
			//由于render在前面，还没有计算 粒子的 生命值，所以即使粒子的生命值是0,也会有图形渲染上去
			//可以得到意想不到的效果
			FFParticleManager.getInstance().render(bmd,dotBmp.bitmapData);
			//计算粒子运动
			FFParticleManager.getInstance().update(d);
			
			a = getTimer();
		}
		//------------------------------------------------------------------------------
//		[Embed(source="./assets/dot.png")]
//		private var Dot:Class;
//		private var bm:Bitmap=  new Dot();
//		private var sp:Sprite = new Sprite();
//		private var p:FFParticle = new FFParticle();
//		private var a:Number;
//		private var plist:Vector.<FFParticle> = new Vector.<FFParticle>;
//		private var clist:Vector.<ColorTransform> = new Vector.<ColorTransform>;
//		private var slist:Vector.<Sprite> = new Vector.<Sprite>;
//		private var blist:Vector.<Bitmap> = new Vector.<Bitmap>;
//		
//		public function fireflight()
//		{
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			
//			this.graphics.lineStyle(2, 0xff0000);
//			this.graphics.moveTo(400,0);
//			this.graphics.lineTo(400,600);
//			for(var i:int = 0; i < 500; i++)
//			{
//				var p:FFParticle = new FFParticle();
//				p.init();
//				plist.push(p);
//				
//				var bm:Bitmap = new Dot();
//				var sp:Sprite = new Sprite();
//				bm.x = -16;
//				bm.y = -16;
//				var ct:ColorTransform = new ColorTransform();
//				ct.alphaMultiplier = 0;
//				ct.redMultiplier = 0;
//				ct.greenMultiplier = 0;
//				ct.blueMultiplier = 0;
////				ct.alphaOffset = p.curAlpha;
////				ct.redOffset = p.curRed;
////				ct.greenOffset = p.curGreen;
////				ct.blueOffset = p.curBlue;
//				bm.bitmapData.colorTransform(bm.bitmapData.rect, ct);
//				clist.push(ct);
//				blist.push(bm);
//				
//				sp.addChild(bm);
//				addChild(sp);
//				
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
////				slist[i].blendMode = BlendMode.SCREEN;
//				clist[i].alphaOffset = plist[i].curAlpha;
//				clist[i].redOffset = plist[i].curRed;
//				clist[i].greenOffset = plist[i].curGreen;
//				clist[i].blueOffset = plist[i].curBlue;
//				blist[i].bitmapData.colorTransform(blist[i].bitmapData.rect, clist[i]);
//				
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