#pragma once
#include <memory>
#include <unordered_map>
#include <utility>
#include <functional>
#include "EventBase.h"

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

	void addEventListener(const EventType& name, std::function<void(const EventBase&)> foo);
	void dispatch(const EventType& name, EventBase& evt);
	void removeEventListener(const EventType& name);
	bool hasEvent(const EventType& name);
private:
	static std::unique_ptr<EventManager> mInstance;
	std::unordered_map<EventType, std::function<void(const EventBase&)>> eventMap;
};
