#include "Parser.h"
#include "Composite.h"
#include "Leaf.h"
#include "BinaryNode.h"
#include <iostream>

using namespace std;


Parser::Parser(Lexer& lexer):mLexer(lexer)
{
}

void Parser::parse()
{
	shared_ptr<Token> token = getToken();
	if (token->getType() != Token::OPEN_CURLY)
	{
		throw "line" + to_string(token->getLineNo()) + " :must start with {";
		//throw L"line" + to_wstring(token->getLineNo()) + L" :格式错误!必须以 { 开头";
	}

	mASTree = make_shared<Composite>(token);

	nestedCurlyValue(mASTree);

	token = getToken();
	if (token->getType() != Token::CLOSE_CURLY)
	{
		throw "line" + to_string(token->getLineNo()) + " :must end with }";
		//throw L"line" + to_wstring(token->getLineNo()) + L" :格式错误!必须以 } 结尾";
	}
}

std::string Parser::toString() const
{
	return mASTree->toString();
}

std::shared_ptr<ASTree> Parser::getAST()
{
	return mASTree;
}

std::shared_ptr<ASTree> Parser::nestedCurlyValue(std::shared_ptr<ASTree> rootNode)
{
	shared_ptr<ASTree> nestNode = rootNode;
	shared_ptr<ASTree> node = nullptr;
	bool hasMore = false;
	shared_ptr<Token> token = nullptr;
	do {
		node = item();
		nestNode->insert(node);

		token = getToken(true);
		if (token && token->getType() == Token::COMMA)
		{
			shared_ptr<Token> comma = getToken();//跳过逗号
			hasMore = true;
		}
		else {
			hasMore = false;
		}
	} while (hasMore);

	return nestNode;
}

std::shared_ptr<ASTree> Parser::item()
{
	shared_ptr<ASTree> keyNode = nullptr;
	shared_ptr<ASTree> valueNode = nullptr;
	shared_ptr<ASTree> node = nullptr;
	shared_ptr<Token> token = nullptr;

	shared_ptr<Token> key = getToken();
	if (key->getType() != Token::STRING)
	{
		throw "line" + to_string(token->getLineNo()) + " :key must be string type";
		//throw "line" + to_string(key->getLineNo()) + " Key必须为字符串类型!当前类型为: " + *key->getValue();
	}
	if (*key->getValue() == "")
	{
		throw "line" + to_string(token->getLineNo()) + " :key is empty";
		//throw "line" + to_string(key->getLineNo()) + " Key不能为空!";
	}
	keyNode = make_shared<Leaf>(key);

	token = getToken();
	if (token->getType() != Token::COLON)
	{
		throw "line" + to_string(token->getLineNo()) + " :missing colon";
		//throw "line" + to_string(token->getLineNo()) + "缺少冒号!";
	}
	node = make_shared<BinaryNode>(token);// :

	valueNode = parseValue();

	node->insert(keyNode);
	node->insert(valueNode);

	return node;
}

std::shared_ptr<ASTree> Parser::nestedBracketValue(std::shared_ptr<ASTree> rootNode)
{
	shared_ptr<ASTree> nestNode = rootNode;
	shared_ptr<ASTree> node = nullptr;
	bool hasMore = false;
	shared_ptr<Token> token = nullptr;
	do {
		node = parseValue();
		nestNode->insert(node);

		token = getToken(true);
		if (token && token->getType() == Token::COMMA)
		{
			shared_ptr<Token> comma = getToken();//跳过逗号
			hasMore = true;
		}
		else {
			hasMore = false;
		}
	} while (hasMore);

	return nestNode;
}

std::shared_ptr<ASTree> Parser::parseValue()
{
	shared_ptr<ASTree> valueNode = nullptr;

	shared_ptr<Token> token = getToken();
	if (token->getType() == Token::STRING)
	{
		valueNode = make_shared<Leaf>(token);
	}
	else if (token->getType() == Token::INT)
	{
		valueNode = make_shared<Leaf>(token);
	}
	else if (token->getType() == Token::FLOAT)
	{
		valueNode = make_shared<Leaf>(token);
	}
	else if (token->getType() == Token::OPEN_CURLY)
	{
		valueNode = make_shared<Composite>(token);

		nestedCurlyValue(valueNode);

		token = getToken();
		if (token->getType() != Token::CLOSE_CURLY)
		{
			throw "line" + to_string(token->getLineNo()) + "must end with }";
			//throw "line" + to_string(token->getLineNo()) + "格式错误!必须以 } 结尾";
			//cout << "line" + to_string(token->getLineNo()) + "must end with }" << endl;
		}
	}
	else if (token->getType() == Token::OPEN_BRACKET)
	{
		valueNode = make_shared<Composite>(token);
		nestedBracketValue(valueNode);

		token = getToken();
		if (token->getType() != Token::CLOSE_BRACKET)
		{
			throw "line" + to_string(token->getLineNo()) + "must end with ]";
			//throw "line" + to_string(token->getLineNo()) + "格式错误!必须以 ] 结尾";
		}
	}
	else
	{
		throw "line" + to_string(token->getLineNo()) + "format error!";
		//throw "line" + to_string(token->getLineNo()) + "错误的值格式!";
	}

	return valueNode;
}

shared_ptr<Token> Parser::getToken(bool peek)
{
	shared_ptr<Token> token = nullptr;
	if (peek == false)
	{
		token = mLexer.next();
	}
	else
	{
		token = mLexer.peek();
	}
	if (token == nullptr)
	{
		throw "line" + to_string(mLexer.lookLast()->getLineNo()) + "end of token!";
	}

	return token;
}
