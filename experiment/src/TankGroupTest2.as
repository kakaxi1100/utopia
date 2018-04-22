package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import vo.Base;
	import vo.CMatrix;
	import vo.CUtils;
	import vo.td.CCamera;
	import vo.td.CObjective;
	import vo.td.CPoint4D;
	import vo.td.CPolygon;
	import vo.td.PolygonStates;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class TankGroupTest2 extends Sprite
	{
		private var uloader:URLLoader;
		private var back:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
		private var object4D:CObjective;
		private var objectList:Vector.<CObjective> = new Vector.<CObjective>();
		private var worldPosList:Vector.<CPoint4D> = new Vector.<CPoint4D>();
		private var worldPos:CPoint4D = new CPoint4D(0,0,500);
		private var camera:CCamera = new CCamera(new CPoint4D(0,0, 1750), new CPoint4D(0,0,0), 400);
		
		
		private var rotateMt:CMatrix = new CMatrix(4, 4);
		private var transMt:CMatrix = new CMatrix(4, 4);
		private var projectMt:CMatrix = new CMatrix(4, 4);
		private var tempMt1:CMatrix = new CMatrix(4, 4);
		private var tempMt2:CMatrix = new CMatrix(4, 4);
		private var tempMt3:CMatrix = new CMatrix(4, 4);
		private var tempMt4:CMatrix = new CMatrix(4, 4);
		
		private var cameraDistance:Number = 1750;
		private var ObjectSpace:Number = 250;
		private var ObjectNum:int = 16;
		
		public function TankGroupTest2()
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
			
			//初始条件
			camera.target = new CPoint4D(0,0,0);
			
			var request:URLRequest = new URLRequest("configs/tank1.plg");
			uloader = new URLLoader();
			uloader.addEventListener(Event.COMPLETE, onLoaderComplete);
			uloader.load(request);
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var s:String = uloader.data as String;
			trace("#####--Object Info--#####\n", s,"\n#####################\n");
			object4D = Base.parseObjective4D(s);
			var wx:int,wz:int; 
			for(var i:int = 0; i < 5; i++)
			{
				objectList.push(object4D.clone());
				wx = i % 6 * ObjectSpace;
				wz = (i / 6 >> 0) * ObjectSpace;
				worldPosList.push(new CPoint4D(wx,0,wz));
			}
			
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
//------------------------------------------------------------------			
			for(var i:int = 0; i < objectList.length; i++)
			{
//				rotationSelf(objectList[i]);
				pipeline(objectList[i], worldPosList[i]);
				//绘图
				if((objectList[i].state & CObjective.CULLED) == 0)
				{
					objectList[i].drawBitmap(back.bitmapData);
				}
			}
//-----------------------------------------------------------------			
			//单个
//-----------------------------------------------------------------			
//			rotationSelf(object4D);
//			pipeline(object4D, worldPos);
//			//绘图
//			if((object4D.state & CObjective.CULLED) == 0)
//			{
//				object4D.drawBitmap(back.bitmapData);
//			}
//			object4D.drawBounding(back.bitmapData);
//------------------------------------------------------------------			
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
//					startTestFlow();
					return;
			}
//			pipeline(object4D);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			//相机移动
			cameraMove(camera);
			//清空图片
			back.bitmapData.fillRect(back.bitmapData.rect, 0);
			//先画坐标
			drawAxis();
//			drawViewport();
			//-------------多个-------------------------------
			for(var i:int = 0; i < objectList.length; i++)
			{
				rotationSelf(objectList[i]);
				pipeline(objectList[i], worldPosList[i]);
				//绘图
				if((objectList[i].state & CObjective.CULLED) == 0)
				{
					objectList[i].drawBitmap(back.bitmapData);
				}
			}
			//----------------------------------------------
			
			//------------- 单个 -----------------------------
//			rotationSelf(object4D);
//			pipeline(object4D, worldPos);
//			//绘图
//			if((object4D.state & CObjective.CULLED) == 0)
//			{
//				object4D.drawBitmap(back.bitmapData);
//			}
//			object4D.drawBounding(back.bitmapData);
			//----------------------------------------------
		}
		
		private var viewA:int = 0;
		private function cameraMove(c:CCamera):void
		{
			if(viewA >= 360)
			{
				viewA = 0;
			}
			
			c.pos.x = cameraDistance * Math.cos(viewA * CUtils.RADIAN);
			c.pos.y = cameraDistance * Math.sin(viewA * CUtils.RADIAN);
			c.pos.z = 2*cameraDistance * Math.sin(viewA * CUtils.RADIAN);
			
			viewA++;
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
			//0.前置条件
			//将本地坐标复制给变换坐标
			o.vertexLocalToTrans();
			//计算包围球
			//如果局部坐标不改变那么只需计算一次
//			o.updateSphere();
			//重置物体状态
			o.resetState();
			
			//1.世界坐标变换
			transforToWorld(o, wp);
			//2.物体剔除
//			cullObjective(o, camera, wp);
			//3.背面消除
//			hidingSide(o);
			//4.相机坐标变换
			transforToCamera(o, camera);
			//5.透视投影
			persProject(o);
			//6.视口变换
			//执行视口变换的前提是透视投影必须是归一化的
//			viewPortTransform(object4D);
		}
		
		//世界变换只有平移
		private function transforToWorld(o:CObjective, w:CPoint4D):void
		{
			transMt.normal();
			var mt:CMatrix = CUtils.buildTranslationMatrix(w, false, transMt);
			
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				tempMt1.setToZero();
				mt.multipPoint4D(o.tvlist[i], tempMt1);
			}
//			mt.multipPoint4D(o.sphere.c);
		}
		
		//在相机坐标中进行
		private function cullObjective(o:CObjective, c:CCamera, w:CPoint4D):void
		{
			var zTest:Number;
			
			//转成世界坐标
			transMt.normal();
			var mt:CMatrix = CUtils.buildTranslationMatrix(w, false, transMt);
			tempMt3.setToZero();
			mt.multipPoint4D(o.sphere.c);
			
			//转成相机坐标
			transMt.normal();
			rotateMt.setToZero();
			CUtils.buildUVNCameraMatrix(c, transMt, rotateMt);
			tempMt4.setToZero();
			c.matrix.multipPoint4D(o.sphere.c);
			
			//计算远近裁面
			if((o.sphere.c.z - o.sphere.r) > c.farClipZ ||
				(o.sphere.c.z + o.sphere.r) < c.nearClipZ)
			{
				o.state |= CObjective.CULLED;
				return;
			}
			
			//计算左右裁面
			//斜率 * 球心 z 坐标， 得到在 z 坐标下右裁面对应的x的点(由对称关系可以知道,左裁面的坐标是 -zTest)
			zTest = (0.5 * back.bitmapData.width)/c.viewDistance * o.sphere.c.z;
			if((o.sphere.c.x - o.sphere.r) > zTest ||
				(o.sphere.c.x + o.sphere.r) < -zTest)
			{
				o.state |= CObjective.CULLED;
				return;
			}
			
			//计算上下裁面
			zTest = (0.5 * back.bitmapData.height)/c.viewDistance * o.sphere.c.z;
			if((o.sphere.c.y - o.sphere.r) > zTest ||
				(o.sphere.c.y + o.sphere.r) < -zTest)
			{
				o.state |= CObjective.CULLED;
				return;
			}
		}
		
		//相机坐标变换, 包括了平移和旋转
		private function transforToCamera(o:CObjective, c:CCamera):void
		{
			transMt.normal();
			rotateMt.setToZero();
			CUtils.buildUVNCameraMatrix(c, transMt, rotateMt);
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				tempMt1.setToZero();
				c.matrix.multipPoint4D(o.tvlist[i], tempMt1);
			}
//			c.matrix.multipPoint4D(o.sphere.c);
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
//			o.sphere.c.x = camera.viewDistance*o.sphere.c.x/o.sphere.c.z;
//			o.sphere.c.y = camera.viewDistance*o.sphere.c.y*camera.aspectRatio/o.sphere.c.z;
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
				camera.pos.minusNew(p.vlist[p.vert[0]], view);
				var dot:Number = n.dot(view);
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
		
		private function drawViewport():void
		{
			back.bitmapData.lock();
			for(var i:int = -50; i < 50; i++){
				back.bitmapData.setPixel32(i + Base.worldCenterX,Base.worldCenterY - 50, 0xFFFFFF);
				back.bitmapData.setPixel32(i + Base.worldCenterX,Base.worldCenterY + 50, 0xFFFFFF);
			}
			for(var j:int = -50; j < 50; j++){
				back.bitmapData.setPixel32(Base.worldCenterX - 50, j + Base.worldCenterY, 0xFFFFFF);
				back.bitmapData.setPixel32(Base.worldCenterX + 50, j + Base.worldCenterY, 0xFFFFFF);
			}
			back.bitmapData.unlock();
		}
	}
}