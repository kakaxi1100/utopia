package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import common.event.EventHandler;
	import common.event.EventType;
	import common.event.mouse.MouseEventData;
	
	import display.Screen;
	
	import ui.button.ButtonElement;
	import ui.button.ButtonStyle;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class UITest extends Sprite
	{
		[Embed(source="assets/images/test/surge.png")]
		private var RedRabbit:Class;
		private var redRabbitData:BitmapData = (new RedRabbit() as Bitmap).bitmapData;
		
		private var screen:Screen;
		private var eventHD:EventHandler;
		public function UITest()
		{
			super();
			
			eventHD = new EventHandler();
			
			screen = new Screen(800,600,true);
			this.addChild(screen.canvas);
			
			var button:ButtonElement = new ButtonElement();
			button.x = 50;
			button.y = 50;
			screen.addChild(button);
//			(button.getStyle(ButtonElement.OVER_STATE) as ButtonStyle).backgroundData = redRabbitData;
			
			var button2:ButtonElement = new ButtonElement();
			button2.x = 100;
			button2.y = 100;
			screen.addChild(button2);
			
			
			screen.draw();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOut);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			screen.draw();
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			eventHD.dispatchEvent(new MouseEventData(EventType.MOUSE_OUT_EVENT, event.stageX, event.stageY));
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			eventHD.dispatchEvent(new MouseEventData(EventType.MOUSE_UP_EVENT, event.stageX, event.stageY));
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			eventHD.dispatchEvent(new MouseEventData(EventType.MOUSE_DOWN_EVENT, event.stageX, event.stageY));
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			eventHD.dispatchEvent(new MouseEventData(EventType.MOUSE_OVER_EVENT, event.stageX, event.stageY));
			eventHD.dispatchEvent(new MouseEventData(EventType.MOUSE_OUT_EVENT, event.stageX, event.stageY));
		}
	}
}