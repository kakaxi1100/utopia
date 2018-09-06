#pragma once
#include "ASTree.h"


class Composite : public ASTree
{
public:
	Composite(std::shared_ptr<Token> token = nullptr);
	virtual ~Composite() = default;
	virtual void insert(std::shared_ptr<ASTree> child) override;
	virtual std::string toString() override;
private:

};
