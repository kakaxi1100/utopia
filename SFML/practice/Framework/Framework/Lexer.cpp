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
	unsigned int charCode;
	Token token;
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
		else if (charCode == ENDOFLINE_CODE)
		{

		}
		else if (charCode == SLASH_CODE) 
		{

		}
		else if (charCode == QUOTATION_CODE)
		{

		}
		else if (charCode == NEGATIVE_CODE)
		{

		}
		else if (charCode >= ZERO_CODE && charCode <= NINE_CODE)
		{

		}
		else if (charCode == DOT_CODE)
		{

		}
		else if (charCode == OPENBRACKET_CODE)
		{

		}
		else if (charCode == OPENCURLY_CODE)
		{

		}
		else if (charCode == CLOSEBRACKET_CODE)
		{

		}
		else if (charCode == CLOSECURLY_CODE)
		{

		}
		else if (charCode == COMMA_CODE)
		{

		}
		else if (charCode == COLON_CODE)
		{

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
}

void Lexer::stateInt()
{
}

void Lexer::stateFloat()
{
}

void Lexer::stateQuotation()
{
}

void Lexer::stateMutipleLinesComment()
{
}

void Lexer::stateOneLineComment()
{
}

void Lexer::stateEndOfLine()
{
}



unsigned int Lexer::getCharCode()
{
	unsigned int charCode;
	if (mCharBuff.size() > 0)
	{
		charCode = mCharBuff.back();
		mCharBuff.pop_back();
	}
	else
	{
		charCode = mStream.get();
	}
	return charCode;
}
