package common.event.mouse
{
	import display.IDrawable;
	import common.event.EventData;
	import common.event.EventSubject;

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
		private var capture_bubbleList:Array = [];
		public function MouseEventSubject()
		{
			super();
			
		}
		
		//这里对  Object 进行区分
		//如果 Object 不是显示对象那就直接执行代码
		//如果 Object 是显示对象那根据事件是否冒泡来决定它的父级是否需要执行侦听代码
		override public function dispatchEvent(event:EventData):void
		{
			var mouseEvent:MouseEventData = event as MouseEventData;
			for(var o:Object in mDic)
			{
				if(o is IDrawable)//假如它是IDrawable 包括了 Screen, Layer, 和  DrawObject
				{
					var draw:IDrawable = o as IDrawable;
					//TODO:捕获的阶段,需要有个Screen管理来, 这样才能实现从上到下运行
											
					
					//冒泡的阶段
					if(draw.hitTestPoint(mouseEvent.mouseX, mouseEvent.mouseY))
					{
						if(mDic[draw] != null)
						{
							draw.isPrevHasMouse = draw.isHasMouse;
							draw.isHasMouse = true;
							if(draw.isPrevHasMouse == false && draw.isHasMouse == true)
							{
								trace(draw.isPrevHasMouse, draw.isHasMouse);
							}
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
			
			//目标阶段
			while(capture_bubbleList.length > 0)
			{
				var obj:Object = capture_bubbleList.shift();
				mDic[obj].call(obj, event);
			}
		}
	}
}