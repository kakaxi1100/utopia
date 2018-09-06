#include "JsonFloat.h"

JsonFloat::JsonFloat(float num):mFloat(num)
{
}

float JsonFloat::getValue() const
{
	return mFloat;
}

int JsonFloat::getType()
{
	return JsonValue::TYPE_FLOAT;
}

std::string JsonFloat::toString()
{
	return std::to_string(mFloat);
}
