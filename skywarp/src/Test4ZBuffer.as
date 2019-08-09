package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import skywarp.version2.SWPoint3D;
	import skywarp.version2.SWUtils;
	
	[SWF(width="100", height="100", frameRate="30", backgroundColor="0xcccccc")]
	public class Test4ZBuffer extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800, 600);
		private var bmp:Bitmap = new Bitmap(bmd);
		private var centerX:int = stage.stageWidth >> 1;
		private var centerY:int = stage.stageHeight >> 1;
		private var centerZ:int = 200;
		private var vertexList:Array = [];
		private var polygonList:Array = [];
		public function Test4ZBuffer()
		{
			super();
			stage.addChild(bmp);
			var p:SWPoint3D;
			SWUtils.setZBuffer(bmd);
//------------------cube-----------------------------			
			p = new SWPoint3D(50, 50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, 50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, 50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, 50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, -50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, -50, 50);
			vertexList.push(p);
			
			p = new SWPoint3D(-50, -50, -50);
			vertexList.push(p);
			
			p = new SWPoint3D(50, -50, -50);
			vertexList.push(p);
			
			polygonList.push(2, 1, 0,
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
							1, 5, 0);
			
//------------------tank------------------------------			
//			p = new SWPoint3D(-30, 50, -90);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(30, 50, -90);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(20, 20, 40);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-20, 20, 40);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-20, 20, -80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(20, 20, -80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-20, 60, -50);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(20, 60, -50);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-25, 50, -30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(25, 50, -30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-40, 30, -100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-30, 10, 100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-70, 0, -30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(-70, 0, -80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(40, 30, -100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(70, 0, -80);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(70, 0, -30);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(30, 10, 100);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(0, 70, -70);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(0, 70, 20);
//			vertexList.push(p);
//			
//			p = new SWPoint3D(0, 90, -100);
//			vertexList.push(p);
//			
//			polygonList.push(2, 9, 1, 
//							 2, 1, 5,
//							 1, 0, 4,
//							 1, 4, 5,
//							 0, 8, 3,
//							 0, 3, 4,
//							 2, 3, 8,
//							 2, 8, 9,
//							 6, 7, 9,
//							 6, 9, 8,
//							 0, 1, 7,
//							 0, 7, 6,
//							 0, 6, 8,
//							 1, 9, 7,
//							 10, 11, 12,
//							 10, 12, 13,
//							 14, 15, 16,
//							 14, 16, 17,
//							 20, 19, 18);
//-------------------------------------------------------			
			this.drawWrieframe();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < this.vertexList.length; i++)
			{
				var p3D:SWPoint3D = this.vertexList[i];
				p3D.rotateY(1);
				p3D.rotateX(1);
				p3D.rotateZ(1);
			}
			this.drawWrieframe();
		}
		
		private function drawWrieframe():void
		{
			bmd.fillRect(bmd.rect, 0xffffffff);
			SWUtils.clearZBuffer();
			for(var i:int = 0; i < this.polygonList.length - 2; i+=3)
			{
//				trace(i, this.polygonList.length);
//				var p1:Point = this.convertToScreen(this.vertexList[this.polygonList[i]]);
//				var p2:Point = this.convertToScreen(this.vertexList[this.polygonList[i + 1]]);
//				var p3:Point = this.convertToScreen(this.vertexList[this.polygonList[i + 2]]);
				
				var p1:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i]]);
				var p2:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 1]]);
				var p3:SWPoint3D = this.convertToScreen(this.vertexList[this.polygonList[i + 2]]);
								
//				var color = 0.25 + ((indexFaces % cMesh.Faces.length) / cMesh.Faces.length) * 0.75;
				if( i % 2 == 0){
					SWUtils.drawTriangle(p1, p2, p3, bmd, 0x7700ff00);
				}else{
					SWUtils.drawTriangle(p1, p2, p3, bmd, 0x77ffff00);
				}
				
//				SWUtils.DrawLine(bmd, p1, p2, 0xffff0000);
//				SWUtils.DrawLine(bmd, p2, p3, 0xffff0000);
//				SWUtils.DrawLine(bmd, p1, p2, 0xffff0000);
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