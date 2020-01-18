package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class MovingCircle extends Sprite
	{
		private var preMouseX:Number = 0;
		private var preMouseY:Number = 0;
		
		private var list:Array = [];
		public function MovingCircle()
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
import flash.display.Sprite;

class MoveAbleCircle extends Sprite
{
	private var mColor:uint;
	private var mRadius:Number;
	public function MoveAbleCircle()
	{
		this.mColor = (Math.random() * 0.5 + 0.5) * 0xFFFFFF;
		this.mRadius = 0;
	}
	
	public function update():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(0, this.mColor, 1 - this.mRadius / 60);
		this.graphics.drawCircle(0, 0, this.mRadius);
		this.mRadius += 0.5;
		
		checkDestroy();
	}
	
	public function checkDestroy():void
	{
		if(this.parent)
		{
			if(this.mRadius >= 60){
				this.parent.removeChild(this);
			}
		}
	}
}

