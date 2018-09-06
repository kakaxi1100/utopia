#include "Token.h"

using namespace std;

Token::Token(unsigned int line, int type, shared_ptr<string>& value):mLineNo(line), mType(type), mValue(value)
{
}

int Token::getType() const
{
	return mType;
}

unsigned int Token::getLineNo() const
{
	return mLineNo;
}

std::shared_ptr<std::string> Token::getValue()
{
	return mValue;
}

std::string Token::toString() const
{
	return *mValue;
}
