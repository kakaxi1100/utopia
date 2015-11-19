package org.ares.vernalbreeze
{
	public class VBForceManage
	{
		private var forceRegistrys:Vector.<VBForceRegistration>;
		public function VBForceManage()
		{
			forceRegistrys = new Vector.<VBForceRegistration>();
		}
		
		public function add(p:VBParticle, f:IVBForce):void
		{
			
		}
		
		public function remove(p:VBParticle, f:IVBForce):void
		{
			
		}
		
		public function clear():void
		{
			forceRegistrys.length = 0;
		}
		
		public function update(duration:Number):void
		{
			for each(var fr:VBForceRegistration in forceRegistrys)
			{
				fr.force.update(fr.particle, duration);
			}
		}
	}
}