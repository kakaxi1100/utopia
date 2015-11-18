package org.ares.vernalbreeze
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import test.shape.FireworkShape;

	/**
	 *SkinFirework粒子工厂 
	 * @author JuLi
	 * 
	 */	
	public class VBSkinFireworkFactory extends VBFireworkFactory
	{
		//需要一个皮肤工厂
		private var mSkin:Sprite;
		private var mParent:DisplayObjectContainer;
		public function VBSkinFireworkFactory(pskin:Sprite, pparent:DisplayObjectContainer = null)
		{
			super();
			mSkin = new FireworkShape();
			mParent = pparent;
			if(mParent != null)
			{
				//mParent.addChild(mSkin);
			}
		}
		
		private function addSkin(pparent:DisplayObjectContainer = null):void
		{
			if(pparent != null)
			{
				mParent = pparent;
			}
			
			if(mParent != null)
			{
				mParent.addChild(mSkin);
			}
		}
		
		override public function create():VBFirework
		{
			mSkin = new FireworkShape();
			addSkin();
			return new VBSkinFirework(mSkin);
		}
	}
}