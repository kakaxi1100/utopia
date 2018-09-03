#include "Token.h"

using namespace std;

Token::Token(unsigned int line, int type, shared_ptr<string> value):mLineNo(line), mType(type), mValue(value)
{
}

std::string Token::toString()
{
	return *mValue;
}
