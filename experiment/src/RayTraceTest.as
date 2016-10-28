package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vo.CUtils;
	import vo.CVector;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="0x000000")]
	public class RayTraceTest extends Sprite
	{
		[Embed(source="assets/14.png")]
		private var Laser1:Class;
		
		[Embed(source="assets/Laser_2.png")]
		private var Laser2:Class;
		
		private var bmp2:Bitmap = new Laser2();
		private var empty:Bitmap = new Bitmap(new BitmapData(640, 480, false, 0));
		private var vertexs:Vector.<CVector> = new Vector.<CVector>();
		public function RayTraceTest()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addChild(empty);
			
			vertexs.push(new CVector(0,0), new CVector(32, 0), new CVector(0, 32), new CVector(32, 32));
			CUtils.random_quadrangle(bmp2.bitmapData, 16,16,vertexs, empty.bitmapData);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			vertexs[0].reset(0,0);
			vertexs[1].reset(stage.mouseX, stage.mouseY);
			vertexs[2].reset(-stage.mouseY, stage.mouseX);
			vertexs[3].reset((stage.mouseX-stage.mouseY), (stage.mouseY+stage.mouseX));
			empty.bitmapData.fillRect(empty.bitmapData.rect, 0);
			CUtils.random_quadrangle(bmp2.bitmapData, 16,16,vertexs, empty.bitmapData);
		}
	}
}