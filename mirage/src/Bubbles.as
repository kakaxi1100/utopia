package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#87CEFA")]
	public class Bubbles extends Sprite
	{
		private var blist:Array = [];
		public function Bubbles()
		{
			super();
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var b:Bubble = new Bubble();

			addChild(b);
			blist.push(b);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < blist.length; i++)
			{
				var b:Bubble = blist[i];
				if(this.contains(b))
				{
					b.update();
				}else{
					blist.splice(i, 1);
					i--;
				}
			}
		}
	}
}
import flash.display.Bitmap;
import flash.display.Sprite;

class Bubble extends Sprite
{
	[Embed(source="assets/bubble.png")]
	private var BubbleImg:Class;
	private var bubble:Bitmap = new BubbleImg();
	
	public var bx:Number;
	public var bz:Number;
	public var cnt:Number;
	public var wl:Number;
	public var amp:Number;
	public var ysp:Number;
	public var tx:Number = 0;
	public var ty:Number = 0;
	public var tz:Number = 0;
	public function Bubble()
	{
		super();		
		addChild(bubble);
		init();
	}
	
	public function init():void
	{
		// set initial values
		this.bx = 300*Math.random()-150;
		// base x coord for sine
		this.y = 400;
		// initial y coord
		this.bz = 300*Math.random()-150;
		// base z coord for sine
		this.cnt = 5000*(2*Math.PI)*Math.random();
		// randomize counter for sine
		this.wl = 8;
		// wavelength for sine calculations
		this.amp = 120;
		// amplitude for sine wave
		this.ysp = -1;
	}
	
	public function update():void
	{
		this.tx = this.bx+(this.amp*Math.sin(this.cnt/this.wl));
		this.ty += this.ysp;
		this.tz = this.bz+((this.amp/2)*Math.sin(this.cnt/this.wl));
		// increase counter on which sin and cosine are based
		this.cnt += 0.05;
		// call the function that applies 3d effects to this bubble
		m3d(this.tx, this.ty, this.tz);
		// check whether this instance is off screen, if so delete it
		if (this.y<-200) 
		{
			this.parent.removeChild(this);
		}
	}
	
	
	public function m3d(tx, ty, tz):void
	{
		// calculate perspective value
		var ps:Number = 300/(300 + tz);
		// change the object's properties
		
		// set 2d coords
		this.x = 500 +(this.tx*ps);
		this.y = 500 +(this.ty*ps);
		// set scale and alpha
		this.scaleX = (100-(z/2))/100;
		this.scaleY = (100-(z/2))/100;
		this.alpha = (100-(z/2))/100;
		
	}
}