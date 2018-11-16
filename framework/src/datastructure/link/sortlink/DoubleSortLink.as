package datastructure.link.sortlink
{
	public class DoubleSortLink
	{
		private var mHead:DoubleSortLinkNode;
		private var mTail:DoubleSortLinkNode;
		public function DoubleSortLink()
		{
			mHead = new DoubleSortLinkNode();
			mTail = mHead;
		}
		
		public function insert(value:int, data:Object = null):void
		{
			//新建节点
			var newNode:DoubleSortLinkNode = new DoubleSortLinkNode();
			newNode.sortKey = value;
			newNode.data = data;
			//要有两个指针,一个是指向当前检测值的,还有一个是指向当前值前驱的
			var prev:DoubleSortLinkNode, curt:DoubleSortLinkNode;
			prev = mHead;
			curt = prev.next;
			while(curt != null)
			{
				if(curt.sortKey > value) //假如当前值要比插入的值大, 那么说明这个值要插在curt的前面
				{
					break;
				}else//注意这里是 <= 也就是说相同的值是按照插入顺序来排的
				{
					prev = curt;
					curt = prev.next;
				}
			}
			
			newNode.next = curt;
			newNode.prev = prev;
			prev.next = newNode;
			
			//假如新加的节点没有下一个节点,那么它就是最后一个节点啦
			if(newNode.next == null)
			{
				mTail = newNode;
			}
		}
		
		//找到连表中第一个等于这个value的节点,注意是第一个, 因为有相同值
		private function searchByKey(value:int):DoubleSortLinkNode
		{
			var curt:DoubleSortLinkNode = mHead.next;
			while(curt != null)
			{
				if(curt.sortKey == value)
				{
					return curt;
				}else
				{
					curt = curt.next;
				}
			}
			return null;
		}
		
		//删除同一个sortkay的所有对象
		public function removeByKey(value:int):void
		{
			var curt:DoubleSortLinkNode = searchByKey(value);
			if(curt == null) return;
			var prev:DoubleSortLinkNode = curt.prev;
			curt = curt.next;
			while(curt != null && curt.sortKey == value)
			{
				curt.prev = null; //删除前驱的引用
				curt = curt.next;
				curt.prev.next = null;//删除后继的引用
			}
			
			prev.next = curt;
			if(curt != null)
			{
				curt.prev = prev;
			}else
			{
				mTail = prev;
			}
			
		}
		
		private function searchByObj(obj:Object):DoubleSortLinkNode
		{
			var curt:DoubleSortLinkNode = mHead.next;
			while(curt != null)
			{
				if(curt.data == obj)
				{
					return curt;
				}else
				{
					curt = curt.next;
				}
			}
			return null;
		}
		
		public function removeByObj(obj:Object):void
		{
			var curt:DoubleSortLinkNode = searchByObj(obj);
			if(curt == null) return;
			
			curt.prev.next = curt.next;
			curt.next.prev = curt.prev;
			if(curt.prev.next == null)
			{
				mTail = curt.prev;
			}
			
			curt.prev = curt.next = null;
		}
		
		public function get head():DoubleSortLinkNode
		{
			return mHead;
		}
		
		public function get tail():DoubleSortLinkNode
		{
			return mTail;
		}
	}
}