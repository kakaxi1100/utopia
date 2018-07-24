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

void EventManager::addEventListener(const EventType & name, std::function<void(const EventBase&)> foo)
{
	eventMap.insert({ name, foo});
}

void EventManager::dispatch(const EventType & name, EventBase & evt)
{
	if (hasEvent(name) == true)
	{
		auto callback = eventMap.at(name);
		callback(evt);
	}
}

void EventManager::removeEventListener(const EventType & name)
{
	if (hasEvent(name) == true)
	{
		eventMap.erase(name);
	}
}

bool EventManager::hasEvent(const EventType & name)
{

	auto it = eventMap.find(name);
	if (it != eventMap.end())
	{
		std::cout << "TURE" << std::endl;
		return true;
	}
	std::cout << "FALSE" << std::endl;
	return false;
}

