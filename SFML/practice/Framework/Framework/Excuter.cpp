#include "Excuter.h"
#include "JsonString.h"
#include "JsonArray.h"
#include "JsonFloat.h"
#include "JsonInt.h"

using namespace std;

Excuter::Excuter(Parser& parser):mParser(parser)
{
}

void Excuter::excute()
{
	mJsonObj = excuteNCV(mParser.getAST());
}

std::shared_ptr<JsonObject> Excuter::excuteNCV(std::shared_ptr<ASTree> node)
{
	size_t i;
	shared_ptr<JsonObject> jsonObj = make_shared<JsonObject>();
	for (i = 0; i < node->children.size(); i++)
	{
		excuteItem(node->children[i], jsonObj);
	}

	return jsonObj;
}

void Excuter::excuteItem(std::shared_ptr<ASTree> node, std::shared_ptr<JsonObject> parent)
{
	shared_ptr<JsonKey> jsonKey;
	shared_ptr<JsonValue> jsonValue;
	jsonKey = excuteKey(node->getFirst());
	jsonValue = excuteValue(node->getLast());
	
	parent->insert(jsonKey, jsonValue);
}

std::shared_ptr<JsonKey> Excuter::excuteKey(std::shared_ptr<ASTree> node)
{
	shared_ptr<JsonKey> jsonKey = make_shared<JsonKey>(node->info->getValue());
	return jsonKey;
}

std::shared_ptr<JsonValue> Excuter::excuteValue(std::shared_ptr<ASTree> node)
{
	shared_ptr<JsonValue> jsonValue;
	int type = node->info->getType();

	if (type == Token::STRING)
	{
		jsonValue = make_shared<JsonString>(node->info->getValue());
	}
	else if (type == Token::INT)
	{
		jsonValue = make_shared<JsonInt>(stoi(*(node->info->getValue())));
	}
	else if (type == Token::FLOAT)
	{
		jsonValue = make_shared<JsonFloat>(stof(*(node->info->getValue())));
	}
	else if (type == Token::OPEN_CURLY)
	{
		jsonValue = excuteNCV(node);
	}
	else if (type == Token::OPEN_BRACKET)
	{
		jsonValue = excuteArray(node);
	}

	return jsonValue;
}

std::shared_ptr<JsonValue> Excuter::excuteArray(std::shared_ptr<ASTree> node)
{
	size_t i;
	shared_ptr<JsonArray> jsonArray = make_shared<JsonArray>();
	shared_ptr<JsonValue> value;
	for (i = 0; i < node->children.size(); i++)
	{
		value = excuteValue(node->children[i]);
		jsonArray->insert(value);
	}

	return jsonArray;
}

std::shared_ptr<JsonObject> Excuter::getJsonObj()
{
	return mJsonObj;
}

std::string Excuter::toString()
{
	return mJsonObj->toString();
}
