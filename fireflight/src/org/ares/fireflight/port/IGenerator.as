package org.ares.fireflight.port
{
	import org.ares.fireflight.FFPayload;
//也可以学 Rule 加个参数 或者学习 Pattern 传入参数
	public interface IGenerator
	{
		function generate(pl:FFPayload):void;
	}
}