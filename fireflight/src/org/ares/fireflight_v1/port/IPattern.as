package org.ares.fireflight_v1.port
{
	import org.ares.fireflight_v1.FFPayload;

	public interface IPattern
	{
		function run(pl:FFPayload, duration:Number):void;
	}
}