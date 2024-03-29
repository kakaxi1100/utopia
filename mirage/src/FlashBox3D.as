package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class FlashBox3D extends Sprite
	{
		private var _holder:Sprite;  
		private var _n:Number = 0;
		public function FlashBox3D()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;  
			
			_holder = new Sprite();
			_holder.x = stage.stageWidth / 2;
			_holder.y = stage.stageHeight / 2;
			addChild(_holder);
			
			var shape1:Shape = new Shape();
			shape1.z = 200;
			shape1.graphics.beginFill(0xffffff);  
			shape1.graphics.drawRect(-100, -100, 200, 200);
			_holder.addChild(shape1);
			
			var shape2:Shape = new Shape();
			shape2.z = -200;
			shape2.graphics.beginFill(0xffffff);  
			shape2.graphics.drawRect(-100, -100, 200, 200);
			_holder.addChild(shape2);
			
			var shape3:Shape = new Shape();
			shape3.x = 200;
			shape3.rotationY = 90;
			shape3.graphics.beginFill(0xffffff);  
			shape3.graphics.drawRect(-100, -100, 200, 200);
			_holder.addChild(shape3);
			
			var shape4:Shape = new Shape();
			shape4.x = -200;
			shape4.rotationY = -90;
			shape4.graphics.beginFill(0xffffff);  
			shape4.graphics.drawRect(-100, -100, 200, 200);
			_holder.addChild(shape4);
			
			var shape5:Shape = new Shape();
			shape5.y = 200;
			shape5.rotationX = 90;
			shape5.graphics.beginFill(0xffffff);  
			shape5.graphics.drawRect(-100, -100, 200, 200);
			_holder.addChild(shape5);
			
			var shape6:Shape = new Shape();
			shape6.y = -200;
			shape6.rotationX = -90;
			shape6.graphics.beginFill(0xffffff);  
			shape6.graphics.drawRect(-100, -100, 200, 200);
			_holder.addChild(shape6);
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);  
		}
		
		private function onEnterFrame(event:Event):void   {  
			_holder.rotationY += 2;
			_holder.rotationX += 1.5;
		}
	}
}