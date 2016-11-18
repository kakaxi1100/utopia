package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import vo.td.CPoint3D;
	import vo.td.EulerCamera;
	import vo.td.Polygon;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="0x000000")]
	public class ThreeDDome extends Sprite
	{
		//顶点列表
		private var vlist:Vector.<CPoint3D> = new Vector.<CPoint3D>();
		
		//局部坐标
		private var p1:CPoint3D = new CPoint3D(0,50,0);
		private var p2:CPoint3D = new CPoint3D(50,-50,0);
		private var p3:CPoint3D = new CPoint3D(-50,-50,0);
		//世界坐标
		private var worldPos:CPoint3D = new CPoint3D(300,200,100);
		
		//多边形
		private var polygon:Polygon;
		//相机
		private var camera:EulerCamera;
		
		public function ThreeDDome()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.align = StageAlign.TOP_LEFT;
			
			//初始化
			vlist.push(p1, p2, p3);
			polygon = new Polygon(vlist,0,1,2);
			camera = new EulerCamera();
			camera.pos.x = 0;
			camera.pos.y = 0;
			camera.pos.z = 0;
			//复制原始坐标到变换坐标
			polygon.cloneVToTransV();
//			//局部--->世界
//			transforToWorld();
//			//世界--->相机
//			transforToCamera();
//			//相机--->透视╮
//			//		  	  ﹜此两步合为一步
//			//透视--->屏幕 ╯
//			persProject();
			
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					worldPos.y -= 3;
					break;
				case Keyboard.DOWN:
					worldPos.y += 3;
					break;
				case Keyboard.LEFT:
					worldPos.x -= 3;
					break;
				case Keyboard.RIGHT:
					worldPos.x += 3;
					break;
				case Keyboard.A:
					worldPos.z -= 1;
					break;
				case Keyboard.D:
					worldPos.z += 1;
					break;
				case Keyboard.E:
					camera.dir.x -= 1;
					break;
				case Keyboard.Q:
					camera.dir.x += 1;
					break;
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			//渲染多边形
			this.graphics.clear();
			this.graphics.lineStyle(2, 0xff000);
			polygon.draw(this.graphics);
			rotationY();
			//3D流水线再来一遍
			transforToWorld();
			transforToCamera();
			persProject();
		}
		
		private function rotationY():void
		{
			for each(var p:CPoint3D in polygon.vlist)
			{
				p.rotateY(1);	
			}
		}
		
		private function transforToWorld():void
		{
			polygon.tvlist[0].x = polygon.vlist[0].x + worldPos.x;
			polygon.tvlist[0].y = polygon.vlist[0].y + worldPos.y;
			polygon.tvlist[0].z = polygon.vlist[0].z + worldPos.z;
			
			polygon.tvlist[1].x = polygon.vlist[1].x + worldPos.x;
			polygon.tvlist[1].y = polygon.vlist[1].y + worldPos.y;
			polygon.tvlist[1].z = polygon.vlist[1].z + worldPos.z;
			
			polygon.tvlist[2].x = polygon.vlist[2].x + worldPos.x;
			polygon.tvlist[2].y = polygon.vlist[2].y + worldPos.y;
			polygon.tvlist[2].z = polygon.vlist[2].z + worldPos.z;
		}
		private function transforToCamera():void
		{
			//平移
			polygon.tvlist[0].x -= camera.pos.x;
			polygon.tvlist[0].y -= camera.pos.y;
			polygon.tvlist[0].z -= camera.pos.z;
			
			polygon.tvlist[1].x -= camera.pos.x;
			polygon.tvlist[1].y -= camera.pos.y;
			polygon.tvlist[1].z -= camera.pos.z;
			
			polygon.tvlist[2].x -= camera.pos.x;
			polygon.tvlist[2].y -= camera.pos.y;
			polygon.tvlist[2].z -= camera.pos.z;
			//旋转
			polygon.tvlist[0].rotateXYZ(camera.dir.x, camera.dir.y, camera.dir.z);
			polygon.tvlist[1].rotateXYZ(camera.dir.x, camera.dir.y, camera.dir.z);
			polygon.tvlist[2].rotateXYZ(camera.dir.x, camera.dir.y, camera.dir.z);
		}
		
		private function persProject():void
		{
			for each(var p:CPoint3D in polygon.tvlist)
			{
				p.x *= 320/(320 + p.z);
				p.y *= 320/(320 + p.z);
				p.z = 0;
			}
		}
	}
}