#pragma once
#include "EventBase.h"
#include <memory>
#include "JsonObject.h"

class LoaderJsonEvent : public EventBase
{
public:
	LoaderJsonEvent() = default;
	~LoaderJsonEvent() = default;

	std::shared_ptr<JsonObject> data;
private:

};
