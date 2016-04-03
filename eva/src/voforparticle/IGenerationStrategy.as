package voforparticle
{
	/**
	 *产出粒子接口
	 * 可以考虑改成基类 
	 * @author juli
	 * 
	 */	
	public interface IGenerationStrategy
	{
		function generation(pl:Payload):void;
	}
}