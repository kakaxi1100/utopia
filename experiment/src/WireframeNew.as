package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import vo.Base;
	import vo.td.CPoint3D;
	import vo.td.EulerCamera;
	import vo.td.Objective;
	import vo.td.Polygon;
	import vo.td.PolygonStates;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0xcccccc")]
	public class WireframeNew extends Sprite
	{
		private var uloader:URLLoader;
		private var back:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
		private var object3D:Objective;
		
		private var worldPos:CPoint3D = new CPoint3D(0,0,400);
		private var camera:EulerCamera = new EulerCamera(new CPoint3D(0,200,0), new CPoint3D(0,0,0));
		
		public function WireframeNew()
		{
			super();
			Base.worldCenterX = stage.stageWidth >> 1;
			Base.worldCenterY = stage.stageHeight >> 1;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.BOTTOM_RIGHT;
			
			//将0点坐标变为左下角
			back.scaleY = -1;
			back.y += back.height;
			addChild(back);
			
			var request:URLRequest = new URLRequest("configs/cube2.plg");
			uloader = new URLLoader();
			uloader.addEventListener(Event.COMPLETE, onLoaderComplete);
			uloader.load(request);
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var s:String = uloader.data as String;
			trace(s);
			object3D = Base.parseObjective(s);
			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			onEnterFrame(null);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode){
				case Keyboard.LEFT:
					camera.dir.y += 1;
					break;
				case Keyboard.RIGHT:
					camera.dir.y -= 1;
					break;
				case Keyboard.UP:
					camera.dir.x += 1;
					break;
				case Keyboard.DOWN:
					camera.dir.x -= 1;
					break;
				case Keyboard.PAGE_DOWN:
					camera.dir.z -= 1;
					break;
				case Keyboard.PAGE_UP:
					camera.dir.z += 1;
					break;
				case Keyboard.SPACE:
					rotationSelf();
					onEnterFrame(null);
					return;
			}
			pipeline();
		}
		
		protected function onEnterFrame(event:Event):void
		{
//			rotationSelf();
			pipeline();
			Base.drawLineXY(camera.pos.x, camera.pos.y, 
				object3D.plist[0].vlist[object3D.plist[0].vert[0]].x, 
				object3D.plist[0].vlist[object3D.plist[0].vert[0]].y,
				back.bitmapData, 0xFFFFFF);
		}
		
		private var a:int = 1;
		private function rotationSelf():void
		{
			for(var i:int = 0; i < object3D.vlist.length; i++)
			{
				object3D.vlist[i].rotateY(a);
			}
		}
		
		private function pipeline():void
		{
			//清空图片
			back.bitmapData.fillRect(back.bitmapData.rect, 0);
			
			//1.世界坐标变换
			transforToWorld(object3D, worldPos);
			//2.背面消除
//			hidingSide();
			//3.相机坐标变换
			transforToCamera(object3D, camera);
			//4.透视投影
			persProject(object3D);
			
			//绘图
			object3D.drawBitmap(back.bitmapData);
		}
		
		//世界变换只有平移
		private function transforToWorld(o:Objective, w:CPoint3D):void
		{
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				o.tvlist[i].x = o.vlist[i].x + w.x;
				o.tvlist[i].y = o.vlist[i].y + w.y;
				o.tvlist[i].z = o.vlist[i].z + w.z;
			}
		}
		
		//相机坐标变换, 包括了平移和旋转
		private function transforToCamera(o:Objective, c:EulerCamera):void
		{
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				//平移, 要计算处, 物体相对于相机原点的坐标
				o.tvlist[i].x -= c.pos.x;
				o.tvlist[i].y -= c.pos.y;
				o.tvlist[i].z -= c.pos.z;
				//旋转
				o.tvlist[i].rotateXYZ(c.dir.x, c.dir.y, c.dir.z);
//				o.tvlist[i].rotateY(c.dir.y);
//				o.tvlist[i].rotateX(c.dir.x);
//				o.tvlist[i].rotateZ(c.dir.z);
			}
		}
		
		//透视变换
		private function persProject(o:Objective):void
		{
			var p:CPoint3D;
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				p = o.tvlist[i];
				
//				p.x *= 200/(200 + p.z);
//				p.y *= 200/(200 + p.z);
//				p.z = 0;
				p.x *= 200/p.z;
				p.y *= 200/p.z;
				p.z = 0;
			}
		}
		
		//背面消除
		private function hidingSide():void
		{
			var view:CPoint3D;
			for(var i:int = 0; i < object3D.polysNum; i++)
			{
				var p:Polygon = object3D.plist[i];
				var n:CPoint3D = p.normal();
//				trace("normal: ", n);
				view = camera.pos.minusNew(p.vlist[p.vert[0]]);
//				trace("view: ", view);
				var dot:Number = n.dot(view);
//				trace(dot);
				if( dot <= 0)
				{
					p.state |= PolygonStates.BACKFACE;
				}else{
					p.state = PolygonStates.NORMAL;
				}
			}
		}
	}
}