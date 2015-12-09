package org.ares.vernalbreeze
{
	import flash.geom.Matrix;

	/**
	 *图元 
	 * @author JuLi
	 * 
	 */	
	public class VBBPrimitive
	{
		public var rigidBody:VBRigidBody;
		public var offset:Matrix;
		private var mAxis:VBVector;
		public function VBBPrimitive()
		{
		}
		
		//取得图元的轴
		public function get axis():VBVector
		{
			mAxis.x = offset.tx;
			
			
			mAxis.y = offset.ty;
			return null;
		}
	}
}