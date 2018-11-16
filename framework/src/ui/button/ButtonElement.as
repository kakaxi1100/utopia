package ui.button
{
	import common.event.EventHandler;
	import common.event.EventType;
	import common.event.mouse.MouseEventData;
	
	import display.DrawObject;
	
	import ui.base.Element;
	
	public class ButtonElement extends Element
	{
		public static const NORMAL_STATE:String = "NORMAL_STATE";
		public static const OVER_STATE:String = "OVER_STATE";
		public static const PRESS_STATE:String = "PRESS_STATE";
		public static const DISABLE_STATE:String = "DISABLE_STATE";
		
		private var mStateType:String = NORMAL_STATE;
		private var mBackground:DrawObject;
		private var mEventHandler:EventHandler;
		public function ButtonElement()
		{
			super();
			
			mEventHandler = new EventHandler(this);
			
			mBackground = new DrawObject();
			this.addChild(mBackground);
			
			var style:ButtonStyle = new ButtonStyle();
			style.backgroundData = ButtonDefaultAssert.getInstance().NORMALASSERT;
			this.addState(NORMAL_STATE, ButtonState.getInstance(), style); 
			
			style = new ButtonStyle();
			style.backgroundData = ButtonDefaultAssert.getInstance().OVERASSERT;
			this.addState(OVER_STATE, ButtonState.getInstance(), style);
			
			style = new ButtonStyle();
			style.backgroundData = ButtonDefaultAssert.getInstance().PRESSASSERT;
			this.addState(PRESS_STATE, ButtonState.getInstance(), style);
			
			style = new ButtonStyle();
			style.backgroundData = ButtonDefaultAssert.getInstance().DISABLEASSERT;
			this.addState(DISABLE_STATE, ButtonState.getInstance(), style);
			
			changeState(NORMAL_STATE);
			
			mEventHandler.addEventListener(EventType.MOUSE_UP_EVENT, onMouseUpHandler);
			mEventHandler.addEventListener(EventType.MOUSE_DOWN_EVENT, onMouseDownHandler);
			mEventHandler.addEventListener(EventType.MOUSE_OVER_EVENT, onMouseOverHandler);
			mEventHandler.addEventListener(EventType.MOUSE_OUT_EVENT, onMouseOutHandler);
		}
		
		private function onMouseOutHandler(event:MouseEventData):void
		{	
			changeState(NORMAL_STATE);
		}
		
		private function onMouseOverHandler(event:MouseEventData):void
		{
			if(currentStateType == PRESS_STATE) return;
			
			changeState(OVER_STATE);			
		}
		
		private function onMouseDownHandler(event:MouseEventData):void
		{
			changeState(PRESS_STATE);
		}
		
		private function onMouseUpHandler(event:MouseEventData):void
		{
			changeState(OVER_STATE);
		}
		
		public function get background():DrawObject
		{
			return mBackground;
		}
	}
}