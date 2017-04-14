package org.ares.fireflight_v1.test
{
	import org.ares.fireflight_v1.FFParticle;
	import org.ares.fireflight_v1.FFPayload;
	import org.ares.fireflight_v1.manager.FFParticleManager;
	import org.ares.fireflight_v1.port.IGenerator;
	
	public class GenerateUp implements IGenerator
	{
		private static var instance:GenerateUp;
		public function GenerateUp()
		{
		}
		public static function getInstance():GenerateUp
		{
			return instance ||= new GenerateUp();
		}
		
		public function generate(pl:FFPayload):void
		{
			for(var i:int = 0; i < 1; i++)
			{
				var p:FFParticle = FFParticleManager.getInstance().addParticle();
				p.color = 0xFFFFFF00;
				//注意假如设置lifespan = 0 由于render 再 update 前面，所有也会形成粒子
				p.lifespan = 0;
//				p.position.setTo(pl.head.position.x,pl.head.position.y);
				p.position.setTo(pl.head.position.x+Math.random()*100, pl.head.position.y-Math.random()*100);
				p.velocity.setTo(Math.random()*50-20, Math.random()*50-20);
			}
		}
	}
}