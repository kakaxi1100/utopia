package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import file.ParseString;
	
	import vo.td.CPoint3D;
	import vo.td.EulerCamera;
	import vo.td.Objective;
	import vo.td.Polygon;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0x000000")]
	public class Wireframe extends Sprite
	{
		private var uloader:URLLoader;
		private var fileLines:Array;
		private var cube:Objective;
		//相机
		private var camera:EulerCamera;
		//世界坐标
		private var worldPos:CPoint3D = new CPoint3D(300,200,200);
		public function Wireframe()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.graphics.lineStyle(1, 0xff000);
			
			var request:URLRequest = new URLRequest("configs/cube1.plg");
			uloader = new URLLoader();
			uloader.addEventListener(Event.COMPLETE, onLoaderComplete);
			uloader.load(request);
			
			//初始化
			cube = new Objective();
			camera = new EulerCamera(new CPoint3D(), new CPoint3D());
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var s:String = uloader.data as String;
			trace(s);
			var arr:Array = ParseString.getTrimLines(s);
			//start parse
			var index:int = 0;
			var i:int;
			//1.info
			var line:Array = (arr[index++] as String).split(" ");
			line[0] = ParseString.trim(line[0]);//name
			line[1] = ParseString.trim(line[1]);//vertexs
			line[2] = ParseString.trim(line[2]);//polygons
			cube.name = line[0];
			cube.vertexsNum = parseInt(line[1]);
			cube.polysNum = parseInt(line[2]);
			//2.local vertexs
			for(i = 0; i < cube.vertexsNum; i++)
			{
				line = arr[index++].split(" ");
				line[0] = ParseString.trim(line[0]);//mx
				line[1] = ParseString.trim(line[1]);//my
				line[2] = ParseString.trim(line[2]);//mz
				
				var p:CPoint3D = new CPoint3D(parseInt(line[0]), parseInt(line[1]), parseInt(line[2]));
				cube.vlist[i] = p;
			}
			//local vertexs--> trans vertexs
			//因为polygon不需要tvertexs列表了,它的数据来自于object的trans vertexs 列表
			cube.vertexLocalToTrans();
			//3.polygon list
			for(i = 0; i < cube.polysNum; i++)
			{
				line = arr[index++].split(" ");
				line[0] = ParseString.trim(line[0]);//description (no use now)
				line[1] = ParseString.trim(line[1]);//polygon vertexs
				line[2] = ParseString.trim(line[2]);//polygon vertex indexs
				line[3] = ParseString.trim(line[3]);//polygon vertex indexs
				line[4] = ParseString.trim(line[4]);//polygon vertex indexs
				
				line[0] = parseInt(line[0], 16);
				line[1] = parseInt(line[1]);
				line[2] = parseInt(line[2]);
				line[3] = parseInt(line[3]);
				line[4] = parseInt(line[4]);
				
				var polygon:Polygon = new Polygon(cube.tvlist, line[2], line[3], line[4]);
				cube.plist[i] = polygon;
			}
			
			index = 0;
			//end parse
			//---------------------------------------------			
			//			//start render
			//			//local vertexs--> trans vertexs
			//			cube.vertexLocalToTrans();
			//			//local-->global
			//			transforToWorld();
			//			//global-->camera
			//			transforToCamera();
			//			//camera-->screen
			//			persProject();
			//			//render
			//			cube.draw(this.graphics);
			//------------------------------------------
			stage.addEventListener(Event.EXIT_FRAME, onEnterframe);
		}
		
		protected function onEnterframe(event:Event):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(2, 0xff000);
			//start render
			//local vertexs--> trans vertexs
			cube.vertexLocalToTrans();
			//moving
			rotation();
			//local-->global
			transforToWorld();
			//global-->camera
			transforToCamera();
			//camera-->screen
			persProject();
			//render
			cube.draw(this.graphics);
		}
		
		private function transforToWorld():void
		{
			for(var i:int = 0; i < cube.tvlist.length; i++)
			{
				cube.tvlist[i].x += worldPos.x;
				cube.tvlist[i].y += worldPos.y;
				cube.tvlist[i].z += worldPos.z;
			}
		}
		
		private function transforToCamera():void
		{
			var i:int = 0;
			for(i = 0; i < cube.tvlist.length; i++)
			{
				//平移
				cube.tvlist[i].x -= camera.pos.x;
				cube.tvlist[i].y -= camera.pos.y;
				cube.tvlist[i].z -= camera.pos.z;
				//旋转
				cube.tvlist[i].rotateXYZ(camera.dir.x, camera.dir.y, camera.dir.z);
			}
			
		}
		
		private function persProject():void
		{
			for(var i:int = 0; i < cube.tvlist.length; i++)
			{
				cube.tvlist[i].x *= 320/(320 + cube.tvlist[i].z);
				cube.tvlist[i].y *= 320/(320 + cube.tvlist[i].z)*640/480;
				cube.tvlist[i].z = 0;
			}
		}
		
		private function rotation():void
		{
			var rand1:Number = Math.random()*3;
			var rand2:Number = Math.random()*3;
			var rand3:Number = Math.random()*3;
			
			for(var i:int = 0; i < cube.tvlist.length; i++)
			{
				cube.vlist[i].rotateXYZ(rand1,rand2,rand3);
			}
		}
	}
//--------------------立方体线框绕轴运动---------------------------------------------------------------		
//		private var uloader:URLLoader;
//		private var fileLines:Array;
//		private var cube:Objective;
//		//相机
//		private var camera:EulerCamera;
//		//世界坐标
//		private var worldPos:CPoint3D = new CPoint3D(300,200,200);
//		public function Wireframe()
//		{
//			super();
//			
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			this.graphics.lineStyle(2, 0xff000);
//			
//			var request:URLRequest = new URLRequest("configs/cube1.plg");
//			uloader = new URLLoader();
//			uloader.addEventListener(Event.COMPLETE, onLoaderComplete);
//			uloader.load(request);
//			
//			//初始化
//			cube = new Objective();
//			camera = new EulerCamera(new CPoint3D(), new CPoint3D());
//		}
//		
//		protected function onLoaderComplete(event:Event):void
//		{
//			var s:String = uloader.data as String;
//			trace(s);
//			var arr:Array = ParseString.getTrimLines(s);
//			//start parse
//			var index:int = 0;
//			var i:int;
//			//1.info
//			var line:Array = (arr[index++] as String).split(" ");
//			line[0] = ParseString.trim(line[0]);//name
//			line[1] = ParseString.trim(line[1]);//vertexs
//			line[2] = ParseString.trim(line[2]);//polygons
//			cube.name = line[0];
//			cube.vertexsNum = parseInt(line[1]);
//			cube.polysNum = parseInt(line[2]);
//			//2.local vertexs
//			for(i = 0; i < cube.vertexsNum; i++)
//			{
//				line = arr[index++].split(" ");
//				line[0] = ParseString.trim(line[0]);//mx
//				line[1] = ParseString.trim(line[1]);//my
//				line[2] = ParseString.trim(line[2]);//mz
//				
//				var p:CPoint3D = new CPoint3D(parseInt(line[0]), parseInt(line[1]), parseInt(line[2]));
//				cube.vlist[i] = p;
//			}
//			//local vertexs--> trans vertexs
//			//因为polygon不需要tvertexs列表了,它的数据来自于object的trans vertexs 列表
//			cube.vertexLocalToTrans();
//			//3.polygon list
//			for(i = 0; i < cube.polysNum; i++)
//			{
//				line = arr[index++].split(" ");
//				line[0] = ParseString.trim(line[0]);//description (no use now)
//				line[1] = ParseString.trim(line[1]);//polygon vertexs
//				line[2] = ParseString.trim(line[2]);//polygon vertex indexs
//				line[3] = ParseString.trim(line[3]);//polygon vertex indexs
//				line[4] = ParseString.trim(line[4]);//polygon vertex indexs
//				
//				line[0] = parseInt(line[0], 16);
//				line[1] = parseInt(line[1]);
//				line[2] = parseInt(line[2]);
//				line[3] = parseInt(line[3]);
//				line[4] = parseInt(line[4]);
//				
//				var polygon:Polygon = new Polygon(cube.tvlist, line[2], line[3], line[4]);
//				cube.plist[i] = polygon;
//			}
//			
//			index = 0;
//			//end parse
////---------------------------------------------			
////			//start render
////			//local vertexs--> trans vertexs
////			cube.vertexLocalToTrans();
////			//local-->global
////			transforToWorld();
////			//global-->camera
////			transforToCamera();
////			//camera-->screen
////			persProject();
////			//render
////			cube.draw(this.graphics);
////------------------------------------------
//			stage.addEventListener(Event.EXIT_FRAME, onEnterframe);
//		}
//		
//		protected function onEnterframe(event:Event):void
//		{
//			this.graphics.clear();
//			this.graphics.lineStyle(2, 0xff000);
//			//start render
//			//local vertexs--> trans vertexs
//			cube.vertexLocalToTrans();
//			//moving
//			rotation();
//			//local-->global
//			transforToWorld();
//			//global-->camera
//			transforToCamera();
//			//camera-->screen
//			persProject();
//			//render
//			cube.draw(this.graphics);
//		}
//		
//		private function transforToWorld():void
//		{
//			for(var i:int = 0; i < cube.tvlist.length; i++)
//			{
//				cube.tvlist[i].x += worldPos.x;
//				cube.tvlist[i].y += worldPos.y;
//				cube.tvlist[i].z += worldPos.z;
//			}
//		}
//		
//		private function transforToCamera():void
//		{
//			var i:int = 0;
//			for(i = 0; i < cube.tvlist.length; i++)
//			{
//				//平移
//				cube.tvlist[i].x -= camera.pos.x;
//				cube.tvlist[i].y -= camera.pos.y;
//				cube.tvlist[i].z -= camera.pos.z;
//				//旋转
//				cube.tvlist[i].rotateXYZ(camera.dir.x, camera.dir.y, camera.dir.z);
//			}
//			
//		}
//		
//		private function persProject():void
//		{
//			for(var i:int = 0; i < cube.tvlist.length; i++)
//			{
//				cube.tvlist[i].x *= 320/(320 + cube.tvlist[i].z);
//				cube.tvlist[i].y *= 320/(320 + cube.tvlist[i].z)*640/480;
//				cube.tvlist[i].z = 0;
//			}
//		}
//		
//		private function rotation():void
//		{
//			var rand1:Number = Math.random()*3;
//			var rand2:Number = Math.random()*3;
//			var rand3:Number = Math.random()*3;
//
//			for(var i:int = 0; i < cube.tvlist.length; i++)
//			{
//				cube.vlist[i].rotateXYZ(rand1,rand2,rand3);
//			}
//		}
//	}
//------------------------------------------------------------------------
}