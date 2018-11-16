package common.event.mouse
{
	import display.IDrawable;
	import common.event.EventData;
	import common.event.EventSubject;

	public class MouseOutEventSubject extends EventSubject
	{
		public function MouseOutEventSubject()
		{
			super();
		}
		
		override public function dispatchEvent(event:EventData):void
		{
			var mouseEvent:MouseEventData = event as MouseEventData;
			for(var o:Object in mDic)
			{
				if(o is IDrawable)
				{
					var draw:IDrawable = o as IDrawable;

					if(draw.hitTestPoint(mouseEvent.mouseX, mouseEvent.mouseY, mouseEvent.isUserShape))
					{
						
					}else
					{
						draw.isPrevHasMouse = draw.isHasMouse;
						draw.isHasMouse = false;
						if(draw.isPrevHasMouse && !draw.isHasMouse)
						{
							mDic[draw].call(draw, event);
						}
					}
				}else
				{
					mDic[o].call(o, event);
				}
			}
		}
	}
}