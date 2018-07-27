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
//	//��Ϊ����ط��õ��� EventDispatcher ���� bind ���ǵ�this�� EventDispatcher�Ķ������������
//	//�������ջ�ִ�� EventDispatcher �ĺ���
//	std::function<void(const EventBase&)> fun = std::bind(foo, target, std::placeholders::_1);
//	eventMap.insert({ name, fun });
//}

void EventManager::dispatch(const EventType & type, EventBase & evt)
{
	if (hasEvent(type) == true)
	{
		//equal_range ����һ�������� pair, ��һ��Ԫ�� �ǵ�һ����ؼ���ƥ���Ԫ��, �ڶ���Ԫ�������һ����ؼ���ƥ���Ԫ��
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

