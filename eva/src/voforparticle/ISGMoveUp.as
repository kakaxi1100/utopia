package voforparticle
{
	public class ISGMoveUp implements IInitStrategy
	{
		private static var instance:ISGMoveUp;
		public function ISGMoveUp()
		{
		}
		public static function getInstance():ISGMoveUp
		{
			return instance ||= new ISGMoveUp();
		}
		
		public function reset(pl:Payload = null):void
		{
			var p:Payload;
			for(var i:int = 0; i < 2; i++)
			{
				p = PayloadManager.getInstance().addPayload();
				p.head.posX = (i*40)+380;
				p.head.posY = 580;
				p.head.velX = 0;
				p.head.velY = -5;
				p.head.lifeSpan = 20;
				p.generSG = GSGFix.getInstance();
			}
			p.initSGList[0] = ISGScatter.getInstance();
		}
	}
}