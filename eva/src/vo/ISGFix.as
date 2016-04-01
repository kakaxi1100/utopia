package vo
{
	public class ISGFix implements IInitStrategy
	{
		public function ISGFix()
		{
		}
		
		public function reset(pl:Payload):void
		{
			pl.head.lifeSpan = 1;
			pl.count = 2;
		}
	}
}