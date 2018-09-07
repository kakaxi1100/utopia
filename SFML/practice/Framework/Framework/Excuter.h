#pragma once
#include <string>
#include <memory>
#include "JsonObject.h"
#include "Parser.h"
#include "ASTree.h"

class Excuter
{
public:
	Excuter(Parser& parser);
	~Excuter() = default;

	void excute();
	std::shared_ptr<JsonObject> excuteNCV(std::shared_ptr<ASTree> node);
	void excuteItem(std::shared_ptr<ASTree> node, std::shared_ptr<JsonObject> parent);
	std::shared_ptr<JsonKey> excuteKey(std::shared_ptr<ASTree> node);
	std::shared_ptr<JsonValue> excuteValue(std::shared_ptr<ASTree> node);
	std::shared_ptr<JsonValue> excuteArray(std::shared_ptr<ASTree> node);

	std::shared_ptr<JsonObject> getJsonObj();
	std::string toString();
private:
	std::shared_ptr<JsonObject> mJsonObj;
	Parser& mParser;
};
