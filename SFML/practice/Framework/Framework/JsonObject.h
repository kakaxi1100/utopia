#pragma once
#include "JsonValue.h"
#include "JsonKey.h"
#include "JsonArray.h"
#include <memory>
#include <string>
#include <unordered_map>

class JsonArray;
class JsonObject : public JsonValue, public std::enable_shared_from_this<JsonObject>
{
public:
	JsonObject() = default;
	virtual ~JsonObject()= default;

	void insert(std::shared_ptr<JsonKey> key, std::shared_ptr<JsonValue> value);
	std::shared_ptr<JsonObject> getValue();

	int searchInt(std::string keyStr);
	float searchFloat(std::string keyStr);
	std::string searchString(std::string keyStr);
	std::shared_ptr<JsonObject> searchObject(std::string keyStr);
	std::shared_ptr<JsonArray> searchArray(std::string keyStr);

	virtual int getType() override;
	virtual std::string toString() override;
private:
	std::unordered_map<std::string, std::shared_ptr<JsonValue>> mDict;
};

