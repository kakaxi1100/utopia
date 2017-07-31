package org.ares.archive.fireflight_v1.test
{
	import org.ares.archive.fireflight_v1.FFParticle;
	import org.ares.archive.fireflight_v1.FFPayload;
	import org.ares.archive.fireflight_v1.port.IPattern;
	
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

	