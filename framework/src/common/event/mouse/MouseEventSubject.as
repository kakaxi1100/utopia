package common.event.mouse
{
	import common.event.EventData;
	import common.event.EventSubject;
	
	import datastructure.link.sortlink.DoubleSortLinkNode;
	
	import display.IDrawable;
	import display.ScreenContainer;

	/**
	 * 这里涉及到了捕获和冒泡
	 * 
	 * 捕获是如何做到的呢?
	 * 捕获是从最顶层往下找, 一直找到目标节点后停止
	 * 比如：
	 * 鼠标时间肯定是从 Stage 开始的,然后再鼠标事件中有 注册侦听的一些 Screen Layer 和 DrawObject (注意这些节点是随机乱放的)
	 * 捕获的时候, 从 Stage 找到 Screen, Screen执行 HitTestPoint来判断它是否被点击到了, 如果点击到了, 再看看鼠标列表里面有没有 这个Screen 
	 * 如果有则再一个新的 数组中(不一定是数组)添加进去  [Screen]
	 * 然后 再在这个Screen中遍历里面的Layer, 然后看哪个 Layer 被点击到了,  如果这个 Layer 又正好在鼠标事件列表里面  则添加到 数组的末尾 [Screen, Layer]
	 * 然后 再再这个Layer 里面遍历 DrawObject 然后看哪个 DrawObject 被点击到了, 如果这个 DrawObject 又正好在鼠标事件列表里面  则添加到 数组的末尾[Screen, Layer, DrawObject]
	 * 
	 * 得到这个数组后, 我们就按照这个顺序来 执行事件
	 * 
	 * 
	 * 冒泡是如何做到的呢？
	 * 其实我认为冒泡的机制更高效
	 * 冒泡是从最底层往上找, 一直找到最上层注册了鼠标事件的节点
	 * 
	 * 首先 在鼠标事件列表里面查找(注意鼠标事件里面的点是乱放的,不存在先后顺序)
	 * 假如我找到了一个Screen, 假如这个Screen被点到了, 那么就将Screen添加到一个 空列表里 [Screen]
	 * 
	 * 我们继续在事件列表里面找, 假如找到了一个 Layer, 而这个Layer又被点到了, 那么我们把Layer 加到这个列表里[Layer, Screen]
	 * 同时我们要 检查一下Layer父级 即Screen 是否也包含 在鼠标事件列表里 如果包含, 那么 Screen Screen应该插入Layer的后面, 如果这个Screen已经在临时列表里面则不用插入了
	 * 
	 * DrawObject 同理 [DrawObject,Layer,Screen]
	 * 
	 *  
	 * @author juli
	 * 
	 */
	public class MouseEventSubject extends EventSubject
	{
		//TODO：
		//这里应该用一个链表替换, 暂时先这么做, 等链表逻辑写好了再替换
		private var mCaptureList:Array = [];
		public function MouseEventSubject()
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
				mDic[draw].call(draw, event);
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