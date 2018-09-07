#pragma once
#include "JsonValue.h"
#include "JsonObject.h"
#include <string>
#include <memory>
#include <vector>

class JsonObject;

class JsonArray : public JsonValue, public std::enable_shared_from_this<JsonArray>
{
public:
	JsonArray() = default;
	virtual ~JsonArray() = default;

	std::shared_ptr<JsonArray> getValue();
	float getFloat(size_t i);
	int getInt(size_t i);
	std::string getString(size_t i);
	std::shared_ptr<JsonArray> getArray(size_t i);
	std::shared_ptr<JsonObject> getObject(size_t i);
	virtual int getType() override;
	void insert(std::shared_ptr<JsonValue> value);
	virtual std::string toString() override;
private:
	std::vector<std::shared_ptr<JsonValue>> mArray;
	std::shared_ptr<JsonArray> self;
};
