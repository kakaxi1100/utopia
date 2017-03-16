package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Camera;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import vo.Base;
	import vo.CMatrix;
	import vo.CUtils;
	import vo.td.CEulerCamera;
	import vo.td.CObjective;
	import vo.td.CPoint3D;
	import vo.td.CPoint4D;
	import vo.td.CPolygon;
	import vo.td.PolygonStates;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0xcccccc")]
	public class TankTest extends Sprite
	{
		private var uloader:URLLoader;
		private var back:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
		private var object4D:CObjective;
		private var objectList:Vector.<CObjective> = new Vector.<CObjective>();
		private var worldPosList:Vector.<CPoint4D> = new Vector.<CPoint4D>();
		private var worldPos:CPoint4D = new CPoint4D(0,0,500);
		private var camera:CEulerCamera = new CEulerCamera(new CPoint4D(0,200,0), new CPoint4D(0,0,0), 200);
		
		
		private var rotateMt:CMatrix = new CMatrix(4, 4);
		private var transMt:CMatrix = new CMatrix(4, 4);
		private var projectMt:CMatrix = new CMatrix(4, 4);
		
		public function TankTest()
		{
			super();
			//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.BOTTOM_RIGHT;
			
			Base.worldCenterX = stage.stageWidth >> 1;
			Base.worldCenterY = stage.stageHeight >> 1;
			
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
			trace("#####--Object Info--#####\n", s,"\n#####################");
			object4D = Base.parseObjective4D(s);
			for(var i:int = 0; i < 4; i++)
			{
				objectList.push(object4D.clone());
			}
			worldPosList.push(new CPoint4D(-125,0,375),new CPoint4D(-125,0,625),new CPoint4D(125,0,375),new CPoint4D(125,0,625));
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			startTestFlow();
		}
		
		private function startTestFlow():void
		{
			//清空图片
			back.bitmapData.fillRect(back.bitmapData.rect, 0);
			//先画坐标
			drawAxis();
			//多个
			//			for(var i:int = 0; i < objectList.length; i++)
			//			{
			//				//				rotationSelf(objectList[i]);
			//				pipeline(objectList[i], worldPosList[i]);
			//				//绘图
			//				objectList[i].drawBitmap(back.bitmapData);
			//			}
			//单个
			rotationSelf(object4D);
			pipeline(object4D, worldPos);
			//绘图
			object4D.drawBitmap(back.bitmapData);
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
					startTestFlow();
					return;
			}
//			pipeline(object4D);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			//清空图片
			back.bitmapData.fillRect(back.bitmapData.rect, 0);
			//先画坐标
			drawAxis();
			//多个
//			for(var i:int = 0; i < objectList.length; i++)
//			{
//				rotationSelf(objectList[i]);
//				pipeline(objectList[i], worldPosList[i]);
//				//绘图
//				objectList[i].drawBitmap(back.bitmapData);
//			}
			//一个
			rotationSelf(object4D);
			pipeline(object4D, worldPos);
			//绘图
			object4D.drawBitmap(back.bitmapData);
		}
		
		private var a:int = 1;
		private function rotationSelf(o:CObjective):void
		{
			rotateMt.setToZero();
			var mt:CMatrix = CUtils.buildRotationMatrix(0,a,0, rotateMt);
			for(var i:int = 0; i < o.vlist.length; i++)
			{
				mt.multipPoint4D(o.vlist[i]);
			}
		}
		
		private function pipeline(o:CObjective, wp):void
		{
			//0.将本地坐标复制给变换坐标
			o.vertexLocalToTrans();
			
			//1.世界坐标变换
			transforToWorld(o, wp);
			//2.背面消除
			hidingSide(o);
			//3.相机坐标变换
			transforToCamera(o, camera);
			//4.透视投影
			persProject(o);
			//5.视口变换
//			viewPortTransform(object4D);
		}
		
		//世界变换只有平移
		private function transforToWorld(o:CObjective, w:CPoint4D):void
		{
			transMt.normal();
			var mt:CMatrix = CUtils.buildTranslationMatrix(w, false, transMt);
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				mt.multipPoint4D(o.tvlist[i]);
			}
		}
		
		//相机坐标变换, 包括了平移和旋转
		private function transforToCamera(o:CObjective, c:CEulerCamera):void
		{
			transMt.normal();
			//			var mtt:CMatrix = CUtils.buildTranslationMatrix(c.pos, true, transMt);
			rotateMt.setToZero();
			//			var mrt:CMatrix = CUtils.buildRotationMatrix(-c.dir.x, -c.dir.y, -c.dir.z, rotateMt);
			
			CUtils.buildEulerCameraMatrix(c, transMt, rotateMt);
			
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				c.matrix.multipPoint4D(o.tvlist[i]);
				//				//平移
				//				mtt.multipPoint4D(o.tvlist[i]);
				//				//旋转
				//				mrt.multipPoint4D(o.tvlist[i]);
			}
		}
		
		//透视变换
		//因为相机放的位置，所以无需+200, 请理解一下这段
		//透视投影会影响隐面消除时,对图像的呈现
		private function persProject(o:CObjective):void
		{
			var p:CPoint4D;
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				p = o.tvlist[i];
				p.x = camera.viewDistance*p.x/p.z;
				p.y = camera.viewDistance*p.y*camera.aspectRatio/p.z;
			}
			
			
			
			//			projectMt.setToZero();
			//			var mt:CMatrix = CUtils.buildPersProject(camera, projectMt);
			//			for(var i:int = 0; i < o.tvlist.length; i++)
			//			{
			//				//投影
			//				mt.multipPoint4D(o.tvlist[i]);
			//			}
			
			
			//			var p:CPoint4D;
			//			for(var i:int = 0; i < o.tvlist.length; i++)
			//			{
			//				p = o.tvlist[i];
			//				
			//				p.x *= 200/(200 + p.z);
			//				p.y *= 200/(200 + p.z);
			//				p.z = 0;
			//			}
		}
		
		//视口变换
		//归一化之后才需要做视口变换吧先想一想
		private function viewPortTransform(o:CObjective):void
		{
			var p:CPoint4D;
			var alpha:Number = (0.5*camera.viewPortWdith-0.5);
			var beta:Number = (0.5*camera.viewPortHeight-0.5);
			for (var i:int = 0; i < o.tvlist.length; i++)
			{
				p = o.tvlist[i];
				p.x = alpha + alpha*p.x;
				p.y = beta  - beta *p.y;
			}
		}
		
		//背面消除
		private var n:CPoint4D = new CPoint4D();
		private	var view:CPoint4D = new CPoint4D();
		private function hidingSide(o:CObjective):void
		{
			for(var i:int = 0; i < o.polysNum; i++)
			{
				var p:CPolygon = o.plist[i];
				p.normal(n);
				//				trace("normal: ", n);
				camera.pos.minusNew(p.vlist[p.vert[0]], view);
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
		
		private function drawAxis():void
		{
			back.bitmapData.lock();
			for(var i:int = 0; i < back.bitmapData.width; i++){
				back.bitmapData.setPixel32(i,Base.worldCenterY, 0xFFFFFF);
			}
			for(var j:int = 0; j < back.bitmapData.height; j++){
				back.bitmapData.setPixel32(Base.worldCenterX,j, 0xFFFFFF);
			}
			back.bitmapData.unlock();
		}
	}
}