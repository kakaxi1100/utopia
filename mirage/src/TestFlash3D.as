package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class TestFlash3D extends Sprite
	{
		private var _shape:Shape;  
		public function TestFlash3D()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;  
			
//			_shape = new Shape();  
//			_shape.graphics.beginFill(0xff0000);  
//			_shape.graphics.drawRect(-100, -100, 200, 200);  
//			_shape.x = stage.stageWidth / 2;  
//			_shape.y = stage.stageHeight / 2;  
//			addChild(_shape);  
//			
//			addEventListener(Event.ENTER_FRAME, onEnterFrame);  
			
			addChild(new Position3D());
		}
		
//		private function onEnterFrame(event:Event):void   {  
//			_shape.rotationY += 2;  
//		}
	}
}
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

class Position3D extends Sprite
{
	private var _shape:Shape;  
	private var _n:Number = 0;
	
	public function Position3D(){
		_shape = new Shape();
		_shape.graphics.beginFill(0x00ff00);
		_shape.graphics.drawRect(-100, -100,200, 200);
		_shape.graphics.endFill();
		addChild(_shape);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame); 
	}
	
	private function onEnterFrame(event:Event):void {
		_shape.x = mouseX;  
		_shape.y = mouseY;  
		_shape.z = 10000 + Math.sin(_n += .1) * 10000; 
	}
}