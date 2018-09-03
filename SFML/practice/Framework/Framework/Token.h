#pragma once
#include <memory>
#include <string>

class Token
{
public:
	static const int OPEN_CURLY = 1;//"{"
	static const int CLOSE_CURLY = 2;//"}"
	static const int OPEN_BRACKET = 3;//"["
	static const int CLOSE_BRACKET = 4;//"]"
	static const int COMMA = 5;//","
	static const int COLON = 6;//":"
	static const int STRING = 7;// ""
	static const int NUMBER = 8; // 9999
public:
	Token(unsigned int line, int type, std::shared_ptr<std::string> value);
	~Token() = default;

	std::string toString();
private:
	unsigned int mLineNo;
	int mType;
	std::shared_ptr<std::string> mValue;
};
