package voforparticle
{
	public class GSGFix implements IGenerationStrategy
	{
		private static var instance:GSGFix;
		public function GSGFix()
		{
		}
		public static function getInstance():GSGFix
		{
			return instance ||= new GSGFix();
		}
		
		public function generation(pl:Payload):void
		{
			var p:ParticleSimple = ParticleSimpleManager.getInstance().addParticle();
			p.posX = pl.head.posX;
			p.posY = pl.head.posY;
			p.lifeSpan = 1;
		}
	}
}