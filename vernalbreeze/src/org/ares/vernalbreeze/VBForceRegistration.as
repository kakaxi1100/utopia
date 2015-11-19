package org.ares.vernalbreeze
{
	public class VBForceRegistration
	{
		public var particle:VBParticle;
		public var force:IVBForce;
		
		public function VBForceRegistration(p:VBParticle, f:IVBForce)
		{
			particle = p;
			force = f;
		}
	}
}