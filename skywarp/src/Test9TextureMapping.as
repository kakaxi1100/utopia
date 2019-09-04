package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import skywarp.version2.SWPoint3D;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class Test9TextureMapping extends Sprite
	{
		[Embed(source="assets/images/text.png")]
		private var Wall:Class;
		private var wall:Bitmap = new Wall();
		
		private var bmd:BitmapData = new BitmapData(800, 600, false, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var centerX:int = stage.stageWidth >> 1;
		private var centerY:int = stage.stageHeight >> 1;
		private var centerZ:int = 200;
		private var vertexList:Array = [];
		private var uvList:Array = [];
		private var vertexTranList:Array = [];
		private var polygonList:Array = [];
		private var vertexNormalList:Array = [];
		private var vertexColorList:Array = [];
		private var polygonState:Array = [];
		
		private var ambient:Light = new Light();
		private var parallel:Light = new Light();
		private var point:Light = new Light();
		
		private var tempColor1:Color = new Color();
		private var tempColor2:Color = new Color();
		private var tempColor3:Color = new Color();
		public function Test9TextureMapping()
		{
			super();
			stage.addChild(bmp);
			var p:SWPoint3D;
			var uv:Point;
			//------------------light--init----------------------
			//没有位置, 也没有方向
			ambient.ambient.hex = 0xFF00FF00;
			
			//没有位置, 只有方向
			parallel.diffuse.hex = 0xFFFF0000;
			parallel.dir.setTo(0, 0, 1);
			parallel.dir.normalize(parallel.dir);
			
			//点光源 没有方向, 只有位置
			point.diffuse.hex = 0xFF0000FF
			point.pos.setTo(centerX , centerY, 0);
			//------------------cube-----------------------------			
			var index:int = 0;
			p = new SWPoint3D(64, 64, -64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFFFF0000;
			uv = new Point(127, 0);
			uvList.push(uv);
			
			
			p = new SWPoint3D(-64, 64, -64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFF00FF00;
			uv = new Point(0, 0);
			uvList.push(uv);
			
			p = new SWPoint3D(-64, 64, 64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFF0000FF;
			uv = new Point(0, 127);
			uvList.push(uv);
			
			p = new SWPoint3D(64, 64, 64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFFFF0000;
			uv = new Point(127, 127);
			uvList.push(uv);
			
			p = new SWPoint3D(64, -64, -64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFF00FF00;
			uv = new Point(127, 127);
			uvList.push(uv);
			
			p = new SWPoint3D(-64, -64, -64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFF00000FF;
			uv = new Point(0, 127);
			uvList.push(uv);
			
			p = new SWPoint3D(-64, -64, 64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFFFF0000;
			uv = new Point(127, 127);
			uvList.push(uv);
			
			p = new SWPoint3D(64, -64, 64);
			vertexList.push(p);
			vertexColorList[index++] = 0xFF00FF00;
			uv = new Point(0, 127);
			uvList.push(uv);
			
			//			polygonList.push(
			//				2, 1, 0,
			//				3, 2, 0,
			//				4, 7, 0,
			//				7, 3, 0,
			//				6, 7, 4,
			//				5, 6, 4,
			//				2, 6, 1,
			//				6, 5, 1,
			//				7, 6, 3,
			//				6, 2, 3,
			//				5, 4, 0,
			//				1, 5, 0
			//			);
			
			polygonList.push(
//				4, 7, 0,
//				7, 3, 0,
				5, 4, 0,
				1, 5, 0
			)
			//				
			//			polygonList.push(
			//				2, 1, 0,
			//				3, 2, 0,
			//				4, 7, 0,
			//				7, 3, 0
			//			)
			//-------------------------------------------------------	
			for(var i:int = 0; i < polygonList.length / 3; i++)
			{
				polygonState[i] = 1;
			}
			//-------------------------------------------------------		
			
			for(i = 0; i < this.vertexList.length; i++)
			{
				this.vertexNormalList[i] = new VertexNormal();
				var p3D:SWPoint3D = this.vertexList[i];
				//				p3D.rotateY(0);
				//				p3D.rotateX(1);
				//				p3D.rotateZ(1);
			}
			
			this.initVetexNormal();
			this.hidingSide();
			this.fillTriangle();
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//--------------------------单片面测试------------------------------------
			
			//			stage.scaleMode = StageScaleMode.NO_SCALE;
			//			
			//			var p1:SWPoint3D = new SWPoint3D(0 + centerX, 0 + centerY);
			//			var p2:SWPoint3D = new SWPoint3D(127 + centerX, 0 + centerY);
			//			var p3:SWPoint3D = new SWPoint3D(0 + centerX, 127 + centerY);
			//			var p4:SWPoint3D = new SWPoint3D(127 + centerX, 127 + centerY);
			//			
			//			var uv1:Point = new Point(0, 0);
			//			var uv2:Point = new Point(127, 0);
			//			var uv3:Point = new Point(0, 127);
			//			var uv4:Point = new Point(127, 127);
			//			
			//			Utils.drawTriangle(tempColor1, tempColor2, tempColor3, p1, p2, p3, uv1, uv2, uv3, bmd, wall.bitmapData);
			//			Utils.drawTriangle(tempColor1, tempColor2, tempColor3, p2, p3, p4, uv2, uv3, uv4, bmd, wall.bitmapData);
		}
		
		private var count:int = 2;
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(count > 0)
			{
				count--;
				return;
			}else{
				count = 2;
			}
			
			var p3D:SWPoint3D;
			var i:int;
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
				{
					for(i = 0; i < this.vertexList.length; i++)
					{
						p3D = this.vertexList[i];
						p3D.rotateY(1);
						//						p3D.rotateX(1);
						//						p3D.rotateZ(1);
					}
					break;
				}
				case Keyboard.RIGHT:
				{
					for(i = 0; i < this.vertexList.length; i++)
					{
						p3D = this.vertexList[i];
						p3D.rotateY(-1);
						//						p3D.rotateX(1);
						//						p3D.rotateZ(1);
					}
					break;
				}
				default:
				{
					break;
				}
			}
			
			this.initVetexNormal();
			this.hidingSide();
			this.fillTriangle();
			
		}
		
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
				p3D.rotateY(1);
				//				p3D.rotateX(1);
				//				p3D.rotateZ(1);
			}
			
			this.initVetexNormal();
			this.hidingSide();
			this.fillTriangle();
		}
		
		public function initVetexNormal():void
		{
			for(var i:int = 0; i < this.vertexNormalList.length; i++)
			{
				this.vertexNormalList[i].reset();
			}
		}
		
		private function fillTriangle():void
		{
			bmd.fillRect(bmd.rect, 0xFF000000);
			for(var i:int = 0; i < this.polygonList.length - 2; i+=3)
			{
				if(!polygonState[i/3 >>0])
				{
					continue;
				}
				
				var op1:SWPoint3D = this.vertexList[this.polygonList[i]];
				var op2:SWPoint3D = this.vertexList[this.polygonList[i + 1]];
				var op3:SWPoint3D = this.vertexList[this.polygonList[i + 2]];
				
				var p1:SWPoint3D = this.convertToScreen(op1);
				var p2:SWPoint3D = this.convertToScreen(op2);
				var p3:SWPoint3D = this.convertToScreen(op3);
				
				var color:Number = 0.25 + ((i % this.polygonList.length) / this.polygonList.length) * 0.75;
				var colorU:uint = (color * 255) >> 0;
				var colorHex:uint = 0xff << 24 | colorU << 16 | colorU << 8 | colorU;
				colorHex = 0xFFFFFFFF;
				
				var cList:Array = this.illumination(this.polygonList[i], this.polygonList[i + 1], this.polygonList[i + 2], colorHex);
				var c1:Color = cList[0];
				var c2:Color = cList[1];
				var c3:Color = cList[2];
				
				var uv1:Point = this.uvList[this.polygonList[i]];
				var uv2:Point = this.uvList[this.polygonList[i + 1]];
				var uv3:Point = this.uvList[this.polygonList[i + 2]];
				
				Utils.drawTriangle(c1, c2, c3, p1, p2, p3, uv1, uv2, uv3, bmd, wall.bitmapData, colorHex);
			}
		}
		
		//背面剔除
		private var tempP1:SWPoint3D = new SWPoint3D();
		private var tempP2:SWPoint3D = new SWPoint3D();
		private var tempP3:SWPoint3D = new SWPoint3D();
		private var tempP4:SWPoint3D = new SWPoint3D();
		
		private var p1World:SWPoint3D = new SWPoint3D();
		private var p2World:SWPoint3D = new SWPoint3D();
		private var p3World:SWPoint3D = new SWPoint3D();
		// 视点
		private var camera:SWPoint3D = new SWPoint3D(centerX, centerY, 0);
		private function hidingSide():void
		{
			for(var i:int = 0; i < this.polygonList.length - 2; i += 3)
			{
				var p1:SWPoint3D = this.vertexList[this.polygonList[i]];
				var p2:SWPoint3D = this.vertexList[this.polygonList[i + 1]];
				var p3:SWPoint3D = this.vertexList[this.polygonList[i + 2]];
				//其实这个理没有必要用世界坐标计算, 因为p3world-p1world = p3 - p1;  p2world - p1world = p2 - p1;
				p1World.setTo(p1.x + centerX, p1.y + centerY, p1.z + centerZ);
				p2World.setTo(p2.x + centerX, p2.y + centerY, p2.z + centerZ);
				p3World.setTo(p3.x + centerX, p3.y + centerY, p3.z + centerZ);
				//计算平面的法向没必要归一化
				p2World.minus(p1World, tempP1);
				p3World.minus(p1World, tempP2);
				//				trace(tempP1, tempP2);
				//计算顶点法线, 这个法线应该保存下来, 供光照使用, 这个normal其实是世界坐标的
				var n:SWPoint3D = tempP2.cross(tempP1, tempP2);
				var vertexNormal:SWPoint3D = this.vertexNormalList[this.polygonList[i]].normal; 
				vertexNormal.plus(n, vertexNormal);
				this.vertexNormalList[this.polygonList[i]].count++;
				
				vertexNormal = this.vertexNormalList[this.polygonList[i + 1]].normal; 
				vertexNormal.plus(n, vertexNormal);
				this.vertexNormalList[this.polygonList[i + 1]].count++;
				
				vertexNormal = this.vertexNormalList[this.polygonList[i + 2]].normal; 
				vertexNormal.plus(n, vertexNormal);
				this.vertexNormalList[this.polygonList[i + 2]].count++;
				
				//求视点相对于p1的位置
				var view:SWPoint3D = camera.minus(p1World, tempP1);
				//求点积
				var dot:Number = n.dot(view);
				//				trace(n, view, dot);
				if( dot <= 0)
				{
					polygonState[i/3 >>0] = 0;
				}else{
					polygonState[i/3 >>0] = 1;
				}
			}
		}
		
		
		//光照计算
		private function illumination(i1:int, i2:int, i3:int, color:uint):Array
		{
			
			var dp:Number;
			var cosT:Number;
			var len:Number;
			var dist:Number;
			var attent:Number;
			
			//1. 取得物体面片的颜色
			var a:uint = color >> 24 & 0xFF; 
			var r:uint = color >> 16 & 0xFF;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			
			//2. 处理光照
			var rl1:uint = 0, gl1:uint = 0, bl1:uint = 0;
			var rl2:uint = 0, gl2:uint = 0, bl2:uint = 0;
			var rl3:uint = 0, gl3:uint = 0, bl3:uint = 0;
			
			//          //〇 用本来的颜色
			//			var rl1:uint = r1, gl1:uint = g1, bl1:uint = b1;
			//			var rl2:uint = r2, gl2:uint = g2, bl2:uint = b2;
			//			var rl3:uint = r3, gl3:uint = g3, bl3:uint = b3;
			
			//①. 处理环境光
			//颜色调制
			rl1 += ambient.ambient.red / 255 * r;
			bl1 += ambient.ambient.blue/ 255 * b;
			gl1 += ambient.ambient.green / 255 * g;
			
			rl2 += ambient.ambient.red / 255 * r;
			bl2 += ambient.ambient.blue/ 255 * b;
			gl2 += ambient.ambient.green / 255 * g;
			
			rl3 += ambient.ambient.red / 255 * r;
			bl3 += ambient.ambient.blue/ 255 * b;
			gl3 += ambient.ambient.green / 255 * g;
			
			//②. 处理无穷远光, 无关距离, 只跟方向有关
			//假设光源的方向是归一化的
			var n1:SWPoint3D = this.vertexNormalList[i1].getAverage(tempP1);
			var n2:SWPoint3D = this.vertexNormalList[i2].getAverage(tempP2);
			var n3:SWPoint3D = this.vertexNormalList[i3].getAverage(tempP3);
			
			//normal需要反向, 计算出的角度才是和光照同向的角度
			dp = parallel.dir.dot(n1.mult(-1, tempP4));
			if(dp > 0)
			{
				//这个光强跟夹角有关
				len = n1.magnitude();
				cosT = dp/len;
				rl1 += parallel.diffuse.red / 255 * r * cosT;
				bl1 += parallel.diffuse.blue/ 255 * b * cosT;
				gl1 += parallel.diffuse.green / 255 * g * cosT;
			}
			
			dp = parallel.dir.dot(n2.mult(-1, tempP4));
			if(dp > 0)
			{
				//这个光强跟夹角有关
				len = n2.magnitude();
				cosT = dp/len;
				rl2 += parallel.diffuse.red / 255 * r * cosT;
				bl2 += parallel.diffuse.blue/ 255 * b * cosT;
				gl2 += parallel.diffuse.green / 255 * g * cosT;
			}
			
			dp = parallel.dir.dot(n3.mult(-1, tempP4));
			if(dp > 0)
			{
				//这个光强跟夹角有关
				len = n3.magnitude();
				cosT = dp/len;
				rl3 += parallel.diffuse.red / 255 * r * cosT;
				bl3 += parallel.diffuse.blue/ 255 * b * cosT;
				gl3 += parallel.diffuse.green / 255 * g * cosT;
			}
			
			//			//③. 处理点光源
			//			var p1Local:SWPoint3D = this.vertexList[i1];
			//			p1World.setTo(p1Local.x + centerX, p1Local.y + centerY, p1Local.z + centerZ);
			//			var p2Local:SWPoint3D = this.vertexList[i2];
			//			p2World.setTo(p2Local.x + centerX, p2Local.y + centerY, p2Local.z + centerZ);
			//			var p3Local:SWPoint3D = this.vertexList[i3];
			//			p3World.setTo(p3Local.x + centerX, p3Local.y + centerY, p3Local.z + centerZ);
			//			
			//			var light:SWPoint3D = point.pos.minus(p1World, tempP1);//记住这里也要归一化
			//			dp = light.dot(n1);
			//			if(dp > 0){
			//				len = n1.magnitude();
			//				dist = light.magnitude();
			////				trace(light, normal, dp, dist);
			//				attent = (0.5 + 0.0001 * dist);
			////				trace(dist);
			//				//dp/len*dist 是归一化
			//				cosT = dp/(len * dist * attent);
			////				trace(cosT);
			//				rl1 += point.diffuse.red / 256 * r * cosT;
			//				bl1 += point.diffuse.blue/ 256 * b * cosT;
			//				gl1 += point.diffuse.green / 256 * g * cosT;
			//			}
			//			
			//			light = point.pos.minus(p2World, tempP1);
			//			dp = light.dot(n2);
			//			if(dp > 0){
			//				len = n2.magnitude();
			//				dist = light.magnitude();
			////				trace(light, normal, dp, dist);
			//				attent = (0.5 + 0.0001 * dist);
			////				trace(dist);
			//				//dp/len*dist 是归一化
			//				cosT = dp/(len * dist * attent);
			////				trace(cosT);
			//				rl2 += point.diffuse.red / 256 * r * cosT;
			//				bl2 += point.diffuse.blue/ 256 * b * cosT;
			//				gl2 += point.diffuse.green / 256 * g * cosT;
			//			}
			//			
			//			light = point.pos.minus(p3World, tempP1);
			//			dp = light.dot(n3);
			//			if(dp > 0){
			//				len = n3.magnitude();
			//				dist = light.magnitude();
			////				trace(light, normal, dp, dist);
			//				attent = (0.5 + 0.0001 * dist);
			////				trace(dist);
			//				//dp/len*dist 是归一化
			//				cosT = dp/(len * dist * attent);
			////				trace(cosT);
			//				rl3 += point.diffuse.red / 256 * r * cosT;
			//				bl3 += point.diffuse.blue/ 256 * b * cosT;
			//				gl3 += point.diffuse.green / 256 * g * cosT;
			//			}
			
			
			//3. 处理临界情况
			if(rl1 > 255) rl1 = 255;
			if(bl1 > 255) bl1 = 255;
			if(gl1 > 255) gl1 = 255;
			
			if(rl2 > 255) rl2 = 255;
			if(bl2 > 255) bl2 = 255;
			if(gl2 > 255) gl2 = 255;
			
			if(rl3 > 255) rl3 = 255;
			if(bl3 > 255) bl3 = 255;
			if(gl3 > 255) gl3 = 255;
			
			tempColor1.setRGBA(rl1, gl1, bl1);
			tempColor2.setRGBA(rl2, gl2, bl2);
			tempColor3.setRGBA(rl3, gl3, bl3);
			
			return [tempColor1, tempColor2, tempColor3];
		}
		
		private function convertToScreen(p3D:SWPoint3D):SWPoint3D
		{
			var p:SWPoint3D = new SWPoint3D();
			p.x = (p3D.x / (p3D.z + centerZ)) * centerX + centerX;;
			p.y = (-p3D.y / (p3D.z + centerZ)) * centerY + centerY;
			p.z = p3D.z;
			
			return p;
		}
	}
}
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import skywarp.version2.SWPoint3D;


class Utils
{
	public static function drawTriangle(c1:Color, c2:Color, c3:Color, 
										p1:SWPoint3D, p2:SWPoint3D, p3:SWPoint3D, 
										uv1:Point, uv2:Point, uv3:Point,
										bmd:BitmapData, texture:BitmapData, color:uint = 0):void
	{
		//1. 按y值排序 p1.y ≤ p2.y ≤ p3.y 
		var temp:SWPoint3D;
		var tempColor:Color;
		var tempUV:Point;
		
		if(p1.y > p2.y)
		{
			temp = p1;
			p1 = p2;
			p2 = temp;
			
			tempColor = c1;
			c1 = c2;
			c2 = tempColor;
			
			tempUV = uv1;
			uv1 = uv2;
			uv2 = tempUV;
		}
		
		if(p1.y > p3.y)
		{
			temp = p1;
			p1 = p3;
			p3 = temp;
			
			tempColor = c1;
			c1 = c3;
			c3 = tempColor;
			
			tempUV = uv1;
			uv1 = uv3;
			uv3 = tempUV;
		}
		
		if(p2.y > p3.y)
		{
			temp = p2;
			p2 = p3;
			p3 = temp;
			
			tempColor = c2;
			c2 = c3;
			c3 = tempColor;
			
			tempUV = uv2;
			uv2 = uv3;
			uv3 = tempUV;
		}
		
		//2.判断p2在p1p3的那一侧, 只比较x值是不够的
		//可以用直线的一般方程来判断, <0 在左侧, >0在右侧. 可用 y-x=0  y-2x=0  y-0.5x=0 这三条直线来检测
		//已知两点可求得直线的一般方程式, AX + BY + C = 0, (x1, y1), (x2, y2) 先用斜截式考虑飞0情况展开, 再考虑0的情况, 可求得
		// A = Y2 - Y1,  B = X1 - X2, C = X2*Y1 - X1*Y2
		// p1 => (x1, y1) , p3 => (x2, y2) 因为斜率是按照 p1计算的
		var a:Number = p3.y - p1.y;
		var b:Number = p1.x - p3.x;
		var c:Number = p3.x*p1.y - p1.x*p3.y;
		var result:Number = p2.x*a + p2.y*b + c;
		var y:int;
		if(result > 0)
		{
			//			trace("p2 at right of p1p3");
			for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
			{
				if(y < p2.y)
				{
					processScanLine(y, p1, p3, p1, p2, bmd, texture, c1, c3, c1, c2, uv1, uv3, uv1, uv2);
				}else
				{
					processScanLine(y, p1, p3, p2, p3, bmd, texture, c1, c3, c2, c3, uv1, uv3, uv2, uv3);//平顶 如果 p1.y == p2.y 直接就处理这里了, 精妙!
				}
			}
		}else
		{
			//			trace("p2 at left of p1p3");
			for(y = (p1.y >> 0) ; y <= (p3.y >> 0); y++)
			{
				if(y < p2.y)
				{
					processScanLine(y, p1, p2, p1, p3, bmd, texture, c1, c2, c1, c3, uv1, uv2, uv1, uv3);
				}else
				{
					processScanLine(y, p2, p3, p1, p3, bmd, texture, c2, c3, c1, c3, uv2, uv3, uv1, uv3);
				}
			}
		}
	}
	
	//处理扫描线
	//y表示当前处理的行值
	// pa, pb 是左边的线, pc, pd 是右边的线
	private static function processScanLine(y:int, pa:SWPoint3D, pb:SWPoint3D, pc:SWPoint3D, pd:SWPoint3D, 
											bmd:BitmapData, texture:BitmapData,
											ca:Color, cb:Color, cc:Color, cd:Color,
											uva:Point, uvb:Point, uvc:Point, uvd:Point):void
	{
		//这里的处理非常巧妙, 佩服佩服！！
		//先得到, 左边线的处理进度, 再得到右边线的处理进度
		var gradient1:Number = pa.y != pb.y ? (y - pa.y) / (pb.y - pa.y) : 1;
		var gradient2:Number = pc.y != pd.y ? (y - pc.y) / (pd.y - pc.y) : 1;
		
		var sx:int = interpolate(pa.x, pb.x, gradient1) >> 0;
		var ex:int = interpolate(pc.x, pd.x, gradient2) >> 0;
		
		var su:Number = interpolate(uva.x, uvb.x, gradient1);
		var eu:Number = interpolate(uvc.x, uvd.x, gradient2);
		
		var sv:Number = interpolate(uva.y, uvb.y, gradient1);
		var ev:Number = interpolate(uvc.y, uvd.y, gradient2);
		
		//		var scr:uint = interpolate(ca.red, cb.red, gradient1);
		//		var ecr:uint = interpolate(cc.red, cd.red, gradient2);
		//		
		//		var scg:uint = interpolate(ca.green, cb.green, gradient1);
		//		var ecg:uint = interpolate(cc.green, cd.green, gradient2);
		//		
		//		var scb:uint = interpolate(ca.blue, cb.blue, gradient1);
		//		var ecb:uint = interpolate(cc.blue, cd.blue, gradient2);
		
		// drawing a line from left (sx) to right (ex) 
		for(var x:int = sx; x < ex; x++) {
			
			var gradient:Number = (x - sx)/(ex - sx);
			
			//			var red:uint = interpolate(scr, ecr, gradient) >> 0;
			//			var green:uint = interpolate(scg, ecg, gradient) >> 0;
			//			var blue:uint = interpolate(scb, ecb, gradient) >> 0;
			//			var color:uint = red << 16 | green << 8 | blue;
			//			bmd.setPixel(x, y, color);
			
			var u:Number = interpolate(su, eu, gradient) >> 0;
			var v:Number = interpolate(sv, ev, gradient) >> 0;
			
			//			u = Math.abs(u % texture.width) >> 0;
			//			v = Math.abs(v % texture.width) >> 0;
			
			//			trace(u, v);
			//			bmd.copyPixels(texture, new Rectangle(u, v, 1, 1), new Point(x, y));
			bmd.setPixel(x, y, texture.getPixel(u,v));
		}
	}
	
	//gradient是一个0~1之间的数
	// p0 + (p1 - p0)*gradient
	private static function interpolate(p0:Number, p1:Number, gradient:Number):Number
	{
		return p0 + (p1 - p0)* clamp(gradient);
	}
	
	// Clamping values to keep them between 0 and 1
	private static function clamp(value:Number, min:Number = 0, max:Number = 1):Number
	{
		return Math.max(min, Math.min(value, max));
	}
}

class VertexNormal
{
	public var normal:SWPoint3D = new SWPoint3D();
	public var count:uint = 0;
	public function VertexNormal()
	{
		
	}
	
	public function getAverage(out:SWPoint3D = null):SWPoint3D
	{
		if(out == null)
		{
			out = new SWPoint3D();
		}
		
		out.setTo(normal.x / count, normal.y / count, normal.z / count);
		
		return out;
	}
	
	public function reset():void
	{
		this.normal.setTo(0, 0, 0);
		this.count = 0;
	}
}
/**
 *光源
 *  
 *  环境光, 点光源, 平行光 属性是不一样的
 * 
 * @author juli
 * 
 */
class Light
{
	//光源ID
	public var id:int;
	//各种光强, 每种光源都可以设置这3种光强, 光强会对物体进行颜色调制
	public var ambient:Color, diffuse:Color, specular:Color;
	//光源位置
	public var pos:SWPoint3D;
	//光源方向
	public var dir:SWPoint3D;
	
	public function Light()
	{
		ambient = new Color();
		diffuse = new Color();
		specular = new Color();
		
		pos = new SWPoint3D();
		dir = new SWPoint3D();
	}
}


/**
 *材质的反射光可以简单的理解为:
 * 反射系数 * 光强
 * 
 * 光强分为环境光ambient, 散色光diffuse, 反射光specular, 这个是光源的属性
 * 
 * 而反射系数又和自身的颜色相关
 *   
 * @author juli
 * 
 */
class Material
{
	//材质ID
	public var id:int;
	
	//反射系数
	public var ka:Number, kd:Number, ks:Number;
	
	public function Material()
	{
		
	}
}

class Color  
{
	private var mHex:uint;
	private var mA:uint;
	private var mR:uint;
	private var mG:uint;
	private var mB:uint;
	public function Color(...params)
	{
		if(params.length == 1)
		{
			mHex = params[0];
			this.separateColor();
		}else if(params.length == 3)
		{
			mA = 0xff;
			mR = params[0];
			mG = params[1];
			mB = params[2];
			this.combineColor();
		}else if(params.length == 4)
		{
			mA = params[0];
			mR = params[1];
			mG = params[2];
			mB = params[3];
			this.combineColor();
		}
	}
	
	public function setRGBA(r:uint, g:uint, b:uint, a:uint = 0xFF):void
	{
		this.mA = a;
		this.mR = r;
		this.mG = g;
		this.mB = b;
		
		this.combineColor();
	}
	
	public function removeAlpha():uint
	{
		mHex = mR << 16 | mG << 8 | mB;
		return mHex;
	}
	
	public function get red():uint
	{
		return this.mR;
	}
	public function get green():uint
	{
		return this.mG;
	}
	public function get blue():uint
	{
		return this.mB;
	}
	public function get alpha():uint
	{
		return this.mA;
	}
	
	public function set hex(c:uint):void
	{
		mHex = c;
		this.separateColor();
	}
	
	public function get hex():uint
	{
		return mHex;	
	}
	
	private function combineColor():void
	{
		mHex = mA << 24 | mR << 16 | mG << 8 | mB;
	}
	
	private function separateColor():void
	{
		mA = mHex >> 24 & 0xff;
		mR = mHex >> 16 & 0xff;
		mG = mHex >> 8 & 0xff;
		mB = mHex & 0xff;
	}
}