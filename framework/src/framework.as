package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 整个容器部分只有 Stage
	 * 为了方便移植,所以其它所有可以显示的对象都不能继承DisplayObject也不能继承DisplayObjectContainer
	 * 所有的显示对象都由bitmap来显示
	 * 鼠标等的侦听动作只能在stage上完成
	 *  
	 * @author juli
	 * 
	 */	
	[SWF(width="800", height="600", frameRate="1", backgroundColor="0")]
	public class framework extends Sprite
	{
		public var s:Sprite = new Sprite();
		public var s1:Sprite = new Sprite();
		public var s2:Sprite = new Sprite();
		public function framework()
		{
			addChild(s);
			s.x = s.y = 100;
			s.addChild(s1);
			s.addChild(s2);
			
//			s.graphics.beginFill(0xff00ff);
//			s.graphics.drawCircle(0,0,200);
//			s.graphics.endFill();
			
			s1.graphics.beginFill(0xff0000);
			s1.graphics.drawCircle(0,0,20);
			s1.graphics.endFill();
			
			s2.x = 10;
			s2.y = 10;
			s2.graphics.beginFill(0x00ff00);
			s2.graphics.drawCircle(0,0,20);
			s2.graphics.endFill();
			
			s.addEventListener(MouseEvent.CLICK, onMouseClick);
			s1.addEventListener(MouseEvent.CLICK, onMouseClick1);
			s2.addEventListener(MouseEvent.CLICK, onMouseClick2);
			
			var test:TestObject = new TestObject();
		}
		
		protected function onMouseClick2(event:MouseEvent):void
		{
			trace("s2");
		}
		
		protected function onMouseClick1(event:MouseEvent):void
		{
			trace("s1");			
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			trace("All");
		}
	}
}
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

class TestObject extends EventDispatcher
{
	public function TestObject()
	{
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
	}
	
	protected function onMouseClick(event:Event):void
	{
		trace("testobject");
	}
}