#include <iostream>
#include "EventManager.h"

std::unique_ptr<EventManager> EventManager::mInstance = nullptr;

EventManager::EventManager()
{
}

EventManager & EventManager::getInstance()
{
	if (mInstance == nullptr)
	{
		mInstance = std::make_unique<EventManager>();
	}

	return *mInstance;
}

void EventManager::addEventListener(const EventType& type, std::function<void(const EventBase&)> foo, const std::string& name = "")
{
	auto tempPair = std::make_pair(name, foo);
	eventMap.insert({type, tempPair});
}

//void EventManager::addEventListener(const EventType & name, const EventDispatcher& target, void (EventDispatcher::*foo)(const EventBase &))
//{
//	//因为这个地方用的是 EventDispatcher 所有 bind 绑定是的this是 EventDispatcher的而不是其子类的
//	//所以最终会执行 EventDispatcher 的函数
//	std::function<void(const EventBase&)> fun = std::bind(foo, target, std::placeholders::_1);
//	eventMap.insert({ name, fun });
//}

void EventManager::dispatch(const EventType & type, EventBase & evt)
{
	if (hasEvent(type) == true)
	{
		//equal_range 返回一个迭代器 pair, 第一个元素 是第一个与关键字匹配的元素, 第二个元素是最后一个与关键字匹配的元素
		for (auto pos = eventMap.equal_range(type); pos.first != pos.second; ++pos.first)
		{
			pos.first->second.second(evt);
			/*auto callback = pos.first->second.second;
			callback(evt);*/
		}
	}
}

void EventManager::removeEventListener(const EventType & type)
{
	if (hasEvent(type) == true)
	{
		eventMap.erase(type);
	}
}

void EventManager::removeEventListener(const EventType & type, const std::string name)
{
	auto it = eventMap.find(type);
	while (it != eventMap.end())
	{
		auto tempPair = it->second;
		
		if (tempPair.first == name)
		{
			eventMap.erase(it);
		}
		++it;
	}
}

bool EventManager::hasEvent(const EventType & type)
{
	auto it = eventMap.find(type);
	if (it != eventMap.end())
	{
		return true;
	}
	return false;
}

