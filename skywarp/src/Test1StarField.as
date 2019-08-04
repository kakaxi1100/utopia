package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class Test1StarField extends Sprite
	{
		private var mPositionX:Vector.<Number> = new Vector.<Number>();
		private var mPositionY:Vector.<Number> = new Vector.<Number>();
		private var mPositionZ:Vector.<Number> = new Vector.<Number>();
		
		private var mScreenX:Vector.<Number> = new Vector.<Number>();
		private var mScreenY:Vector.<Number> = new Vector.<Number>();
		
		private var centerX:Number = stage.stageWidth * 0.5;
		private var centerY:Number = stage.stageHeight * 0.5;
		
		private var starNums:uint = 2000;
		private var speed:Number = 0.3;
		private var spread:Number = 10;
		private var furthest:Number = 100;
		//视距 他是和视域相关的, 因为视频面我们固定到  -1 ~ 1  那么  tan(θ) = 1 / d 其中分子1 就是视频面的半宽 => d = tan(θ)
		//视距越近 观察范围越大  但是观察物越集中
		//视距越远 观察范围越小  但是观察物越分散
		private var d:Number = 2; 
		public function Test1StarField()
		{
			super();
			
			init();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		}
		
		private function init():void
		{
			for(var i:int = 0; i < starNums; i++)
			{
				initStar(i);
			}
		}
		
		//假如视平面是归一化的, 既  -1 < x/z < 1 and -1 < y/z < 1
		//一下的随机要保证在这个范围之内  tan45 = 1 所以角度小于 45度
		private function initStar(i:int):void
		{
			mPositionX[i] = (Math.random()-0.5)* 2 * spread;
			mPositionY[i] = (Math.random()-0.5)* 2 * spread;
			mPositionZ[i] = Math.random() * (furthest-spread) + spread;// spread ~ furthest 
		}
		
		private function movingStar():void
		{
			for(var i:int = 0; i < starNums; i++)
			{
				mPositionZ[i] -= speed;
				if(mPositionZ[i] <= 0){
					initStar(i);
				}
				
				//透视坐标之后 将归一化的视平面 转换到屏幕坐标 以宽度为例   视平面(-1) = 0,  视平面(1) = 屏幕宽度  
				mScreenX[i] = (mPositionX[i] * d / mPositionZ[i]) * centerX + centerX;
				mScreenY[i] = (mPositionY[i] * d / mPositionZ[i]) * centerY + centerY;
				
				if(mScreenX[i] < 0 || mScreenX[i] > stage.stageWidth || 
					mScreenY[i] < 0 || mScreenY[i] > stage.stageHeight)
				{
					initStar(i);
				}
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			movingStar();
			draw();
		}	
		
		private function draw():void
		{
			this.graphics.clear();
			for(var i:int = 0; i < starNums; i++)
			{
				this.graphics.beginFill(0xFFFFFF);
				this.graphics.drawCircle(mScreenX[i], mScreenY[i], 20/mPositionZ[i]);
				this.graphics.endFill();
			}
		}
		
	}
}