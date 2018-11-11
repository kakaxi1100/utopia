package datastructure.link.sortlink
{
	public class SortLink
	{
		private var mHead:SortLinkNode;
		public function SortLink()
		{
			mHead = new SortLinkNode();
		}
		
		public function insert(value:int, data:Object = null):void
		{
			//新建节点
			var newNode:SortLinkNode = new SortLinkNode();
			newNode.sortKey = value;
			newNode.data = data;
			//要有两个指针,一个是指向当前检测值的,还有一个是指向当前值前驱的
			var prev:SortLinkNode, curt:SortLinkNode;
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
			prev.next = newNode;
		}
		
		//找到连表中第一个等于这个value的节点,注意是第一个, 因为有相同值
		private function searchByKey(value:int):Object
		{
			var prev:SortLinkNode = mHead;
			var curt:SortLinkNode = prev.next;
			while(curt != null)
			{
				if(curt.sortKey == value)
				{
					var temp:Object = {};
					temp["prev"] = prev;
					temp["curt"] = curt;
					return temp;
				}else
				{
					prev = curt;
					curt = curt.next;
				}
			}
			return null;
		}
		
		public function removeByKey(value:int):void
		{
			var temp:Object = searchByKey(value);
			if(temp == null) return;
			var prev:SortLinkNode = temp["prev"];
			var node:SortLinkNode = temp["curt"];
			var next:SortLinkNode = node.next;
			//删除所有值相同的节点,因为是有序的所以只需要往下找就可以了
			while(next != null && node.sortKey == next.sortKey)
			{
				node.next = null;
				node = next;
				next = node.next;	
			}
			//找完后node就是最后一个值等于value的节点
			prev.next = node.next;
			node.next = null;
		}
		
		private function searchByObj(obj:Object):Object
		{
			var prev:SortLinkNode = mHead;
			var curt:SortLinkNode = prev.next;
			while(curt != null)
			{
				if(curt.data == obj)
				{
					var temp:Object = {};
					temp["prev"] = prev;
					temp["curt"] = curt;
					return temp;
				}else
				{
					prev = curt;
					curt = curt.next;
				}
			}
			return null;
		}
		
		public function removeByObj(obj:Object):void
		{
			var temp:Object = searchByObj(obj);
			if(temp == null) return;
			var prev:SortLinkNode = temp["prev"];
			var node:SortLinkNode = temp["curt"];
			
			prev.next = node.next;
			node.next = null;
		}
		
		//暂时没有用到用到的时候再补充
		public function changeData():void
		{
			
		}

		public function get head():SortLinkNode
		{
			return mHead;
		}

	}
}