package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class Smoke extends Sprite
	{
		private var preMouseX:Number = 0;
		private var preMouseY:Number = 0;
		
		private var list:Array = [];
		public function Smoke()
		{
			super();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(!(mouseX == preMouseX && mouseY == preMouseY))
			{
				preMouseX = mouseX;
				preMouseY = mouseY;
				
				var s:MoveAbleCircle = new MoveAbleCircle();
				s.x = mouseX;
				s.y = mouseY;
				addChild(s);
				list.push(s);
			}
			
			update();
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
	public function MoveAbleCircle()
	{
		this.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, 0xFFFFFF], [1, 0], [0, 127]);
		this.graphics.drawCircle(0, 0, 60);
		this.graphics.endFill();
		this.width = 0;
		this.height = 0;
	}
	
	public function update():void
	{
		this.width += 2;
		this.height += 2;
		this.alpha *= 0.96;
		
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

