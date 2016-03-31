package vo
{
	public class UpwardISG implements IInitStrategy
	{
		private var colors:Array = [0xFFFFFF00, 0xFF00FF00, 0xFFdb15bb];
		public function UpwardISG()
		{
		}
		//这个有问题，应该除了运动部分，其它部分都是可调的	
		public function reset(pl:Payload):void
		{
			pl.head.lifeSpan = Math.random()*70+60;
			pl.head.velX = Math.random()*4-2;
			pl.head.velY = -(Math.random()*2+1);
			pl.head.color = colors[Math.floor(Math.random()*3)];
			pl.count = 3;
			
//			pl.head.lifespan = Math.random()*2+1;
//			pl.head.velocity.setTo(Math.random()*100-50, -100);
//			pl.head.position.setTo(pl.baseX, pl.baseY);
//			pl.head.color = (0xFF<<24) | (0xFFFF00);
//			pl.count = 4;
		}
	}
}