#pragma once
#include <list>
#include <vector>
#include <fstream>
#include <memory>
#include "Token.h"

/**
*
* 合法的单词有
*
* { } => 花括号
* [ ] => 中括号
* // => 单行注释
* / * * / => 多少注释
* 整型和浮点 => 数字
* " " => 字符串
* , => 逗号
* : => 冒号
*
* @author Ares
*
*/
class Lexer
{
public:
	Lexer() = delete;
	Lexer(std::ifstream& stream);
	~Lexer() = default;

	void read();
	std::shared_ptr<Token> next();
	std::shared_ptr<Token> peek();
	std::shared_ptr<Token> lookLast();
	std::string toString();

private:
	void stateNormal();
	void stateNegative();
	void stateInt();
	void stateFloat();
	void stateQuotation();
	void stateMutipleLinesComment();
	void stateOneLineComment();
	void stateEndOfLine();
	int getCharCode();
private:
	std::ifstream& mStream;
	int mLineNo = 1;
	size_t mIndex = 0;
	unsigned int mPeekIndex = 0;
	std::vector<std::shared_ptr<Token>> mTokenList;
	std::list<int> mCharBuff;

	static const unsigned int TABLE_CODE = 9;// \t
	static const unsigned int ENDOFLINE_CODE = 13; // \r
	static const unsigned int NEWLINE_CODE = 10; // \n
	static const unsigned int SPACE_CODE = 32;// 空格
	static const unsigned int SLASH_CODE = 47;// /
	static const unsigned int STAR_CODE = 42;// *
	static const unsigned int QUOTATION_CODE = 34;// "
	static const unsigned int OPENCURLY_CODE = 123;// {
	static const unsigned int CLOSECURLY_CODE = 125;// }
	static const unsigned int OPENBRACKET_CODE = 91;// [
	static const unsigned int CLOSEBRACKET_CODE = 93;// ]
	static const unsigned int COMMA_CODE = 44;// ,
	static const unsigned int COLON_CODE = 58;// :
	static const unsigned int DOT_CODE = 46;// .
	static const unsigned int ZERO_CODE = 48;// 0
	static const unsigned int NINE_CODE = 57;// 9
	static const unsigned int NEGATIVE_CODE = 45;// -
};
