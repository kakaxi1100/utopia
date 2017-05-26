package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="0")]
	public class DrawTest3 extends Sprite
	{
		[Embed(source="assets/2.png")]
		private var Background:Class;
		
		private var bmp:Bitmap = new Background();
		
		private var rows:int = 5;
		private var cols:int = 5;
		
		private var w:int = bmp.width / cols;
		private var h:int = bmp.height / rows;
		
		public static var WIDTH:int;
		public static var HEIGHT:int;
		
		public static var Error:int = 20;
		
		private var vexs:Array = [];
		private var pieces:Vector.<Vector.<Piece>> = new Vector.<Vector.<Piece>>();
		private var map:Array = [];
		
		private var target:Piece;
		private var preMouseX:Number;
		private var preMouseY:Number;
		
		private var root:Sprite = new Sprite;
		
		public static var index:int = 0; 
		public function DrawTest3()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.graphics.lineStyle(2, 0xFF0000);
			//			test();
			WIDTH = w;
			HEIGHT = h;
			
			addChild(root);
			
			initEgdeStyle();
			createVexs(vexs);
			createPieces();
			startLink();
			drawAll();
//			test2();
			
//			trace("start play");
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMOVE);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			pieces[0][0].move(10,10);
			resetAllPieces(false);
		}
		
		protected function onMouseMOVE(event:MouseEvent):void
		{
			if(target){
				target.move(mouseX - preMouseX, mouseY - preMouseY);
				resetAllPieces(false);
				preMouseX = mouseX;
				preMouseY = mouseY;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(target == null) return;
			
			//计算碰撞
			target.connectCheck();
			resetAllPieces(true);
			target = null;
			checkOver();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			
			for(var r:int = 0; r < rows; r++){
				for(var c:int = 0; c < cols; c++){
					var p:Piece = pieces[r][c];
					if(p.source.bitmapData.getPixel32(mouseX - (p.x + p.source.x), mouseY - (p.y + p.source.y)) == 0)
					{
						continue;
					}
					
					target = p;
					preMouseX = mouseX;
					preMouseY = mouseY;
					return;
				}
			}
		}
		
		public function resetAllPieces(check:Boolean):void
		{
			for(var r:int = 0; r < rows; r++){
				for(var c:int = 0; c < cols; c++){
					if(check){
						pieces[r][c].isChecked = false;
					}else{
						pieces[r][c].isMoved = false;
					}
				}
			}
		}
		
		private function checkOver():void
		{
			var isComplete:Boolean = true;
			var isBreak:Boolean = false;;
			var p:Piece;
			for(var r:int = 0; r < rows; r++){
				for(var c:int = 0; c < cols; c++){
					if(!pieces[r][c].connectComplete){
						isComplete = false;
						break;
					}
				}
				if(isBreak){
					break;
				}
			}
			if(isComplete == true){
				trace("Over");
			}else{
				trace("Not Yet");
			}
		}
		
		//只会按右边和下边来计算
		private function initEgdeStyle():void
		{
			var e:EdgeStyleBase = new EdgeStyleBase("r",1);
			var c:Controller = new Controller();
			//百分比
			c.xPer = -0.5;
			c.yPer = 0.5;
			c.ax = 0;
			c.ay = 1;
			e.addPoint(c);
			EdgeManager.register(e);
			//同时要生成一个左的样式
			e = new EdgeStyleBase("l",1);
			c = new Controller();
			c.xPer = -0.5;
			c.yPer = -0.5;
			c.ax = 0;
			c.ay = -1;
			e.addPoint(c);
			EdgeManager.register(e);
			
			
			
			e = new EdgeStyleBase("d",1);
			var d:Dot = new Dot();
			d.xPer = -0.5;
			d.yPer = -0.5;
			e.addPoint(d);
			EdgeManager.register(e);
			//同时要生成一个下的样式
			e = new EdgeStyleBase("u",1);
			d = new Dot();
			d.xPer = 0.5;
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
				pieces[r] = new Vector.<Piece>;
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
						e.style = EdgeManager.getEdge("r",1);
					}
					
					//下边   从右到左
					e = p.edges[2] = new Edge(vexs);
					e.s.setTo(r + 1, c + 1); 
					e.e.setTo(r + 1, c); 
					if(r + 1 != rows){
						e.style = EdgeManager.getEdge("d",1);
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
					var j:int = r - 1;
					var i:int = c - 1;
					p = pieces[r][c];
					if(r != 0){
						p.up = pieces[j][c];
					}else{
						p.connectUp = true;
					}
					
					if(m != rows){
						p.down = pieces[m][c];
						//当前点的 下边样式 等于 下碎片的 上边样式
						p.down.edges[0].style = EdgeManager.getEdge('u', p.edges[2].style.index);
					}else{
						p.connectDown = true;
					}
					
					if(c != 0){
						p.left = pieces[r][i];
					}else{
						p.connectLeft = true;
					}
					
					if(n != cols){
						p.right = pieces[r][n];
						//当前点的 右边样式 等于 右碎片的 左边样式
						p.right.edges[3].style = EdgeManager.getEdge('l', p.edges[1].style.index);
					}else{
						p.connectRight = true;
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
					//					p.draw(this.graphics);
					p.draw(p.graphics, bmp.bitmapData);
					root.addChildAt(p, 0);
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
		
		private function test2():void
		{
			this.graphics.beginFill(0x00FF00);
			var p:Piece = pieces[1][1];
			p.draw(p.graphics, bmp.bitmapData);
			addChild(p);
			
			p = pieces[0][0];
			p.draw(p.graphics, bmp.bitmapData);
			addChild(p);
			this.graphics.endFill();
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

class Piece extends Sprite
{
	public var row:int;
	public var col:int;
	public var realPos:Point = new Point();
	
	public var edges:Vector.<Edge> = new Vector.<Edge>;
	
	public var right:Piece;
	public var down:Piece;
	public var left:Piece;
	public var up:Piece;
	
	public var connectRight:Boolean;
	public var connectLeft:Boolean;
	public var connectUp:Boolean;
	public var connectDown:Boolean;
	
	public var source:Bitmap;
	
	public var isMoved:Boolean;
	public var isChecked:Boolean;
	
	public function Piece()
	{
		super();
		this.graphics.lineStyle(2, 0xFF0000);
	}
	
	public function draw(g:Graphics, bmd:BitmapData):void
	{
		this.graphics.beginBitmapFill(bmd);
		g.moveTo(edges[0].start.x, edges[0].start.y);
		for(var i:int = 0; i < edges.length; i++)
		{
			edges[i].draw(g);
		}
		this.graphics.endFill();
		
		var dest:BitmapData = new BitmapData(640, 480, true, 0xcccccc);
		dest.draw(this);
		source = new Bitmap(dest);
		source.x = -(col * DrawTest3.WIDTH + DrawTest3.WIDTH * 0.5);
		source.y = -(row * DrawTest3.HEIGHT + DrawTest3.HEIGHT * 0.5);
		addChild(source);
		
		this.graphics.clear();
	}
	
	public function getRealPos():Point
	{
		if(this.parent){
			realPos.setTo(this.parent.x + this.x, this.parent.y + this.y);
		}
		return realPos;
	}
	
	public function connectCheck():void
	{
		var sp:Point = getRealPos();
		var dp:Point, upp:Point, lp:Point, rp:Point;
		var dist:Number;
		var p:Piece;
		isChecked = true;
		if(up != null && !up.isChecked){
			if(!connectUp){
				upp = up.getRealPos();
				dist = Point.distance(sp, upp);
				if(dist <= DrawTest3.Error + DrawTest3.HEIGHT){
					up.move(sp.x - upp.x, sp.y - upp.y - DrawTest3.HEIGHT);
					up.connectDown = true;
					connectUp = true;
				}
			}
			up.connectCheck();
		}
		
		if(down != null && !down.isChecked){
			if(!connectDown){
				dp = down.getRealPos();
				dist = Point.distance(sp, dp);
				if(dist <= DrawTest3.Error + DrawTest3.HEIGHT){
					down.move(sp.x - dp.x, sp.y - dp.y + DrawTest3.HEIGHT);
					connectDown = true;
					down.connectUp = true;
				}
			}
			down.connectCheck();
		}
		
		if(left != null && !left.isChecked){
			if(!connectLeft){
				lp = left.getRealPos();
				dist = Point.distance(sp, lp);
				if(dist <= DrawTest3.Error + DrawTest3.WIDTH){
					left.move(sp.x - lp.x - DrawTest3.WIDTH, sp.y - lp.y);
					connectLeft = true;
					left.connectRight = true;
				}
			}
			left.connectCheck();
		}
		
		if(right != null && !right.isChecked){
			if(!connectRight){
				rp = right.getRealPos();
				dist = Point.distance(sp, rp);
				if(dist <= DrawTest3.Error + DrawTest3.WIDTH){
					right.move(sp.x - rp.x + DrawTest3.WIDTH, sp.y - rp.y);
					connectRight = true;
					right.connectLeft = true;
				}
			}
			right.connectCheck();
		}
	}
	
	public function move(ox:Number, oy:Number):void
	{
		trace(row, col);
		this.x += ox;
		this.y += oy;
		isMoved = true;
		if(right != null && connectRight && !right.isMoved){
			right.move(ox, oy);
		}
		
		if(left != null && connectLeft && !left.isMoved){
			left.move(ox, oy);
		}
		
		if(up != null && connectUp && !up.isMoved){
			up.move(ox, oy);
		}
		
		if(down != null && connectDown && !down.isMoved){
			down.move(ox, oy);
		}
	}
	
	public function reset():void
	{
		isChecked = false;
		isMoved = false;
	}
	
	public function get connectComplete():Boolean
	{
		return connectRight && connectLeft && connectDown && connectUp;
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
		g.lineTo(center.x + xPer * DrawTest3.WIDTH, center.y + yPer * DrawTest3.HEIGHT);
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
		g.curveTo(center.x + xPer * DrawTest3.WIDTH, center.y + yPer * DrawTest3.HEIGHT, center.x + ax * DrawTest3.WIDTH, center.y + ay * DrawTest3.HEIGHT);
	}
	
	public function copy():IPointType
	{
		var c:Controller = new Controller();
		c.xPer = this.xPer;
		c.yPer = this.yPer;
		c.ax = this.xPer;
		c.ay = this.yPer;
		
		return c;
	}
}

class EdgeManager
{
	public static var edges:Object = {"r":[], "d":[], "u":[], "l":[]};
	
	public static function register(e:EdgeStyleBase):void
	{
		edges[e.type][e.index] = e;
	}
	
	public static function getEdge(name:String, index:int):EdgeStyleBase
	{
		return edges[name][index];
	}
}

class EdgeStyleBase
{
	public var type:String;
	public var index:int;
	public var tlist:Array = [];
	public function EdgeStyleBase(t:String, i:int)
	{
		type = t;
		index = i;
	}
	
	//添加点
	public function addPoint(p:IPointType):void
	{
		tlist.push(p);
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

