#pragma once
#include "JsonValue.h"
#include <string>
#include <memory>
#include <vector>

class JsonArray : public JsonValue
{
public:
	JsonArray() = default;
	virtual ~JsonArray() = default;

	std::vector<std::shared_ptr<JsonValue>> getValue() const;
	virtual int getType() override;
	void insert(std::shared_ptr<JsonValue> value);
	virtual std::string toString() override;
private:
	std::vector<std::shared_ptr<JsonValue>> mArray;
};
