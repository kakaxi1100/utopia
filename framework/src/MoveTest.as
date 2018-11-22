package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import common.event.EventHandler;
	import common.event.EventType;
	import common.event.mouse.MouseEventData;
	
	import display.Layer;
	import display.Screen;
	
	import ui.button.ButtonElement;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0xcccccc")]
	public class MoveTest extends Sprite
	{
		private var eventHD:EventHandler;
		private var screen:Screen;
		private var layer:Layer;
		private var button:ButtonElement;
		public function MoveTest()
		{
			super();
			
			eventHD = new EventHandler();
			
			screen = new Screen();
			this.addChild(screen.canvas);
			
			layer = new Layer();
			screen.addChild(layer);
			
			button = new ButtonElement();
			layer.addChild(button);
			button = new ButtonElement();
			button.x = 100;
			button.y = 100;
			layer.addChild(button);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			layer.x += 1;
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