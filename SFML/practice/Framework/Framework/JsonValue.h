#pragma once
#include <string>

class JsonValue
{
public:
	JsonValue() = default;
	virtual ~JsonValue() = default;

	static const int TYPE_STRING = 1;
	static const int TYPE_INT = 2;
	static const int TYPE_FLOAT = 3;
	static const int TYPE_OBJECT = 4;
	static const int TYPE_ARRAY = 5;

	virtual int getType();
	virtual std::string toString();
private:

};
