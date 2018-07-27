#pragma once
#include <iostream>

class EventDispatcher
{
public:
	EventDispatcher() = default;
	virtual ~EventDispatcher() = default;
	virtual void testFun(const EventBase& evt) {
		std::cout<<"BASE testFun"<<std::endl;
	};

};
