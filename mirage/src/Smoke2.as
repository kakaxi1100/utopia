package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class Smoke2 extends Sprite
	{
		private var preMouseX:Number = 0;
		private var preMouseY:Number = 0;
		
		private var list:Array = [];
		public function Smoke2()
		{
			super();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
//			if(!(mouseX == preMouseX && mouseY == preMouseY))
//			{
//				preMouseX = mouseX;
//				preMouseY = mouseY;
				
				var s:MoveAbleCircle = new MoveAbleCircle();
				s.x = mouseX;
				s.y = mouseY;
				s.baseX = mouseX;
				addChild(s);
				list.push(s);
//			}
			
			update();
//			trace(list.length);
		}
		
		public function update():void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var c:MoveAbleCircle = list[i];
				if(!this.contains(c))
				{
					list.splice(i, 1);
					i--;
				}else
				{
					c.update();
				}
				
			}
		}
	}
}
import flash.display.GradientType;
import flash.display.Sprite;

class MoveAbleCircle extends Sprite
{
	private var mColor:uint;
	private var wavelength:Number = 0;
	private var ampl:Number = 0;
	private var amplSpeed:Number = 0;
	private var speed:Number = 0;
	public var baseX:Number = 0;
	public function MoveAbleCircle()
	{
		this.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, 0xFFFFFF], [1, 0], [0, 127]);
		this.graphics.drawCircle(0, 0, 60);
		this.graphics.endFill();
		this.width = 10;
		this.height = 10;
		
		this.wavelength = 50 + 50*Math.random();
		this.ampl = 0;
		this.amplSpeed = 2 * Math.random();
		this.speed = 2+2*Math.random();
	}
	
	public function update():void
	{
		this.width += 2;
		this.height += 2;
		this.alpha *= 0.96;
		
		this.x = this.baseX + (this.ampl * Math.sin((this.y/this.wavelength)));
		this.y -= this.speed;
		this.ampl += this.amplSpeed;
		
		checkDestroy();
	}
	
	public function checkDestroy():void
	{
		if(this.parent)
		{
			if(this.alpha < 0.01){
				this.parent.removeChild(this);
			}
		}
	}
}

