package
{
	import flash.display.Sprite;
	
	import vo.Canvas;
	import vo.ParticleEmitter;
	
	[SWF(frameRate="60",width="800",height="600",backgroundColor="0xcccccc")]
	public class FlyTest2 extends Sprite
	{
		private var cv:Canvas = new Canvas(800,600);
		private var pe:ParticleEmitter = new ParticleEmitter();
		public function FlyTest2()
		{
			super();
		}
	}
}