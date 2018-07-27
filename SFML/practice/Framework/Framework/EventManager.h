#pragma once
#include <memory>
#include <unordered_map>
#include <utility>
#include <functional>
#include "EventBase.h"
#include "EventDispatcher.h"

enum class EventType
{
	TEST1,
	TEST2,
	TEST3
};

class EventManager
{
public:
	EventManager();
	~EventManager() = default;
	static EventManager& getInstance();

	void addEventListener(const EventType& type, std::function<void(const EventBase&)> foo, const std::string& name = "");
	//void addEventListener(const EventType& name, const EventDispatcher& target, void(EventDispatcher::*foo)(const EventBase&));
	
	void dispatch(const EventType& name, EventBase& evt);
	void removeEventListener(const EventType& type);
	void removeEventListener(const EventType& type, const std::string name);
	bool hasEvent(const EventType& type);
private:
	static std::unique_ptr<EventManager> mInstance;
	std::unordered_multimap<EventType, std::pair<const std::string&, std::function<void(const EventBase&)>>> eventMap;
};