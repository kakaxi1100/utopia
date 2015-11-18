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
	
		/**
		 *发射粒子 
		 * 
		 */		
		public function emission():void
		{
			for(var i:int = 0; i<mPayloads.length; i++)
			{
				var temp:VBPayload = mPayloads[i];
				temp.createParticle(mPosition.x, mPosition.y);
			}
		}
		
		/**
		 *更新 
		 * 
		 */		
		public function update(duration:Number):void
		{
			for(var i:int = 0; i<mPayloads.length; i++)
			{
				mPayloads[i].update(duration);
			}
		}
		/**
		 *添加承载器 
		 * @param pl
		 * 
		 */		
		public function addPayloads(pl:VBPayload):void
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