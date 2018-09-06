#include "JsonInt.h"

JsonInt::JsonInt(int num):mInt(num)
{
}

int JsonInt::getValue() const
{
	return mInt;
}

int JsonInt::getType()
{
	return JsonValue::TYPE_INT;
}

std::string JsonInt::toString()
{
	return std::to_string(mInt);
}
