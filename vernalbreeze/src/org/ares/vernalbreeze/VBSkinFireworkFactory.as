package org.ares.vernalbreeze
{
	/**
	 *SkinFirework粒子工厂 
	 * @author JuLi
	 * 
	 */	
	public class VBSkinFireworkFactory extends VBFireworkFactory
	{
		public function VBSkinFireworkFactory()
		{
			super();
		}
		
		override public function create():VBFirework
		{
			return new VBSkinFirework();
		}
	}
}