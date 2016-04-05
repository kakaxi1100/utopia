package org.ares.fireflight.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import org.ares.fireflight.FFParticle;
	import org.ares.fireflight.pool.FFParticlePool;

	/**
	 *粒子的管理器
	 * 负责粒子的创建，删除和每帧的更新 
	 * @author juli
	 * 
	 */	
	public class FFParticleManager
	{
		private var plist:Vector.<FFParticle>;
		private var mPool:FFParticlePool;
		
		private static var instance:FFParticleManager;
		private var zeroPt:Point = new Point();
		public function FFParticleManager(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
			
			plist = new Vector.<FFParticle>();
			mPool = FFParticlePool.getInstance();
		}
		public static function getInstance():FFParticleManager
		{
			return instance ||= new FFParticleManager(new O());
		}
		
		public function removeParticle(p:FFParticle):Boolean
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(p == plist[i])
				{
					var temp:FFParticle = plist.splice(i, 1)[0];
					mPool.removeParticle(temp);
//					temp.resert();
					return true;
				}
			}
			return false;
		}
		
		public function addParticle():FFParticle
		{
			var p:FFParticle = FFParticlePool.getInstance().createParticle();
			plist.push(p);
			return p;
		}
		
		public function update(duration:Number):void
		{
			var len:uint;
			var p:FFParticle;
			while(len < plist.length)
			{
				p = plist[len];
				//如果生命周期到了，就给我滚回池里去
				if(p.lifeTime(duration) == false)
				{
					//p.destory();
					this.removeParticle(p);
					continue;
				}
				plist[len].update(duration);
				len++;
			}
		}
		
		public function render(bmd:BitmapData, img:BitmapData = null):void
		{
			bmd.lock();
//			bmd.fillRect(bmd.rect, 0);
			var p:FFParticle;
			for(var i:uint = 0; i < plist.length; i++)
			{
				p = plist[i];
				if(img == null)
				{
					bmd.setPixel32(p.position.x, p.position.y, p.color);
				}else{
					zeroPt.x = p.position.x;
					zeroPt.y = p.position.y;
					bmd.copyPixels(img, img.rect, zeroPt,null,null,true);
				}
			}
			
			bmd.unlock();
		}
		
	}
}
class O
{
	
}