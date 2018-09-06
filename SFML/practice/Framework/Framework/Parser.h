#pragma once
#include "Lexer.h"
#include "ASTree.h"
#include "Token.h"

/**
*语法规范
* 没有处理 { 空 }的情况
*
* program => { nestedValue } | { 空 }
*
* nestedCurlyValue => item | nestedValue , item
*
* item => key : value
*
* key => string
*
* nestedBracketValue => value | nestedBracketValue, value
*
* value => string | number | { nestedValue } | [ nestedBracketValue ]
*
*
* 生成的语法树为
*
*
*
* @author Ares
*
*/
class Parser
{
public:
	Parser(Lexer& lexer);
	~Parser() = default;

	void parse();
	std::string toString() const;
	std::shared_ptr<ASTree> getAST();
private:
	std::shared_ptr<ASTree> nestedCurlyValue(std::shared_ptr<ASTree> rootNode);
	std::shared_ptr<ASTree> item();
	std::shared_ptr<ASTree> nestedBracketValue(std::shared_ptr<ASTree> rootNode);
	std::shared_ptr<ASTree> parseValue();

	std::shared_ptr<Token> getToken(bool peek = false);
private:
	Lexer& mLexer;
	std::shared_ptr<ASTree> mASTree;
};