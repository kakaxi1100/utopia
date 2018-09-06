#include "Composite.h"

using namespace std;

Composite::Composite(std::shared_ptr<Token> token):ASTree(token)
{

}

void Composite::insert(std::shared_ptr<ASTree> child)
{
	children.push_back(child);
}

std::string Composite::toString()
{
	size_t i = 0;
	std::string s = "";
	std::string last = "";

	if (info->getType() == Token::OPEN_CURLY)
	{
		s = "{";
		last = "}";
	}
	else if (info->getType() == Token::OPEN_BRACKET)
	{
		s = "[";
		last = "]";
	}

	for (i = 0; i < children.size() - 1; i++)
	{
		s += children[i]->toString() + ",";
	}
	s += children[i]->toString() + last;

	return s;
}
