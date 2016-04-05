package org.ares.fireflight.port
{
	import org.ares.fireflight.FFPayload;

	public interface IPattern
	{
		function run(pl:FFPayload, duration:Number):void;
	}
}