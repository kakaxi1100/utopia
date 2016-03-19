package vo
{
	import flash.geom.Point;
	
	import utils.MatrixUtil;

	public class Bone
	{
		public var sp:Point;
		public var len:Number;
		private var _mAngle:Number;
		
		private var _mEP:Point = new Point();
		
		private var mStart:Matrix = new Matrix_1x3();
		private var mTranslate:Matrix = new Matrix_3x3();
		private var mRotate:Matrix = new Matrix_3x3();
		private var mScale:Matrix = new Matrix_3x3();
		
		private var mResult:Matrix = new Matrix_3x3();
		private var mFinal:Matrix = new Matrix_1x3();
		public function Bone(s:Point, l:Number, ang:Number)
		{
			sp = s;
			len = l;
			angle = ang;
			caculateEndPoint();
		}

		public function get angle():Number
		{
			return _mAngle;
		}

		public function set angle(value:Number):void
		{
			_mAngle = value;
		}

		private function caculateEndPoint():void
		{
			//初始化起点
			MatrixUtil.Matrix_init_1x3(mStart);
			//初始化平移矩阵
			MatrixUtil.Matrix_init_3x3(mTranslate);
			//赋值平移
			MatrixUtil.Matrix_translate_3x3(mTranslate, len, 0);
			//初始化旋转矩阵
			MatrixUtil.Matrix_init_3x3(mRotate);
			//赋值旋转
			MatrixUtil.Matrix_rotate_3x3(mRotate, angle);
			//计算旋转和平移
			MatrixUtil.Matrix_mult_3x3_3x3(mTranslate, mRotate, mResult);
			//计算起点做平移和旋转之后的点
			MatrixUtil.Matrix_mult_1x3_3x3(mStart, mResult,mFinal);
			//转换为世界坐标点
			_mEP.setTo(mFinal.v[0][0]+sp.x, mFinal.v[0][1]+sp.y);
		}
		
		public function get ep():Point
		{
			caculateEndPoint();
			return _mEP;
		}
	}
}