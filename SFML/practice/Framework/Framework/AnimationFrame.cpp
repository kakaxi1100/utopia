#include "AnimationFrame.h"

using namespace std;

unsigned int AnimationFrame::mSpriteCount = 1;
AnimationFrame::AnimationFrame() :mName("")
{
}

AnimationFrame::AnimationFrame(const std::string & name) : mName(name)
{
}

void AnimationFrame::setCallBack(std::function<void(const EventBase&)> callback, std::shared_ptr<EventBase> argument)
{
	mCallBack = callback;
	mArgument = argument;
}

void AnimationFrame::addConent(std::shared_ptr<sf::Sprite> sprite)
{
	string name = "instance" + to_string(mSpriteCount);
	++mSpriteCount;
	mContents.insert({ name, sprite });
}

void AnimationFrame::addConent(std::shared_ptr<sf::Sprite> sprite, const std::string& name)
{
	mContents.insert({ name, sprite });
}

void AnimationFrame::excuteCallBack()
{
	mCallBack(*mArgument);
}

std::string AnimationFrame::getName()
{
	return mName;
}
