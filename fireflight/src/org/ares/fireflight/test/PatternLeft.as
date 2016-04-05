package org.ares.fireflight.test
{
	import org.ares.fireflight.FFParticle;
	import org.ares.fireflight.FFPayload;
	import org.ares.fireflight.port.IPattern;
	
	public class PatternLeft implements IPattern
	{
		private static var instance:PatternLeft;
		public function PatternLeft()
		{
		}
		public static function getInstance():PatternLeft
		{
			return instance ||= new PatternLeft();
		}
		
		public function run(p:FFPayload, duration:Number):void
		{
			p.head.velocity.setTo(100,0);
			p.head.update(duration);
		}
	}
}

	