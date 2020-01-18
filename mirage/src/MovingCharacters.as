package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class MovingCharacters extends Sprite
	{
		private var preMouseX:Number = 0;
		private var preMouseY:Number = 0;
		private var rotate:Number = 0;
		
		private var list:Array = [];
		
		public function MovingCharacters()
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
//				rotate += 1;
				rotate = list.length;
				
				var s:MoveAbleCircle = new MoveAbleCircle();
				s.rotation = rotate;
				s.x = mouseX;
				s.y = mouseY;
				addChild(s);
				list.push(s);
				
			}
			
			update();
			trace(list.length);
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
	public function MoveAbleCircle()
	{
		this.graphics.lineStyle(0, 0xFFFFFF);
		this.graphics.moveTo(0, -200);
		this.graphics.lineTo(0, 200);
		
		this.scaleX = 0.1;
		this.scaleY = 0.1;
	}
	
	public function update():void
	{
		this.scaleX += 0.05;
		this.scaleY += 0.05;
		this.rotation += 3;
		this.alpha *= 0.99;
		
		checkDestroy();
	}
	
	public function checkDestroy():void
	{
		if(this.parent)
		{
			if(this.alpha < 0.1){
				this.parent.removeChild(this);
			}
		}
	}
}

