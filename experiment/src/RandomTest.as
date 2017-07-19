package
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	public class RandomTest extends Sprite
	{
		private const MAX_RATIO:Number = 1 / uint.MAX_VALUE;
		private var r:uint;
		public function RandomTest()
		{
			super();
			this.setSeed();
			for(var i:int = 0; i < 10; i++){
				trace(this.nextFloat());
			}
		}
		
		public function setSeed(seed:uint = 1):void
		{
			r = seed;
		}
	
		public function next():Number
		{
			r ^= (r << 21);
			r ^= (r >>> 35);
			r ^= (r << 4);
			return r;
		}
		
		public function nextInt(bound):int {
			// apply bound twice to fix JavaScript modulo bug
			return (this.next() % bound + bound) % bound;
		}
		
		public function nextFloat():Number {
			return next() * MAX_RATIO;
		}
	}
}