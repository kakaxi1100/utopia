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
		private var mBubbleList:Array = [];
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
			var draw:IDrawable;
			
			while(drawNode != null && drawNode.data != null)
			{
//				drawNode = draw.drawList.tail;//从尾部开始
				draw = drawNode.data as IDrawable;
				if(draw.hitTestPoint(mouseEvent.mouseX, mouseEvent.mouseY, mouseEvent.isUserShape)) //找到之后继续往下找
				{
					draw.isPrevHasMouse = draw.isHasMouse;
					draw.isHasMouse = true;
					if(mDic[draw] != null)
					{
						mCaptureList.push(draw);//找到之后看它是否在侦听列表中, 如果在就把它加到捕获列表中
					}
					if(draw.drawList != null)//这个draw还是layer就继续往下找
					{
						drawNode = draw.drawList.tail;//就在这个layer中找
					}else//这个draw已经是DrawObject了
					{
						drawNode = null;
					}
					
				}else //假如没有找到就找前下一个, 注意是在显示层上从前往后找, 防止遮挡
				{
					drawNode = drawNode.prev;
				}
			}
			
		}
		
		private function bubble():void
		{
			
		}
	}
}