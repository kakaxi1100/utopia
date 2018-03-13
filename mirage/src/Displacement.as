/**
 *http://www.innerdrivestudios.com/blog/actionscript-2/as2-displacement-maps/displacement-maps-basics 
 * reusltPixel[x, y] = srcPixel[x + ((displaceX(x, y) - 128) * scaleX) / 256, y + ((displaceY(x, y) - 128) * scaleY) / 256]
 * 对这个公式有疑问, 觉得/128更合适
 * reusltPixel[x, y] = srcPixel[x + ((displaceX(x, y) - 128) * scaleX) / 128, y + ((displaceY(x, y) - 128) * scaleY) / 128]
 * 
 * 这个公式可以简化为
 * 
 * r[x,y] = s[x + dx*scaleX, y + dy*scaleY];
 * rx = sx + dx * scaleX;
 * ry = sy + dy * scaleY;
 * 很显然 dx和dy应该在 -1 到 1 之间取值
 * 而displaceX(x, y) = 0~255 如果要它等于 -1~1 之间
 * (dispaceX(x, y) - 128)/128
 * 所以我认为上面的公式不应该 /256 而是应该 /128
 * 
 * 那么如果知道结果图片如何求出置换贴图呢？
 * 因为这里是求颜色, 所以不需要用位置的参数
 * r = s + d => d = r - s
 * 即:
 * (displace(x,y) - 128) = r(x, y) - s(x, y);
 * 
 * displace(x,y) = r(x, y) - s(x, y) + 128;
 * 
 * 原图  s 我们可以用一张 所有颜色都不重复的图片来得到
 * r 我们可以通过photoshop对 s 执行滤镜得到
 * 通过这个公式我们就可以得到置换图
 * 
 * 
 */
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import utils.MColor;

	[SWF(width="800", height="600", frameRate="120", backgroundColor="0")]
	public class Displacement extends Sprite
	{
		[Embed(source="assets/base.jpg")]
		private var Base:Class;
	
		[Embed(source="assets/Cat256256.jpg")]
		private var Cat:Class;
		
		[Embed(source="assets/sphere.jpg")]
		private var Sphere:Class;
		[Embed(source="assets/shear.jpg")]
		private var Shear:Class;
		[Embed(source="assets/zigzag.jpg")]
		private var Zigzag:Class;
		[Embed(source="assets/crystal.jpg")]
		private var Crystal:Class;
		
		
		private var sphereData:Bitmap = new Sphere();
		private var shearData:Bitmap = new Shear();
		private var zigzagData:Bitmap = new Zigzag();
		private var crystalData:Bitmap = new Crystal();
		
		private var baseData:Bitmap = new Base();
		private var grayData:Bitmap = new Bitmap(new BitmapData(baseData.width, baseData.height, false, 0x808080));
		private var displaceData:Bitmap = new Bitmap(new BitmapData(baseData.width, baseData.height, false, 0xcccccc));
		
		private var cat:Bitmap = new Cat();
		private var destData:Bitmap = new Bitmap(new BitmapData(baseData.width, baseData.height, false, 0xcccccc));
		
		private var scaleFactor:int = 128;
		private var effectList:Array = [sphereData, shearData, zigzagData, crystalData];
		private var effectIndex:int = 0;
		public function Displacement()
		{
			super();
			
			addChild(baseData);
			
			sphereData.x = baseData.x + baseData.width;
			addChild(sphereData);
			shearData.x = baseData.x + baseData.width;
			addChild(shearData);
			zigzagData.x = baseData.x + baseData.width;
			addChild(zigzagData);
			crystalData.x = baseData.x + baseData.width;
			addChild(crystalData);
			
			
			grayData.x = sphereData.x + sphereData.width;
			addChild(grayData);
			
			displaceData.y = baseData.y + baseData.height;
			addChild(displaceData);
			
			cat.y = displaceData.y;
			cat.x = displaceData.x + displaceData.width;
			addChild(cat);
			
			destData.y = cat.y;
			destData.x = cat.x + cat.width;
			addChild(destData);
			
			setVisiabeEffect();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function applyDiaplaceData():void
		{
			var i:int, j:int;
			var data:BitmapData = destData.bitmapData;
			var sData:BitmapData = cat.bitmapData;
			for(i = 0; i < baseData.width; i++)
			{
				for(j = 0; j < baseData.height; j++)
				{
					var dxy:uint = displaceData.bitmapData.getPixel32(i, j);
					var dColor:MColor = new MColor(dxy);
					
					var sX:int = i  + (dColor.red - 128)/128 * scaleFactor;
					var sY:int = j + (dColor.green - 128)/128 * scaleFactor;
					if(sX < 0){
						sX = 0;
					}else if(sX > 255){
						sX = 255;
					}
					if(sY < 0){
						sY = 0;
					}else if(sY > 255){
						sY = 255;
					}
//					trace(sX, sY);
					var color:uint = sData.getPixel32(sX, sY);
					
					
					data.setPixel32(i, j, color); 
				}
			}
		}
		
		private function calculateDisplaceData():void
		{
			var i:int, j:int;
			var data:BitmapData = displaceData.bitmapData;
			for(i = 0; i < baseData.width; i++)
			{
				for(j = 0; j < baseData.height; j++)
				{
					var sxy:uint = baseData.bitmapData.getPixel32(i, j);
					var sColor:MColor = new MColor(sxy);
					var rxy:uint = effectList[effectIndex].bitmapData.getPixel32(i, j);
					var rColor:MColor = new MColor(rxy);
					
					var destColor:MColor = new MColor();
					var red:int = (rColor.red - sColor.red) + 128;
					var green:int = (rColor.green - sColor.green) + 128;
					var blue:int = (rColor.blue - sColor.blue) + 128;
					if(red < 0){
						red = 0;
					}else if(red > 255){
						red = 255;
					}
					
					if(green < 0){
						green = 0;
					}else if(green > 255){
						green = 255;
					}
					
					if(blue < 0){
						blue = 0;
					}else if(blue > 255){
						blue = 255;
					}
					destColor.setByRGB(red, green, blue);
					
					data.setPixel32(i, j, destColor.color);
				}
			}
		}
			
		private function setVisiabeEffect():void
		{
			for(var i:int = 0; i < effectList.length; i++)
			{
				if(i == effectIndex){
					effectList[effectIndex].visible = true;
				}else{
					effectList[i].visible = false;
				}
			}
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			var change:Boolean = false;
			switch(event.keyCode)
			{
				case Keyboard.UP:
					scaleFactor += 10;
					change = true;
					break;
				case Keyboard.DOWN:
					scaleFactor -= 10;
					change = true;
					break;
				case Keyboard.LEFT:
					effectIndex -= 1;
					if(effectIndex < 0)
					{
						effectIndex = effectList.length - 1;
					}
					setVisiabeEffect();
					change = true;
					break;
				case Keyboard.RIGHT:
					effectIndex += 1;
					if(effectIndex >= effectList.length)
					{
						effectIndex = 0;
					}
					setVisiabeEffect();
					change = true;
					break;
				case Keyboard.SPACE:
					change = true;
					break;
			}
			
			if(change)
			{
				trace(scaleFactor);
				calculateDisplaceData();
				applyDiaplaceData();
			}
		}
	}
}