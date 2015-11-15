package org.ares.vernalbreeze
{
	public class VBFirework extends VBParticle
	{
		//粒子的持续时间		
		private var mAge:Number;
		public function VBFirework()
		{
			super();
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