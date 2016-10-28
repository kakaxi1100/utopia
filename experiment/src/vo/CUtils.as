package vo
{
	import flash.display.BitmapData;

	public class CUtils
	{
		public static function random_quadrangle(source:BitmapData, sw:Number, sh:Number, vertexs:Vector.<CVector>, dest:BitmapData):void
		{
			//偏移量
			var offsetLeftX:Number, offsetLeftY:Number;
			var offsetRightX:Number, offsetRightY:Number;	
			var leftPointX:Number, leftPointY:Number;
			var rightPointX:Number, rightPointY:Number;
			
			offsetLeftX = (vertexs[2].x - vertexs[0].x)/sh; //平均每行左边X要走多少步
			offsetLeftY = (vertexs[2].y - vertexs[0].y)/sh; //平均每行左边Y要走多少步
			offsetRightX = (vertexs[3].x - vertexs[1].x)/sh;//平均每行右边X要走多少步
			offsetRightY = (vertexs[3].y - vertexs[1].y)/sh;//平均每行右边X要走多少步
			
			leftPointX = vertexs[0].x;
			leftPointY = vertexs[0].y;
			rightPointX = vertexs[1].x;
			rightPointY = vertexs[1].y;
			
			//当前斜线段的X,Y的比例
			var hDX:Number, hDY:Number;
			
			//颜色分量, 要放的点
			var color:uint;
			var tx:Number, ty:Number;
			for(var i:int = 0; i < sh; i++)
			{
				hDX = (rightPointX - leftPointX) / sw;
				hDY = (rightPointY - leftPointY) / sw;
				
				tx = leftPointX;
				ty = leftPointY;
				for(var j:int = 0; j < sw; j++)
				{
					color = source.getPixel32(j, i);
					dest.setPixel32(int(tx), int(ty), color);
					tx += hDX;
					ty += hDY;
				}
				
				leftPointX += offsetLeftX;
				leftPointY += offsetLeftY;
				rightPointX += offsetRightX;
				rightPointY += offsetRightY;
			}
		}
	}
}