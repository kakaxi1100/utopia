#pragma once
#include <iostream>
#include "EventBase.h"
/*
* ������������
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
