#pragma once
#include "ASTree.h"

class Leaf : public ASTree
{
public:
	Leaf(std::shared_ptr<Token> token);
	virtual ~Leaf() = default;
	virtual std::string toString() override;
private:

};
