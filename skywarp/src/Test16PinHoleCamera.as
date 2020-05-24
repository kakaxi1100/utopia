/**
 *
 * 针孔摄像机光栅化模拟, 参数参考Maya
 *  
 */
package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	
	import skywarp.version2.SWPoint3D;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="0xcccccc")]
	public class Test16PinHoleCamera extends Sprite
	{
		private var content:Sprite = new Sprite();
		
		private var verts:Array;
		private var tris:Array;
		
		private var focalLength:Number = 35;
		private var filmApertureWidth:Number = 0.980; 
		private var filmApertureHeight:Number = 0.735; 
		private static const inchToMm:Number = 25.4; 
		private var nearClippingPlane:Number = 0.1; 
		private var farClipingPlane:Number = 1000; 
		
		private var imageWidth:uint = 640; 
		private var imageHeight:uint = 480; 
		
		private static const kFill:int = 0;
		private static const kOverscan:int = 1;
		private var fitFilm:int = kFill; 
		
		public function Test16PinHoleCamera()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
//			content.x = stage.stageWidth * 0.5;
//			content.y = stage.stageHeight * 0.5;
			this.graphics.lineStyle(1);
			addChild(content);
			
			verts = [
				new SWPoint3D(  -2.5703,   0.78053,  -2.4e-05), new SWPoint3D( -0.89264,  0.022582,  0.018577), 
				new SWPoint3D(   1.6878, -0.017131,  0.022032), new SWPoint3D(   3.4659,  0.025667,  0.018577), 
				new SWPoint3D(  -2.5703,   0.78969, -0.001202), new SWPoint3D( -0.89264,   0.25121,   0.93573), 
				new SWPoint3D(   1.6878,   0.25121,    1.1097), new SWPoint3D(   3.5031,   0.25293,   0.93573), 
				new SWPoint3D(  -2.5703,    1.0558, -0.001347), new SWPoint3D( -0.89264,    1.0558,    1.0487), 
				new SWPoint3D(   1.6878,    1.0558,    1.2437), new SWPoint3D(   3.6342,    1.0527,    1.0487), 
				new SWPoint3D(  -2.5703,    1.0558,         0), new SWPoint3D( -0.89264,    1.0558,         0), 
				new SWPoint3D(   1.6878,    1.0558,         0), new SWPoint3D(   3.6342,    1.0527,         0), 
				new SWPoint3D(  -2.5703,    1.0558,  0.001347), new SWPoint3D( -0.89264,    1.0558,   -1.0487), 
				new SWPoint3D(   1.6878,    1.0558,   -1.2437), new SWPoint3D(   3.6342,    1.0527,   -1.0487), 
				new SWPoint3D(  -2.5703,   0.78969,  0.001202), new SWPoint3D( -0.89264,   0.25121,  -0.93573), 
				new SWPoint3D(   1.6878,   0.25121,   -1.1097), new SWPoint3D(   3.5031,   0.25293,  -0.93573), 
				new SWPoint3D(   3.5031,   0.25293,         0), new SWPoint3D(  -2.5703,   0.78969,         0), 
				new SWPoint3D(   1.1091,    1.2179,         0), new SWPoint3D(    1.145,     6.617,         0), 
				new SWPoint3D(   4.0878,    1.2383,         0), new SWPoint3D(  -2.5693,    1.1771, -0.081683), 
				new SWPoint3D(  0.98353,    6.4948, -0.081683), new SWPoint3D( -0.72112,    1.1364, -0.081683), 
				new SWPoint3D(   0.9297,     6.454,         0), new SWPoint3D(  -0.7929,     1.279,         0), 
				new SWPoint3D(  0.91176,    1.2994,         0) 
			];
			
			tris = [
				4,   0,   5,   0,   1,   5,   1,   2,   5,   5,   2,   6,   3,   7,   2, 
				2,   7,   6,   5,   9,   4,   4,   9,   8,   5,   6,   9,   9,   6,  10, 
				7,  11,   6,   6,  11,  10,   9,  13,   8,   8,  13,  12,  10,  14,   9, 
				9,  14,  13,  10,  11,  14,  14,  11,  15,  17,  16,  13,  12,  13,  16, 
				13,  14,  17,  17,  14,  18,  15,  19,  14,  14,  19,  18,  16,  17,  20, 
				20,  17,  21,  18,  22,  17,  17,  22,  21,  18,  19,  22,  22,  19,  23, 
				20,  21,   0,  21,   1,   0,  22,   2,  21,  21,   2,   1,  22,  23,   2, 
				2,  23,   3,   3,  23,  24,   3,  24,   7,  24,  23,  15,  15,  23,  19, 
				24,  15,   7,   7,  15,  11,   0,  25,  20,   0,   4,  25,  20,  25,  16, 
				16,  25,  12,  25,   4,  12,  12,   4,   8,  26,  27,  28,  29,  30,  31, 
				32,  34,  33 
			];
			
			test();
		}
		
		public function test():void
		{
			var filmAspectRatio:Number = filmApertureWidth / filmApertureHeight;
			var deviceAspectRatio:Number = imageWidth / imageHeight;
			
			var top:Number = ((filmApertureHeight * inchToMm / 2) / focalLength) * nearClippingPlane;
			var right:Number = ((filmApertureWidth * inchToMm / 2) / focalLength) * nearClippingPlane;
			
			var xscale:Number = 1; 
			var yscale:Number = 1;
			
			switch (fitFilm) 
			{ 
				
				case kFill: 
					if (filmAspectRatio > deviceAspectRatio) { 
						xscale = deviceAspectRatio / filmAspectRatio; 
					} 
					else { 
						yscale = filmAspectRatio / deviceAspectRatio; 
					} 
					break; 
				case kOverscan: 
					if (filmAspectRatio > deviceAspectRatio) { 
						yscale = filmAspectRatio / deviceAspectRatio; 
					} 
					else { 
						xscale = deviceAspectRatio / filmAspectRatio; 
					} 
					break; 
				default: 
					break;
			} 
			
			right *= xscale; 
			top *= yscale; 
			
			var bottom:Number = -top; 
			var left:Number = -right; 
			
			var cameraToWorld:SWMatrix44 = new SWMatrix44(
				-0.95424, 0, 0.299041, 0, 
				0.0861242, 0.95763, 0.274823, 0, 
				-0.28637, 0.288002, -0.913809,0, 
				-3.734612, 7.610426, -14.152769, 1);
			var worldToCamera:SWMatrix44 = cameraToWorld.inverse()
			
			for(var i:int = 0; i < Math.floor(this.tris.length / 3); i++)
			{
				var v0World:SWPoint3D = this.verts[this.tris[i * 3]];
				var v1World:SWPoint3D = this.verts[this.tris[i * 3 + 1]];
				var v2World:SWPoint3D = this.verts[this.tris[i * 3 + 2]];
				
				var v0Raster:Point = new Point();
				var v1Raster:Point = new Point();
				var v2Raster:Point = new Point();
				
				computePixelCoordinates(v0World, worldToCamera, bottom, left, top, right, nearClippingPlane, imageWidth, imageHeight, v0Raster);
				computePixelCoordinates(v1World, worldToCamera, bottom, left, top, right, nearClippingPlane, imageWidth, imageHeight, v1Raster);
				computePixelCoordinates(v2World, worldToCamera, bottom, left, top, right, nearClippingPlane, imageWidth, imageHeight, v2Raster);
				
				trace(v0Raster, v1Raster, v2Raster);
				this.graphics.moveTo(v0Raster.x, v0Raster.y);
				this.graphics.lineTo(v1Raster.x, v1Raster.y);
				this.graphics.lineTo(v2Raster.x, v2Raster.y);
				this.graphics.lineTo(v0Raster.x, v0Raster.y);
				
//				this.graphics.moveTo(431, 80);
//				this.graphics.lineTo(238, 273);
//				this.graphics.lineStyle(1, 0xff0000);
//				this.graphics.lineTo(329, 182);
//				this.graphics.lineStyle(1, 0x00ff00);
//				this.graphics.lineTo(431, 80);
			}
			
		}
		
		
		/**
		 * 
		 * @param pWorld 世界坐标
		 * @param worldToCarmera 世界坐标到相机坐标的转换矩阵
 		 * @param b canvas的底部坐标
		 * @param l canvas的左边坐标
		 * @param t canvas的顶部坐标
		 * @param r canvas的右边坐标
		 * @param near 近裁面
		 * @param imageWidth 图片宽度
		 * @param imageHeight 图片高度
		 * @param pRaster 光栅面上的坐标
		 * @return 
		 * 
		 */		
		public function computePixelCoordinates(pWorld:SWPoint3D, 
												worldToCarmera:SWMatrix44,
												b:Number, l:Number, t:Number, r:Number, near:Number,
												imageWidth:uint, imageHeight:uint,
												pRaster:Point):Boolean
		{
			//1. 世界坐标到相机坐标
			var pCarmera:SWPoint3D;
			pCarmera = worldToCarmera.multPoint3Matrix(pWorld);
			
			//2. 相机坐标到屏幕坐标(我们将屏幕设在近裁面的位置, 所以焦距就是near)
			var pScreen:Point = new Point();
			pScreen.x = - pCarmera.x/pCarmera.z * near;
			pScreen.y = - pCarmera.y/pCarmera.z * near;
			
			//3. 屏幕坐标到NDC坐标[0, 1](Normal device coordinate)
			var pNDC:Point = new Point();
			pNDC.x = (pScreen.x + r)/(2 * r);
			pNDC.y = (pScreen.y + t)/(2 * t);
			
			//4. NDC转化为光栅屏坐标
			pRaster.x = Math.floor(pNDC.x * imageWidth);
			pRaster.y = Math.floor((1 - pNDC.y) * imageHeight);
			
			var visible:Boolean = true;
			
			if(pScreen.x < l || pScreen.x > r || pScreen.y < b || pScreen.y > t){
				visible = false;
			}
			
			return visible;
		}
	}
}
import skywarp.version2.SWPoint3D;

class SWMatrix44
{
	public var matrix:Vector.<Vector.<Number>>;
	public function SWMatrix44(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 0, 
							   e:Number = 0, f:Number = 1, g:Number = 0, h:Number = 0, 
							   i:Number = 0, j:Number = 0, k:Number = 1, l:Number = 0, 
							   m:Number = 0, n:Number = 0, o:Number = 0, p:Number = 1)
	{
		matrix = new Vector.<Vector.<Number>>();
		for(var t:int = 0; t < 4; t++)
		{
			matrix[t] = new Vector.<Number>();
		}
		
		matrix[0][0] = a;
		matrix[0][1] = b;
		matrix[0][2] = c;
		matrix[0][3] = d;
		matrix[1][0] = e;
		matrix[1][1] = f;
		matrix[1][2] = g;
		matrix[1][3] = h;
		matrix[2][0] = i;
		matrix[2][1] = j;
		matrix[2][2] = k;
		matrix[2][3] = l;
		matrix[3][0] = m;
		matrix[3][1] = n;
		matrix[3][2] = o;
		matrix[3][3] = p;
	}
	
	public function multPoint3Matrix(src:SWPoint3D):SWPoint3D
	{
		var a:Number, b:Number, c:Number, w:Number;

		a = src.x * matrix[0][0] + src.y * matrix[1][0] + src.z * matrix[2][0] + matrix[3][0];
		b = src.x * matrix[0][1] + src.y * matrix[1][1] + src.z * matrix[2][1] + matrix[3][1];
		c = src.x * matrix[0][2] + src.y * matrix[1][2] + src.z * matrix[2][2] + matrix[3][2];
		w = src.x * matrix[0][3] + src.y * matrix[1][3] + src.z * matrix[2][3] + matrix[3][3];
		
		var dst:SWPoint3D = new SWPoint3D();
		dst.x = a / w;
		dst.y = b / w;
		dst.z = c / w;
		
		return dst;
	}
	
	public function inverse():SWMatrix44
	{
		var i:int, j:int, k:int;
		var s:SWMatrix44 = new SWMatrix44();
		
		// Forward elimination
		for (i = 0; i < 3 ; i++) {
			var pivot:int = i;
			
			var pivotsize:Number = this.matrix[i][i];
			
			if (pivotsize < 0)
				pivotsize = -pivotsize;
			
			for (j = i + 1; j < 4; j++) {
				var tmp:Number = this.matrix[j][i];
				
				if (tmp < 0)
					tmp = -tmp;
				
				if (tmp > pivotsize) {
					pivot = j;
					pivotsize = tmp;
				}
			}
			
			if (pivotsize == 0) {
				// Cannot invert singular matrix
				return new SWMatrix44();
			}
			
			if (pivot != i) {
				for (j = 0; j < 4; j++) {
					var tmp:Number;
					
					tmp = this.matrix[i][j];
					this.matrix[i][j] = this.matrix[pivot][j];
					this.matrix[pivot][j] = tmp;
					
					tmp = s.matrix[i][j];
					s.matrix[i][j] = s.matrix[pivot][j];
					s.matrix[pivot][j] = tmp;
				}
			}
			
			for (j = i + 1; j < 4; j++) {
				var f:Number = this.matrix[j][i] / this.matrix[i][i];
				
				for (k = 0; k < 4; k++) {
					this.matrix[j][k] -= f * this.matrix[i][k];
					s.matrix[j][k] -= f * s.matrix[i][k];
				}
			}
		}
		
		// Backward substitution
		for (i = 3; i >= 0; --i) {
			var f:Number;
			
			if ((f = this.matrix[i][i]) == 0) {
				// Cannot invert singular matrix
				return new SWMatrix44();
			}
			
			for (j = 0; j < 4; j++) {
				this.matrix[i][j] /= f;
				s.matrix[i][j] /= f;
			}
			
			for (j = 0; j < i; j++) {
				f = this.matrix[j][i];
				
				for (k = 0; k < 4; k++) {
					this.matrix[j][k] -= f * this.matrix[i][k];
					s.matrix[j][k] -= f * s.matrix[i][k];
				}
			}
		}
		
		return s;
	}
}