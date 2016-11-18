package vo.td
{
	import flash.display.Graphics;

	public class EulerCamera
	{
		private var mPos:CPoint3D;//相机位置
		private var mDir:CPoint3D;//欧拉角度
		
		public function EulerCamera(pos:CPoint3D = null, dir:CPoint3D = null)
		{
			if(pos == null){
				mPos = new CPoint3D();
			}else{
				mPos = pos;
			}
			if(dir == null)
			{
				mDir = new CPoint3D();
			}else{
				mDir = dir;
			}
		}

		public function draw(g:Graphics):void
		{
			g.drawCircle(0,0,10);
			g.lineTo(5,5);
		}
		
		public function get pos():CPoint3D
		{
			return mPos;
		}

		public function set pos(value:CPoint3D):void
		{
			mPos = value;
		}

		public function get dir():CPoint3D
		{
			return mDir;
		}

		public function set dir(value:CPoint3D):void
		{
			mDir = value;
		}

	}
}