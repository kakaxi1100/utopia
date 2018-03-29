/**
 * var dIn32x:Number = in3.x – in2.x;
 * var dIn13x:Number = in1.x – in3.x;
 * var dIn21x:Number = in2.x – in1.x;
 * var dIn32y:Number = in3.y – in2.y;
 * var dIn13y:Number = in1.y – in3.y;
 * var dIn21y:Number = in2.y – in1.y;
 * var denomAB:Number = 1/((in1.x * dIn32y) + (in2.x * dIn13y) + (in3.x * dIn21y));
 * var denomCD:Number = 1/((in1.y * dIn32x) + (in2.y * dIn13x) + (in3.y * dIn21x));
 * 
 * var matrix:Matrix = new Matrix();
 * matrix.a = ((out1.x * dIn32y) + (out2.x * dIn13y) + (out3.x * dIn21y)) * denomAB;
 * matrix.b = ((out1.y * dIn32y) + (out2.y * dIn13y) + (out3.y * dIn21y)) * denomAB;
 * matrix.c = ((out1.x * dIn32x) + (out2.x * dIn13x) + (out3.x * dIn21x)) * denomCD;
 * matrix.d = ((out1.y * dIn32x) + (out2.y * dIn13x) + (out3.y * dIn21x)) * denomCD;
 * matrix.tx = out1.x – (matrix.a * in1.x) – (matrix.c * in1.y);
 * matrix.ty = out1.y – (matrix.b * in1.x) – (matrix.d * in1.y);
 * 
 * and modify them to accomplish the division of the plane into smaller rectangles, which are divided into triangles.
 * 
 * in1______in3
 * |\       |
 * | \      |
 * |  \     |
 * |   \    |
 * |    \   |
 * |     \  |
 * |      \ |
 * |_______\|
 * in3     in2
 *  
 * var dIn32x:Number = in3.x – in2.x => -piecewidth
 * var dIn13x:Number = in1.x – in3.x => 0
 * var dIn21x:Number = in2.x – in1.x => piecewidth
 * var dIn32y:Number = in3.y – in2.y => 0
 * var dIn13y:Number = in1.y – in3.y => -pieceheight
 * var dIn21y:Number = in2.y – in1.y => pieceheight
 * 
 * var denomAB:Number = 1/((in2.x * -pieceheight) + (in3.x * pieceheight));
 * var denomCD:Number = 1/((in1.y * -piecewidth) + (in3.y * piecewidth));
 * 
 * So we see our In1 coordinate is simply (x*piecewidth, y*pieceheight), 
 * In2 is ((x+1)*piecewidth, (y+1)*pieceheight) and In3b is (x*piecewidth, (y+1)*pieceheight).
 * 
 * var denomAB:Number = 1/(((x+1)*piecewidth * -pieceheight) + (x*piecewidth * pieceheight));
 * var denomCD:Number = 1/((y*pieceheight * -piecewidth) + ((y+1)*pieceheight * piecewidth)); 
 * 
 * var denomAB:Number = 1/(((x+1)*-pieceArea) + (x*pieceArea));
 * var denomCD:Number = 1/((y*-pieceArea) + ((y+1)*pieceArea));
 * 
 * Is the same as:
 * 
 * var denomAB:Number = -1/pieceArea;
 * var denomCD:Number = 1/pieceArea;
 * 
 * var matrix:Matrix = new Matrix();
 * matrix.a = ((out1.x * dIn32y) + (out2.x * dIn13y) + (out3.x * dIn21y)) * denomAB;
 * matrix.b = ((out1.y * dIn32y) + (out2.y * dIn13y) + (out3.y * dIn21y)) * denomAB;
 * matrix.c = ((out1.x * dIn32x) + (out2.x * dIn13x) + (out3.x * dIn21x)) * denomCD;
 * matrix.d = ((out1.y * dIn32x) + (out2.y * dIn13x) + (out3.y * dIn21x)) * denomCD;
 * matrix.tx = out1.x - (matrix.a * in1.x) - (matrix.c * in1.y);
 * matrix.ty = out1.y - (matrix.b * in1.x) - (matrix.d * in1.y);
 *
 *will give us:
 *
 * var matrix:Matrix = new Matrix();
 * matrix.a = ((out2.x * -pieceheight) + (out3.x * pieceheight)) * denomAB;
 * matrix.b = ((out2.y * -pieceheight) + (out3.y * pieceheight)) * denomAB;
 * matrix.c = ((out1.x * -piecewidth) + (out3.x * piecewidth)) * denomCD;
 * matrix.d = ((out1.y * -piecewidth) + (out3.y * piecewidth)) * denomCD;
 * matrix.tx = out1.x - (matrix.a * x*piecewidth) - (matrix.c * y * pieceheight);
 * matrix.ty = out1.y - (matrix.b * x*piecewidth) - (matrix.d * y * pieceheight);
 *
 * Simplifying this further gives us:
 *
 * matrix.a = (out2.x - out3.x)	* pieceheight/ pieceArea;
 * matrix.b = (out2.y -out3.y) * pieceheight /pieceArea;
 * matrix.c = (out3.x - out1.x) * piecewidth / pieceArea;
 * matrix.d = (out3.y - out1.y) * piecewidth /pieceArea;
 * matrix.tx = out1.x - (matrix.a * x*piecewidth) - (matrix.c * y * pieceheight);
 * matrix.ty = out1.y - (matrix.b * x*piecewidth) - (matrix.d * y * pieceheight);
 *
 * And further:
 * 
 * matrix.a = (out2.x-out3.x)/piecewidth;
 * matrix.b = (out2.y-out3.y)/piecewidth;
 * matrix.c = (out3.x-out1.x)/pieceheight;
 * matrix.d = (out3.y-out1.y)/pieceheight;
 * matrix.tx = out1.x - (matrix.a * x * piecewidth) - (matrix.c * y * pieceheight);
 * matrix.ty = out1.y - (matrix.b * x * piecewidth) - (matrix.d * y * pieceheight);
 *
 * And even further:
 * 
 * matrix.a = (out2.x-out3.x)/piecewidth;
 * matrix.b = (out2.y-out3.y)/piecewidth;
 * matrix.c = (out3.x-out1.x)/pieceheight;
 * matrix.d = (out3.y-out1.y)/pieceheight;
 * matrix.tx = out1.x - ((out2.x-out3.x) * x) - ((out3.x-out1.x) * y);
 * matrix.ty = out1.y - ((out2.y-out3.y) * x) - ((out3.y-out1.y) * y);
 *
 * We could store the out pairs into variables, but the storing and lookup probably costs just as much as calculating it again.
 * A slight rewrite might save a bit more, using invPieceWidth = 1/lPieceWidth and invPieceHeight = 1/lPieceHeight, or in other words:
 * 
 * invPieceWidth = gridXCount/bitmapwidth
 * invPieceHeight = gridYCount/bitmapheight
 * 
 * And then:
 * 
 * matrix.a = (out2.x-out3.x);
 * matrix.b = (out2.y-out3.y);
 * matrix.c = (out3.x-out1.x);
 * matrix.d = (out3.y-out1.y);
 * matrix.tx = out1.x - (matrix.a * x) - (matrix.c * y);
 * matrix.ty = out1.y - (matrix.b * x) - (matrix.d * y);
 * matrix.a *= invPieceWidth;
 * matrix.b *= invPieceWidth;
 * matrix.c *= invPieceHeight;
 * matrix.d *= invPieceHeight;
 * 
 * 
 * interpolated value:
 * 
 * pTop.x = (1-ix)*pUL.x+ix*pUR.x;
 * pTop.y = (1-ix)*pUL.y+ix*pUR.y;
 * pBottom.x = (1-ix)*pLL.x+ix*pLR.x;
 * pBottom.y = (1-ix)*pLL.y+ix*pLR.y;
 * 
 * and then interpolate these over y where pIP is the interpolated point:
 * 
 * pIP.x = (1-iy)*pTop.x-iy*pBottom.x;
 * pIP.y = (1-iy)*pTop.y-iy*pBottom.y;
 * 
 * Put together:
 * 
 * pIP.x = (1-iy)*((1-ix)*pUL.x+ix*pUR.x)-iy*((1-ix)*pLL.x+ix*pLR.x);
 * pIP.y = (1-iy)*((1-ix)*pUL.y+ix*pUR.y)-iy*((1-ix)*pLL.y+ix*pLR.y);
 * 
 * http://www.innerdrivestudios.com/blog/actionscript-2/as2-3d-principles-and-experiments/part-iii-plane-rendering
 */

package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	
	[SWF(width="800", height="600", frameRate="120", backgroundColor="0")]
	public class MultiTriangleBitmapfill extends Sprite
	{
		[Embed(source="assets/Cat256256.jpg")]
		private var Cat:Class;
		private var cat:Bitmap = new Cat();
		
		private var src:Sprite = new Sprite();
		private var dest:Sprite = new Sprite();
		private var matrix:Matrix = new Matrix();
		
		private var inList:Array = [];
		private var outList:Array = [];
		
		private var rows:int;
		private var cols:int;
		
		private var pieceW:int;
		private var pieceH:int;
		
		private var currentP:Sprite;
		private var index:int = 0;
		private var plist:Array = [];
		
		public static var dotRadius:Number = 2;
		public function MultiTriangleBitmapfill()
		{
			super();
			
			src.x = 100;
			src.y = 100;
			addChild(src);
			src.addChild(cat);
			
			dest.graphics.lineStyle(2, 0xfffffff);
			dest.graphics.drawRect(0,0,256,256);
			dest.x = src.x + src.width + 40;
			dest.y = src.y;
			addChild(dest);
			
			this.rows = 16;
			this.cols = 16;
			this.gridsImage(cat.width, cat.height);
			this.renderGrids();
			this.renderDest();
			
			currentP = outList[index];
			currentP.graphics.beginFill(0xff0000);
			currentP.graphics.drawCircle(0,0,dotRadius*2);
			currentP.graphics.endFill();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
					currentP.graphics.clear();
					currentP.graphics.beginFill(0x00ff00);
					currentP.graphics.drawCircle(0,0,dotRadius*2);
					currentP.graphics.endFill();
					if(index >= plist.length)
					{
						index = 0;
					}
					currentP = plist[index];
					currentP.graphics.clear();
					currentP.graphics.beginFill(0xff0000);
					currentP.graphics.drawCircle(0,0,dotRadius*4);
					currentP.graphics.endFill();
					break;
			}
			
			addjustOutPoints();
			this.renderDest();
		}
		
		//调整所有的OutPoints
		//因为只要有一个点移动了, 那么所有点都要重新计算
		//那么根据什么计算呢
		//1.算上边 进行线性插值 得到了一系列点
		//2.算下边 进行线性插值 得到了一系列点
		//3.算中间 进行线性插值 得到了一系列点
		//Pu = (1 - tx) * Pul + tx * Pur;
		//Pd = (1 - tx) * Pdl + tx * Pdr;
		//P = (1 - ty) * Pux + ty * Pdx; 
		//tx = ix * 1/c
		//ty = iy * 1/r
		
		private function addjustOutPoints():void
		{
			var i:int, j:int;
			var tx:Number, ty:Number;
			var puxX:Number, puxY:Number; 
			var pdxX:Number, pdxY:Number;
			
			var dot:Dot;
			for(i = 0; i <= rows; i++)
			{
				for(j = 0; j <= cols; j++)
				{
					tx = j /cols;
					ty = i / rows;
					
					puxX = (1 - tx)*outList[0].x + tx*outList[cols].x;
					puxY = (1 - tx)*outList[0].y + tx*outList[cols].y;
					
					pdxX = (1 - tx)*outList[rows * (cols + 1)].x + tx*outList[rows * (cols + 1) + cols].x;
					pdxY = (1 - tx)*outList[rows * (cols + 1)].y + tx*outList[rows * (cols + 1) + cols].y;
					
					dot = outList[i * (cols + 1) + j];
					dot.x = (1 - ty) * puxX + ty * pdxX;
					dot.y = (1 - ty) * puxY + ty * pdxY;
				}
			}
		}
		
		/**
		* matrix.a = (out2.x-out3.x)/piecewidth;
		* matrix.b = (out2.y-out3.y)/piecewidth;
		* matrix.c = (out3.x-out1.x)/pieceheight;
		* matrix.d = (out3.y-out1.y)/pieceheight;
		* matrix.tx = out1.x - ((out2.x-out3.x) * col) - ((out3.x-out1.x) * row);
		* matrix.ty = out1.y - ((out2.y-out3.y) * col) - ((out3.y-out1.y) * row);
		* row, col是in1的行列
		* 注意不是grids的行列
		* in的行列比grids的行列大一轮
		* 
	    */
		private function renderDest():void
		{
			var i:int, j:int, ix:int, iy:int;
			var out1:Dot, out2:Dot, out3:Dot;
			dest.graphics.clear();
			
			for(i = 0; i < rows; i++)
			{
				for(j = 0; j < cols; j++)
				{
					out1 = outList[i * (cols + 1) + j]; 
					out2 = outList[(i + 1)*(cols + 1) + (j + 1)];
					out3 = outList[(i + 1)*(cols + 1) + j];
					
					matrix.a = (out2.x-out3.x)/pieceW;
					matrix.b = (out2.y-out3.y)/pieceW;
					matrix.c = (out3.x-out1.x)/pieceH;
					matrix.d = (out3.y-out1.y)/pieceH;
					matrix.tx = out1.x - ((out2.x-out3.x) * j) - ((out3.x-out1.x) * i);
					matrix.ty = out1.y - ((out2.y-out3.y) * j) - ((out3.y-out1.y) * i);
					
					dest.graphics.beginBitmapFill(cat.bitmapData, matrix, false, true);
					dest.graphics.moveTo(out1.x, out1.y);
					dest.graphics.lineTo(out2.x, out2.y);
					dest.graphics.lineTo(out3.x, out3.y);
					dest.graphics.lineTo(out1.x, out1.y);
					dest.graphics.endFill();
					
					out3 = outList[i * (cols + 1) + j + 1];
					dest.graphics.beginBitmapFill(cat.bitmapData, matrix, false, true);
					dest.graphics.moveTo(out1.x, out1.y);
					dest.graphics.lineTo(out2.x, out2.y);
					dest.graphics.lineTo(out3.x, out3.y);
					dest.graphics.lineTo(out1.x, out1.y);
					dest.graphics.endFill();
				}
			}
			
		}
		
		private function renderGrids():void
		{
			var i:int; 
			for(i = 0; i < inList.length; i++)
			{
				src.addChild(inList[i]);
			}
			
			for(i = 0; i < outList.length; i++)
			{
				dest.addChild(outList[i]);
			}
		}
		
		private function gridsImage(tw:Number, th:Number):void
		{
			var i:int, j:int;
			var dot:Dot;
			
			pieceW = tw / cols;
			pieceH = th / rows;
			
			while(inList.length > 0)
			{
				src.removeChild(inList.pop());
			}
			
			while(outList.length > 0)
			{
				dest.removeChild(outList.pop());
			}
			
			for(i = 0; i <= rows; i++)
			{
				for(j = 0; j <= cols; j++)
				{
					dot = new Dot(dotRadius);
					dot.x = j * pieceW;
					dot.y = i * pieceH;
					inList.push(dot);
					
					dot = new Dot(dotRadius);
					dot.x = j * pieceW;
					dot.y = i * pieceH;
					outList.push(dot);
					dot.alpha = 0.5;
				}
			}
			
			plist = [];
			plist[0] = outList[0];
			plist[1] = outList[cols];
			plist[2] = outList[rows * (cols + 1)];
			plist[3] = outList[rows * (cols + 1) + cols];
			plist[0].alpha = 1;
			plist[1].alpha = 1;
			plist[2].alpha = 1;
			plist[3].alpha = 1;
		}
	}
}
import flash.display.Sprite;

class Dot extends Sprite
{
	public function Dot(r:Number)
	{
		super();
		this.graphics.beginFill(0x00ff00);
		this.graphics.drawCircle(0,0, r);
		this.graphics.endFill();
	}
}














