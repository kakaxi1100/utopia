package voforparticle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 *粒子的管理器
	 * 负责粒子的创建，删除和每帧的更新 
	 * @author juli
	 * 
	 */	
	public class ParticleManager
	{
		private var plist:Vector.<Particle>;
		private var mPool:ParticlePool;
		
		private static var instance:ParticleManager;
		public function ParticleManager(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
			
			plist = new Vector.<Particle>();
			mPool = ParticlePool.getInstance();
		}
		public static function getInstance():ParticleManager
		{
			return instance ||= new ParticleManager(new O());
		}
		
		public function removeParticle(p:Particle):Boolean
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(p == plist[i])
				{
					var temp:Particle = plist.splice(i, 1)[0];
					mPool.removeParticle(temp);
					temp.resert();
					return true;
				}
			}
			return false;
		}
		
		public function addParticle():Particle
		{
			var p:Particle = ParticlePool.getInstance().createParticle();
			plist.push(p);
			return p;
		}
		
		public function update(duration:Number):void
		{
			var len:uint;
			var p:Particle;
			while(len < plist.length)
			{
				p = plist[len];
				//如果生命周期到了，就给我滚回池里去
				if(p.lifeTime(duration) == false)
				{
					this.removeParticle(p);
					continue;
				}
				plist[len].update(duration);
				len++;
			}
		}
		
		public function render(bmd:BitmapData):void
		{
			bmd.lock();
//			bmd.fillRect(bmd.rect, 0);
			var p:Particle;
			for(var i:uint = 0; i < plist.length; i++)
			{
				p = plist[i];
				bmd.setPixel32(p.position.x, p.position.y, p.color);
			}
			
			bmd.unlock();
		}
		
	}
}
class O
{
	
}