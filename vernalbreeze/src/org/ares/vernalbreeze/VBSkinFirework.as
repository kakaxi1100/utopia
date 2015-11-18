package org.ares.vernalbreeze
{
	import flash.display.Sprite;

	/**
	 *带皮肤的firework粒子 
	 * @author JuLi
	 * 
	 */	
	public class VBSkinFirework extends VBFirework
	{
		public var skin:Sprite;
		public function VBSkinFirework(pskin:Sprite)
		{
			super();
			
			init();
			skin = pskin;
		}
		
		/**
		 *更新皮肤的位置
		 * @param duration
		 * @return 
		 * 
		 */		
		override public function update(duration:Number):Boolean
		{
			var b:Boolean = super.update(duration);
			skin.x = this.position.x;
			skin.y = this.position.y;
//			trace(skin.x, skin.y);
			return b;
		}
	}
}