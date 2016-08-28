package
{
	import flash.display.Bitmap;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import graphics.Circle;
	import graphics.Particle3D;
	
	public class Rotate3DTest extends Sprite
	{
		private var ps:Array = [];
		private var a:Number = 0;
		private var container:Sprite = new Sprite();
		
		[Embed(source="assets/surge.png")]
		private var Surge:Class;
		public function Rotate3DTest()
		{
			super();
		
			container.x = stage.stageWidth / 2 - 50;
			container.y = stage.stageHeight / 2 - 50;
			addChild(container);
			
			for(var i:int = 0; i < 5; i++)
			{
				for(var j:int = 0; j < 5; j++)
				{
//					var c:Circle = new Circle(Math.random()*0xFFFFFF);
					var c:Bitmap = new Surge();
					var x:Number = (i - 2) * 50;
					var y:Number = (j - 2) * 50;
					var p:Particle3D = new Particle3D(x, y, 0, container, c);
					p.render();
					ps.push(p);
					
				}
			}
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
		}
		
		protected function onEnterframe(event:Event):void
		{
			ps.sort(zsort);
			//绕X轴旋转
			for(var i:int = 0; i < ps.length; i++)
			{
				var p:Particle3D = ps[i];
				container.addChild(p.mc);
				p.pos.rotateXYZ(a, a, a);
				p.render();
			}
			a = 1;
		}
		
		private function zsort(a:Particle3D, b:Particle3D):Number
		{
			if(a.pos.z > b.pos.z) return -1;
			else return 1;
		}
	}
}