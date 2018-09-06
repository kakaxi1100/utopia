#pragma once
#include "JsonValue.h"
#include <string>

class JsonInt : public JsonValue
{
public:
	JsonInt(int num);
	virtual ~JsonInt() = default;

	int getValue() const;
	virtual int getType() override;
	virtual std::string toString() override;

private:
	int mInt;
};
