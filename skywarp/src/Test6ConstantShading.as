package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import skywarp.version2.SWPoint3D;
	import skywarp.version2.SWUtils;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	/**
	 * 固定着色
	 * 固定着色不考虑任何光照效果, 只是用某种颜色填充多边形
	 *  
	 */	
	public class Test6ConstantShading extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800, 600);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var centerX:int = stage.stageWidth >> 1;
		private var centerY:int = stage.stageHeight >> 1;
		private var centerZ:int = 200;
		private var vertexList:Array = [];
		private var vertexTranList:Array = [];
		private var polygonList:Array = [];
		private var polygonState:Array = [];
		public function Test6ConstantShading()
		{
			super();
			stage.addChild(bmp);
			var p:SWPoint3D;
//			SWUtils.setZBuffer(bmd);
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
			
			vertexTranList = vertexList.concat();
			
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
			}
//-------------------------------------------------------			
//			this.hidingSide();
//			this.drawWrieframe();
//			this.fillTriangle();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
				p3D.rotateY(1);
				p3D.rotateX(1);
//				p3D.rotateZ(1);
			}
			this.hidingSide();
//			this.drawWrieframe();
			this.fillTriangle();
		}
		
		private function drawWrieframe():void
		{
			bmd.fillRect(bmd.rect, 0xff000000);
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
			bmd.fillRect(bmd.rect, 0xffffffff);
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
				
				SWUtils.drawTriangle(p1, p2, p3, bmd, colorHex);
			}
		}
		
		//背面剔除
		private var tempP1:SWPoint3D = new SWPoint3D();
		private var tempP2:SWPoint3D = new SWPoint3D();
		private var p1World:SWPoint3D = new SWPoint3D();
		private var p2World:SWPoint3D = new SWPoint3D();
		private var p3World:SWPoint3D = new SWPoint3D();
		// 视点, 也就是相机方向是(0,0,1)
		private var camera:SWPoint3D = new SWPoint3D(centerX, centerY,0);
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
				//计算平面的法向没必要归一化, 因为只算方向, 注意顶点旋转顺序采用右手法则
				p2World.minus(p1World, tempP1);
				p3World.minus(p1World, tempP2);
				//				trace(tempP1, tempP2);
				var n:SWPoint3D = tempP2.cross(tempP1, tempP2);
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