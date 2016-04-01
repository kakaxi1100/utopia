package vo
{
	public class GSGMoveUp implements IGenerationStrategy
	{
		public function GSGMoveUp()
		{
		}
		
		public function generation(pl:Payload):void
		{
			var p:ParticleSimple;
			for(var i:uint = 0; i < pl.count; i++)
			{
				p = ParticleSimpleManager.getInstance().addParticle();
				p.lifeSpan = Math.random()*30+70;
				p.posX = pl.head.posX;
				p.posY = pl.head.posY;
				p.velX = Math.random()*2-1;
				p.velY = Math.random()*8 - 4;
			}
		}
	}
}