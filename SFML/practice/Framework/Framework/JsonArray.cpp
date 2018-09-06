#include "JsonArray.h"

std::vector<std::shared_ptr<JsonValue>> JsonArray::getValue() const
{
	return mArray;
}

int JsonArray::getType()
{
	return JsonValue::TYPE_ARRAY;
}

void JsonArray::insert(std::shared_ptr<JsonValue> value)
{
	mArray.push_back(value);
}

std::string JsonArray::toString()
{
	size_t i = 0;
	std::string s = "[";

	for (i = 0; i < mArray.size() - 1; i++)
	{
		s += mArray[i]->toString() + ",";
	}
	s += mArray[i]->toString() + "]";
	return s;
}

