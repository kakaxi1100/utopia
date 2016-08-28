package graphics
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import vo.CVector3D;

	public class Particle3D
	{
		private var mPos:CVector3D;
		private var mSprite:DisplayObject;
		
		public function Particle3D(x:Number, y:Number, z:Number, container:DisplayObjectContainer, s:DisplayObject)
		{
			mPos = new CVector3D(x, y, z);
			mSprite = s;
			container.addChild(s);
		}
		
		public function render():void
		{
			//取得投影比例
			var p:Number = mPos.getPerspective();
			var screenPos:CVector3D = mPos.persProjectNew();
			
			mSprite.x = screenPos.x;
			mSprite.y = -screenPos.y; // 因为Vector采用的是笛卡尔坐标, y轴是向上的, 所以这个理要取反.
			
			mSprite.scaleX = mSprite.scaleY = p;
		}

		public function get pos():CVector3D
		{
			return mPos;
		}

		public function get mc():DisplayObject
		{
			return mSprite;
		}


	}
}