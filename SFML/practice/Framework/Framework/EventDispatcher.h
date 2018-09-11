#pragma once
#include <iostream>
#include "EventBase.h"

class EventDispatcher
{
public:
	EventDispatcher() = default;
	virtual ~EventDispatcher() = default;
	virtual void testFun(const EventBase& evt) {
		std::cout<<"BASE testFun"<<std::endl;
	};

	virtual void loadTextureError(const EventBase& e) {};
	virtual void loadTextureCompleted(const EventBase& e) {};
	virtual void loadPropertyError(const EventBase& e) {};
	virtual void loadPropertyCompleted(const EventBase& e) {};
};
