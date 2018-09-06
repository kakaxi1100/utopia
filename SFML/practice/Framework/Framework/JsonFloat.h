#pragma once
#include "JsonValue.h"
#include <string>

class JsonFloat :public JsonValue
{
public:

	JsonFloat(float num);
	virtual ~JsonFloat() = default;

	float getValue() const ;
	virtual int getType() override;
	virtual std::string toString() override;
private:
	float mFloat;
};