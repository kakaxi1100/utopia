package common.event.mouse
{
	import common.event.EventData;

	public class MouseEventData extends EventData
	{
		public var mouseX:Number;
		public var mouseY:Number;
		
		public var isUserShape:Boolean;
		public var isStop:Boolean;//不要冒泡, 碰到第一个就停止
		public function MouseEventData(type:String, mX:Number, mY:Number, userShape:Boolean = true, stop:Boolean = true)
		{
			super(type);
			
			isUserShape = userShape;
			isStop = stop;
			
			mouseX = mX;
			mouseY = mY;
		}
	}
}