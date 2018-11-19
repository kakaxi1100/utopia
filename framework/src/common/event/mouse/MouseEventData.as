package common.event.mouse
{
	import common.event.EventData;

	public class MouseEventData extends EventData
	{
		public var mouseX:Number;
		public var mouseY:Number;
		
		public var isUserShape:Boolean;
		public function MouseEventData(type:String, mX:Number, mY:Number, userShape:Boolean = true)
		{
			super(type);
			
			isUserShape = userShape;
			
			mouseX = mX;
			mouseY = mY;
		}
	}
}