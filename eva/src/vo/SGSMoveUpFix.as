package vo
{
	public class SGSMoveUpFix implements IGenerationStrategy
	{
		private static var instance:SGSMoveUpFix;
		public function SGSMoveUpFix()
		{
		}
		public static function getInstance():void
		{
			instance ||= new SGSMoveUpFix;
		}
		
		public function generation(pl:Payload):void
		{
			var p:ParticleSimple;
			for(var i:uint = 0; i < pl.count; i++)
			{
				p = ParticleSimpleManager.getInstance().addParticle();
				p.lifeSpan = 50;
				p.posX = pl.head.posX;
				p.posY = pl.head.posY;
				p.velX = pl.head.velX;
				p.velY = pl.head.velY;
			}
		}
	}
}