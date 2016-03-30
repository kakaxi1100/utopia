package vo
{
	public class UpwardISG implements IInitStrategy
	{
		public function UpwardISG()
		{
		}
		//这个有问题，应该除了运动部分，其它部分都是可调的	
		public function reset(pl:Payload):void
		{
			pl.head.lifespan = Math.random()*3;
			pl.head.velocity.setTo(Math.random()*200-100, -200);
			pl.head.position.setTo(pl.baseX, pl.baseY);
			pl.head.color = (0xFF<<24) | (Math.random()*0xcccccc);
			pl.count = 4;
		}
	}
}