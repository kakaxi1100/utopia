#include "JsonArray.h"
#include "JsonString.h"
#include "JsonFloat.h"
#include "JsonInt.h"
#include "JsonObject.h"


using namespace std;


std::string JsonArray::getString(size_t i)
{
	auto value = dynamic_pointer_cast<JsonString>(mArray.at(i));
	if (value->getType() == JsonValue::TYPE_STRING)
	{
		return value->getValue();
	}
	throw "It's not string type!";
}

std::shared_ptr<JsonArray> JsonArray::getValue()
{
	return shared_from_this();
}

float JsonArray::getFloat(size_t i)
{
	auto value = dynamic_pointer_cast<JsonFloat>(mArray.at(i));
	if (value->getType() == JsonValue::TYPE_FLOAT)
	{
		return value->getValue();
	}
	throw "It's not float type!";
}

int JsonArray::getInt(size_t i)
{
	auto value = dynamic_pointer_cast<JsonInt>(mArray.at(i));
	if (value->getType() == JsonValue::TYPE_INT)
	{
		return value->getValue();
	}
	throw "It's not int type!";
}

std::shared_ptr<JsonArray> JsonArray::getArray(size_t i)
{
	auto value = dynamic_pointer_cast<JsonArray>(mArray.at(i));
	if (value->getType() == JsonValue::TYPE_ARRAY)
	{
		return value->getValue();
	}
	throw "It's not array type!";
}

std::shared_ptr<JsonObject> JsonArray::getObject(size_t i)
{
	auto value = dynamic_pointer_cast<JsonObject>(mArray.at(i));
	if (value->getType() == JsonValue::TYPE_OBJECT)
	{
		return value->getValue();
	}
	throw "It's not object type!";
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

