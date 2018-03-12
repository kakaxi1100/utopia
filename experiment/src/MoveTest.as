package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import utils.BActionParallel;
	import utils.BEasing;
	import utils.BTweenBase;
	import utils.BTweenManger;
	
	[SWF(frameRate="60")]
	public class MoveTest extends Sprite
	{
		private var dt:Number;
		private var action:BActionParallel = new BActionParallel(-1);
		
		private var tiles:Vector.<Tile> = new Vector.<Tile>();
		private var root:Sprite = new Sprite();
		private var timex:int = 0;
		private var timey:int = 0;
		public function MoveTest()
		{
			super();
			addChild(root);
			
			root.x = 100;
			root.y = 100;
			for(var j:int = 0; j < 8; j++)
			{
				for(var i:int = 0; i <8; i++)
				{
					var t:Tile;
					if(j == 7 && i == 7){
						t = new Tile(true);
					}else{
						t = new Tile();
					}
					t.x = 0;
					t.y = 5 * 40;
					t.dest.x = i * 40;
					t.dest.y = (5 - j) * 40;
					
					tiles.push(t);
					root.addChild(t);
					
					action.addTween(new BTweenBase(300 + timex, t, {x:t.dest.x}, BEasing.easeInElastic))
						  .addTween(new BTweenBase(300 + timey, t, {y:t.dest.y}, BEasing.easeInElastic));
					
					timex += 50;
					timey += 50;
				}
			}
			
			BTweenManger.getInstance().add(action);
			dt = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			BTweenManger.getInstance().update(dt);
			dt = getTimer();
		}
	}
}
import flash.display.Sprite;
import flash.geom.Point;

class Tile extends Sprite
{
	public var source:Point = new Point();
	public var dest:Point = new Point();
	public function Tile(fill = false)
	{
		this.graphics.lineStyle(2);
		if(!fill){
			this.graphics.drawCircle(0,0,20);
		}else{
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0,0,20);
			this.graphics.endFill();
		}
	}
}