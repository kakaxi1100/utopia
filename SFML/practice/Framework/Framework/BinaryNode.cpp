#include "BinaryNode.h"

BinaryNode::BinaryNode(std::shared_ptr<Token> token):Composite(token)
{
}

std::string BinaryNode::toString()
{
	std::string s = "";

	s = children[0]->toString() + *info->getValue() + children[1]->toString();
	return s;
}
