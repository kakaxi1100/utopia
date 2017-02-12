package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="0x000000")]
	public class LightTest extends Sprite
	{
//---------alpha blend-------------------------		
		[Embed(source="assets/surge.jpg")]
		private var surge:Class;
		
		[Embed(source="assets/graywal.jpg")]
		private var Module:Class;
		
		private var m:Bitmap = new Module();
		private var s:Bitmap = new surge();
		
		private var n:Bitmap = new Bitmap(new BitmapData(m.width, m.height, false));
		
		private var alpha:Number = 0.3;
		public function LightTest(){
			super();
			
			addChild(m);
			
			s.x = m.width;
			addChild(s);
			
			n.y = m.height + 10;
			addChild(n);
			
			blend();
		}
		
		private function blend():void{
			for(var i:int = 0; i < m.bitmapData.width; i++)
			{
				for(var j:int = 0; j < m.bitmapData.height; j++)
				{
					var c:uint, a:uint, r:uint, g:uint, b:uint;
					
					c = s.bitmapData.getPixel32(i, j);
					var sa:uint = (c>>24 & 0x000000ff);
					var sr:uint = (c>>16 & 0x000000ff);
					var sg:uint = (c>>8 & 0x000000ff);
					var sb:uint = (c & 0x000000ff)
										
					c =  m.bitmapData.getPixel32(i, j);
					var ma:uint = (c>>24 & 0x000000ff);
					var mr:uint = (c>>16 & 0x000000ff);
					var mg:uint = (c>>8 & 0x000000ff);
					var mb:uint = (c & 0x000000ff);
					
					a = Math.min(ma*alpha + sa*(1-alpha), 255);
					r = Math.min(mr*alpha + sr*(1-alpha), 255);
					g = Math.min(mg*alpha + sg*(1-alpha), 255);
					b = Math.min(mb*alpha + sb*(1-alpha), 255);
					
					c = a<<24 | r<<16 | g<<8 | b;
					n.bitmapData.setPixel32(i, j, c);
				}
			}
		}
//----------------light test--------------------------------------------------------		
//		[Embed(source="assets/whitecircle.png")]
//		private var Light:Class;
//		
//		[Embed(source="assets/graywal.jpg")]
//		private var Module:Class;
//		
//		private var m:Bitmap = new Module();
//		private var l:Bitmap = new Light();
//		
//		private var n:Bitmap = new Bitmap(new BitmapData(m.width, m.height, false));
//		
//		private var ambient:Number = 0.1;
//		private var isOne:int = 0;
//		public function LightTest()
//		{
//			super();
//			
//			addChild(m);
//			
//			l.x = m.width;
//			addChild(l);
//			
//			n.y = m.height + 10;
//			addChild(n);
//			
//			formulaTwo();
//			
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//		}
//		
//		protected function onEnterFrame(event:Event):void
//		{
//			if(isOne == 0){
//				formulaTwo();
//			}else{
//				formulaOne();
//			}
//		}
//		
//		protected function onKeyDown(event:KeyboardEvent):void
//		{
//			switch(event.keyCode)
//			{
//				case Keyboard.A:
//				{
//					ambient += 0.1;
//					trace(ambient);
//					break;
//				}
//				case Keyboard.S:
//				{
//					ambient -= 0.1;
//					trace(ambient);
//					break;
//				}	
//				case Keyboard.SPACE:
//				{
//					isOne ^= 1;
//					break;
//				}	
//				default:
//				{
//					break;
//				}
//			}
//		}
//		
//		private function formulaOne():void{
//			for(var i:int = 0; i < m.bitmapData.width; i++)
//			{
//				for(var j:int = 0; j < m.bitmapData.height; j++)
//				{
//					var c:uint, a:uint, r:uint, g:uint, b:uint;
//					
//					c = l.bitmapData.getPixel32(i,j);
//					var la:uint = (c>>24 & 0x000000ff);
//					var lr:uint = (c>>16 & 0x000000ff);
//					var lg:uint = (c>>8 & 0x000000ff);
//					var lb:uint = (c & 0x000000ff)
//										
//					c =  m.bitmapData.getPixel32(i, j);
//					var ma:uint = (c>>24 & 0x000000ff);
//					var mr:uint = (c>>16 & 0x000000ff);
//					var mg:uint = (c>>8 & 0x000000ff);
//					var mb:uint = (c & 0x000000ff);
//					
//					a = Math.min(ma*ambient + la*ma/255, 255);
//					r = Math.min(mr*ambient + lr*mr/255, 255);
//					g = Math.min(mg*ambient + lg*mg/255, 255);
//					b = Math.min(mb*ambient + lb*mb/255, 255);
//					
//					c = a<<24 | r<<16 | g<<8 | b;
//					n.bitmapData.setPixel32(i, j, c);
//				}
//			}
//		}
//		
//		private function formulaTwo():void{
//			for(var i:int = 0; i < m.bitmapData.width; i++)
//			{
//				for(var j:int = 0; j < m.bitmapData.height; j++)
//				{
//					var c:uint, a:uint, r:uint, g:uint, b:uint;
//					
//					c = l.bitmapData.getPixel32(i,j);
//					var la:uint = (c>>24 & 0x000000ff);
//					var lr:uint = (c>>16 & 0x000000ff);
//					var lg:uint = (c>>8 & 0x000000ff);
//					var lb:uint = (c & 0x000000ff)
//					
//					c =  m.bitmapData.getPixel32(i, j);
//					var ma:uint = (c>>24 & 0x000000ff);
//					var mr:uint = (c>>16 & 0x000000ff);
//					var mg:uint = (c>>8 & 0x000000ff);
//					var mb:uint = (c & 0x000000ff);
//					
//					a = Math.min(la*ambient + ma, 255);
//					r = Math.min(lr*ambient + mr, 255);
//					g = Math.min(lg*ambient + mg, 255);
//					b = Math.min(lb*ambient + mb, 255);
//					
//					c = a<<24 | r<<16 | g<<8 | b;
//					n.bitmapData.setPixel32(i, j, c);
//				}
//			}
//		}
//-------------------------------------------------------------------------------------		
	}
}