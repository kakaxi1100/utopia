package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import foed.Circle;
	import foed.SteeredVehicle;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class AvoidTest extends Sprite
	{
		private var clist:Array = [];
		private var v:SteeredVehicle = new SteeredVehicle();
		public function AvoidTest()
		{
			super();
			
			for(var i:int = 0; i < 20; i++)
			{
				var c:Circle = new Circle(Math.random()*40 + 10);
				c.x = Utils.randomRange(c.radius, stage.stageWidth - c.radius);
				c.y = Utils.randomRange(c.radius, stage.stageHeight - c.radius);
				clist.push(c);
				addChild(c);
			}
			
			addChild(v);
			v.position.x = 100;
			v.position.y = 100;
			v.velocity.x = 5;
			v.velocity.y = 5;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			v.avoid(clist);
			v.update();
		}
	}
}

class Utils
{
	public static function randomRange(start:Number, end:Number):Number
	{
		return Math.random() * (end - start) + start;
	}
}