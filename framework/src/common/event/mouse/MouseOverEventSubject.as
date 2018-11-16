package common.event.mouse
{
	import common.event.EventData;
	import common.event.EventSubject;
	
	import display.IDrawable;

	public class MouseOverEventSubject extends EventSubject
	{
		private var capture_bubbleList:Array = [];
		public function MouseOverEventSubject()
		{
			super();
		}
		
		override public function dispatchEvent(event:EventData):void
		{
			var draw:IDrawable;
			var mouseEvent:MouseEventData = event as MouseEventData;
			for(var o:Object in mDic)
			{
				if(o is IDrawable)//假如它是IDrawable 包括了 Screen, Layer, 和  DrawObject
				{
					draw = o as IDrawable;
					//TODO:捕获的阶段,需要有个Screen管理来, 这样才能实现从上到下运行
					
					
					//冒泡的阶段
					if(draw.hitTestPoint(mouseEvent.mouseX, mouseEvent.mouseY, mouseEvent.isUserShape))
					{
						if(mDic[draw] != null)
						{
							draw.isPrevHasMouse = draw.isHasMouse;
							draw.isHasMouse = true;

							capture_bubbleList.push(draw);
							var parent:IDrawable = draw.parent;
							while(parent != null)
							{
								if(mDic[parent] != null)
								{
									parent.isPrevHasMouse = parent.isHasMouse;
									parent.isHasMouse = true;
									capture_bubbleList.push(parent);
								}
								parent = parent.parent;
							}
						}
					}
					//事件是否停止传输(这个暂时还没有遇到这种需求, 以后再实现)
					
				}else
				{
					mDic[o].call(o, event);
				}
			}
			
			if(mouseEvent.isStop)
			{
				draw = capture_bubbleList.shift();
				if(draw != null)
				{
					mDic[draw].call(draw, event);
				}
			}else{
				//目标阶段
				while(capture_bubbleList.length > 0)
				{
					draw = capture_bubbleList.shift();
					if(!draw.isPrevHasMouse && draw.isHasMouse)
					{
						mDic[draw].call(draw, event);
					}
				}
			}
		}
	}
}