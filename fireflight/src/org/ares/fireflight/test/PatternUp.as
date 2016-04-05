package org.ares.fireflight.test
{
	import org.ares.fireflight.FFParticle;
	import org.ares.fireflight.FFPayload;
	import org.ares.fireflight.port.IPattern;
	
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