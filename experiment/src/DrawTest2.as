package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	
	import fl.motion.easing.Back;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="0")]
	public class DrawTest2 extends Sprite
	{
		[Embed(source="assets/2.png")]
		private var Background:Class;
		
		private var bmp:Bitmap = new Background();
		
		private var rows:int = 2;
		private var cols:int = 2;
		
		private var w:int = bmp.width / rows;
		private var h:int = bmp.height / cols;
		
		public static var WIDTH:int;
		public static var HEIGHT:int;
		
		private var vexs:Array = [];
		private var pieces:Array = [];
		public function DrawTest2()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.graphics.lineStyle(2, 0xFF0000);
			//			test();
			WIDTH = w;
			HEIGHT = h;
			
			initEgdeStyle();
			createVexs(vexs);
			createPieces();
			startLink();
			//			drawAll();
			this.graphics.beginFill(0x00FF00);
			//			pieces[0][0].draw(this.graphics);
			pieces[0][1].draw(this.graphics);
			this.graphics.endFill();
		}
		
		//只会按右边和下边来计算
		private function initEgdeStyle():void
		{
			var e:EdgeStyleBase = new EdgeStyleBase("v_1");
			var c:Controller = new Controller();
			//百分比
			c.xPer = -0.5;
			c.yPer = 0.5;
			c.ax = 0;
			c.ay = 1;
			e.addPoint(c);
			EdgeManager.register(e);
			
			e = new EdgeStyleBase("h_1");
			var d:Dot = new Dot();
			d.xPer = -0.5;
			d.yPer = -0.5;
			e.addPoint(d);
			EdgeManager.register(e);
		}
		
		//创建顶点列表
		private function createVexs(v:Array):void
		{
			for(var r:int = 0; r < rows + 1 ; r++){
				v[r] = [];
				for(var c:int = 0; c < cols + 1; c++){
					v[r][c] = new Point(c * w, r * h);
				}
			}
		}
		
		//创建拼图块
		private function createPieces():void
		{
			var p:Piece;
			var e:Edge;
			for(var r:int = 0; r < rows; r++){
				pieces[r] = [];
				for(var c:int = 0; c < cols; c++){
					p = pieces[r][c] = new Piece();
					p.row = r;
					p.col = c;
					
					//上边   从左到右
					e = p.edges[0] = new Edge(vexs);
					e.s.setTo(r, c); 
					e.e.setTo(r, c + 1); 
					
					//右边   从上到下
					e = p.edges[1] = new Edge(vexs);
					e.s.setTo(r, c + 1); 
					e.e.setTo(r + 1, c + 1); 
					if(c + 1 != cols){
						e.style = EdgeManager.getEdge("v_1");
					}
					
					//下边   从右到左
					e = p.edges[2] = new Edge(vexs);
					e.s.setTo(r + 1, c + 1); 
					e.e.setTo(r + 1, c); 
					if(r + 1 != rows){
						e.style = EdgeManager.getEdge("h_1");
					}
					
					//左边  从下到上
					e = p.edges[3] = new Edge(vexs);
					e.s.setTo(r + 1, c); 
					e.e.setTo(r, c); 
				}
			}
		}
		
		//将当前碎片的右碎片和下碎片连接到当前碎片
		private function startLink():void
		{
			var p:Piece;
			for(var r:int = 0; r < rows; r++){
				for(var c:int = 0; c < cols; c++){
					var m:int = r + 1;
					var n:int = c + 1;
					p = pieces[r][c];
					if(m != rows){
						p.down = pieces[m][c];
						//当前点的 下边样式 等于 下碎片的 上边样式
						p.down.edges[0].style = p.edges[2].style;
					}
					if(n != cols){
						p.right = pieces[r][n];
						//当前点的 右边样式 等于 右碎片的 左边样式
						p.right.edges[3].style = p.edges[1].style;
					}
				}
			}
		}
		
		private function drawAll():void
		{
			var p:Piece;
			for(var r:int = 0; r < rows; r++)
			{
				for(var c:int = 0; c < cols; c++)
				{
					p = pieces[r][c];
					p.draw(this.graphics);
				}
			}
		}
		
		private function test():void
		{
			this.graphics.lineStyle(2, 0xFF00000);
			this.graphics.beginFill(0x00FF00);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(320,0);
			//			this.graphics.moveTo(320,0);
			this.graphics.curveTo(160,120, 320, 240);
			//			this.graphics.moveTo(320, 240);
			this.graphics.lineTo(0, 240);
			//			this.graphics.moveTo(0, 240);
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
		}
	}
}
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

class Piece extends Sprite
{
	public var row:int;
	public var col:int;
	
	public var edges:Array = [];
	
	public var right:Piece;
	public var down:Piece;
	
	public function Piece()
	{
		super();
	}
	
	public function draw(g:Graphics):void
	{
		g.moveTo(edges[0].start.x, edges[0].start.y);
		for(var i:int = 0; i < edges.length; i++)
		{
			edges[i].draw(g);
		}
	}
}

interface IPointType{
	function execute(center:Point, g:Graphics):void;
	function copy():IPointType;
}

class Dot implements IPointType
{
	public var xPer:Number;
	public var yPer:Number;
	public function execute(center:Point, g:Graphics):void
	{
		g.lineTo(center.x + xPer * DrawTest2.WIDTH, center.y + yPer * DrawTest2.HEIGHT);
	}
	
	public function copy():IPointType
	{
		var d:Dot = new Dot();
		d.xPer = this.xPer;
		d.yPer = this.yPer;
		return d;
	}
}

class Controller implements IPointType
{
	public var xPer:Number;
	public var yPer:Number;
	
	public var ax:Number;
	public var ay:Number;
	public function execute(center:Point, g:Graphics):void
	{
		g.curveTo(center.x + xPer * DrawTest2.WIDTH, center.y + yPer * DrawTest2.HEIGHT, center.x + ax * DrawTest2.WIDTH, center.y + ay * DrawTest2.HEIGHT);
	}
	
	public function copy():IPointType
	{
		var d:Dot = new Dot();
		d.xPer = this.xPer;
		d.yPer = this.yPer;
		return d;
	}
}

class EdgeManager
{
	public static var edges:Object = {};
	public static function register(e:EdgeStyleBase):void
	{
		edges[e.name] = e;
	}
	
	public static function getEdge(name:String):EdgeStyleBase
	{
		return edges[name];
	}
}

class EdgeStyleBase
{
	public var name:String;
	public var tlist:Array = [];
	public function EdgeStyleBase(n:String)
	{
		name = n;
	}
	
	//添加点
	public function addPoint(p:IPointType):void
	{
		tlist.push(p);
	}
	
	public function reverseList():Array
	{
		var result:Array = [];
		
		for(var i:int = tlist.length - 1; i >= 0; i--)
		{
			
		}
		
		return result;
	}
}

class Edge
{
	public var s:Point = new Point();
	public var e:Point = new Point();
	
	public var style:EdgeStyleBase;
	
	private var vlist:Array;
	public function Edge(list:Array)
	{
		vlist = list;
	}
	
	public function draw(g:Graphics):void
	{
		for(var i:int = 0; style != null && i < style.tlist.length; i++)
		{
			var p:IPointType = style.tlist[i];
			p.execute(vlist[s.x][s.y], g);
		}
		g.lineTo(end.x, end.y);
	}
	
	public function get start():Point
	{
		return vlist[s.x][s.y];
	}
	
	public function get end():Point
	{
		return vlist[e.x][e.y];
	}
}

