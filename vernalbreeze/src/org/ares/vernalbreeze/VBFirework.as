package org.ares.vernalbreeze
{
	/**
	 *粒子 
	 * 因为粒子极有可能会被扩展, 所以粒子需要粒子工厂
	 * 承载器拥有一个这样的工厂
	 * 可以用来批量产生粒子
	 * @author JuLi
	 * 
	 */	
	public class VBFirework extends VBParticle
	{
		//粒子的持续时间		
		private var mAge:Number;
		public function VBFirework()
		{
			super();
		}
		
		public function update():void
		{
			
		}
		
		public function get age():Number
		{
			return mAge;
		}

		public function set age(value:Number):void
		{
			mAge = value;
		}

	}
}