#include "JsonString.h"

JsonString::JsonString(std::shared_ptr<std::string> value):mString(value)
{
}

std::string JsonString::getValue() const
{
	return *mString;
}

int JsonString::getType()
{
	return JsonValue::TYPE_STRING;
}

std::string JsonString::toString()
{
	return *mString;
}
