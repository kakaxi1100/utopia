package org.ares.fireflight.base.collision
{
	import org.ares.fireflight.base.FFVector;

	public class FFCollisionTriangle
	{
		private var mVertexes:Vector.<FFVector>;
		public function FFCollisionTriangle(a:FFVector, b:FFVector, c:FFVector)
		{
			mVertexes = new Vector.<FFVector>(3);
			mVertexes[0] = a;
			mVertexes[1] = b;
			mVertexes[2] = c;
		}
		
		public function get vertexes():Vector.<FFVector>
		{
			return mVertexes;
		}

		public function set vertexes(value:Vector.<FFVector>):void
		{
			mVertexes = value;
		}

		public function get a():FFVector
		{
			return mVertexes[0];
		}
		
		public function get b():FFVector
		{
			return mVertexes[1];
		}
		
		public function get c():FFVector
		{
			return mVertexes[2];
		}
	}
}