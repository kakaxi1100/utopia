package org.ares.vernalbreeze
{
	/**
	 *刚体碰撞处理数据结构 
	 * @author JuLi
	 * 
	 */	
	public class VBContact
	{
		//碰撞点
		public var contactPoint:VBVector;
		//碰撞法线
		public var contactNormal:VBVector;
		//碰撞深度
		public var penetration:Number;
		
		public function VBContact()
		{
		}
	}
}