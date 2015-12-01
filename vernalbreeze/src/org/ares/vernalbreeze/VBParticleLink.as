package org.ares.vernalbreeze
{
	public class VBParticleLink
	{
		public var particle:Vector.<VBParticle>;
		public function VBParticleLink()
		{
		}
		
		protected function currentLength():Number
		{
			var relativePos:VBVector = particle[0].position.minus(particle[1].position);
			return relativePos.magnitude();
		}
		
		public function fillContact(contact:VBParticleContact, limit:uint):uint
		{
			return 0;
		}
	}
}