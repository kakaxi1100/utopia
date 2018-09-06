#include "ASTree.h"

using namespace std;

ASTree::ASTree(std::shared_ptr<Token> token):info(token)
{

}

void ASTree::insert(std::shared_ptr<ASTree> child)
{
}

std::shared_ptr<ASTree> ASTree::getFirst()
{
	return children[0];
}

std::shared_ptr<ASTree> ASTree::getLast()
{
	return children[children.size() - 1];
}

std::string ASTree::toString()
{
	return nullptr;
}
