#pragma once
#include "JsonValue.h"
#include <string>
#include <memory>

class JsonString : public JsonValue
{
public:
	JsonString(std::shared_ptr<std::string> value);
	virtual ~JsonString() = default;

	std::string getValue() const;
	virtual int getType() override;
	virtual std::string toString() override;
private:
	std::shared_ptr<std::string> mString;
};
