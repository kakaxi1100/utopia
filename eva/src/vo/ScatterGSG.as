package vo
{
	public class ScatterGSG implements IGenerationStrategy
	{
		public function ScatterGSG()
		{
		}
		//这个有问题，应该除了运动部分，其它部分都是可调的
		public function generation(pl:Payload):void
		{
			var p:Particle;
			for(var i:uint = 0; i < pl.count; i++)
			{
				p = ParticleManager.getInstance().addParticle();
				p.lifespan = Math.random()*2 + 1;
				p.position.setTo(pl.head.position.x, pl.head.position.y);
				p.velocity.setTo((i-4)*Math.random()*5+5, Math.random()*20+10);
				p.color =pl.head.color;
			}
		}
	}
}