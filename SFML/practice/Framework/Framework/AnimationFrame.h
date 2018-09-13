#pragma once
#include <memory>
#include <string>
#include "EventBase.h"
#include <functional>
#include <map>
#include "SFML\Graphics.hpp"

class AnimationFrame
{
public:
	AnimationFrame();
	AnimationFrame(const std::string& name);
	~AnimationFrame() = default;

	void setCallBack(std::function<void(const EventBase&)> callback, std::shared_ptr<EventBase> argument);
	void addConent(std::shared_ptr<sf::Sprite> sprite);
	void addConent(std::shared_ptr<sf::Sprite> sprite, const std::string& name);
	void excuteCallBack();

	std::string getName();
private:
	//instance name
	static unsigned int mSpriteCount;
	//label for animation and event search
	std::string mName;
	std::function<void(const EventBase&)> mCallBack;
	std::shared_ptr<EventBase> mArgument;
	std::map<std::string, std::shared_ptr<sf::Sprite>> mContents;
};
