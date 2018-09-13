#include "Animation.h"

Animation::Animation(unsigned int frameRate):mFrameRate(frameRate),mWave(1.0/ static_cast<float>(frameRate))
{
	
}

Animation::Animation(unsigned int frameRate, int loop) :mFrameRate(frameRate), mWave(1.0 / static_cast<float>(frameRate)), mLoop(loop)
{
}

void Animation::addFrame(std::shared_ptr<AnimationFrame> frame)
{
	mFrames.push_back(frame);
}

void Animation::setLoop(int loop)
{
	mLoop = loop;
}

void Animation::play()
{
	mIsPlaying = true;
}

void Animation::stop()
{
	mIsPlaying = false;
	mIndex = 0;
}

void Animation::pause()
{
	mIsPlaying = false;
}

void Animation::gotoAndPlay(unsigned int frameIndex)
{
	mIndex = frameIndex;
	play();
}

void Animation::gotoAndPlay(std::string frameName)
{
	for (size_t i = 0; i < mFrames.size(); i++)
	{
		auto frame = mFrames.at(i);
		if (frame->getName() == frameName)
		{
			mIndex = i;
			break;
		}
	}
	play();
}

void Animation::gotoAndStop(unsigned int frameIndex)
{
	mIndex = frameIndex;
	render();
	stop();
}

void Animation::gotoAndStop(std::string frameName)
{
	for (size_t i = 0; i < mFrames.size(); i++)
	{
		auto frame = mFrames.at(i);
		if (frame->getName() == frameName)
		{
			mIndex = i;
			break;
		}
	}
	render();
	stop();
}

void Animation::gotoAndPause(unsigned int frameIndex)
{
	mIndex = frameIndex;
	render();
	pause();
}

void Animation::gotoAndPause(std::string frameName)
{
	for (size_t i = 0; i < mFrames.size(); i++)
	{
		auto frame = mFrames.at(i);
		if (frame->getName() == frameName)
		{
			mIndex = i;
			break;
		}
	}
	render();
	pause();
}



void Animation::update(float dt)
{
	//假如没有播放
	if (mIsPlaying == false)
	{
		return;
	}

	//既可以解决时间延迟的问题, 又可以解决跳帧的问题
	bool isRendered = false;
	mDuration += dt;
	while(mDuration > mWave)
	{
		render();
		mDuration -= mWave;//如果直接只是减去framerate则可能出现跳帧的问题, 所以执行render之后一定要再将它重置回零
		isRendered = true;
	}

	if (isRendered == true)
	{
		mDuration = 0;
	}
}

void Animation::render()
{
	//enter callback
	mFrames.at(mIndex);
	//draw image
	//leave callback
	++mIndex;
	if (mIndex >= mFrames.size())
	{
		//无限循环
		if (mLoop < 0)
		{
			mIndex = 0;
		}
		else if (mLoop == 0)//不循环
		{
			mIsPlaying = false;
		}
		else
		{
			--mLoop;
			mIndex = 0;
		}
	}
}
