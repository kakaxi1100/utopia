package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.ares.archive.fireflight_v2.FFVector;
	import org.ares.archive.fireflight_v2.collision.FFCollisionCircle;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class BoundingCircleTest extends Sprite
	{
		private var circle:FFCollisionCircle = new FFCollisionCircle();
		private var vlist:Vector.<FFVector> = new Vector.<FFVector>();
		public function BoundingCircleTest()
		{
			super();
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			vlist.push(new FFVector(mouseX, mouseY));
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			
			for(var i:int = 0; i < vlist.length; i++)
			{
				var j:int = i + 1;
				if(j == vlist.length){
					j = 0;
				}
				this.graphics.moveTo(vlist[i].x, vlist[i].y);
				this.graphics.lineTo(vlist[j].x, vlist[j].y)
			}
			
			circle.updateCircle(vlist);
			
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawCircle(circle.center.x, circle.center.y, circle.radius);
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawCircle(circle.center.x, circle.center.y, 5);
			this.graphics.endFill();
		}
	}
}