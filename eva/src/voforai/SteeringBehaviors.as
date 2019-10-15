package voforai
{
	import flash.display.Graphics;
	
	import base.EVector;

	public class SteeringBehaviors
	{
		//群聚算法策略
		//权值累加带优先级的算法
		public static const Weighted_Prioritized:int = 0;
		//权值累加算法
		public static const Weighted_Sum:int = 1;
		
		public static var panicDistanceSq:Number = 100*100;
		//权值很难调 aliment 和 cohesion 会冲突
		public static var separationWeight:Number = 4;
		public static var alignmentWeight:Number = 0.1;
		public static var cohesionWeight:Number = 0.1;
		
		private static var mIsSpacePartition:Boolean = false;
		public function SteeringBehaviors()
		{
		}
//-------------------是否开启空间分割检测------------------------------
		public static function openSpacePartition():void
		{
			mIsSpacePartition = true;
		}
		
		public static function closeSpacePartition():void
		{
			mIsSpacePartition = false;
		}
		
		public static function isSpacePartition():Boolean
		{
			return mIsSpacePartition;
		}
//------------------开启力以及检测力是否开启----------------------------
		public static function on(v:Vehicle, f:int):Boolean
		{
			return Boolean((v.flags & f) == f);
		}
		
		public static function separationOn(v:Vehicle):void
		{
			v.flags |= BehaviorType.separation;
		}
		
		public static function alignmentOn(v:Vehicle):void
		{
			v.flags |= BehaviorType.alignment;
		}
		
		public static function cohesionOn(v:Vehicle):void
		{
			v.flags |= BehaviorType.cohesion;
		}
//---------------------------------------------------------------
//------------------------单体行为----------------------------------		
		public static function seek(v:Vehicle, t:EVector):EVector
		{
			var direct:EVector = t.minus(v.position);
			direct.normalizeEquals();
			direct.multEquals(v.maxSpeed);
			//---为了方便控制力
			//---将这部分移动到了caculate里面去计算
			//---这里仅仅是返回cohesion所受的力
//			v.addForce(direct.minusEquals(v.velocity));
			return direct.minusEquals(v.velocity);
		}
		
		public static function flee(v:Vehicle, t:EVector):void
		{
			var direct:EVector = v.position.minus(t);
			//距离得平方
			var dist2:Number = direct.scalarMult(direct);
			if(dist2 < panicDistanceSq){
				direct.normalizeEquals();
				direct.multEquals(v.maxSpeed);
				v.addForce(direct.minusEquals(v.velocity));
			}
		}
		
		public static function arrive(v:Vehicle, t:EVector):EVector
		{
			var direct:EVector = t.minus(v.position);
			var dist:Number = direct.magnitude();
			direct.normalizeEquals();
			if(dist < 100){
				direct.multEquals(v.maxSpeed*dist/100);
			}else{
				direct.multEquals(v.maxSpeed);
			}
			//---为了方便控制力
			//---将这部分移动到了caculate里面去计算
			//---这里仅仅是返回cohesion所受的力
			var force:EVector = direct.minusEquals(v.velocity);
			v.addForce(force);
			return force;
		}
		/**
		 *p 追 e 
		 * Todo:
		 * 还可以考虑转向时间
		 * 
		 * @param v
		 * @param t
		 * 
		 */		
		public static function pursue(p:Vehicle, e:Vehicle):void
		{
			var direct:EVector = e.position.minus(p.position);
			//首先计算追逐者和被追者得角度，假如被追着面向追逐者，则追逐者不需要再计算被追着将要到达得位置（因为可能这个位置再追逐者背后，造成追逐者在此帧反向）
			//现在将20°角的范围规定为正面
			//用点击计算角度
			//这两个 θ 即角度范围,注意是 二三象限
			//----------------------------------
			//			
			//				E
			//			     ↙   ↑   ↘
			//			 ↙ θ	↑ θ	↘
			//		        ↙       	↑	     ↘
			//				P
			//
			//----------------------------------
			var relativeHeading:Number = p.velocity.scalarMult(e.velocity);
			//face > 0 表示 p 是朝向 e 得
			var face:Number = direct.scalarMult(p.velocity);
			if(face >0 && relativeHeading < -0.95)//acos(0.95) = 18°
			{
				seek(p, e.position);
			}else{
				//这里就是找到最佳点
				//lookAheadTime 得意思是从 v 走到 t 需要走多少个 maxSpeed 
				//即所需要得时间
				//这个值正比于两者得距离，反比于两者得速度和
				var lookAheadTime:Number = direct.magnitude()/(p.maxSpeed + e.velocity.length);
				//那么要追踪得点为
				var futurePostion:EVector = e.position.plus(e.velocity.mult(lookAheadTime));
				seek(p, futurePostion);
			}
		}
		
		/**
		 *p 逃避 e 
		 * 同追逐
		 * @param p
		 * @param e
		 * 
		 */		
		public static function evade(p:Vehicle, e:Vehicle):void
		{
			var direct:EVector = e.position.minus(p.position);
			var lookAheadTime:Number = direct.magnitude()/(p.maxSpeed + e.velocity.length);
			//那么要逃避得点为
			var futurePostion:EVector = e.position.plus(e.velocity.mult(lookAheadTime));
			flee(p, futurePostion);
		}
		
//		private static var wonderAngle:Number = 0;
//		public static function wander(p:Vehicle, distance:Number, radius:Number, range:Number):void
//		{
//			//确定圆得位置, 这个圆是在速度方向得正前方
//			//这里所说得位置并不是圆实际得位置，而是圆计算位置
//			//即它并不必要在 vehicle 得 位置的前方,　它只要在 vehicle 朝向(即速度方向)上的前方即可,
//			//当它为0得时候，实际点是在世界坐标得远点, 但是计算得坐标相当于是 小车得原点
//			//看不懂？看不懂你他妈得自己画图就知道了。
//			var center:EVector = p.velocity.normalize().multEquals(distance);
//			//计算在圆上得点取, 以(0,0)为中心, radius为半径
//			var offset:EVector = new EVector();
//			offset.length = radius;
//			wonderAngle += Math.random()*2*range - range;//取值范围是 range 到  -range
//			offset.angle = wonderAngle;
//			var force:EVector = center.plusEquals(offset);
//			p.addForce(force);
//		}
		
		//用闭包这样可以把offset封装到里面
		public static var wander:Function = function():Function
		{
			var offset:EVector = new EVector();//注意这里是多辆小车同时共用这个变量, 但是这个变量只是用来过渡,所以没有问题, 所以才能够安心的使用闭包
			return function(p:Vehicle):void{
				//确定圆得位置, 这个圆是在速度方向得正前方
				//这里所说得位置并不是圆实际得位置，而是圆计算位置
				//即它并不必要在 vehicle 得 位置的前方,　它只要在 vehicle 朝向(即速度方向)上的前方即可,
				//当它为0得时候，实际点是在世界坐标得远点, 但是计算得坐标相当于是 小车得原点
				//看不懂？看不懂你他妈得自己画图就知道了。
				var center:EVector = p.velocity.normalize().multEquals(p.wanderDistance);
				//计算在圆上得点取, 以(0,0)为中心, radius为半径
				offset.setTo(0,0);
				offset.length = p.wanderRadius;
				p.wanderAngle += p.wanderRange*(Math.random()*2 - 1);//取值范围是 range 到  -range
				offset.angle = p.wanderAngle;
				//加上中心点的偏移距离即为世界坐标中的力
				var force:EVector = center.plusEquals(offset);
				p.addForce(force);
			};
			
		}();
		
		/**
		 *pi 插入到  p1 和 p2 之间 
		 * @param p1
		 * @param p2
		 * @param pi
		 */		
		public static function interpose(p1:Vehicle, p2:Vehicle, pi:Vehicle):void
		{
			//先算出两个智能体的中间位置
			var midPoint:EVector = p1.position.plus(p2.position).multEquals(0.5);
			//然后计算当前pi到达这个点所需要得最少的时间，即拥有最大速度
			var timeToReachMidPoint:Number = pi.position.distance( midPoint)/pi.maxSpeed;
			//用这个时间来预测 p1和p2 将要到达得位置
			//先计算出速度于这个时间乘积然后再加上现有的位置
			//分成两步些主要是为了节省变量
			var p1Arriving:EVector = p1.velocity.mult(timeToReachMidPoint);
			var p1Pos:EVector = p1Arriving.plusEquals(p1.position);
			
			var p2Arriving:EVector = p2.velocity.mult(timeToReachMidPoint);
			var p2Pos:EVector = p2Arriving.plusEquals(p2.position);
			
			//计算它们未来时间两个小车位置的中间点
			var temp:EVector = p1Pos.plusEquals(p2Pos).multEquals(0.5);
			midPoint.setTo(temp.x, temp.y);
			//然后小车 pi 抵达那个点
			arrive(pi, midPoint);
		}
		
		/**
		 *跟随路径 
		 * @param p
		 * 
		 */		
		public static function followPath(p:Vehicle):void
		{
			//注意这里请将path封装成一个类！！！
			//由于这个只是实验性质的测试，所以就写在这里
			//妈的我懒行了吧, 别唧唧歪歪的了.
			var dist:Number = p.position.distanceSq(p.path[p.cursor]);
			if(dist < p.wayPointSeekDistSq)
			{
				p.cursor++;
				if(p.cursor >= p.path.length)
				{
					p.cursor = 0;
				}
			}
			
			seek(p, p.path[p.cursor]);
		}
		
		/*public static function offsetPursuit(p:Vehicle, leader:Vehicle, offset:EVector, pred:Boolean = false):void
		{
			//求出offset得局部坐标在leader上的投影
			var tempX:Number = leader.xAxis.scalarMult(offset);
			var tempY:Number = leader.yAxis.scalarMult(offset);
			offset.setTo(tempX, tempY);
			//先求出offset 对应的世界坐标得点
			var worldOffset:EVector = leader.position.plus(offset);
			//求出这一点到小车得距离
			var lenOffset:EVector = worldOffset.minus(p.position);
			//预测这个偏移点将要到达得位置
			//正比于距离，反比于速度
			var lookAheadTime:Number = lenOffset.magnitude()/(p.maxSpeed + leader.velocity.length);
			//计算此时得预测点
			var futurePostion:EVector = worldOffset.plusEquals(leader.velocity.mult(lookAheadTime));
			//让小车到达起点
			if(pred == false)
			{
				arrive(p, worldOffset);
			}else{
				arrive(p, futurePostion);
			}
		}*/
		/**
		 *闭包重用localOffset
		 * 
		 * p 表示被偏移的对象
		 * leader表示相对于它进行偏移
		 * 																					   			
		 * offset 表示的是leader的局部坐标的偏移量
		 *  																				   
		 * pattern 代表模式 0--直接arrive到偏移位置  1--就算预期点通过追逐的方式到偏移位置
		 * 
		 */		
		public static var offsetPursuit:Function = function():Function
		{
			var globalOffset:EVector = new EVector();
			return function (p:Vehicle, leader:Vehicle, offset:EVector, pattern:uint = 0, g:Graphics = null):void
			{
				//求出offset的世界坐标
				//在e0轴上的坐标(x轴) 方向*它的局部x坐标
				var e0length:EVector = leader.xAxis.mult(offset.x);
				//在e1轴上的坐标(y轴) 方向*它的局部y坐标
				var e1length:EVector = leader.yAxis.mult(offset.y);
				//它们的和即为offset相对于原点的世界坐标
				var world:EVector = e0length.plusEquals(e1length);
				globalOffset.setTo(world.x, world.y);				
				//求出要到达得点
				var target:EVector = leader.position.plus(globalOffset);
				g.beginFill(0xff0000);
				g.drawCircle(target.x,target.y,10);
				g.endFill();
				//让小车到达起点的方式
				//0  代表直接arrive
				//1 代表计算预期点，然后再到达指定点
				// 实际表现中没有看出太大区别
				if(pattern == 0)
				{
					arrive(p, target);
				}else if(pattern == 1){
					//求出这一点到小车得距离
					var lenOffset:EVector = target.minus(p.position);
					//预测这个偏移点将要到达得位置
					//正比于距离，反比于速度
					var lookAheadTime:Number = lenOffset.magnitude()/(p.maxSpeed + leader.velocity.length);
					//计算此时得预测点
					var futurePostion:EVector = target.plusEquals(leader.velocity.mult(lookAheadTime));
					arrive(p, futurePostion);
				}
			};
		}();
		
//-----------------------------组行为--------------------------------------------------------------
		//标记邻居
		/**
		 *p 参考的小车
		 * radius p小车的半径范围
		 * plist 所有小车集合 
		 * @param p
		 * @param radius
		 * @param plist
		 * 
		 */		
		public static function tagNeighbors(p:Vehicle, radius:Number, plist:Vector.<Vehicle>):void
		{
			var cursor:uint = 0;
			while(cursor < plist.length)
			{
				var curP:Vehicle = plist[cursor];
				if(curP == p){
					cursor++;
					continue;
				}
				//先将当前的tag取消
				curP.unTag();
				//计算到当前p的距离
				var distSq:Number = curP.position.distanceSq(p.position);
				//看这个距离是否在范围之内
				if(distSq < radius*radius)
				{
					curP.tag();
				}
				cursor++;
			}
		}
		
		//分离
		/**
		 * p 参考的小车
		 * plist 所有小车集合 
		 * 这里的分离说的是当前小车于周围邻居的分离而不是
		 * 小车得邻居和当前小车得分离
		 * @param p
		 * @param plist
		 * 
		 */		
		public static function separation(p:Vehicle, plist:Vector.<Vehicle>):EVector
		{
			//所有邻居给这个小车逃离的总和力
			var totalForce:EVector = new EVector();
			for (var i:int = 0; i < plist.length; i++) 
			{
				var curP:Vehicle = plist[i];
				if(curP == p) continue;
				if(curP.isTagged())
				{
//					//不能只用逃离函数
//					flee(curP, p.position);
					//还需要其它计算，应该是距离越近力越大，距离越远力越小
					
					//计算到p的距离
					var toAgent:EVector = p.position.minus(curP.position);//方向是 p指向它，也就是逃离的方向
					var len:Number = (toAgent.length == 0) ? p.maxForce : 1/toAgent.length;//如果位置重合就让它产生最大的力
					//逃离的大小应该跟距离成反比
					totalForce.plusEquals(toAgent.normalizeEquals().multEquals(len));
					//---为了方便控制力
					//---将这部分移动到了caculate里面去计算
					//---这里仅仅是返回separation所受的力
					//添加力	
//					p.addForce(totalForce);
				}
			}
			
			return totalForce;
		}
		
		//对齐
		/**
		 * p 参考的小车
		 * plist 所有小车集合 
		 * 同样这里的对齐也是只得当前小车和所有小车得对齐
		 * 
		 * @param p
		 * @param plist
		 * 
		 */	
		public static function alignment(p:Vehicle, plist:Vector.<Vehicle>):EVector
		{
			var averageHeading:EVector = new EVector();//又要用闭包，请问你是不是用闭包用上瘾了？？嗯，是的，啦啦啦，你来打我啊！
			var force:EVector = averageHeading;
			var count:int;
			for (var i:int = 0; i < plist.length; i++) 
			{
				var curP:Vehicle = plist[i];
				if(curP == p) continue;
				if(curP.isTagged())
				{
					averageHeading.plusEquals(curP.xAxis);//计算朝向的总和
					count++;
				}
			}
			//求平均值
			if(count > 0){
				averageHeading.multEquals(1/count);
				//然后计算转向力
				force = averageHeading.minusEquals(p.xAxis);
				//---为了方便控制力
				//---将这部分移动到了caculate里面去计算
				//---这里仅仅是返回alignment所受的力
				//添加力
//				p.addForce(force);
			}
			
			return force;
		}
		
		//聚集
		/**
		 * p 参考的小车
		 * plist 所有小车集合 
		 * 聚集是当前小车聚集到所有小车得平均点
		 * 
		 * @param p
		 * @param plist
		 * 
		 */	
		public static function cohesion(p:Vehicle, plist:Vector.<Vehicle>):EVector
		{
			var centerOfMass:EVector = new EVector();
			var force:EVector = centerOfMass;
			var count:int = 0;
			for (var i:int = 0; i < plist.length; i++) 
			{
				var curP:Vehicle = plist[i];
				if(curP == p) continue;
				if(curP.isTagged())
				{
					centerOfMass.plusEquals(curP.position);
					count++;
				}
			}
			//求平均值
			if(count > 0){
				//找到中心点
				centerOfMass.multEquals(1/count);
				//---为了方便控制力
				//---将这部分移动到了caculate里面去计算
				//---这里仅仅是返回cohesion所受的力
				force = seek(p, centerOfMass);
//				p.addForce(force);
//				force = arrive(p, centerOfMass);
			}
			
			return force;
		}
//-----------------开启了空间分割的计算方法-----------------------------------------------------
		/**
		 *总体和 separation 方法是一样的, 就是列表变成了提前算出来的邻居列表 
		 * @param p
		 * @param neighbors
		 * 
		 */		
		public static function separationPartition(p:Vehicle, neighbors:Vector.<Vehicle>):EVector
		{
			//所有邻居给这个小车逃离的总和力
			var totalForce:EVector = new EVector();
			for	each(var v:Vehicle in neighbors)
			{
				var curP:Vehicle = v;
				//计算到p的距离
				var toAgent:EVector = p.position.minus(curP.position);//方向是 p指向它，也就是逃离的方向
				var len:Number = (toAgent.length == 0) ? p.maxForce : 1/toAgent.length;//如果位置重合就让它产生最大的力
				//逃离的大小应该跟距离成反比
				totalForce.plusEquals(toAgent.normalizeEquals().multEquals(len));
			}
			return totalForce;
		}
		
		/**
		 * 
		 * @param p
		 * @param neighbors
		 * @return 
		 * 
		 */		
		public static function alignmentPartition(p:Vehicle, neighbors:Vector.<Vehicle>):EVector
		{
			var averageHeading:EVector = new EVector();//又要用闭包，请问你是不是用闭包用上瘾了？？嗯，是的，啦啦啦，你来打我啊！
			var force:EVector = averageHeading;
			var count:int;
			for	each(var v:Vehicle in neighbors)
			{
				var curP:Vehicle = v;
				averageHeading.plusEquals(curP.xAxis);//计算朝向的总和
				count++;
			}
			//求平均值
			if(count > 0){
				averageHeading.multEquals(1/count);
				force = averageHeading.minusEquals(p.xAxis);
			}
			
			return force;
		}
		
		/**
		 * 
		 * @param p
		 * @param neighbors
		 * @return 
		 * 
		 */		
		public static function cohesionPartition(p:Vehicle, neighbors:Vector.<Vehicle>):EVector
		{
			var centerOfMass:EVector = new EVector();
			var force:EVector = centerOfMass;
			var count:int = 0;
			for	each(var v:Vehicle in neighbors)
			{
				var curP:Vehicle = v;
				centerOfMass.plusEquals(curP.position);
				count++;
			}
			//求平均值
			if(count > 0){
				//找到中心点
				centerOfMass.multEquals(1/count);
				force = seek(p, centerOfMass);
			}
			
			return force;
		}
//----------------------------------------------------------------------------------------------------------------		
//------------总方法,应用力只需要调用这个方法即可----------------------------------------------------------------------------
		public static function calculate(v:Vehicle, plist:Vector.<Vehicle>, method:int = 0):void
		{
			//如果开启了flocking行为 则计算邻居
			if(on(v, BehaviorType.separation) || on(v, BehaviorType.alignment) || on(v, BehaviorType.cohesion))
			{
				if(!isSpacePartition())//假如没有开启分割就用普通算法
				{
					tagNeighbors(v, v.scope, plist);
				}else{//假如开启了分割就用分割算法
					CellSpacePartition.getInstance().updateEntity(v);
					CellSpacePartition.getInstance().calculateNeighbors(v.position, 100, v);//暂时写成100
				}
			}
			
			var force:EVector;
			switch(method)
			{
				case Weighted_Prioritized:
					force = calculatePrioritized(v, plist);
					break;
				case Weighted_Sum:
					force = calculateWeightedSum(v, plist);
					break;
			}
			v.addForce(force);
		}
//-------------计算力的各种方法--------------------------------------------------------------------------------------		
		/**
		 *以上产生的力必须要通过权值来判断更倾向于哪些力
		 * 否则它会在某处截断而不进行后面的力的行为
		 * 比如：
		 * ↑
		 * |
		 * |
		 * |
		 * |
		 * |
		 * ————>
		 * 这两个力的合力就更倾向于向上方向
		 * 
		 * 
		 * ↑
		 * |
		 * ——————————————————>
		 * 而这两个力的合力就更倾向于向右方向
		 */		
		public static function calculateWeightedSum(v:Vehicle, plist:Vector.<Vehicle>):EVector
		{
			//先将力置0
			var force:EVector = new EVector();
			//如果开启了flocking行为 则计算邻居 (统一移动至 calculate 方法中)
//			if(on(v, BehaviorType.separation) || on(v, BehaviorType.alignment) || on(v, BehaviorType.cohesion))
//			{
//				tagNeighbors(v, v.scope, plist);
//			}
			//累加各个行为所受的力
			if(on(v, BehaviorType.separation))
			{
				force.plusEquals(separation(v, plist).multEquals(separationWeight));
			}
			
			if(on(v, BehaviorType.alignment))
			{
				force.plusEquals(alignment(v, plist).multEquals(alignmentWeight));
			}
			
			if(on(v, BehaviorType.cohesion))
			{
				force.plusEquals(cohesion(v, plist).multEquals(cohesionWeight));
			}
			//最后的合力加到小车上
			//v.addForce(force);
			return force;
		}
//-------------------------------带优先级的 加权截断累计---------------------------------------------------------------
		//下面是书上的写法, 用到了大量的计算公式,个人感觉不是很高效
		//如果只是截断的话,因为小车在添加力的时候,本身就有一个截断功能,所以没有必要在这里这样做, 
		//我这里提供两种写法, 一个书上的标准写法, 一个是我自己的写法
		
	//---------------------------------书上的写法-----------------------------------------------------------------	
		/**
		 * 这里用大写表示书上的写法,当然书上的写法,要求会返回力, 所以应用这段代码时,还要改变
		 * 其它行为为最后返回力,而不是直接加在小车上
		 *带优先级的 加权截断累计
		 * 注意行为的顺序是会影响最终效果的
		 * 看不懂这个意思就看代码吧
		 * @param v
		 * @param plist
		 * 
		 */		
		public static function calculatePrioritized(v:Vehicle, plist:Vector.<Vehicle>):EVector
		{
			//当前的力
			var curForce:EVector = new EVector();
			//将要加上的力
			var force:EVector = new EVector();
			//如果开启了flocking行为 则计算邻居 (统一移动至 calculate 方法中)
//			if(on(v, BehaviorType.separation) || on(v, BehaviorType.alignment) || on(v, BehaviorType.cohesion))
//			{
//				tagNeighbors(v, v.scope, plist);
//			}
			//累加各个行为所受的力
			if(on(v, BehaviorType.separation))
			{
				if(!isSpacePartition())
				{
					force = separation(v, plist).multEquals(separationWeight);
				}else{
					force = separationPartition(v, CellSpacePartition.getInstance().neighbors).multEquals(separationWeight);
				}
//				trace("separation:", (force.x < 0 )?'-':'', force.length);
				if(accumulateForce(v, force, curForce) == false)
				{
					//v.addForce(curForce);
					return curForce;
				}
			}
			
			if(on(v, BehaviorType.alignment))
			{
				if(!isSpacePartition())
				{
					force = alignment(v, plist).multEquals(alignmentWeight);
				}else{
					force = alignmentPartition(v, CellSpacePartition.getInstance().neighbors).multEquals(alignmentWeight);
				}
//				trace("alignment:", (force.x < 0 )?'-':'', force.length);
				if(accumulateForce(v, force, curForce) == false)
				{
					//v.addForce(curForce);
					return curForce;
				}
			}
			
			if(on(v, BehaviorType.cohesion))
			{
				if(!isSpacePartition())
				{
					force = cohesion(v, plist).multEquals(cohesionWeight);
				}else{
					force = cohesionPartition(v, CellSpacePartition.getInstance().neighbors).multEquals(cohesionWeight);
				}
//				trace("cohesion:", (force.x < 0 )?'-':'', force.length);
				if(accumulateForce(v, force, curForce) == false)
				{
					//v.addForce(curForce);
					return curForce;
				}
			}
			
//			v.addForce(curForce);
			return curForce;
		}
		
		/**
		 * 运算小车实际应该加上多少力
		 * @param v 小车
		 * @param f 要加上的力
		 * @param r 返回的力,这个力是最终要用到小车上的
		 * @return 
		 * 
		 */		
		private static function accumulateForce(v:Vehicle, f:EVector, r:EVector):Boolean
		{
			//当前所使用的总力
			var curForce:Number = r.length;
			//最大力与总力之差，计算剩下还能加多少力上去
			var remainForce:Number = v.maxForce - curForce;
			//假如没有剩余可加的力,则返回false,不在计算剩余的转向行为
			if(remainForce <= 0) return false;
			//计算我们所要加的力的大小
			var forceToAdd:Number = f.length;
			//假如将要加上的力比剩余可加的力还小,那么全部加上去就可以了
			if(forceToAdd < remainForce){
//				v.addForce(f);
				r.plusEquals(f);
			}else{//假如要加的力比剩余力还大, 那么直接加上剩余的力就可以了
				//剩余力为所要加的力的方向和剩余力的大小
				var temp:EVector = f.normalizeEquals().multEquals(remainForce);
//				v.addForce(temp);
				r.plusEquals(temp)
			}
			
			return true;
		}
//----------------------------------------------------------------------------------------------
//-------------------------------------自己的写法--------------------------------------------------
//		public static function calculatePrioritized(v:Vehicle, plist:Vector.<Vehicle>):void
//		{
//			var temp:EVector;
////			if(on(v, BehaviorType.separation) || on(v, BehaviorType.alignment) || on(v, BehaviorType.cohesion))
////			{
////				tagNeighbors(v, v.scope, plist);
////			}
//			//累加各个行为所受的力
//			if(on(v, BehaviorType.separation))
//			{
//				//这里不用再额外调用截断了,因为addForce里面有截断操作
//				temp = separation(v, plist).multEquals(separationWeight);
//				v.addForce(temp);
//				trace("separation:", temp.length);
//				if(v.maxForce*10 == Math.round(v.forceAccum.length*10)) return;
//			}
//			
//			if(on(v, BehaviorType.alignment))
//			{
//				v.addForce(alignment(v, plist).multEquals(alignmentWeight));
////				trace("alignment:",v.forceAccum.length);
//				if(v.maxForce*10 == Math.round(v.forceAccum.length*10)) return;
//
//			}
//			
//			if(on(v, BehaviorType.cohesion))
//			{
//				temp = cohesion(v, plist).multEquals(cohesionWeight);
//				v.addForce(temp);
//				trace("cohesion:",temp.length);
//				if(v.maxForce*10 == Math.round(v.forceAccum.length*10)) return;
//			}
//		}
		
//		/**
//		 *直接就在 每个转向行为那里加上力而不是把力返回 
//		 * @param v
//		 * @param plist
//		 * 
//		 */		
//		public static function calculatePrioritized2(v:Vehicle, plist:Vector.<Vehicle>):void
//		{
//			if(on(v, BehaviorType.separation) || on(v, BehaviorType.alignment) || on(v, BehaviorType.cohesion))
//			{
//				tagNeighbors(v, v.scope, plist);
//			}
//			//累加各个行为所受的力
//			if(on(v, BehaviorType.separation))
//			{
//				separation(v, plist);
//			}
//			
//			if(on(v, BehaviorType.alignment))
//			{
//				alignment(v, plist);			
//			}
//			
//			if(on(v, BehaviorType.cohesion))
//			{
//				cohesion(v, plist);
//			}
//		}
//----------还有一个带优先级和抖动的加权截断方案,这个自己看书去吧,听到抖动就烦------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
//--------------------重叠检测部分跳过, 现在暂时不需要, 不过原理非常简单,看书就懂了.----------------------------------------------
//-------------------------------------------------------------------------------------------------------------
//--------------------空间划分------------------------------------------------------------------------------------
		
		
	}
}































