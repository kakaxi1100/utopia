package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#008080")]
	public class Spirograph extends Sprite
	{
		private var sp:Sprite = new Sprite();
		private var radius:Number = 50;
		
		private var clist:Array = [];
		private var count:int = 0;
		private var cx:Number = 400;
		private var cy:Number = 300;
		private var angle:Number = 0;
		public function Spirograph()
		{
			super();
		
			addChild(sp);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < clist.length; i++)
			{
				var s:Sprite = clist[i];
				if(this.contains(s))
				{
					s.alpha *= 0.9999;
					if(s.alpha < 0.001)
					{
						this.removeChild(s);
					}
				}else{
					clist.splice(i, 1);
					i--;
				}
			}
			
			count++;
			if(count > 1)
			{
				s = new Sprite();
				addChild(s);
				s.graphics.clear();
				s.graphics.lineStyle(0);
				s.graphics.moveTo(300, 300);
				s.graphics.curveTo(cx, cy, 500, 300);
				cx = 400 + 300 * Math.cos(angle);
				cy = 300 + 300 * Math.sin(angle);
				angle += 0.02;
				clist.push(s);
				count = 0;
			}

		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0);
			this.graphics.moveTo(300, 300);
			this.graphics.curveTo(mouseX, mouseY, 500, 300);
			trace(mouseX, mouseY);
		}
	}
}