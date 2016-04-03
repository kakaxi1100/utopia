package voforparticle
{
	public class ISGScatter implements IInitStrategy
	{
		private static var instance:ISGScatter;
		public function ISGScatter()
		{
		}
		public static function getInstance():ISGScatter
		{
			return instance ||= new ISGScatter();
		}
		
		public function reset(pl:Payload = null):void
		{
			var p:Payload;
			for(var i:int = 0; i < 2; i++)
			{
				p = PayloadManager.getInstance().addPayload();
				p.head.posX = pl.head.posX;
				p.head.posY = pl.head.posY;
				p.head.velX = (i*10)-5;
				p.head.velY = -2;
				p.head.lifeSpan = 10;
				p.generSG = GSGFix.getInstance();
				p.initSGList[1] = ISGMoveUp.getInstance();
			}
		}
	}
}