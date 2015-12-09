package org.ares.vernalbreeze
{
	public class VBCollisionData
	{
		//碰撞集合
		public var contacts:Vector.<VBContact>;
		//剩下的碰撞点个数
		public var contactLeft:uint;
		public function VBCollisionData()
		{
		}
	}
}