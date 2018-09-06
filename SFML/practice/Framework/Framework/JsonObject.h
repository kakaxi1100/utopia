#pragma once
#include "JsonValue.h"
#include "JsonKey.h"
#include <memory>
#include <string>
#include <unordered_map>

class JsonObject : public JsonValue
{
public:
	JsonObject() = default;
	virtual ~JsonObject() = default;

	void insert(std::shared_ptr<JsonKey> key, std::shared_ptr<JsonValue> value);
	std::shared_ptr<JsonObject> getValue();

	int searchInt(std::string keyStr);
	float searchFloat(std::string keyStr);
	std::string searchString(std::string keyStr);
	std::shared_ptr<JsonObject> searchObject(std::string keyStr);
	std::vector<std::shared_ptr<JsonValue>> searchArray(std::string keyStr);

	virtual std::string toString() override;
private:
	std::unordered_map<std::string, std::shared_ptr<JsonValue>> mDict;
};

