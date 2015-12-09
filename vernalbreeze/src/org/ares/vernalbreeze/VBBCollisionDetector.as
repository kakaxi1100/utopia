package org.ares.vernalbreeze
{
	/**
	 *碰撞生成器 
	 * @author JuLi
	 * 
	 */	
	public class VBBCollisionDetector
	{
		public function VBBCollisionDetector()
		{
		}
		
		//detector functoin like this
		/*public function detectContacts(firstPrimitive:VBBPrimitive, secondPrimitive:VBBPrimitive, data:VBBCollisionData):void
		{
			
		}*/
		
		public function rimAndRim(c1:VBRim, c2:VBRim, data:VBBCollisionData):uint
		{
			if(data.contactLeft <= 0)
			{
				return 0;
			}
			return 0;
		}
	}
}