package vo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 *粒子的管理器
	 * 负责粒子的创建，删除和每帧的更新 
	 * @author juli
	 * 
	 */	
	public class ParticleSimpleManager
	{
		private var plist:Vector.<ParticleSimple>;
		private var mPool:ParticleSimplePool;
		
		private static var instance:ParticleSimpleManager;
		public function ParticleSimpleManager(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
			
			plist = new Vector.<ParticleSimple>();
			mPool = ParticleSimplePool.getInstance();
		}
		public static function getInstance():ParticleSimpleManager
		{
			return instance ||= new ParticleSimpleManager(new O());
		}
		
		public function removeParticle(p:ParticleSimple):Boolean
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(p == plist[i])
				{
					var temp:ParticleSimple = plist.splice(i, 1)[0];
					mPool.removeParticle(temp);
					temp.resert();
					return true;
				}
			}
			return false;
		}
		
		public function addParticle():ParticleSimple
		{
			var p:ParticleSimple = ParticleSimplePool.getInstance().createParticle();
			plist.push(p);
			return p;
		}
		
		public function update():void
		{
			var len:uint;
			var p:ParticleSimple;
			while(len < plist.length)
			{
				p = plist[len];
				//如果生命周期到了，就给我滚回池里去
				if(p.lifeTime() == false)
				{
					this.removeParticle(p);
					continue;
				}
				plist[len].update();
				len++;
			}
		}
		
		public function render(bmd:BitmapData):void
		{
			bmd.lock();
			//			bmd.fillRect(bmd.rect, 0);
			var p:ParticleSimple;
			for(var i:uint = 0; i < plist.length; i++)
			{
				p = plist[i];
				bmd.setPixel32(p.posX, p.posY, p.color);
			}
			
			bmd.unlock();
		}
		
	}
}
class O
{
	
}