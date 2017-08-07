/**
 * Mode 7是电子游戏机超级任天堂的一个图形方式，可让逐扫描线式的背景层支持旋转与缩放，以此创造大量的不同效果。
 * 其中最著名的效果是，通过缩放和旋转背景层来显示透视效果。这种将高度改为深度的变换，将背景层变为二维水平材质贴图平面。
 * 如此便可显示三维图形的效果。
 * 
 * 注意是将高度变成深度！！
*/

package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import vo.CVector3D;
	
	[SWF(width="1024", height="1024", frameRate="30", backgroundColor="0")]
	public class Mode7Test extends Sprite
	{
		[Embed(source="assets/race.jpg")]
		private var Map:Class;
		
		private var cam:CVector3D = new CVector3D(0, 0, 0);
		private var camDir:CVector3D = new CVector3D(0, 0, 0);
		
		private var m:Bitmap = new Map();
		private var s:Sprite = new Sprite();
		public function Mode7Test()
		{
			super();
			
			m.x = -m.width / 2;
			m.y = -m.height / 2;
			s.addChild(m);
			s.x = m.width / 2;
			s.y = m.height / 2;
			addChild(s);
			
			//四个步骤, 其实和3D的步骤一毛一样
			//1. 平移到相机位置
			//2. 在相机位置进行旋转
			//3. 根据透视距离进行缩放
			//4. 调节缩放后的位置
			
			moveToCam();
			rotationToCam();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onMouseClick);
		}
		
		protected function onMouseClick(event:KeyboardEvent):void
		{
			rotationToCam();
		}		
		
		public function moveToCam():void
		{
			m.x -= cam.x;
			m.y -= cam.y;
			m.z -= cam.z;
		}
		
		public function rotationToCam():void
		{
			s.rotationX++;
			trace(s.rotationX);
		}
	}
}