package org.ares.vernalbreeze
{
	public class VBParticleRod extends VBParticleLink
	{
		//连杆的长度
		public var length:Number;
		public function VBParticleRod()
		{
			super();
		}
		
		override public function fillContact(contact:VBParticleContact, limit:uint):uint
		{
			var currentLen:Number = currentLength();
			//即没有伸长，又没有缩短
			if(currentLen == length)
			{
				return 0;
			}
			//如果长度超过最大长度，则产生了碰撞
			contact.particle[0] = particle[0];
			contact.particle[1] = particle[1];
			//计算法向量
			var normal:VBVector = particle[1].position.minus(particle[0].position);
			normal.normalizeEquals();
			//物体是处于压缩还是伸展状态来决定法向量的方向
			//1,处于伸长状态
			if(currentLen > length)
			{
				//当处于拉力状态的时候，法向和渗透是一致的
				contact.contactNormal = normal;
				contact.penetration = currentLen - length;
			}
			else//2,处于压缩状态
			{
				contact.contactNormal = normal.multEquals(-1);
				contact.penetration = length - currentLen;
			}
			
			//没有回弹系数
			contact.restitution = 0;
			
			return 1;
		}
	}
}