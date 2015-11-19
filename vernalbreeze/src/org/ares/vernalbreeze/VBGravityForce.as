package org.ares.vernalbreeze
{
	public class VBGravityForce implements IVBForce
	{
		private var mGravity:VBVector;
		public function VBGravityForce(g:VBVector)
		{
			mGravity = g;
		}
		
		public function update(p:VBParticle, duration:Number):void
		{
			if(p.mass == 0) return;
			p.addForce(mGravity.mult(p.mass));
		}
	}
}