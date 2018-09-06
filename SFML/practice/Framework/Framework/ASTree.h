#pragma once
#include <string>
#include "Token.h"
#include <memory>
#include <vector>

class ASTree
{
public:
	ASTree(std::shared_ptr<Token> token = nullptr);
	virtual ~ASTree() = default;

	virtual void insert(std::shared_ptr<ASTree> child);
	virtual std::shared_ptr<ASTree> getFirst();
	virtual std::shared_ptr<ASTree> getLast();

	virtual std::string toString();

public:
	std::shared_ptr<Token> info;
	std::vector<std::shared_ptr<ASTree>> children;

private:

};

