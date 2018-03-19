/**
 *“仿射变换”就是：“线性变换”+“平移”。
 * 
 * 根据左乘和右乘是有两个表达方式的
 * P*M			M*P
 * |a  b  0|	|a c tx|
 * |c  d  0| or |b d ty|
 * |tx ty 1|	|0 0 1 |
 * 
 * 1 线性变换
 * 线性变换从几何直观有三个要点：
 * 变换前是直线的，变换后依然是直线
 * 直线比例保持不变
 * 变换前是原点的，变换后依然是原点
 * 
 * 2 仿射变换
 * 仿射变换从几何直观只有两个要点：
 * 变换前是直线的，变换后依然是直线
 * 直线比例保持不变
 * 少了原点保持不变这一条。
 * 比如平移 
 * 
 * 
 * http://blog.csdn.net/pathuang68/article/details/6991867
 * https://en.wikipedia.org/wiki/Transformation_matrix
 * 
 * 平移：
 * my_matrix.translate( 5, 10 );
 * 
 * is the same as
 * my_matrix.tx += 5;
 * my_matrix.ty += 10;
 * 
 * 缩放:
 * my_matrix.scale( 1.5, 2 );
 * 
 * is the same as
 * my_matrix.a *= 1.5;
 * my_matrix.b *= 2;
 * my_matrix.c *= 1.5;
 * my_matrix.d *= 2;
 * my_matrix.tx *= 1.5;
 * my_matrix.ty *= 2;
 * 
 * 
 * 旋转:
 * my_matrix.rotate( Math.PI/4 );
 * 
 * is the same as
 * var sin = Math.sin( Math.PI/4 );
 * var cos = Math.cos( Math.PI/4 );
 * var a = my_matrix.a;
 * var b = my_matrix.b;
 * var c = my_matrix.c;
 * var d = my_matrix.d;
 * var tx = my_matrix.tx;
 * var ty = my_matrix.ty;
 * my_matrix.a = a*cos - b*sin;
 * my_matrix.b = a*sin + b*cos;
 * my_matrix.c = c*cos - d*sin;
 * my_matrix.d = c*sin + d*cos;
 * my_matrix.tx = tx*cos - ty*sin;
 * my_matrix.ty = tx*sin + ty*cos;
 * 
 * 
 * Inverse Matrices
 * 
 * |d/(a*d-b*c) 			-b/(a*d-b*c)				0|
 * |-c/(a*d-b*c)			a/a(a*d-b*c)				0|
 * |(c*ty-d*tx)/(a*b-b*c)	-(a*ty-b*tx)/(a*d-b*c)		1|
 * 
 * 
 * 通过点来计算a, b, c, d, tx, ty的公式
 * 通过矩阵乘法可以得出 
 * Px = a*Px + c*Py + tx
 * Py = b*Px + d*Py + ty
 * Pw = 1
 * 假设三个点 P0(0,0), P1(100,0), P2(0,100) (本地坐标 + 平移, 所以可以一直认为有一组这样的点 只不过 100 100 可换成 w,h)
 * P0x = tx;
 * P0y = ty;
 * =>
 * tx = P0x;
 * ty = P0y;
 * 
 * P1x = 100*a + tx = 100*a + P0x;
 * P1y = 100*b + ty = 100*b + P0y;
 * =>
 * a = (P1x - P0x)/100;
 * b = (P1y - P0y)/100;
 * 
 * P2.x = 100*c + tx = 100*c + P0x;
 * P2.y = 100*d + ty = 100*d + P0x;
 * =>
 * c = (P2x - P0x)/100;
 * d = (P2y - P0y)/100;
 * 
 * 
 * 得出公式
 * a = (p1.x-p0.x)/width
 * b = (p1.y-p0.y)/width
 * c = (p2.x-p0.x)/height
 * d = (p2.y-p0.y)/height
 * tx = p0.x
 * ty = p0.y
 * 
 * 这个是取了原图的 一个直角三角形形状, 任意的情况请看 ArbitraryBitmapfillTransforms.as
 * 
 * 
 */

package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	
	[SWF(width="800", height="600", frameRate="120", backgroundColor="0")]
	public class AffineTransformation2 extends Sprite
	{
		private var matrix:Matrix = new Matrix();
		
		[Embed(source="assets/Cat256256.jpg")]
		private var Cat:Class;
		
		private var cat:Bitmap = new Cat();
		
		private var p0:Sprite = new Sprite();
		private var p1:Sprite = new Sprite();
		private var p2:Sprite = new Sprite();
		
		private var dest:Sprite = new Sprite();
		
		private var currentP:Sprite;
		private var plist:Array = [p0, p1, p2];
		private var index:int = 0;
		public function AffineTransformation2()
		{
			super();
			
			dest.x = 100;
			dest.y = 100;
			dest.addChild(cat);
			addChild(dest);
			
			p0.graphics.beginFill(0x00ff00);
			p0.graphics.drawCircle(0,0,10);
			p0.graphics.endFill();
			p0.x = dest.x;
			p0.y = dest.y;
			addChild(p0);
			
			p1.graphics.beginFill(0x00ff00);
			p1.graphics.drawCircle(0,0,10);
			p1.graphics.endFill();
			p1.x = dest.x + 256;
			p1.y = 0;
			addChild(p1);
			
			p2.graphics.beginFill(0x00ff00);
			p2.graphics.drawCircle(0,0,10);
			p2.graphics.endFill();
			p2.x = 0;
			p2.y = dest.y + 256;
			addChild(p2);
			
			matrix.a = (p1.x - p0.x) / 256;
			matrix.b = (p1.y - p0.y) / 256;
			matrix.c = (p2.x - p0.x) / 256;
			matrix.d = (p2.y - p0.y) / 256;
			matrix.tx = p0.x;
			matrix.ty = p0.y;
			
			dest.transform.matrix = this.matrix;
			
			currentP = plist[index];
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function addjustMatrix():void
		{
			matrix.a = (p1.x - p0.x) / 256;
			matrix.b = (p1.y - p0.y) / 256;
			matrix.c = (p2.x - p0.x) / 256;
			matrix.d = (p2.y - p0.y) / 256;
			matrix.tx = p0.x;
			matrix.ty = p0.y;
			
			dest.transform.matrix = this.matrix;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					currentP.y -= 10;
					break;
				case Keyboard.DOWN:
					currentP.y += 10;
					break;
				case Keyboard.LEFT:
					currentP.x -= 10;
					break;
				case Keyboard.RIGHT:
					currentP.x += 10;
					break;
				case Keyboard.SPACE:
					index++
					if(index >= plist.length)
					{
						index = 0;
					}
					
					currentP = plist[index];
					break;
			}
			
			addjustMatrix();
		}
	}
}