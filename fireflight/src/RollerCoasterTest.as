package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 *计算过山车的加速度
	 * 公式:
	 * F = ma
	 * 这里只考虑重力影响
	 * F = mgcosθ
	 * 这个θ是斜率与重力的夹角 (因为再法线上的重力被抵消, 所以只计算再切线上的重力)
	 * 
	 * cosθ根据点积公式可知
	 * cosθ = A·B/|A||B|
	 * 
	 * 这里A,B可以分别表示为 k 和  重力
	 * 以当前检测的这个点为坐标系: 假设 y向上, x向右
	 * 那么 A = (1, k) (因为y=kx), B = (0, -mg)
	 * 
	 * 得出:
	 * cosθ = -k/√1+k²
	 * 
	 * a = -gk/√1+k²
	 * 
	 * 
	 * 我们可以用定积分来求再曲线上的这段距离
	 * 弧为(AB)
	 * 曲线要走的弧长 S 即我们下一个走的位置长度 P
	 * S = P
	 * 假如弧长方程为 x = φ(t) y = ψ(t)
	 * 我们可以在(AB)这段弧上取N个点, 每个点连上线, 这样就可以得到一个近似的弧长
	 * 如果这个N个点每段的距离都趋向于一个点 那么它们的加和就是弧长
	 * 每一段的长度可以表示为:
	 * √(Δx)² + (Δy)²
	 * 
	 * Δx = φ(t + dt) - φ(t) ≈ dx = φ'(t)dt
	 * Δy = ψ(t + dt) - ψ(t) ≈ dy = ψ'(t)dt
	 * 
	 * ds = √(dx)² + (dy)² = √φ'²(t)(dt)² + ψ'²(t)(dt)² = √φ'²(t) + ψ'²(t) dt
	 * 
	 * S = (α->β)∫√φ'²(t) + ψ'²(t) dt (α<=t<=β) 
	 * 假如 :
	 * y = f(x)
	 * x = x
	 * 
	 * S = (a->b)∫√1 + y'² dx (a<=x<=b)
	 * 
	 * 这里我们已知S, a和y' 需要求的是 b
	 * b 即我们要求的x, 代入到y=f(b) 可求出y 
	 * 
	 * 
	 * 我当是时想用这个来求出 物体 再曲线上的下一个位置, 看来是差强人意的
	 * 计算曲线外一线离曲线的最近点(可以直接计算距离)
	 * 假设曲线外一点为 (px, py) , 曲线上的点为(x, y)
	 * 那么此点到曲线上的点与与线上当前点的切线垂直,那么曲线上的点就是要求的点
	 * 切线垂直说明点积为0, 以曲线上的点建立坐标轴, y向上, x向右
	 * 
	 * 但有些积分很难求出来, 所以只能做表来查询
	 * 
	 * @author juli
	 * 
	 */	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RollerCoasterTest extends Sprite
	{
		private var sin1:Sin = new Sin(80, 0.05);
		private var tempX:Number = 0;
		private var tempT:Number = 0;
		private var ball:Ball = new Ball();
		private var ball2:Ball2 = new Ball2();
		private var c1:Circle = new Circle();
		public function RollerCoasterTest()
		{
			super();
			
//			addChild(sin1);
			addChild(ball);
			
			sin1.x = 100;
			sin1.y = 300;
			sin1.drawBetween(0, 200);
			
			ball.sin = sin1;
			
			addChild(ball2);
			ball2.c = c1;
			addChild(c1);
			c1.x = 200;
			c1.y = 200;
			c1.draw();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x00ff00);
			
			if(tempT >= Math.PI * 2)
			{
				tempT = 0;
			}
			
			var k:Number = c1.derivative(tempT);
			var tempX:Number = c1.getX(tempT);
			var tempY:Number = c1.getY(tempT);
			var b:Number = tempY - k * tempX;
			var nextX:Number = tempX + 20;
			var nextY:Number = nextX * k + b;
			this.graphics.moveTo(tempX + c1.x, tempY + c1.y);
			this.graphics.lineTo(nextX + c1.x, nextY + c1.y);
			
			ball2.k = k;
			ball2.update();
			
			tempT += 0.01;
		}
		
		protected function onEnterFrameSin(event:Event):void
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
			
			ball.k = sin1.derivative(ball.x);
			ball.update();
		}		
		
	}
}
import flash.display.Sprite;

class Circle extends Sprite
{
	public var t:Number = 0;
	public var r:Number = 50;
	public var aX:Number = 0;
	public var aY:Number = 0;
	public function Circle()
	{
		this.graphics.clear();
		this.graphics.lineStyle(2, 0xFFFFFF);
		
		this.aX = Math.cos(t) * r;
		this.aY = Math.sin(t) * r;
	}
	
	public function getX(t:Number):Number
	{
		return Math.cos(t) * r;
	}
	
	public function getY(t:Number):Number
	{
		return Math.sin(t) * r;	
	}
	
	
	public function integrationWithLength(l:Number):Number
	{
		//P = r*t 这里直接写了结果,不懂就去看定积分如何求弧长吧
		var tempT:Number = l / r;
		return tempT;
	}
	
	//某一点的倒数
	//dy/dt / dx/dt
	public function derivative(t:Number):Number
	{
		//dy/dt
		var dydt:Number = r * Math.cos(t);
		var dxdt:Number = -r * Math.sin(t);
		var k:Number = 0;
		if(dxdt == 0){
			k = Number.MAX_VALUE;
		}else{
			k = dydt / dxdt;
		}
		return k;
	}
	
	public function draw():void
	{
		while(t <　Math.PI * 2)
		{
			t += 0.1;
			if(t >= Math.PI * 2){
				t = Math.PI * 2;
			}			
			
			this.graphics.moveTo(this.aX, this.aY);
			this.aX = Math.cos(t) * r;
			this.aY = Math.sin(t) * r;
			this.graphics.lineTo(this.aX, this.aY);
		}
	}
}

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

class Ball2 extends Sprite
{
	public var p:Number = 0;
	public var v:Number = 0;
	public var a:Number = 0;
	public var g:Number = 10;
	public var m:Number = 1;
	public var k:Number = 0;
	public var c:Circle = null;
	public function Ball2()
	{
		super();
		this.graphics.lineStyle(2, 0xFF00FF);
		this.graphics.drawCircle(0,0,10);
	}
	
	public function update(dt = 0.1):void
	{
		if(k >= Number.MAX_VALUE){
			k = 0;
		}
		a = (g * k)/Math.sqrt(1+ k * k);
		v += a * dt;
		p += v * dt;
		
		var tempT:Number = c.integrationWithLength(p);
		this.x = c.getX(tempT) + c.x;
		this.y = c.getY(tempT) + c.y;
	}
}

class Ball extends Sprite
{
	public var p:Number = 0;
	public var v:Number = 0;
	public var a:Number = 0;
	public var g:Number = 10;
	public var m:Number = 1;
	public var k:Number = 0;
	public var sin:Sin = null;
	public function Ball()
	{
		super();
		this.graphics.lineStyle(2, 0xFF00FF);
		this.graphics.drawCircle(0,0,10);
	}
	
	public function update(dt = 0.5):void
	{
		a = (g * k)/Math.sqrt(1+ k * k);
		v += a * dt;
		p += v * dt;
		//因为积分无法处理, 所以采用逼近
		var tempX:Number = 0;
		var tempY:Number = 0;
		var s:Number = 0;
		while(true)
		{
			if(s >= p)
			{
				break;
			}
			s += Math.sqrt(tempX * tempX + tempY * tempY);
			tempY = sin.getYByX(tempX);
			tempX += 1;
		}
		
		this.x = tempX + sin.x;
		this.y = tempY + sin.y;
	}
}