package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="0")]
	public class DrawTest2 extends Sprite
	{
		[Embed(source="assets/2.png")]
		private var Background:Class;
		
		private var bmp:Bitmap = new Background();
		
		private var rows:int = 10;
		private var cols:int = 10;
		
		private var w:int = bmp.width / cols;
		private var h:int = bmp.height / rows;
		
		public static var WIDTH:int;
		public static var HEIGHT:int;
		
		public static var Error:int = 20;
		
		private var vexs:Array = [];
		private var pieces:Vector.<Vector.<Piece>> = new Vector.<Vector.<Piece>>();
		private var map:Array = [];
		
		private var target:SpriteWithID;
		private var preMouseX:Number;
		private var preMouseY:Number;
		public function DrawTest2()
		{
			trace("a");
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.graphics.lineStyle(2, 0xFF0000);
//			test();
			WIDTH = w;
			HEIGHT = h;
			
			addChild(ContainerManager.root);
			
			initEgdeStyle();
			createVexs(vexs);
			createPieces();
			startLink();
			drawAll();
//			test2();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMOVE);
		}
		
		protected function onMouseMOVE(event:MouseEvent):void
		{
			if(target){
				target.x += mouseX - preMouseX;
				target.y += mouseY - preMouseY;
				preMouseX = mouseX;
				preMouseY = mouseY;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(target == null) return;
			
			var len:int = target.list.length;
			for(var i:int = 0; i < len; i++){
				target.list[i].connectCheck();
			}
//			//计算碰撞
//			for each (var p:Piece in target.list){
//				p.connectCheck();
//			}
			target = null;
			checkOver();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			for each(var s:SpriteWithID in ContainerManager.containerList){
				for each (var p:Piece in s.list){
					if(p.source.bitmapData.getPixel32(mouseX - (p.x + p.source.x + s.x), mouseY - (p.y + p.source.y + s.y)) == 0)
					{
						continue;
					}
					
					target = s;
					preMouseX = mouseX;
					preMouseY = mouseY;
					return;
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
					ContainerManager.createContainer().addPiece(p);
				}
			}
//			pieces[0][0].visible = false;
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
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class ContainerManager
{
	public static var INDEX:int = 0;
	public static var containerList:Object = {};
	public static var root:Sprite = new Sprite();
	
	public static function createContainer():SpriteWithID
	{
		var s:SpriteWithID = new SpriteWithID(INDEX); 
		containerList[INDEX++] = s;
		
		root.addChildAt(s, 0);
		return s;
	}
	
	public static function removeContainer(id:int):void
	{
		if(containerList[id] == null)  return;
		root.removeChild(containerList[id]);
		containerList[id] = null;
		delete containerList[id];
	}
}

class SpriteWithID extends Sprite
{
	public var id:int;
	public var list:Vector.<Piece> = new Vector.<Piece>();
	public function SpriteWithID(i:int)
	{
		id = i;
	}
	
	public function addPiece(p:Piece):void
	{
		list.push(p);	
		addChildAt(p, 0);
		p.sParent = this;
	}
}

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
	
	public var sParent:SpriteWithID;
	public var connectRight:Boolean;
	public var connectLeft:Boolean;
	public var connectUp:Boolean;
	public var connectDown:Boolean;
	
	public var source:Bitmap;
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
		
		var rect:Rectangle = this.getRect(this);
		trace(rect);
		var dest:BitmapData = new BitmapData(rect.width, rect.height, true, 0xFFFFFF);
		var m:Matrix = new Matrix();
		m.translate(-rect.x, -rect.y);
		dest.draw(this, m, null, null, null);
		source = new Bitmap(dest);
		source.x = -(col * DrawTest2.WIDTH + DrawTest2.WIDTH * 0.5 - rect.x);
		source.y = -(row * DrawTest2.HEIGHT + DrawTest2.HEIGHT * 0.5 - rect.y);
		addChild(source);
		
		this.graphics.clear();
	}
	
	public function getRealPos():Point
	{
		if(this.parent){
			realPos.setTo(this.parent.x + this.x, this.parent.y + this.y);
		}else{
			realPos.setTo(this.x, this.y);
		}
		return realPos;
	}
	
	public function connectCheck():Boolean
	{
		var sp:Point = getRealPos();
		var rp:Point, dp:Point, lp:Point, upp:Point
		var dist:Number;
		var p:Piece;
		var preContainer:SpriteWithID;
		var isConnect:Boolean;
		//判断右边是否碰上了
		if(right != null && !connectRight){
			rp = right.getRealPos();
			dist = Point.distance(sp, rp);
			if(dist <= DrawTest2.Error + DrawTest2.WIDTH){
				connectRight = true;
				right.connectLeft = true;
				//合并容器
				//1.将容器整体移动过来
				right.sParent.x += sp.x - rp.x + DrawTest2.WIDTH;
				right.sParent.y += sp.y - rp.y;
				//2.将右边的piece移到当前的容器中
				preContainer = right.sParent;
				while(preContainer!= this.sParent && preContainer.list.length > 0){
					p = preContainer.list.pop();
					p.x = p.getRealPos().x - sParent.x;
					p.y = p.getRealPos().y - sParent.y;
					this.sParent.addPiece(p);
				}
				//3.删除之前的 sprite
				if(preContainer!= this.sParent){
					ContainerManager.removeContainer(preContainer.id);
				}
				
				isConnect = true;
			}
		}
		
		//判断左边是否碰上了
		if(down != null && !connectDown){
			dp = down.getRealPos();
			dist = Point.distance(sp, dp);
			if(dist <= DrawTest2.Error + DrawTest2.HEIGHT){
				connectDown = true;
				down.connectUp = true;
				//合并容器
				//1.将容器整体移动过来
				down.sParent.x += sp.x - dp.x;
				down.sParent.y += sp.y - dp.y + DrawTest2.HEIGHT;
				//2.将右边的piece移到当前的容器中
				preContainer = down.sParent;
				while(preContainer!= this.sParent && preContainer.list.length > 0){
					p = preContainer.list.pop();
					p.x = p.getRealPos().x - sParent.x;
					p.y = p.getRealPos().y - sParent.y;
					this.sParent.addPiece(p);
				}
				//3.删除之前的 sprite
				if(preContainer!= this.sParent){
					ContainerManager.removeContainer(preContainer.id);
				}
				
				isConnect = true;
			}
		}
		
		//判断上边是否碰上了
		if(left != null && !connectLeft){
			lp = left.getRealPos();
			dist = Point.distance(sp, lp);
			if(dist <= DrawTest2.Error + DrawTest2.WIDTH){
				connectLeft = true;
				left.connectRight = true;
				//合并容器
				//1.将容器整体移动过来
				left.sParent.x += sp.x - lp.x - DrawTest2.WIDTH;
				left.sParent.y += sp.y - lp.y;
				//2.将右边的piece移到当前的容器中
				preContainer = left.sParent;
				while(preContainer!= this.sParent && preContainer.list.length > 0){
					p = preContainer.list.pop();
					p.x = p.getRealPos().x - sParent.x;
					p.y = p.getRealPos().y - sParent.y;
					this.sParent.addPiece(p);
				}
				//3.删除之前的 sprite
				if(preContainer!= this.sParent){
					ContainerManager.removeContainer(preContainer.id);
				}
				
				isConnect = true;
			}
		}
		
		//判断下边是否碰上了
		if(up != null && !connectUp){
			upp = up.getRealPos();
			dist = Point.distance(sp, upp);
			if(dist <= DrawTest2.Error + DrawTest2.HEIGHT){
				connectUp = true;
				up.connectDown = true;
				//合并容器
				//1.将容器整体移动过来
				up.sParent.x += sp.x - upp.x;
				up.sParent.y += sp.y - upp.y - DrawTest2.HEIGHT;
				//2.将右边的piece移到当前的容器中
				preContainer = up.sParent;
				while(preContainer!= this.sParent && preContainer.list.length > 0){
					p = preContainer.list.pop();
					p.x = p.getRealPos().x - sParent.x;
					p.y = p.getRealPos().y - sParent.y;
					this.sParent.addPiece(p);
				}
				//3.删除之前的 sprite
				if(preContainer!= this.sParent){
					ContainerManager.removeContainer(preContainer.id);
				}
				
				isConnect = true;
			}
		}
		
		return isConnect;
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

