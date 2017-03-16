package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import vo.Base;
	import vo.CMatrix;
	import vo.CUtils;
	import vo.td.CCamera;
	import vo.td.CColor;
	import vo.td.CLight;
	import vo.td.CObjective;
	import vo.td.CPoint4D;
	import vo.td.CPolygon;
	import vo.td.CSphere;
	import vo.td.PolygonStates;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0xcccccc")]
	public class ShadeTest3 extends Sprite
	{
		private var uloader:URLLoader;
		private var back:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
		private var object4D:CObjective;
		private var worldPos:CPoint4D = new CPoint4D(0,0,500);
		private var camera:CCamera = new CCamera(new CPoint4D(0,0,0), new CPoint4D(0,0,0), 400);
		private var light:CLight = new CLight();
		private var light1:CLight = new CLight();
		private var light2:CLight = new CLight();
		
		private var lightInfinity:CLight = new CLight();
		
		private var rotateMt:CMatrix = new CMatrix(4, 4);
		private var transMt:CMatrix = new CMatrix(4, 4);
		private var projectMt:CMatrix = new CMatrix(4, 4);
		
		public function ShadeTest3()
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
			
			//init
			initLight();
			
			var request:URLRequest = new URLRequest("configs/cube3.plg");
			uloader = new URLLoader();
			uloader.addEventListener(Event.COMPLETE, onLoaderComplete);
			uloader.load(request);
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var s:String = uloader.data as String;
			trace("#####--Object Info--#####\n", s,"\n#####################");
			object4D = Base.parseObjective4D(s);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			step();
		}
		
		private function step():void
		{
			//清空图片
			back.bitmapData.fillRect(back.bitmapData.rect, 0);
			//先画坐标
			drawAxis();
			
//			rotationSelf(object4D);
			pipeline(object4D, worldPos);
			//绘图
			if((object4D.state & CObjective.CULLED) == 0)
			{
				object4D.drawBitmap(back.bitmapData, true);
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			//清空图片
			back.bitmapData.fillRect(back.bitmapData.rect, 0);
			//先画坐标
			drawAxis();
			
			rotationSelf(object4D);
			pipeline(object4D, worldPos);
			//绘图
			if((object4D.state & CObjective.CULLED) == 0)
			{
				object4D.drawBitmap(back.bitmapData, true);
			}
		}
		
		private var a:int = 1;
		private function rotationSelf(o:CObjective):void
		{
			rotateMt.setToZero();
			var mt:CMatrix = CUtils.buildRotationMatrix(a,a,a, rotateMt);
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
//			o.updateSphere();
			//重置物体状态
			o.resetState();
			
			//1.世界坐标变换
			transforToWorld(o, wp);
			//2.物体剔除
//			cullObjective(o, camera, wp);
			//3.背面消除
			hidingSide(o);
			//4.光照
			lightenWorld(o,camera);
			//5.相机坐标变换
//			transforToCamera(o, camera);
			//6.透视投影
			persProject(o);
			//7.视口变换
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
		
		//在相机坐标中进行
		private function cullObjective(o:CObjective, c:CCamera, w:CPoint4D):void
		{
			var zTest:Number;
			
			//这里需要使用克隆后的数据
			var sphere:CSphere = o.sphere.clone();
			
			//转成世界坐标
			transMt.normal();
			var mt:CMatrix = CUtils.buildTranslationMatrix(w, false, transMt);
			mt.multipPoint4D(sphere.c);
			
			//转成相机坐标
			transMt.normal();
			rotateMt.setToZero();
			CUtils.buildUVNCameraMatrix(c, transMt, rotateMt);
			c.matrix.multipPoint4D(sphere.c);
			
			//计算远近裁面
			if((sphere.c.z - sphere.r) > c.farClipZ ||
				(sphere.c.z + sphere.r) < c.nearClipZ)
			{
				o.state |= CObjective.CULLED;
				return;
			}
			
			//计算左右裁面
			//斜率 * 球心 z 坐标， 得到在 z 坐标下右裁面对应的x的点(由对称关系可以知道,左裁面的坐标是 -zTest)
			zTest = (0.5 * back.bitmapData.width)/c.viewDistance * sphere.c.z;
			if((sphere.c.x - sphere.r) > zTest ||
				(sphere.c.x + sphere.r) < -zTest)
			{
				o.state |= CObjective.CULLED;
				return;
			}
			
			//计算上下裁面
			zTest = (0.5 * back.bitmapData.height)/c.viewDistance * sphere.c.z;
			if((sphere.c.y - sphere.r) > zTest ||
				(sphere.c.y + sphere.r) < -zTest)
			{
				o.state |= CObjective.CULLED;
				return;
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
		
		//相机坐标变换, 包括了平移和旋转
		private function transforToCamera(o:CObjective, c:CCamera):void
		{
			transMt.normal();
			rotateMt.setToZero();
			CUtils.buildUVNCameraMatrix(c, transMt, rotateMt);
			for(var i:int = 0; i < o.tvlist.length; i++)
			{
				c.matrix.multipPoint4D(o.tvlist[i]);
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
		
		private function initLight():void
		{
			light.colorAmbient = new CColor(0x0000FF);
			light.colorDiffuse = new CColor(0);
			light.colorSpecular = new CColor(0);
			
			light1.colorAmbient = new CColor(0);
			light1.colorDiffuse = new CColor(0xFF0000);
			light1.colorSpecular = new CColor(0);
			light1.dir = new CPoint4D(0, 0, -1);//要与法线保持一致
			
			light2.colorAmbient = new CColor(0);
			light2.colorDiffuse = new CColor(0x00FF00);
			light2.colorSpecular = new CColor(0);
			light2.dir = new CPoint4D(0, 0, -1);
			light2.pos = new CPoint4D(0, 0, 400);
		}
		
		private function lightenWorld(o:CObjective, c:CCamera):void
		{
			var r:uint, g:uint, b:uint;
			//处理每个多边形
			for(var i:int = 0; i < o.plist.length; i++)
			{
				r = g = b = 0;
				
				var p:CPolygon = o.plist[i];
				
				//环境光
				r += light.colorAmbient.red / 255 * p.colorBase.red;
				g += light.colorAmbient.green / 255 * p.colorBase.green;
				b += light.colorAmbient.blue / 255 * p.colorBase.blue;
				
				//无穷远光
				var n:CPoint4D = p.normal();
				var dp:Number = n.dot(light1.dir);
				//光源与表面积所成的cos theta 成正比
				//暂时值计算散射项
//				trace("vert: ", p.vert);
//				trace("dp: ", dp);
				if(dp > 0)
				{
					var theta:Number = dp / (n.length());
					r += light1.colorDiffuse.red / 255 * p.colorBase.red * theta;
					g += light1.colorDiffuse.green / 255 * p.colorBase.green * theta;
					b += light1.colorDiffuse.blue / 255 * p.colorBase.blue * theta;
				}
				
				//点光源
				var n:CPoint4D = p.normal();
				var l:CPoint4D = light2.pos.minusNew(p.vlist[p.vert[0]]);
				var dp:Number = n.dot(l);
				var dist:Number = l.length();
//				trace("vert: ", p.vert);
//				trace("dp: ", dp);
				//光源与表面积所成的cos theta 成正比
				if(dp > 0)
				{
					var atten:Number = (light2.kc + light2.kl*dist);
					var theta:Number = dp / (n.length() * dist * atten);
					
					r += light2.colorDiffuse.red / 255 * p.colorBase.red * theta;
					g += light2.colorDiffuse.green / 255 * p.colorBase.green * theta;
					b += light2.colorDiffuse.blue / 255 * p.colorBase.blue * theta;
				}
				
				if(r > 255) r = 255;
				if(g > 255) g = 255;
				if(b > 255) b = 255;
//				trace("(r: ", r, "g: ", g, "b: ",b,")");
				p.colorBlend.setByRGB(r,g,b);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}