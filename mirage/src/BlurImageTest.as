package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import utils.MColor;
	import utils.MMatrix;
	
	[SWF(width="800", height="600", frameRate="120", backgroundColor="0xcccccc")]
	public class BlurImageTest extends Sprite
	{
		[Embed(source="assets/head.jpg")]
		private var Background:Class;
		
		private var bg:Bitmap = new Background();
		
		private var dest:Bitmap = new Bitmap(new BitmapData(bg.width, bg.height, false, 0));
		public function BlurImageTest()
		{
			super();
			addChild(dest);
//			soomth(bg.bitmapData, dest.bitmapData);
//			blur(bg.bitmapData, dest.bitmapData);
//			pinch(bg.bitmapData, dest.bitmapData);
//			spherize(bg.bitmapData, dest.bitmapData);
//			swirl(bg.bitmapData, dest.bitmapData);
//			lighting(bg.bitmapData, dest.bitmapData);
			mosaic(bg.bitmapData, dest.bitmapData);
		}
		
		private function mosaic(src:BitmapData, dest:BitmapData):void
		{
			//小方块尺寸
			var block:int = 16;
			var product:int = block * block;
			
			var totalR:int = Math.ceil(src.height / block); //小方块的总行数
			var totalC:int = Math.ceil(src.width / block); //小方块的总列数
			
			var curC:int, curR:int;
			var color:MColor = new MColor();;
			var redd:uint, greend:uint, blued:uint;
			var b:int;
			//解决了边缘尺寸不足一个方块的问题。
			for(var c:int = 0; c < totalC; c++)
			{
				for(var r:int = 0; r < totalR; r++)
				{
					redd = greend = blued = 0;
					for(b = 0; b < product; b++)
					{
						//计算这单位内颜色的总和
						curC = c*block + b%block;
						curR = r*block + b/block>>0;
						if(curC >= src.width){
							curC = src.width - 1;
						}
						if(curR >= src.height){
							curR = src.height - 1;
						}
						
						color.setColor(src.getPixel32(curC, curR));
						redd += color.red;
						greend+= color.green;
						blued += color.blue;
					}
					
					redd /= product;
					greend /= product;
					blued /= product;
					
					//赋值
					for(b = 0; b < product; b++)
					{
						curC = c*block + b%block;
						curR = r*block + b/block>>0;
						if(curC > dest.width){
							curC = dest.width;
						}
						if(curR >= dest.height){
							curR = dest.height;
						}
						
						dest.setPixel32(curC, curR, 0xFF << 24 | redd << 16 | greend << 8 | blued);
					}
				}
			}
			
		}
		
		private function lighting(src:BitmapData, dest:BitmapData):void
		{
			
			var power:int = 100;
			
			var realX:int, realY:int;
			var xl:int = src.width / 2;//光源中心
			var yl:int = src.height / 2;
			var radiusd:Number = xl*xl + yl*yl;
			var radius:Number = Math.sqrt(radiusd);//光源半径
			
			//像素点的离光源中心的距离
			var distL:Number = 0, brightness:Number = 0;
			var color:MColor = new MColor();
			for(var c:int = 0; c < src.width; c++)
			{	
				for(var r:int = 0; r < src.height; r++)
				{
					distL = (c - xl)*(c - xl) + (r - yl)*(r - yl);//像素点离光源的距离
					
					color.setColor(src.getPixel32(c, r));
					if(distL < radiusd)
					{
						distL = Math.sqrt(distL);//用来计算光照强度
						
						brightness = power*(radius - distL)/radius;//这个可以参照点光源计算公式
						
						color.setByRGB(color.red + brightness, color.green + brightness, color.blue + brightness);
					}
					
					dest.setPixel32(c, r, color.color);
				}
			}
		}
		
		private function swirl(src:BitmapData, dest:BitmapData):void
		{
			
			var degree:int = 10;
			var swirlDegree:Number = degree / 1000;//这是一个程度变量,需要根据实际情况调节
			
			var realX:int, realY:int;
			var radian:Number = 0, radius:Number = 0;
			var midX:int = src.width / 2;
			var midY:int = src.height / 2;
			
			var offsetX:int, offsetY:int;
			for(var c:int = 0; c < src.width; c++)
			{	
				for(var r:int = 0; r < src.height; r++)
				{
					offsetX = c - midX;
					offsetY = r - midY;
					
					radian = Math.atan2(offsetY, offsetX);
					
					radius = Math.sqrt(offsetX*offsetX + offsetY*offsetY);
					
					realX = radius * Math.cos(radian + swirlDegree * radius) + midX;//因为radius 是不断变化的，近点的会变化小, 远的会变化大
					realY = radius * Math.sin(radian + swirlDegree * radius) + midY;
					
					//边界条件
					if(realX < 0){
						realX = 0;
					}else if(realX >= src.width){
						realX = src.width -1;
					}
					
					if(realY < 0){
						realY = 0;
					}else if(realY >= src.height){
						realY = src.height -1;
					}
					
					dest.setPixel32(c, r, src.getPixel32(realX, realY));
				}
			}
		}
		
		private function spherize(src:BitmapData, dest:BitmapData):void
		{
			
			var realX:int, realY:int;
			var radian:Number = 0, radius:Number = 0;
			var midX:int = src.width / 2;
			var midY:int = src.height / 2;
			var maxMidXY:int = midX > midY ? midX : midY;
			
			
			var offsetX:int, offsetY:int;
			for(var c:int = 0; c < src.width; c++)
			{	
				for(var r:int = 0; r < src.height; r++)
				{
					offsetX = c - midX;
					offsetY = r - midY;
					
					radian = Math.atan2(offsetY, offsetX);
					
					radius = (offsetX*offsetX + offsetY*offsetY) / maxMidXY;
					
					realX = radius * Math.cos(radian) + midX;
					realY = radius * Math.sin(radian) + midY;
					
					//边界条件
					if(realX < 0){
						realX = 0;
					}else if(realX >= src.width){
						realX = src.width -1;
					}
					
					if(realY < 0){
						realY = 0;
					}else if(realY >= src.height){
						realY = src.height -1;
					}

						dest.setPixel32(c, r, src.getPixel32(realX, realY));
				}
			}
		}
		
		private function pinch(src:BitmapData, dest:BitmapData):void
		{
			var degree:int = 15;
			
			var realX:int, realY:int;
			var radian:Number = 0, radius:Number = 0;
			var midX:int = src.width / 2;
			var midY:int = src.height / 2;
			
			var offsetX:int, offsetY:int;
//			var color:MColor = new MColor();
			for(var c:int = 0; c < src.width; c++)
			{	
				for(var r:int = 0; r < src.height; r++)
				{
					offsetX = c - midX;
					offsetY = r - midY;
					
					radian = Math.atan2(offsetY, offsetX);
					
					radius = Math.sqrt(offsetX*offsetX + offsetY*offsetY);
					radius = Math.sqrt(radius) * degree; 
					
					realX = radius * Math.cos(radian) + midX;
					realY = radius * Math.sin(radian) + midY;
					
					//边界条件
					if(realX < 0){
//						realX = 0;
						realX = -1;
					}else if(realX >= src.width){
//						realX = src.width -1;
						realX = src.width;
					}
					
					if(realY < 0){
//						realY = 0;
						realY = -1;
					}else if(realY >= src.height){
//						realY = src.height -1;
						realY = src.height;
					}
					
//					color.color = src.getPixel32(realX, realY);
//					dest.setPixel32(c, r, color.color);

					if(realX > 0 && realY >0){
						dest.setPixel32(c, r, src.getPixel32(realX, realY));
					}
				}
			}
		}
		
		private function blur(src:BitmapData, dest:BitmapData):void
		{
			var i:int;
			var p:Array = [];
			var color:MColor = new MColor();
			var angle:Number = -30, dist:uint = 25;
			angle %= 360;
			var radian:Number = angle * Math.PI / 180;
			
			//计算距离
			var dx:int = Math.cos(radian) * dist;
			var dy:int = Math.sin(radian) * dist;
			var k:Number = 0;
			var stepX:int,stepY:Number = 0;
			var x:int = 0, y:Number = 0;
			if( dx !=0 ){
				k = dy / dx;
				stepX = 1;
				stepY= k;
				if(dx < 0){
					stepX = -1;
					stepY = -k;
				}
				//总范围假如是 [0, 10], 需要将范围改为[-5, 5]
				x = 0, y = 0;
				for(i = 0; i <= Math.abs(dx); i++)
				{
					y += stepY;
					p[i] = new Point(x - dx/2 >> 0, y - dy/2 >> 0);
					x+=stepX;
				}
			}else{//处理dx=0的情况
				stepY= 1;
				if(dy < 0){
					stepY = -1;
				}
				y = 0;
				for(i = 0; i <= Math.abs(dy); i++)
				{
					y += stepY;
					p[i] = new Point(0, y - dy/2 >> 0);
				}
			}
			
			var realX:int, realY:int;
			var bSum:uint, gSum:uint, rSum:uint, aSum:uint, div:uint = 1, validPoint:uint = 0;
			//取得这个距离周围点的平均色彩值
			for(var c:int = 0; c < src.width; c++)
			{	
				for(var r:int = 0; r < src.height; r++)
				{
					bSum = gSum = rSum = aSum = validPoint = 0;
					div = 1;
					for(i = 0; i < p.length; i++)
					{
						realX = c + p[i].x;
						realY = r + p[i].y;
						if((realX >=0 && realX < src.width)&&(realY >=0 && realY < src.height))
						{
							color.setColor(src.getPixel32(realX, realY));
							bSum += color.blue * color.alpha;
							gSum += color.green * color.alpha;
							rSum += color.red * color.alpha;
							aSum += color.alpha;
							div += color.alpha;
							
							validPoint++;
						}
					}
					
					aSum /= validPoint;
					rSum /= div;
					gSum /= div;
					bSum /= div;
					
					color.setByRGB(rSum, gSum, bSum, aSum);
					
					dest.setPixel32(c, r, color.color);
				}
			}	
		}
		
		
		private function soomth(src:BitmapData, dest:BitmapData):void
		{
			var scaleTo:Number = 1/16, offSet:Number = 0;
			
			//因为最小的卷积核为 3x3 矩阵所以假如图片宽或高的像素不到3个，则无法使用卷积
			var mk:Array = [1,2,1, 2,4,2, 1,2,1];
			
			//图像最外一圈无法使用卷积, 因为边界的问题, 所以最外面一圈只是copy原图的像素
			var mc:MMatrix = new MMatrix(3,3);
			
			var destM:MMatrix = new MMatrix(3,3);
			var left:int = 1, top:int = 1, bottom:int = src.height - 1, right:int = src.width - 1;
			var topLeft:uint, topCenter:uint, topRight:uint;
			var midLeft:uint, midCenter:uint, midRight:uint; 
			var bottomLeft:uint, bottomCenter:uint, bottomRight:uint;
			var pixel:int, alpha:uint, red:int, blue:int, green:int;
			var color:uint;
			for(var c:int = left; c < right; c++)
			{	
				for(var r:int = top; r < bottom; r++)
				{
					topLeft = src.getPixel32(c - 1, r - 1);
					midLeft = src.getPixel32(c - 1, r);
					bottomLeft = src.getPixel32(c - 1, r + 1);
						
					topCenter = src.getPixel32(c, r - 1);
					midCenter = src.getPixel32(c, r);
					bottomCenter = src.getPixel32(c, r + 1);
						
					topRight = src.getPixel32(c + 1, r - 1);
					midRight = src.getPixel32(c + 1, r);
					bottomRight = src.getPixel32(c + 1, r + 1);
					
					//alpha
					alpha = midCenter >> 24 & 0xFF;
					
					//red
					red = (topLeft >> 16 & 0xFF) * mk[0] +
						  (topCenter >> 16 & 0xFF) * mk[1] +
						  (topRight >> 16 & 0xFF) * mk[2] +
						  (midLeft >> 16 & 0xFF) * mk[3] +
						  (midCenter >> 16 & 0xFF) * mk[4] +
						  (midRight >> 16 & 0xFF) * mk[5] +
						  (bottomLeft >> 16 & 0xFF) * mk[6] +
						  (bottomCenter >> 16 & 0xFF) * mk[7] +
						  (bottomRight >> 16 & 0xFF) * mk[8];
					//green
					green = (topLeft >> 8 & 0xFF) * mk[0] +
							(topCenter >> 8 & 0xFF) * mk[1] +
							(topRight >> 8 & 0xFF) * mk[2] +
							(midLeft >> 8 & 0xFF) * mk[3] +
							(midCenter >> 8 & 0xFF) * mk[4] +
							(midRight >> 8 & 0xFF) * mk[5] +
							(bottomLeft >> 8 & 0xFF) * mk[6] +
							(bottomCenter >> 8 & 0xFF) * mk[7] +
							(bottomRight >> 8 & 0xFF) * mk[8];
					//blue
					blue = (topLeft & 0xFF) * mk[0] +
							(topCenter & 0xFF) * mk[1] +
							(topRight & 0xFF) * mk[2] +
							(midLeft & 0xFF) * mk[3] +
							(midCenter & 0xFF) * mk[4] +
							(midRight & 0xFF) * mk[5] +
							(bottomLeft & 0xFF) * mk[6] +
							(bottomCenter & 0xFF) * mk[7] +
							(bottomRight & 0xFF) * mk[8];
					
					red = red * scaleTo + offSet;
					green = green * scaleTo + offSet;
					blue = blue * scaleTo + offSet;
					
					if(red < 0){
						red = 0
					}else if(red > 255)
					{
						red = 255;
					}
					
					if(green < 0){
						green = 0
					}else if(green > 255)
					{
						green = 255;
					}
					
					if(blue < 0){
						blue = 0
					}else if(blue > 255)
					{
						blue = 255;
					}
					
					color = alpha << 24 | red << 16 | green << 8 | blue;
					dest.setPixel32(c,r, color);
				}
			}
			
		}
		
	}
}