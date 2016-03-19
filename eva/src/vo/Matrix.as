package vo
{
	public class Matrix
	{
		protected var r:uint;
		protected var c:uint;

		public var v:Vector.<Vector.<Number>>;
		public function Matrix()
		{
			v = new Vector.<Vector.<Number>>(r, true);
			for(var i:int = 0; i<r; i++)
			{
				v[i] = new Vector.<Number>(c,true);
			}
		}
	}
}