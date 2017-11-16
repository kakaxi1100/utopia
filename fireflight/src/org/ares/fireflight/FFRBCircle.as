package org.ares.fireflight
{
	public class FFRBCircle extends FFRigidBody implements ICollideTest
	{
		public function FFRBCircle()
		{
			super();
		}
		
		override public function test(t:ICollideTest):void
		{
			t.testWithCircle(t);
		}
		
		public function testWithCircle(t:ICollideTest):void
		{
			
		}
	}
}