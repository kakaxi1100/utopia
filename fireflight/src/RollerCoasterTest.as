package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RollerCoasterTest extends Sprite
	{
		private var sin1:Sin = new Sin(80, 0.05);
		private var tempX:Number = 0;
		public function RollerCoasterTest()
		{
			super();
			
			addChild(sin1);
			sin1.x = 100;
			sin1.y = 300;
			sin1.drawBetween(0, 200);
			
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
//			sin1.t += 1;
//			sin1.update();
			
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x00ff00);
			
			if(tempX > 200){
				tempX = 0;
			}
			var tempY:Number = sin1.getYByX(tempX);
			var k:Number = sin1.derivative(tempX);
			//注意并不是k=y/x 而是 y = kx + b (这个是斜率的直线方程)  
			var b:Number = tempY - k * tempX;
			var nextX:Number = tempX + 20;
			var nextY:Number = nextX * k + b;
			
			this.graphics.moveTo(tempX + sin1.x, tempY + sin1.y);
			this.graphics.lineTo(nextX + sin1.x, nextY + sin1.y);
			
			tempX += 1; 
		}		
		
	}
}
import flash.display.Sprite;

class Sin extends Sprite
{
	public var t:Number = 0;
	public var a:Number = 0;
	public var w:Number = 0;
	public var φ:Number = 0;
	public var aX:Number = 0;
	public var aY:Number = 0;
	public function Sin(altitude:Number = 0, w:Number = 0, φ:Number = 0)
	{
		super();	
		this.graphics.clear();
		this.graphics.lineStyle(2, 0xFFFFFF);
		this.t = 0;
		this.a = altitude;
		this.w = w;
		this.φ = φ;
		this.aX = t;
		this.aY = altitude * Math.sin(w * t + φ);
	}
	
	public function derivative(t:Number):Number
	{
		//对x = t点进行求导, 用复合函数求导法则
		//a * sin(w*x + φ)倒数 = a * w * cos(w * x + φ)
		return a * w * Math.cos(w * t + φ);
	}
	
	public function getYByX(t:Number):Number
	{
		return a * Math.sin(w * t + φ);
	}
	
	public function drawBetween(min:Number, max:Number):void
	{
		var step:Number = min;
		while(step <= max)
		{
			this.graphics.moveTo(aX, aY);
			aX = step;
			aY = a * Math.sin(w * step + φ);
			this.graphics.lineTo(aX, aY);
			step+=1;
		}
	}
	
	public function update():void
	{
		this.graphics.moveTo(aX, aY);
		
		aX = t;
		aY = a * Math.sin(w * t + φ);
		
		this.graphics.lineTo(aX, aY);
		
	}
}