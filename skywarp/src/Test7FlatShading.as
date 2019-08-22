package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import skywarp.version2.SWPoint3D;
	import skywarp.version2.SWUtils;

	/**
	 *
	 * 采用左手坐标系
	 * 
	 * 物体光照处理, 用的是恒定着色 flatShading
	 * 
	 * 	光照处理应该在 局部坐标到世界坐标转换之后, 透视坐标转换之前
	 * 	由于光照也需要计算面法线, 所以光照计算可以处理的位置可以放在:
	 * 
	 * 方法一：
	 * 	将 背面消除和光照计算合并在一起
	 * 方法二:
	 * 	分开计算背面消除和光照计算
	 * 方法三:
	 * 	在背面消除的时候, 存储法线, 然后供自后的光照计算使用
	 *  
	 * @author juli
	 * 
	 */	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class Test7FlatShading extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800, 600, false, 0);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var centerX:int = stage.stageWidth >> 1;
		private var centerY:int = stage.stageHeight >> 1;
		private var centerZ:int = 200;
		private var vertexList:Array = [];
		private var vertexTranList:Array = [];
		private var polygonList:Array = [];
		private var normalList:Array = [];
		private var polygonState:Array = [];
		
		private var ambient:Light = new Light();
		private var parallel:Light = new Light();
		private var point:Light = new Light();
		
		private var tempColor:Color = new Color();
		public function Test7FlatShading()
		{
			super();
			stage.addChild(bmp);
			var p:SWPoint3D;
//			SWUtils.setZBuffer(bmd);
//------------------light--init----------------------
			//没有位置, 也没有方向
			ambient.ambient.hex = 0xFF000000;
			
			//没有位置, 只有方向
			parallel.diffuse.hex = 0xFFFF0000;
			parallel.dir.setTo(0, 0, 1);
			
			//点光源 没有方向, 只有位置
			point.diffuse.hex = 0xFF0000FF
			point.pos.setTo(centerX , centerY, 0);
//------------------cube-----------------------------			
			p = new SWPoint3D(50, 50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, 50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, 50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, 50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, -50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, -50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, -50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, -50, 50);
			vertexList.push(p);
			
//			vertexTranList = vertexList.concat();
			
			polygonList.push(
				2, 1, 0,
				3, 2, 0,
				4, 7, 0,
				7, 3, 0,
				6, 7, 4,
				5, 6, 4,
				2, 6, 1,
				6, 5, 1,
				7, 6, 3,
				6, 2, 3,
				5, 4, 0,
				1, 5, 0
			);
			
//			polygonList.push(
//				5, 4, 0,
//				1, 5, 0
//			)
//				
//			polygonList.push(
//				1, 5, 0,
//				7, 3, 0
//			)
//------------------tank------------------------------		
			//tank有一些三角形应该是双面都可以显示的, 所以运行这个看起来有点怪异
//			p = new SWPoint3D(-30, 50, 90);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(30, 50, 90);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(20, 20, -40);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-20, 20, -40);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-20, 20, 80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(20, 20, 80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-20, 60, 50);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(20, 60, 50);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-25, 50, 30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(25, 50, 30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-40, 30, 100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-30, 10, -100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-70, 0, 30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-70, 0, 80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(40, 30, 100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(70, 0, 80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(70, 0, 30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(30, 10, -100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(0, 70, 70);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(0, 70, -20);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(0, 90, 100);
//			vertexList.push(p);
//			
//			polygonList.push(2, 9, 1, 
//				2, 1, 5,
//				1, 0, 4,
//				1, 4, 5,
//				0, 8, 3,
//				0, 3, 4,
//				2, 3, 8,
//				2, 8, 9,
//				6, 7, 9,
//				6, 9, 8,
//				0, 1, 7,
//				0, 7, 6,
//				0, 6, 8,
//				1, 9, 7,
//				10, 11, 12,
//				10, 12, 13,
//				14, 15, 16,
//				14, 16, 17,
//				20, 19, 18);
//-------------------------------------------------------	
			for(var i:int = 0; i < polygonList.length / 3; i++)
			{
				polygonState[i] = 1;
				normalList[i] = new SWPoint3D();
			}
//-------------------------------------------------------		
			
			for(i = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
//				p3D.rotateY(45);
//				p3D.rotateX(1);
//				p3D.rotateZ(1);
			}
			
			this.hidingSide();
//			this.drawWrieframe();
			this.fillTriangle();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
				p3D.rotateY(1);
//				p3D.rotateX(1);
				p3D.rotateZ(1);
			}
			this.hidingSide();
//			this.drawWrieframe();
			this.fillTriangle();
		}
		
		private function drawWrieframe():void
		{
			bmd.fillRect(bmd.rect, 0xFF000000);
			SWUtils.clearZBuffer();
			for(var i:int = 0; i < this.polygonList.length - 2; i+=3)
			{
				if(!polygonState[i/3 >>0])
				{
					continue;
				}
				var p1:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i]]);
				var p2:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 1]]);
				var p3:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 2]]);
				
				var color:Number = 0.25 + ((i % this.polygonList.length) / this.polygonList.length) * 0.75;
				var colorU:uint = (color * 255) >> 0;
				var colorHex:uint = 0xff << 24 | colorU << 16 | colorU << 8 | colorU;
				
				SWUtils.DrawLine(bmd, p1, p2, colorHex);
				SWUtils.DrawLine(bmd, p2, p3, colorHex);
				SWUtils.DrawLine(bmd, p3, p1, colorHex);
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
				var p1:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i]]);
				var p2:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 1]]);
				var p3:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 2]]);
				var color:Number = 0.25 + ((i % this.polygonList.length) / this.polygonList.length) * 0.75;
				var colorU:uint = (color * 255) >> 0;
				var colorHex:uint = 0xff << 24 | colorU << 16 | colorU << 8 | colorU;
//				colorHex = 0xFFFFFFFF;
				//物体本身的color:ColorHex
				//执行光照计算计算出正确的color
				var p1Local:SWPoint3D = this.vertexList[this.polygonList[i]];
				p1World.setTo(p1Local.x + centerX, p1Local.y + centerY, p1Local.z + centerZ);
				var realColor:uint = this.illumination(this.normalList[i/3>>0], colorHex, p1World).hex;
				
				SWUtils.drawTriangle(p1, p2, p3, bmd, realColor);
			}
		}
		
		//背面剔除
		private var tempP1:SWPoint3D = new SWPoint3D();
		private var tempP2:SWPoint3D = new SWPoint3D();
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
				//计算法线, 这个法线应该保存下来, 供光照使用, 这个normal其实是世界坐标的
				var n:SWPoint3D = tempP2.cross(tempP1, tempP2);
				(normalList[i/3 >> 0] as SWPoint3D).setTo(n.x, n.y, n.z);
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
		private function illumination(normal:SWPoint3D, hex:uint = 0,  p1:SWPoint3D = null):Color
		{
			//1. 得到物体本身的颜色分量
			var a:uint = hex >> 24 & 0xff;
			var r:uint = hex >> 16 & 0xff;
			var g:uint = hex >> 8 & 0xff;
			var b:uint = hex & 0xff;
						
			//2. 处理光照
			var rl:uint, gl:uint, bl:uint;
			//①. 处理环境光
			//颜色调制
			rl += ambient.ambient.red / 256 * r;
			bl += ambient.ambient.blue/ 256 * b;
			gl += ambient.ambient.green / 256 * g;
			
			//②. 处理无穷远光, 无关距离, 只跟方向有关
			//假设光源的方向是归一化的
			var len:Number = normal.magnitude();
			//normal需要反向, 计算出的角度才是和光照同向的角度
			var dp:Number = parallel.dir.dot(normal.mult(-1, tempP1));
			if(dp > 0)
			{
				//这个光强跟夹角有关
				var cosT:Number = dp/len;
				rl += parallel.diffuse.red / 256 * r * cosT;
				bl += parallel.diffuse.blue/ 256 * b * cosT;
				gl += parallel.diffuse.green / 256 * g * cosT;
			}
			
			//③. 处理点光源
			var light:SWPoint3D = point.pos.minus(p1, tempP1);//记住这里也要归一化
			dp = light.dot(normal);
			if(dp > 0){
				var dist:Number = light.magnitude();
//				trace(light, normal, dp, dist);
				var attent:Number = (0.5 + 0.0001 * dist);
//				trace(dist);
				//dp/len*dist 是归一化
				cosT = dp/(len * dist * attent);
//				trace(cosT);
				rl += point.diffuse.red / 256 * r * cosT;
				bl += point.diffuse.blue/ 256 * b * cosT;
				gl += point.diffuse.green / 256 * g * cosT;
			}
			
			
			//3. 处理临界情况
			if(rl > 255) rl = 255;
			if(bl > 255) bl = 255;
			if(gl > 255) gl = 255;
			
			tempColor.setRGBA(rl, gl, bl);
			
			return tempColor;
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
import skywarp.version2.SWPoint3D;

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