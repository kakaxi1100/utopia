package ecs
{
	public class ComponentBase
	{
		//存放数据集
		protected var pDataSet:Vector.<ComponentData> = new Vector.<ComponentData>();
		//存放实体, 这里是与数据集一一对应, 避免了用键值对结构
		protected var pEntitySet:Vector.<Entity> = new Vector.<Entity>();
		public function ComponentBase()
		{
			
		}
		
		public function registerEntity(e:Entity):void
		{
			if(hasEntity(e) == true)
			{
				return;
			}
			//注意实体的数组与数据的数组是一一对应的,所以要添加就是两个同时添加
			this.pDataSet.push(this.createData());
			this.pEntitySet.push(e);
		}
		
		public function removeEntity(e:Entity):void
		{
			for(var i:int = 0; i < this.pDataSet.length; i++)
			{
				if(e == this.pEntitySet[i])
				{
					//注意实体的数组与数据的数组是一一对应的,所以要删除就是两个同时删除
					this.pDataSet.splice(i, 1);
					this.pEntitySet.splice(i, 1);
				}
			}
		}
		
		public function hasEntity(e:Entity):Boolean
		{
			for (var i:int = 0; i < pEntitySet.length; i++) 
			{
				if (e == pEntitySet[i]) 
				{
					return true;
				} 
			}
			return false;
		}
		
		public function getData(e:Entity):ComponentData
		{
			for (var i:int = 0; i < pEntitySet.length; i++) 
			{
				if (e == pEntitySet[i]) 
				{
					return pDataSet[i];
				} 
			}
			return null;
		}
		
		//需要由子类实现,因为每个子类的data结构都不同
		protected function createData():ComponentData 
		{
			return null;
		}
	}
}