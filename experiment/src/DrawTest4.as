package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	[SWF(width="1024", height="748", frameRate="30", backgroundColor="0xcccccc")]
	public class DrawTest4 extends Sprite
	{
		[Embed(source="assets/2.png")]
		private var Background:Class;
		
		private var bmp:Bitmap = new Background();
		
		public static var rows:int = 5;
		public static var cols:int = 5;
		
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
		
		private var showEdge:int;
		private var button1:RectText = new RectText("Show", 0xff0000);
		
		private var hintTarget:SpriteWithID;
		private var button2:RectText = new RectText("Hint", 0x00ff00);
		
		private var button3:RectText = new RectText("Restart", 0xffff00);
		
		private var isShow:int;
		private var button4:RectText = new RectText("preview", 0x00ffff);
		
		private var wt:TextField = new TextField();
		private var ht:TextField = new TextField();
		
		public function DrawTest4()
		{
			trace("c");
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.graphics.lineStyle(2, 0xFF0000);
			//			test();
			addChild(ContainerManager.root);
			
			bmp.x = 100;
			bmp.y = 100;
			
			wt.height = 20;
			wt.width = 100;
			wt.x = button1.x;
			wt.y = button1.y + 30;
			wt.type = TextFieldType.INPUT;
			wt.background = true;
			wt.border = true;
			wt.backgroundColor = 0xffffff;
			wt.text = "3";
			wt.restrict = "0-9";
			
			ht.height = 20;
			ht.width = 100;
			ht.x = wt.x + wt.width + 30;
			ht.y = wt.y;
			ht.text = "3";
			ht.border = true;
			ht.background = true;
			ht.backgroundColor = 0xffffff;
			ht.type = TextFieldType.INPUT;
			ht.restrict = "0-9";
			
			flow();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMOVE);
			
			
			//add show edge button
			addChild(button1);
			button1.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			button2.x = button1.x + button1.width;
			addChild(button2);
			button2.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			button3.x = button2.x + button2.width;
			addChild(button3);
			button3.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			button4.x = button3.x + button3.width;
			addChild(button4);
			button4.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			addChild(wt);
			addChild(ht);
		}
		
		private function initConfig():void
		{
			rows = int(wt.text);
			cols = int(ht.text);
			w = bmp.width / cols;
		 	h = bmp.height / rows;
			
			WIDTH = w;
			HEIGHT = h;
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var p:Piece;
			if(event.currentTarget == button1){
				showEdge ^= 1;
				for(var r:int = 0; r < rows; r++){
					for(var c:int = 0; c < cols; c++){
						p = pieces[r][c];
						if(showEdge){
							if(p.isEdge){
								p.alpha = 1;
							}else{
								p.alpha = 0;
							}
						}else{
							p.alpha = 1;
						}
					}
				}
			}else if(event.currentTarget == button2){
				if(hintTarget != null){
					for each (p in hintTarget.list){
						p.imConnect();
//						if(p.connectRight == false){
//							p.imConnectRight();
//							return;
//						}else if(p.connectLeft == false){
//							p.imConnectLeft();
//							return;
//						}else if(p.connectUp == false){
//							p.imConnectUp();
//							return;
//						}else if(p.connectDown == false){
//							p.imConnectDown();
//							return;
//						}
					}
					hintTarget.isConnected = false;
				}
			}else if(event.currentTarget == button3){
				ContainerManager.removeAll();
				flow();
			}else if(event.currentTarget == button4){
				isShow ^= 1;
				if(isShow){
					this.addChild(bmp);
				}else{
					this.removeChild(bmp);
				}
			}
		}
		
		private function flow():void
		{
			initConfig();
			initEgdeStyle();
			createVexs(vexs);
			createPieces();
			startLink();
			drawAll();
			//			test2();
			shuffle();
			destory();
		}
		
		private function destory():void
		{
			if(isShow){
				isShow = 0;
				this.removeChild(bmp);
			}
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
					hintTarget = s;
					preMouseX = mouseX;
					preMouseY = mouseY;
					ContainerManager.changeToTop(target);
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
//				trace("Not Yet");
			}
		}
		
		//只会按右边和下边来计算
		private function initEgdeStyle():void
		{
			var d:Dot;
			var c:Controller;
			var e:EdgeStyleBase = new EdgeStyleBase("r",1);
			d = new Dot();
			d.xPer = -0.25;
			d.yPer = 0.25;
			e.addPoint(d);
			
			c = new Controller();
			//百分比
			c.xPer = -0.75;
			c.yPer = 0.25;
			c.ax = -0.25;
			c.ay = 0.55;
			e.addPoint(c);
			EdgeManager.register(e);
			
			//同时要生成一个左的样式
			e = new EdgeStyleBase("l",1);
			d = new Dot();
			d.xPer = -0.25;
			d.yPer = -0.45;
			e.addPoint(d);
			
			c = new Controller();
			c.xPer = -0.75;
			c.yPer = -0.75;
			c.ax = -0.25;
			c.ay = -0.75;
			e.addPoint(c);
			EdgeManager.register(e);
			
			e = new EdgeStyleBase("d",1);
		 	d = new Dot();
			d.xPer = -0.25;
			d.yPer = -0.25;
			e.addPoint(d);
			
			c = new Controller();
			c.xPer = -0.25;
			c.yPer = -0.55;
			c.ax = -0.75;
			c.ay = -0.55;
			e.addPoint(c);
			
			EdgeManager.register(e);
			//同时要生成一个下的样式
			e = new EdgeStyleBase("u",1);
			d = new Dot();
			d.xPer = 0.25;
			d.yPer = -0.55;
			e.addPoint(d);
			
			c = new Controller();
			c.xPer = 0.75;
			c.yPer = -0.55;
			c.ax = 0.75;
			c.ay = -0.25;
			e.addPoint(c);
			EdgeManager.register(e);
			
			
			
			e = new EdgeStyleBase("r",2);
			c = new Controller();
			//百分比
			c.xPer = -0.5;
			c.yPer = 0.5;
			c.ax = 0;
			c.ay = 1;
			e.addPoint(c);
			EdgeManager.register(e);
			//同时要生成一个左的样式
			e = new EdgeStyleBase("l",2);
			c = new Controller();
			c.xPer = -0.5;
			c.yPer = -0.5;
			c.ax = 0;
			c.ay = -1;
			e.addPoint(c);
			EdgeManager.register(e);
			
			e = new EdgeStyleBase("d",2);
			d = new Dot();
			d.xPer = -0.5;
			d.yPer = -0.5;
			e.addPoint(d);
			EdgeManager.register(e);
			//同时要生成一个下的样式
			e = new EdgeStyleBase("u",2);
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
						e.style = EdgeManager.getEdge("r",Math.round(Math.random() + 1));
					}
					
					//下边   从右到左
					e = p.edges[2] = new Edge(vexs);
					e.s.setTo(r + 1, c + 1); 
					e.e.setTo(r + 1, c); 
					if(r + 1 != rows){
						e.style = EdgeManager.getEdge("d",Math.round(Math.random() + 1));
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
		
		private function shuffle():void
		{
			var p:Piece;
			for(var r:int = 0; r < rows; r++)
			{
				for(var c:int = 0; c < cols; c++)
				{
					p = pieces[r][c];
					p.x = Math.random()*(stage.stageWidth - 100) + 100;
					p.y = Math.random()*(stage.stageHeight - 100) + 100;
				}
			}
		}
		
		private function test():void
		{
//			this.graphics.lineStyle(0, 0xFF00000);
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
import flash.text.TextField;

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
	
	public static function changeToTop(s:SpriteWithID):void
	{
		root.swapChildren(root.getChildAt(root.numChildren - 1), s);
	}
	
	public static function removeAll():void
	{
		while(root.numChildren > 0){
			root.removeChildAt(0);
		}
		INDEX = 0;
	}
}

class SpriteWithID extends Sprite
{
	public var id:int;
	public var list:Vector.<Piece> = new Vector.<Piece>();
	public var isConnected:Boolean;
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
		this.graphics.lineStyle(1, 0x000000);
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
		var dest:BitmapData = new BitmapData(rect.width, rect.height, true, 0xFFFFFF);
		var m:Matrix = new Matrix();
		m.translate(-rect.x, -rect.y);
		dest.draw(this, m, null, null, null);
		source = new Bitmap(dest);
		source.x = -(col * DrawTest4.WIDTH + DrawTest4.WIDTH * 0.5 - rect.x);
		source.y = -(row * DrawTest4.HEIGHT + DrawTest4.HEIGHT * 0.5 - rect.y);
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
	
	public function imConnect():void
	{
		var sp:Point;
		var rp:Point, dp:Point, lp:Point, upp:Point
		var dist:Number;
		var p:Piece;
		var preContainer:SpriteWithID;
		//判断右边是否碰上了
		if(right != null && !connectRight){
			rp = right.getRealPos();
			sp = getRealPos();
			preContainer = right.sParent;
			//合并容器
			//1.将当前容器移过去
			if(preContainer != this.sParent){
				if(!right.sParent.isConnected && !this.sParent.isConnected){
					right.sParent.x += sp.x - rp.x + DrawTest4.WIDTH;
					right.sParent.y += sp.y - rp.y;
					right.sParent.isConnected = true;
					this.sParent.isConnected = true;
					connectRight = true;
					right.connectLeft = true;
					//2.将右边的piece移到当前的容器中
					while( preContainer.list.length > 0){
						p = preContainer.list.pop();
						p.x = p.getRealPos().x - sParent.x;
						p.y = p.getRealPos().y - sParent.y;
						this.sParent.addPiece(p);
					}
					//3.删除之前的 sprite
					if(preContainer!= this.sParent){
						ContainerManager.removeContainer(preContainer.id);
					}
				}
			}else{
				connectRight = true;
				right.connectLeft = true;
			}
			
		}
		
		//判断左边是否碰上了
		if(down != null && !connectDown){
			dp = down.getRealPos();
			sp = getRealPos();
			preContainer = down.sParent;
			
			//合并容器
			//1.将当前容器移过去
			if(preContainer != this.sParent){
				if(!down.sParent.isConnected && !this.sParent.isConnected){
					down.sParent.x += sp.x - dp.x;
					down.sParent.y += sp.y - dp.y + DrawTest4.HEIGHT;
					down.sParent.isConnected = true;
					this.sParent.isConnected = true;
					connectDown = true;
					down.connectUp = true;
					//2.将右边的piece移到当前的容器中
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
				}
			}else{
				connectDown = true;
				down.connectUp = true;
			}
		}
		
		//判断上边是否碰上了
		if(left != null && !connectLeft){
			lp = left.getRealPos();
			sp = getRealPos();
			
			preContainer = left.sParent;
			//合并容器
			//1.将当前容器移过去
			if(preContainer != this.sParent){
				if(!left.sParent.isConnected && !this.sParent.isConnected){
					left.sParent.x += sp.x - lp.x - DrawTest4.WIDTH;
					left.sParent.y += sp.y - lp.y;
					left.sParent.isConnected = true;
					this.sParent.isConnected = true;
					connectLeft = true;
					left.connectRight = true;
					//2.将右边的piece移到当前的容器中
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
				}
			}else{
				connectLeft = true;
				left.connectRight = true;
			}
				
		}
		
		//判断下边是否碰上了
		if(up != null && !connectUp){
			upp = up.getRealPos();
			sp = getRealPos();
			
			preContainer = up.sParent;
			//合并容器
			//1.将当前容器移过去
			if(preContainer != this.sParent){
				if(!up.sParent.isConnected && !this.sParent.isConnected){
					up.sParent.x += sp.x - upp.x;
					up.sParent.y += sp.y - upp.y - DrawTest4.HEIGHT;
					up.sParent.isConnected = true;
					this.sParent.isConnected = true;
					connectUp = true;
					up.connectDown = true;
					//2.将右边的piece移到当前的容器中
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
				}
			}else{
				connectUp = true;
				up.connectDown = true;
			}
		}
	}
	
	public function imConnectRight():void
	{
		var preContainer:SpriteWithID;
		var sp:Point;
		var rp:Point;
		var p:Piece;
		
		rp = right.getRealPos();
		sp = getRealPos();
		if(!connectRight){
			connectRight = true;
			right.connectLeft = true;
			//合并容器
			//1.将当前容器移过去
			right.sParent.x += sp.x - rp.x + DrawTest4.WIDTH;
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
		}
	}
	
	public function imConnectLeft():void
	{
		var preContainer:SpriteWithID;
		var sp:Point;
		var lp:Point;
		var p:Piece;
		
		lp = left.getRealPos();
		sp = getRealPos();
		if(!connectLeft){
			connectLeft = true;
			left.connectRight = true;
			//合并容器
			//1.将容器整体移动过来
			left.sParent.x += sp.x - lp.x - DrawTest4.WIDTH;
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
		}
	}
	
	public function imConnectUp():void
	{
		var preContainer:SpriteWithID;
		var sp:Point;
		var upp:Point;
		var p:Piece;
		
		upp = up.getRealPos();
		sp = getRealPos();
		if(!connectUp){
			connectUp = true;
			up.connectDown = true;
			//合并容器
			//1.将容器整体移动过来
			up.sParent.x += sp.x - upp.x;
			up.sParent.y += sp.y - upp.y - DrawTest4.HEIGHT;
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
		}
	}
	
	public function imConnectDown():void
	{
		var preContainer:SpriteWithID;
		var sp:Point;
		var dp:Point;
		var p:Piece;
		
		dp = down.getRealPos();
		sp = getRealPos();
		if(!connectDown){
			connectDown = true;
			down.connectUp = true;
			//合并容器
			//1.将容器整体移动过来
			down.sParent.x += sp.x - dp.x;
			down.sParent.y += sp.y - dp.y + DrawTest4.HEIGHT;
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
		}
	}
	
	public function connectCheck():Boolean
	{
		var sp:Point;
		var rp:Point, dp:Point, lp:Point, upp:Point
		var dist:Number;
		var p:Piece;
		var preContainer:SpriteWithID;
		var isConnect:Boolean;
		//判断右边是否碰上了
		if(right != null && !connectRight){
			rp = right.getRealPos();
			sp = getRealPos();
			dist = Point.distance(sp, rp);
			if(rp.x >= sp.x && dist <= DrawTest4.Error + DrawTest4.WIDTH && dist >= DrawTest4.WIDTH - DrawTest4.Error){
				connectRight = true;
				right.connectLeft = true;
				preContainer = right.sParent;
				//合并容器
				//1.将当前容器移过去
				if(preContainer != this.sParent){
					this.sParent.x += rp.x - sp.x - DrawTest4.WIDTH;
					this.sParent.y += rp.y - sp.y;
				}
				//2.将右边的piece移到当前的容器中
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
			sp = getRealPos();
			dist = Point.distance(sp, dp);
			if(sp.y <= dp.y && dist <= DrawTest4.Error + DrawTest4.HEIGHT && dist >= DrawTest4.HEIGHT - DrawTest4.Error){
				connectDown = true;
				down.connectUp = true;
				preContainer = down.sParent;
				//合并容器
				//1.将当前容器移过去
				if(preContainer != this.sParent){
					this.sParent.x += dp.x - sp.x;
					this.sParent.y += dp.y - sp.y - DrawTest4.HEIGHT;
				}
				//2.将右边的piece移到当前的容器中
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
			sp = getRealPos();
			dist = Point.distance(sp, lp);
			if(sp.x >= lp.x && dist <= DrawTest4.Error + DrawTest4.WIDTH && dist >= DrawTest4.WIDTH - DrawTest4.Error){
				connectLeft = true;
				left.connectRight = true;
				preContainer = left.sParent;
				//合并容器
				//1.将当前容器移过去
				if(preContainer != this.sParent){
					this.sParent.x += lp.x - sp.x + DrawTest4.WIDTH;
					this.sParent.y += lp.y - sp.y;
				}
				//2.将右边的piece移到当前的容器中
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
			sp = getRealPos();
			dist = Point.distance(sp, upp);
			if(sp.y >= upp.y && dist <= DrawTest4.Error + DrawTest4.HEIGHT && dist >= DrawTest4.HEIGHT - DrawTest4.Error){
				connectUp = true;
				up.connectDown = true;
				preContainer = up.sParent;
				//合并容器
				//1.将当前容器移过去
				if(preContainer != this.sParent){
					this.sParent.x += upp.x - sp.x;
					this.sParent.y += upp.y - sp.y + DrawTest4.HEIGHT;
				}
				//2.将右边的piece移到当前的容器中
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
	
	public function get isEdge():Boolean
	{
		var boo:Boolean = (row == 0 || col == 0 || row == DrawTest4.rows - 1 || col == DrawTest4.cols - 1);
		return boo;
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
		g.lineTo(center.x + xPer * DrawTest4.WIDTH, center.y + yPer * DrawTest4.HEIGHT);
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
		g.curveTo(center.x + xPer * DrawTest4.WIDTH, center.y + yPer * DrawTest4.HEIGHT, center.x + ax * DrawTest4.WIDTH, center.y + ay * DrawTest4.HEIGHT);
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

class RectText extends Sprite
{
	private var txt:TextField = new TextField();
	public function RectText(t:String, c:uint = 0, w:Number = 100, h:Number = 30)
	{
		super();
		this.graphics.beginFill(c);
		this.graphics.drawRect(0,0,w,h);
		this.graphics.endFill();
		
		this.mouseChildren = false;
		txt.mouseEnabled = false;
		txt.selectable = false;
		txt.text = t;
		txt.x = w/2 - txt.textWidth;
		txt.y = h/2 - txt.textHeight;
		addChild(txt)
	}
}

