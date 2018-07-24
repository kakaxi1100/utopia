#pragma once
#include "EventBase.h"

class CustomEvent : public EventBase
{
public:
	int i = 10;
public:
	CustomEvent() = default;
	virtual ~CustomEvent() = default;
private:

};
