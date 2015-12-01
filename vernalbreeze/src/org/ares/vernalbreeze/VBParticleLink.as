package org.ares.vernalbreeze
{
	public class VBParticleLink
	{
		public var particle:Vector.<VBParticle>;
		public function VBParticleLink()
		{
			particle = new Vector.<VBParticle>(2);
		}
		//计算两质点间的距离
		protected function currentLength():Number
		{
			var relativePos:VBVector = particle[0].position.minus(particle[1].position);
			return relativePos.magnitude();
		}
		//添加约束
		public function fillContact(contact:VBParticleContact, limit:uint):uint
		{
			return 0;
		}
	}
}