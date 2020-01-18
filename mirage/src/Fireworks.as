package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class Fireworks extends Sprite
	{
		private var slist:Array = [];
		private var count:int = 0;
		public function Fireworks()
		{
			super();
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			count++;
			if(count < 10)
			{
				return;
			}
			count = 0;
			var s:Spark = new Spark();
			s.x = Math.random() * stage.stageWidth;
			s.y = stage.stageHeight - 10;
			s.baseX = mouseX;
			s.baseY = mouseY;
			addChild(s);
			slist.push(s);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var s:Spark = new Spark();
			s.x = Math.random() * stage.stageWidth;
			s.y = stage.stageHeight - 10;
			s.baseX = mouseX;
			s.baseY = mouseY;
			addChild(s);
			slist.push(s);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < slist.length; i++)
			{
				var s:Spark = slist[i];
				if(this.contains(s))
				{
					s.update();
				}else{
					slist.splice(i, 1);
					i--;
				}
			}
		}
	}
}
import flash.display.Sprite;

class Spark extends Sprite
{
	public var baseX:Number;
	public var baseY:Number;
	public var plist:Array = [];
	
	public var state:int = 1;
	public var color:uint;
	public function Spark()
	{
		super();
		
		this.graphics.beginFill(0xFFF8DC);
		this.graphics.drawCircle(0, 0, 10);
		this.graphics.endFill();
		
		init();
	}
	
	public function init():void
	{
		var r:uint = Math.random() * 140 + 115;
		var g:uint = Math.random() * 140 + 115;
		var b:uint = Math.random() * 140 + 115;
		this.color = r << 16 | g << 8 | b;
		for(var i:int = 0; i < Math.ceil(Math.random() * 80 + 20); i++)
		{
			plist.push(new Particle(color));
		}
	}
	
	public function update():void
	{
		if(state == 1){
			this.moving();
		}else{
			this.explode();
		}
	}
	
	public function moving():void
	{
		//距离与速度成正比, 距离越大速度越大, 距离越小速度越小
		var dx:Number = baseX - this.x;
		var dy:Number = baseY - this.y;
		
		this.x += dx * 0.04;
		this.y += dy * 0.04;
		
		var dist:Number = dx*dx + dy*dy;
		if(dist < 5)
		{
			state = 2;
			this.graphics.clear();
			for(var i:int = 0; i < plist.length; i++)
			{
				addChild(plist[i]);
			}
		}
	}
	
	public function explode():void
	{
		for(var i:int = 0; i < plist.length; i++)
		{
			if(this.contains(plist[i])){
				plist[i].update();
			}else{
				plist.splice(i, 1);
				i--;
			}
		}
		
		if(plist.length == 0)
		{
			this.parent.removeChild(this);
		}
	}
}

class Particle extends Sprite
{
	public var angle:Number;
	public var speed:Number;
	public var xs:Number;
	public var ys:Number;
	public var gr:Number;
	public var grInc:Number;
	public function Particle(color:uint)
	{
		super();
			
		this.graphics.beginFill(color, Math.random() * 0.5 + 0.5);
		this.graphics.drawCircle(0, 0, Math.random() * 2 + 5);
		this.graphics.endFill();
		
		init();
	}
	
	public function init():void
	{
		angle = Math.random() * 2 * Math.PI;
		speed = (Math.random() * 10) + 16;
		xs = speed * Math.sin(angle);
		ys = speed * Math.cos(angle);
		gr = 0.1;
		grInc = Math.random() * 0.08 + 0.06;
	}
	
	public function update():void
	{
		this.x += this.xs;
		this.y += this.ys + this.gr;
		this.xs *= 0.8;
		this.ys *= 0.8;
		this.gr += this.grInc;
		this.alpha *= 0.948;
		if(this.alpha < 0.1)
		{
			this.parent.removeChild(this);
		}
	}
}