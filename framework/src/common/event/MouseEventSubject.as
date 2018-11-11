package common.event
{
	import display.DrawObject;
	import display.IDrawable;
	import display.Layer;
	import display.Screen;

	public class MouseEventSubject extends EventSubject
	{
		public function MouseEventSubject()
		{
			super();
		}
		
		//这里对  Object 进行区分
		//如果 Object 不是显示对象那就直接执行代码
		//如果 Object 是显示对象那根据事件是否冒泡来决定它的父级是否需要执行侦听代码
		override public function dispatchEvent(event:EventData):void
		{
			for(var o:Object in mDic)
			{
				if(o is IDrawable)//假如它是IDrawable 包括了 Screen, Layer, 和  DrawObject
				{
					//捕获的阶段
											
					
					//冒泡的阶段
					
					
					//事件是否停止传输(这个暂时还没有遇到这种需求, 以后再实现)
					
				}else
				{
					mDic[o].call(mDic[o].owner, event);
				}
				
				
			}
			
		}
	}
}