package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import voforai.SteeringBehaviors;
	import voforai.Vehicle;
	
	public class Test2 extends Sprite
	{
		private var sp:Sprite = new Sprite();
		private var o:Object = {x:0, y:0, sx:0,sy:100};
		public function Test2()
		{
			super();
		
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild(sp);
			sp.graphics.lineStyle(1, 0x00ff00);
			sp.graphics.moveTo(o.sx, o.sy);
			
			o.x = o.sx;
			o.y = o.sy;
			
			this.graphics.lineStyle(1,0xff0000);
			this.graphics.moveTo(o.sx, o.sy);
			this.graphics.lineTo(1000, o.sy);
			try {
				// sorry this operation is not supported yet
				throw new Error("This is not yet supported");
			} catch (bizError:InvalidRequest) {
				trace("bizError");
			} catch (th:Error) {
				trace("th");
			}
			//stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var a:Number = 90;
		protected function onEnterFrame(event:Event):void
		{
			var sinb:Number = Math.sin(a*Math.PI/180);
			trace(a,"####", sinb);
			o.y += sinb*5;
			o.x += 1;
			a += 10;
			
			sp.graphics.lineTo(o.x, o.y);
		}
	}
}

class InvalidRequest extends Error{
	
}