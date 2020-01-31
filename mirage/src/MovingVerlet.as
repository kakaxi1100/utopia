package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#008080")]
	public class MovingVerlet extends Sprite
	{
		private var point:VerletPoint;
		public function MovingVerlet()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			point = new VerletPoint(100, 100);
			point.vx = 1;
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{

			point.update();
			graphics.clear();
			point.render(graphics);
		}
	}
}
import flash.display.Graphics;

class VerletPoint
{
	public var x:Number;
	public var y:Number;
	
	private var mPrevX:Number;
	private var mPrevY:Number;
	public function VerletPoint(x:Number, y:Number)
	{
		setPosition(x, y);
	}
	
	public function update():void
	{
		var tempX:Number = x;
		var tempY:Number = y;
		x += vx; 
		y += vy; 
		mPrevX = tempX; 
		mPrevY = tempY; 
	}
	
	public function setPosition(x:Number, y:Number):void
	{
		this.x = this.mPrevX = x;
		this.y = this.mPrevY = y;
	}
	
	public function set vx(value:Number):void
	{
		mPrevX = x - value;
	}
	
	public function get vx():Number
	{
		return x - mPrevX;
	}
	
	public function set vy(value:Number):void
	{
		mPrevY = y - value;
	}
	
	public function get vy():Number
	{
		return y - mPrevY;
	}
	
	public function render(g:Graphics):void 
	{ 
		g.beginFill(0); 
		g.drawCircle(x, y, 4); 
		g.endFill(); 
	}  
}