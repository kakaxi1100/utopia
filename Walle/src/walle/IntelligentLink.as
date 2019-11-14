package walle
{
	public class IntelligentLink
	{
		private var mHead:IntelligentNode;
		private var mCur:IntelligentNode;
		private var mIndex:IntelligentNode;
		private var mLength:int;
		
		public function IntelligentLink()
		{
			mHead = new IntelligentNode();
		}
		
		public function insert(node:IntelligentNode):void
		{
			if(mHead.next == null)
			{
				mHead.next = node;
			}else{
				mCur.next = node;
			}
			
			mCur = node;
			++mLength;
		}
		
		public function begin():IntelligentNode
		{
			mIndex = mHead;
			return mIndex;
		}
		
		public function next():IntelligentNode
		{
			var next:IntelligentNode = null;
			
			if(mIndex)
			{
				next = mIndex = mIndex.next;
			}
			
			return next;
		}
		
		public function clear():void
		{
			mHead.next = null;
			mIndex = null;
			mCur = null;
			mLength = 0;
		}
		
		public function get length():int
		{
			return mLength;
		}
	}
}