#pragma once
#include <fstream>
#include "JsonObject.h"
#include <memory>

class JsonRunner
{
public:
	JsonRunner() = default;
	~JsonRunner() = default;

	static std::shared_ptr<JsonObject> decode(std::string path);

private:

};
