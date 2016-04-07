package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import foed.SteeredVehicle;
	import foed.Vector2D;

	[SWF(frameRate="30", backgroundColor="#FFFFFF",width="800",height="600")]
	public class SeekTest extends Sprite
	{
		private var _vehicle:SteeredVehicle;
		private var empty:Vector2D = new Vector2D(0,0);
		public function SeekTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_vehicle = new SteeredVehicle();
			addChild(_vehicle);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		protected function onMouseClick(event:MouseEvent):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(this.mouseX,this.mouseY,2);
			this.graphics.endFill();
			
			empty.x = this.mouseX;
			empty.y = this.mouseY;
		}
		private function onEnterFrame(event:Event):void
		{
			_vehicle.seek(empty);
			_vehicle.update();
		}
	}
}