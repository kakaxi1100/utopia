package org.ares.vernalbreeze
{
	public class VBRigidBody
	{
		public var inverseMass:Number;
		public var position:VBVector;
		//记录方位[cosΘ,sinΘ]
		public var orientation:VBVector;
		//线速度
		public var velocity:VBVector;
		//角速度
		public var rotation:Number;
		
		public function VBRigidBody()
		{
		}
		
		//设置弧度,应该让弧度处于这个范围之间 (-π，π]
		public function set angle(a:Number):void
		{
			orientation.x = Math.cos(a);
			orientation.y = Math.sin(a);
		}
		
		public function get angle():Number
		{
			return Math.atan2(orientation.y,orientation.x)
		}
		
		public function get degree():Number
		{
			return 180/Math.PI*angle;
		}
	}
}