#pragma once
#include "Composite.h"

class BinaryNode:public Composite
{
public:
	BinaryNode(std::shared_ptr<Token> token = nullptr);
	virtual ~BinaryNode() = default;

	virtual std::string toString() override;
private:

};
