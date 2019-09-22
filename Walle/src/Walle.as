package
{
	import flash.display.Sprite;
	
	import walle.Car;
	
	public class Walle extends Sprite
	{
		public function Walle()
		{
			var c:Car = new Car();
			c.x = 100;
			c.y = 100;
			addChild(c);
		}
	}
}