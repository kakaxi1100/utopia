package voforparticle
{
	/**
	 *初始化策略接口 
	 * @author juli
	 * 
	 */	
	public interface IInitStrategy
	{
		function reset(pl:Payload = null):void;
	}
}