#include "JsonObject.h"
#include "JsonInt.h"
#include "JsonFloat.h"
#include "JsonArray.h"
#include "JsonString.h"

using namespace std;

void JsonObject::insert(std::shared_ptr<JsonKey> key, std::shared_ptr<JsonValue> value)
{
	mDict[*key->getValue()] = value;
}

shared_ptr<JsonObject> JsonObject::getValue()
{
	return shared_ptr<JsonObject>(this);
}

int JsonObject::searchInt(std::string keyStr)
{
	auto value = mDict.at(keyStr);
	if (value->getType() == JsonValue::TYPE_INT)
	{
		return dynamic_pointer_cast<JsonInt>(value)->getValue();
	}
	throw "It's not int type!";
}

float JsonObject::searchFloat(std::string keyStr)
{
	auto value = mDict.at(keyStr);
	if (value->getType() == JsonValue::TYPE_FLOAT)
	{
		return dynamic_pointer_cast<JsonFloat>(value)->getValue();
	}
	throw "It's not float type!";
}

string JsonObject::searchString(std::string keyStr)
{
	auto value = mDict.at(keyStr);
	if (value->getType() == JsonValue::TYPE_STRING)
	{
		return dynamic_pointer_cast<JsonString>(value)->getValue();
	}
	throw "It's not string type!";
}

shared_ptr<JsonObject> JsonObject::searchObject(std::string keyStr)
{
	auto value = mDict.at(keyStr);
	if (value->getType() == JsonValue::TYPE_OBJECT)
	{
		return dynamic_pointer_cast<JsonObject>(value)->getValue();
	}
	throw "It's not string type!";
}

std::vector<std::shared_ptr<JsonValue>> JsonObject::searchArray(std::string keyStr)
{
	auto value = mDict.at(keyStr);
	if (value->getType() == JsonValue::TYPE_OBJECT)
	{
		return dynamic_pointer_cast<JsonArray>(value)->getValue();
	}
	throw "It's not string type!";
}

std::string JsonObject::toString()
{
	string s = "{";
	string ob = "";
	string cb = "";
	auto mapIt = mDict.cbegin();
	while (mapIt != mDict.cend())
	{

		s += mapIt->first + ":" + ob + mapIt->second->toString() + cb + ",";

		++mapIt;
	}
	if (s[s.length() - 1] == ',')
	{
		s = s.substr(0, s.length() - 1);
	}
	s += "}";

	return s;
}
