package vo
{
	public class ISGMoveUp implements IInitStrategy
	{
		private var count:uint = 2;
		public function ISGMoveUp()
		{
		}
		
		public function reset(pl:Payload):void
		{
			var p:Payload = PayloadManager.getInstance().addPayload();
			for(var i:int = 0; i < count; i++)
			{
				p.head.posX += i*40-20;
				p.head.velX = 0;
				p.head.velY = -5;
				p.head.lifeSpan = 1;
				p.count = 1;
				p.generSGList = new Vector.<IGenerationStrategy>;
				p.generSGList[0] = SGSMoveUpFix.getInstance();
			}
		}
	}
}