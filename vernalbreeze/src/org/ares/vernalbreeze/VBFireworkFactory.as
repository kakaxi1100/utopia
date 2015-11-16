package org.ares.vernalbreeze
{
	/**
	 *firework粒子工厂
	 * 被承载器使用 
	 * @author JuLi
	 * 
	 */	
	public class VBFireworkFactory
	{
		public function VBFireworkFactory()
		{
		}
		
		public function create():VBFirework
		{
			return new VBFirework();
		}
	}
}