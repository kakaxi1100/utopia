#pragma once
#include <iostream>
#include "EventBase.h"
/*
* 此类已无作用
*
*/
class EventDispatcher
{
public:
	EventDispatcher() = default;
	virtual ~EventDispatcher() = default;
	virtual void testFun(const EventBase& evt) {
		std::cout<<"BASE testFun"<<std::endl;
	};
};
