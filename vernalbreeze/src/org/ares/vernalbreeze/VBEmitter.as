package org.ares.vernalbreeze
{
	/**
	 *发射器
	 * 提供一个位置信息，在哪里发射粒子
	 * 以及包含了一系列的承载器 
	 * @author JuLi
	 * 
	 */	
	public class VBEmitter
	{
		private var mPosition:VBVector;
		private var mPayloads:Array;
		
		public function VBEmitter(px:Number, py:Number)
		{
			mPosition = new VBVector(px, py);
			mPayloads = new Array();
		}
	
		public function emission():void
		{
			for(var i:int = 0; i<mPayloads.length; i++)
			{
				var temp:VBPayLoad = mPayloads[i];
				temp.createParticle(mPosition.x, mPosition.y);
			}
		}
		
		public function update():void
		{
			for(var i:int = 0; i<mPayloads.length; i++)
			{
				mPayloads[i].update();
			}
		}
		/**
		 *添加承载器 
		 * @param pl
		 * 
		 */		
		public function addPayLoads(pl:VBPayLoad):void
		{
			mPayloads.push(pl);
		}
		
		//--设置发射器位置
		public function get position():VBVector
		{
			return mPosition;
		}

		public function set position(value:VBVector):void
		{
			mPosition = value;
		}

	}
}