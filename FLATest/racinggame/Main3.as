package 
{
    import flash.display.*;
    import flash.events.*;

    public class Main3 extends MovieClip
    {
		private var lines:Array = [];
		private var d:Number = 415;
		private var h:Number = 10;
        public function Main3()
        {
			var index = 0;
			for(var i:int = 0; i < 150; i++)
			{
				var r:Road = new Road();
				r.z = i * 5 + d;
				
				if(i % 10 == 0)
				{
					index ^= 1;
				}
				r.gotoAndStop(index + 1);
				addChild(r);
				
				//Calculate Y
				//Calculate X
			}
            //addEventListener(Event.ENTER_FRAME, this.race);
        }

        private function race(event:Event) : void
        {
            
        }
    }
}
