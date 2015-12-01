package org.ares.vernalbreeze
{
	public class VBParticleCable extends VBParticleLink
	{
		//绳子的最大长度
		public var maxLength:Number;
		//绳子的反弹系数
		public var restitution:Number;
		public function VBParticleCable()
		{
			super();
		}
		
		override public function fillContact(contact:VBParticleContact, limit:uint):uint
		{
			//得到当前的长度
			var length:Number = currentLength();
			//看看是否超过最大长度，如果没有超过最大长度则不会产生任何作用力
			if(length < maxLength)
			{
				return 0;
			}
			//如果长度超过最大长度，则产生了碰撞
			contact.particle[0] = particle[0];
			contact.particle[1] = particle[1];
			//计算法向量
			var normal:VBVector = particle[1].position.minus(particle[0].position);
			normal.normalizeEquals();
			contact.contactNormal = normal;
			
			contact.penetration = length - maxLength;
			contact.restitution = restitution;
			
			return 1;
		}
	}
}