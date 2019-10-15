package walle
{
	import flash.display.Graphics;
	
	public class SteeringBehaviors
	{
		public static var tempV1:FFVector = new FFVector();
		public static var tempV2:FFVector = new FFVector();
		public static var tempV3:FFVector = new FFVector();
		public static var tempV4:FFVector = new FFVector();
		public static var tempV5:FFVector = new FFVector();
		public static var tempV6:FFVector = new FFVector();
		
		public function SteeringBehaviors()
		{
		}
		
		public static function seek(source:Intelligent, target:FFVector):void
		{
			var dir:FFVector = target.minus(source.position, tempV1);
			var desiredVelocity:FFVector = dir.mult(source.maxSpeed, dir);
			
			var force:FFVector = desiredVelocity.minus(source.velocity, tempV1);
			source.addForce(force);
		}
		
		public static function flee(source:Intelligent, target:FFVector):void
		{
			var dir:FFVector = source.position.minus(target, tempV1);
			
			if(dir.magnitudeSquare() < source.panicDisSq)
			{
				var desiredVelocity:FFVector = dir.mult(source.maxSpeed, dir);
				var force:FFVector = desiredVelocity.minus(source.velocity, tempV1);
				source.addForce(force);
			}
		}
		
		public static function arrive(source:Intelligent, target:FFVector):void
		{
			var dir:FFVector = target.minus(source.position, tempV1);
			var dist:Number = dir.magnitude();
			var desiredVelocity:FFVector;
			//注意这个0是可调的, 主要用于什么位置停止arrive
			if(dist >= 100 )
			{
				desiredVelocity = dir.normalize(dir).mult(source.maxSpeed, dir);
			}else
			{
				desiredVelocity = dir.normalize(dir).mult(source.maxSpeed * dist/100, dir);
			}
			
			var force:FFVector = desiredVelocity.minus(source.velocity, tempV2);
			source.addForce(force);
		}
		
		public static function wander(source:Intelligent):void
		{
			//计算圆心的世界坐标
			var center:FFVector = source.head.mult(source.wanderDist, tempV1);
			//计算抖动偏移量
			var offset:FFVector = tempV2.setTo(Utils.randomBinomial() * source.wanderJitter, Utils.randomBinomial() * source.wanderJitter);
			//将之前的点加上偏移量,得到偏移的点
			var targetPos:FFVector = source.wanderTarget.plus(offset, source.wanderTarget);
			//将偏移的点投影到圆上
			targetPos.minus(center, targetPos);
			targetPos.normalize(targetPos);
			targetPos.mult(source.wanderRadius, targetPos);
			targetPos.plus(center, targetPos);
			source.addForce(targetPos);
		}
		
		public static function pursuit(source:Intelligent, dest:Intelligent):void
		{
			var dir:FFVector = dest.position.minus(source.position, tempV1);
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
			var relativeHeading:Number = source.head.scalarMult(dest.head);
			//face > 0 表示 p 是朝向 e 得
			var face:Number = dir.scalarMult(source.head);
			if(face > 0 && relativeHeading < -0.95)//acos(0.95) = 18°
			{
				seek(source, dest.position);
			}else
			{
				//这里就是找到最佳点
				//lookAheadTime 得意思是从 v 走到 t 需要走多少个 maxSpeed 
				//即所需要得时间
				//这个值正比于两者得距离，反比于两者得速度和
				var lookAheadTime:Number = dir.magnitude()/(source.maxSpeed + dest.velocity.magnitude());
				//如果需要考虑转向时间, 可以加这个
//				lookAheadTime += turnAroundTime(source, dest.position);
				
				//那么要追踪得点为
				var futurePostion:FFVector = dest.position.plus(dest.velocity.mult(lookAheadTime, tempV2), tempV2);//速度乘以时间等于距离
				seek(source, futurePostion);
			}
		}
		
		//lookAheadTime可以加上一个智能体转向的时间, 因为智能体转向也需要时间, 如果不加上这个时间的话 ,那么预测的时间实际是变相减少的
		public static function turnAroundTime(source:Intelligent, target:FFVector):Number
		{
			var dir:FFVector = target.minus(source.position, tempV1);
			dir.normalize(dir);
			var face:Number = source.head.scalarMult(dir);
			//假如是正对, face = 1 那么不需要转向, 返回0, 如果是 在反面 face = -1, 需要最大转向
			var coefficient:Number = 0.5;
			
			return (face - 1) * (-coefficient);
		}
		
		public static function evade(pursuer:Intelligent, evader:Intelligent):void
		{
			var dir:FFVector = pursuer.position.minus(evader.position, tempV1);
			var lookAheadTime:Number = dir.magnitude()/(evader.maxSpeed + pursuer.velocity.magnitude());
			var futurePostion:FFVector = pursuer.position.plus(pursuer.velocity.mult(lookAheadTime, tempV2), tempV2);//速度乘以时间等于距离
			flee(evader, futurePostion);
		}
		
//		//避开圆形障碍物
//		public static function avoid(source:Intelligent, circles:Array, g:Graphics):void
//		{
//			var closeCircle:Circle;
//			var closeDist:Number = 9999;
//			var closeSide:Number = 0;
//			for(var i:int = 0; i < circles.length; i++)
//			{
//				var circle:Circle = circles[i] as Circle;
//				//将circle转换到相对于 source的位置
//				var dir:FFVector = circle.center.minus(source.position, tempV1);
//				//再将它投影到heading上, 看这个位置若果小于0则圆在heading的背面, 不用考虑
//				var projection:Number = dir.scalarMult(source.head);
//				if(projection <= 0)
//				{
//					continue;
//				}
//				
//				//用OBB的包围圆先去除掉不相交的障碍物
//				source.detetionBoxLength = source.minDetetionBoxLength + (source.velocity.magnitude() / source.maxSpeed) * source.minDetetionBoxLength;
//				//首先把圆的坐标系转换为OBB的坐标系
//				//在side上的投影为
//				var sideProjection:Number = dir.scalarMult(source.side);
//				var minX:Number = 0, maxX:Number = source.detetionBoxLength;
//				var minY:Number = -source.detetionBoxHalfHeight, maxY:Number = source.detetionBoxHalfHeight;
//				var curX:Number, curY:Number;
//				if(projection < minX)
//				{
//					curX = minX;
//				}else if(projection > maxX)
//				{
//					curX = maxX;
//				}else{
//					curX = projection;
//				}
//				
//				if(sideProjection < minY)
//				{
//					curY = minY;
//				}else if(sideProjection > maxY)
//				{
//					curY = maxY;
//				}else{
//					curY = sideProjection;
//				}
//				//计算圆心到此点的距离与半径作比较
//				var localDist:Number = (curX - projection) * (curX - projection) + (curY - sideProjection) * (curY - sideProjection);
//				if(localDist > circle.radius * circle.radius)
//				{
//					continue;
//				}
//								
//				//在heading上的投影点为
//				var projectPoint:FFVector = source.head.mult(projection, tempV2);
//				//算出圆心与这个点的距离
//				var dist:Number = dir.minus(projectPoint, tempV3).magnitude();
//				//假如dist超过了半径,那么圆不与包围盒相交
//				//记住为什么要加上 OBB的一半高, 因为这样我们只需要检测圆与head这条线是否相交就能判断圆是否与OBB是否相交
//				var detectDist:Number = dist + source.detetionBoxHalfHeight - circle.radius;
//				if(detectDist >= 0)
//				{
//					continue;
//				}
//				
//				//那么走到这里, 就剩下与OBB相交的有效的圆了, 找到最近的相交圆
//				if(projection < closeDist)
//				{
//					closeDist = projection;
//					closeSide = detectDist;
//					closeCircle = circle;
//				}		
//			}
//			
//			
//			/**力的计算其实相当于水平上 arrive到某个点, 垂直上逃离某个点*/
//			//找到了最近圆的话, 开始计算侧向力和制动力
//			if(closeCircle != null)
//			{
//				//侧向力有两部分组成, 在head方向上障碍物离OBB多近, 以及在y方向上离OBB多近
//				//找到需要远离的点, 理论上这个点应该是圆与OBB离智能体较近的那个交点
//				//这里为了方便计算, 取圆heading上的投影 - 圆的半径 在heading上得到的点
//				var target:FFVector = source.head.mult(projection - closeCircle.radius, tempV4);
//				target.plus(source.position, tempV4);
//				g.lineStyle(2, 0xFF0000);
//				g.drawCircle(target.x, target.y, 2);
//				//小车的制动力, 离这个点越近制动力越强
//				var breakForce:FFVector = source.position.minus(target, tempV4);
//				//与速度和距离成正比
//				breakForce.mult(target.magnitude() * source.velocity.magnitude()/source.maxSpeed, tempV4);
//				trace(breakForce);
//				//小车的侧向力, 离这个点越近侧向力力越强
//				//圆的中心点与小车的侧向距离
////				var sideForce:FFVector = ;
//				
//				source.addForce(breakForce);
//			}
//		}
		
		//避开圆形障碍物
		public static function avoid(source:Intelligent, circles:Array, g:Graphics):void
		{
			var closeCircle:Circle;
			var closeDist:Number = Number.MAX_VALUE;
			var localPos:FFVector = tempV6;
			
			for(var i:int = 0; i < circles.length; i++)
			{
				var circle:Circle = circles[i] as Circle;
				//将circle转换到相对于 source的位置
				var dir:FFVector = circle.center.minus(source.position, tempV1);
				//再将它投影到heading上, 看这个位置若果小于0则圆在heading的背面, 不用考虑
				var projection:Number = dir.scalarMult(source.head);
				if(projection <= 0)
				{
					continue;
				}
				
				//用OBB的包围圆先去除掉不相交的障碍物
				source.detetionBoxLength = source.minDetetionBoxLength + (source.velocity.magnitude() / source.maxSpeed) * source.minDetetionBoxLength;
				//首先把圆的坐标系转换为OBB的坐标系
				//在side上的投影为
				var sideProjection:Number = dir.scalarMult(source.side);
				var minX:Number = 0, maxX:Number = source.detetionBoxLength;
				var minY:Number = -source.detetionBoxHalfHeight, maxY:Number = source.detetionBoxHalfHeight;
				var curX:Number, curY:Number;
				if(projection < minX)
				{
					curX = minX;
				}else if(projection > maxX)
				{
					curX = maxX;
				}else{
					curX = projection;
				}
				
				if(sideProjection < minY)
				{
					curY = minY;
				}else if(sideProjection > maxY)
				{
					curY = maxY;
				}else{
					curY = sideProjection;
				}
				//计算圆心到此点的距离与半径作比较
				var localDist:Number = (curX - projection) * (curX - projection) + (curY - sideProjection) * (curY - sideProjection);
				if(localDist > circle.radius * circle.radius)
				{
					continue;
				}
				
				//那么走到这里, 就剩下与OBB相交的有效的圆了, 找到最近的相交圆
				if(projection < closeDist)
				{
					closeDist = projection;
					closeCircle = circle;
					//设置本地坐标
					localPos.setTo(projection, sideProjection);
				}		
			}
			
			//找到了最近圆的话, 开始计算侧向力和制动力
			if(closeCircle != null)
			{
				var multiplier:Number = 1.0 + (source.detetionBoxLength - localPos.x)/source.detetionBoxLength;
				var force:FFVector = tempV2;
				//计算侧向力 它的最近点离小车的侧向的距离, 用本地坐标更容易计算
				force.y = (closeCircle.radius - localPos.y) * multiplier;
				//计算制动力
				force.x = (closeCircle.radius - localPos.x) * 0.2;
				//将这个force转化为世界坐标
				source.head.mult(force.x, tempV3);
				source.side.mult(force.y, tempV4);
				var worldForce:FFVector = tempV3.plus(tempV4, tempV5);
				
				source.addForce(worldForce);
			}
		}
		
//		public static function collideCirclePoint(c:Circle, p:FFVector):Boolean
//		{
//			var dist:Number = c.center.minus(p, tempV1).magnitudeSquare();
//			
//			return dist <= c.radius * c.radius;
//		}
		
		//插入
		public static function interpose(dest1:Intelligent, dest2:Intelligent, source:Intelligent):void
		{
			//先算出两个智能体的中间位置
			var midPoint:FFVector = dest1.position.plus(dest2.position, tempV1).mult(0.5, tempV1);
			//然后计算当前source到达这个点所需要得最少的时间，即拥有最大速度
			var timeToReachMidPoint:Number = source.position.distance(midPoint, tempV2)/source.maxSpeed;
			//用这个时间来预测 dest1和dest2 将要到达得位置
			//先计算出速度于这个时间乘积然后再加上现有的位置
			//分成两步些主要是为了节省变量
			var dest1Arriving:FFVector = dest1.velocity.mult(timeToReachMidPoint, tempV1);
			var dest1Pos:FFVector = dest1Arriving.plus(dest1.position, tempV1);
			
			var dest2Arriving:FFVector = dest2.velocity.mult(timeToReachMidPoint, tempV2);
			var dest2Pos:FFVector = dest2Arriving.plus(dest2.position, tempV2);
			
			//计算它们未来时间两个小车位置的中间点
			var temp:FFVector = dest1Pos.plus(dest2Pos, tempV3).mult(0.5, tempV3);
			midPoint.setTo(temp.x, temp.y);
			//然后小车 source 抵达那个点
			arrive(source, midPoint);
		}
		
		public static function followPath(source:Intelligent, path:Path):void
		{
			var dist:Number = source.position.distanceSquare(path.curtPoint, tempV1);
			//表示到达了
			if(dist <= path.curtDist * path.curtDist)
			{
				path.next();
			}
			
			if(path.isEnd() && !path.loop)
			{
				arrive(source, path.curtPoint);
			}else
			{
				seek(source, path.curtPoint);
			}
		}
		
		//offest 是相对于 leader的坐标, 所以要转化为世界空间坐标, 因为最后要追逐的位置是世界坐标的位置
		public static function offsetPursuit(leader:Intelligent, follow:Intelligent, offset:FFVector):void
		{
			//求offset再heading和side上的投影, 分别得到offset在side和heading上的两个世界坐标分量, 最后再加起来
			var offsetX:FFVector = leader.head.mult(offset.x, tempV1);
			var offsetY:FFVector = leader.side.mult(offset.y, tempV2);
			var offsetWorld:FFVector = leader.position.plus(offsetX.plus(offsetY, tempV1), tempV1);
			//这个点就是追逐者要到达的距离
			var offsetLen:Number = offsetWorld.minus(follow.position, tempV3).magnitude();
			//预期要到达的位置
			var lookAheadTime:Number = offsetLen / (follow.maxSpeed + leader.velocity.magnitude());
			//计算此时得预测点
			var futurePostion:FFVector = offsetWorld.plus(leader.velocity.mult(lookAheadTime, tempV2), tempV3);
			arrive(follow, futurePostion);
		}
	}
}