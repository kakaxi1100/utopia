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
	static const int INT = 8; // 9999
	static const int FLOAT = 9; // 9999
public:
	Token(unsigned int line, int type, std::shared_ptr<std::string>& value);
	~Token() = default;

	int getType() const;
	unsigned int getLineNo() const;
	std::shared_ptr<std::string> getValue();
	std::string toString() const;
private:
	unsigned int mLineNo;
	int mType;
	std::shared_ptr<std::string> mValue;
};
