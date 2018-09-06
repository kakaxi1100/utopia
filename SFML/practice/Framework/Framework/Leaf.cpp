#include "Leaf.h"

Leaf::Leaf(std::shared_ptr<Token> token):ASTree(token)
{
}

std::string Leaf::toString()
{
	return *info->getValue();
}
