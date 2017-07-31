package org.ares.archive.fireflight_v1.test
{
	import org.ares.archive.fireflight_v1.FFParticle;
	import org.ares.archive.fireflight_v1.FFPayload;
	import org.ares.archive.fireflight_v1.port.IPattern;
	
	public class PatternUp implements IPattern
	{
		private static var instance:PatternUp;
		public function PatternUp()
		{
		}
		public static function getInstance():PatternUp
		{
			return instance ||= new PatternUp();
		}
		
		public function run(p:FFPayload, duration:Number):void
		{
			p.head.velocity.setTo(0,-100);
			p.head.update(duration);
		}
	}
}	