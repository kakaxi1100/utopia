package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import fl.motion.easing.Linear;

	public class Main3 extends MovieClip
	{
		private var lines:Array = [];
		private var linesLength:int = 150;
		private var camera:Object = {"y":100};
		private var dist:Number = 415;
		public function Main3()
		{
			var i:int;
			for (i = 0; i < linesLength; i++)
			{
				var l:Road = new Road();
				l.stop();
				l.cx = stage.stageWidth / 2;
				l.cy = 0 - camera.y;
				l.cz = dist + i;
				addChild(l);
				//caculate X
				l.x = l.cx;
				//caculate Y
				l.y = stage.stageHeight + (dist * l.cy / l.cz);
				//l.y = stage.stageHeight - i;
				trace(l.y);
			}
			
			//addEventListener(Event.ENTER_FRAME, this.race);
		}

		private function race(event:Event):void
		{

		}
	}
}