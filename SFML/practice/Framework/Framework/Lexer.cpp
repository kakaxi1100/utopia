#include "Lexer.h"
#include <iostream>
#include <string>

using namespace	std;

Lexer::Lexer(ifstream & stream):mStream(stream)
{
	
}

void Lexer::read()
{
}

void Lexer::stateNormal()
{
	int charCode;
	shared_ptr<Token> token = nullptr;
	string value;
	//这里要用peek预读下一个字符, 因为当流读到文件最后一个字符的时候
	//并不会立即判断是读到了文件尾, 而是继续再读一次的时候,才会判断读到文件尾了
	//这样就会多运行一次循环, 所以不能直接用 !mStream.eof() 来判断  
	while (mStream.peek() != EOF || mCharBuff.size() > 0)
	{
		//先排除空白 即空格和制表符
		charCode = getCharCode();
		if (charCode == TABLE_CODE || charCode == SPACE_CODE)
		{
			continue;
		}
		else if (charCode == NEWLINE_CODE)
		{
			stateEndOfLine();
		}
		else if (charCode == SLASH_CODE) 
		{
			charCode = getCharCode();
			if (charCode == SLASH_CODE)
			{
				charCode = getCharCode();
				if (charCode == SLASH_CODE)// /
				{
					stateOneLineComment();
				}
				else if (charCode == STAR_CODE)// *
				{
					stateMutipleLinesComment();
				}

			}
		}
		else if (charCode == QUOTATION_CODE)
		{
			stateQuotation();
		}
		else if (charCode == NEGATIVE_CODE)
		{
			mCharBuff.push_back(charCode);
			stateNegative();
		}
		else if (charCode >= ZERO_CODE && charCode <= NINE_CODE)
		{
			//进入数字状态
			mCharBuff.push_back(charCode);
			stateInt();
		}
		else if (charCode == DOT_CODE)
		{
			//浮点状态
			mCharBuff.push_back(charCode);
			stateFloat();
		}
		else if (charCode == OPENBRACKET_CODE)
		{
			token = make_shared<Token>(mLineNo, Token::OPEN_BRACKET, make_shared<string>("["));
			mTokenList.push_back(token);
		}
		else if (charCode == OPENCURLY_CODE)
		{
			token = make_shared<Token>(mLineNo, Token::OPEN_CURLY, make_shared<string>("{"));
			mTokenList.push_back(token);
		}
		else if (charCode == CLOSEBRACKET_CODE)
		{
			token = make_shared<Token>(mLineNo, Token::CLOSE_BRACKET, make_shared<string>("]"));
			mTokenList.push_back(token);
		}
		else if (charCode == CLOSECURLY_CODE)
		{
			token = make_shared<Token>(mLineNo, Token::CLOSE_CURLY, make_shared<string>("}"));
			mTokenList.push_back(token);
		}
		else if (charCode == COMMA_CODE)
		{
			token = make_shared<Token>(mLineNo, Token::COMMA, make_shared<string>(","));
			mTokenList.push_back(token);
		}
		else if (charCode == COLON_CODE)
		{
			token = make_shared<Token>(mLineNo, Token::COLON, make_shared<string>(":"));
			mTokenList.push_back(token);
		}
		else
		{
			mCharBuff.clear();
			mStream.close();
			wstring err = L"第";
			err += to_wstring(mLineNo);
			err += L"行: 未识别的标识符 ";
			err += char(charCode);
			wcout << err << endl;
		}
	}
}

void Lexer::stateNegative()
{
	int charCode;
	if (mStream.peek() != EOF)
	{
		charCode = mStream.get();
		mCharBuff.push_back(charCode);
	}
	else
	{
		charCode = -1;
		mCharBuff.push_back(charCode);
		return;
	}
	if (charCode >= ZERO_CODE && charCode <= NINE_CODE)
	{
		stateInt();
	}
	else {
		//stateNormal();
	}
}

void Lexer::stateInt()
{
	int charCode;
	while (mStream.peek() != EOF)
	{
		charCode = mStream.get();
		if (charCode >= ZERO_CODE && charCode <= NINE_CODE)
		{
			mCharBuff.push_back(charCode);
		}
		else if (charCode == DOT_CODE)
		{
			mCharBuff.push_back(charCode);
			stateFloat();
		}
		else {
			//生成整型token
			shared_ptr<string> value = make_shared<string>("");
			while (mCharBuff.size() > 0)
			{
				*value += char(mCharBuff.front());
				mCharBuff.pop_front();
			}
			shared_ptr<Token> token = make_shared<Token>(mLineNo, Token::NUMBER, value);
			mTokenList.push_back(token);

			//最后一个字符要读入
			mCharBuff.push_back(charCode);
			//stateNormal();
			break;
		}
	}
}

void Lexer::stateFloat()
{
	int charCode;
	while (mStream.peek() != EOF)
	{
		charCode = mStream.get();
		if (charCode >= ZERO_CODE && charCode <= NINE_CODE)
		{
			mCharBuff.push_back(charCode);
		}
		else {
			//生成浮点型token
			shared_ptr<string> value = make_shared<string>("");
			while (mCharBuff.size() > 0)
			{
				*value += char(mCharBuff.front());
				mCharBuff.pop_front();
			}
			shared_ptr<Token> token = make_shared<Token>(mLineNo, Token::NUMBER, value);
			mTokenList.push_back(token);

			//最后一个字符要读入
			mCharBuff.push_back(charCode);
			//stateNormal();
			break;
		}
	}
}

void Lexer::stateQuotation()
{
	int charCode;
	while (mStream.peek() != EOF)
	{
		charCode = mStream.get();
		if (charCode != QUOTATION_CODE)// "
		{
			if (charCode == NEWLINE_CODE) {

			}
			else {
				mCharBuff.push_back(charCode);
			}
		}
		else {
			//生成字符串token
			shared_ptr<string> value = make_shared<string>("");
			
			while (mCharBuff.size() > 0)
			{
				*value += char(mCharBuff.front());
				mCharBuff.pop_front();
			}
			shared_ptr<Token> token = make_shared<Token>(mLineNo, Token::STRING, value);
			mTokenList.push_back(token);
			break;
		}
	}
}

void Lexer::stateMutipleLinesComment()
{
	int charCode;
	while (mStream.peek() != EOF)
	{
		charCode = getCharCode();
		if (charCode == STAR_CODE)// *
		{
			charCode = getCharCode();
			if (charCode == SLASH_CODE)// /
			{
				break;
			}
		}
	}
}

void Lexer::stateOneLineComment()
{
	int charCode;
	while (mStream.peek() != EOF)
	{
		charCode = getCharCode();
		if (charCode == NEWLINE_CODE)
		{
			stateEndOfLine();
		}
	}
}

void Lexer::stateEndOfLine()
{
	++mLineNo;
}



int Lexer::getCharCode()
{
	int charCode;
	if (mCharBuff.size() > 0)
	{
		charCode = mCharBuff.back();
		mCharBuff.pop_back();
	}
	else
	{
		if (mStream.peek() != EOF) 
		{
			charCode = mStream.get();
		}
		else
		{
			charCode = -1;
			mCharBuff.push_back(charCode);
		}
	}
	return charCode;
}

std::string Lexer::toString()
{
	string s = "";
	for (size_t i = 0; i < mTokenList.size(); i++)
	{
		s += mTokenList[i]->toString();
	}
	return s;
}
