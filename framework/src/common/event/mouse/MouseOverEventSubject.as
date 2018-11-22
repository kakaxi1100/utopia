package common.event.mouse
{
	import common.event.EventData;
	import common.event.EventSubject;
	
	import datastructure.link.sortlink.DoubleSortLinkNode;
	
	import display.IDrawable;
	import display.ScreenContainer;
	
	public class MouseOverEventSubject extends EventSubject
	{
		private var mCaptureList:Array = [];
		public function MouseOverEventSubject()
		{
			super();
		}
		
		override public function dispatchEvent(event:EventData):void
		{
			var draw:IDrawable;
			var mouseEvent:MouseEventData = event as MouseEventData;
			capture(mouseEvent);
			
			//目标阶段
			while(mCaptureList.length > 0)
			{
				draw = mCaptureList.pop();
				if(!draw.isPrevHasMouse && draw.isHasMouse)
				{
					mDic[draw].call(draw, event);
				}
			}
		}
		
		//从上往下找
		private function capture(mouseEvent:MouseEventData):void
		{
			var drawNode:DoubleSortLinkNode = ScreenContainer.getInstance().screenList.tail;
			var draw:IDrawable = captureTarget(drawNode, mouseEvent);
			
			while(draw != null)
			{
				if(mDic[draw] != null)
				{
					draw.isPrevHasMouse = draw.isHasMouse;
					draw.isHasMouse = true;
					mCaptureList.push(draw);
				}
				draw = draw.parent;
			}
		}
		
		private function captureTarget(node:DoubleSortLinkNode, mouseEvent:MouseEventData):IDrawable
		{	
			while(node.data != null)
			{					
				var draw:IDrawable = node.data as IDrawable;
				if(draw.drawList != null)
				{
					node = draw.drawList.tail;
				    var temp:IDrawable = captureTarget(node, mouseEvent);//进入下一层
					if(temp)
					{
						return temp
					}
				}else{
					if(draw.hitTestPoint(mouseEvent.mouseX, mouseEvent.mouseY, mouseEvent.isUserShape))
					{
						return draw;//如果找到了就返回找到的找个对象
					}
				}
				node = node.prev;//再本层查找					
			}
			
			return null;
		}
	}
}