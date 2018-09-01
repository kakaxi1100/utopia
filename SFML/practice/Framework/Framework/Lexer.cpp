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
	//����Ҫ��peekԤ����һ���ַ�, ��Ϊ���������ļ����һ���ַ���ʱ��
	//�����������ж��Ƕ������ļ�β, ���Ǽ����ٶ�һ�ε�ʱ��,�Ż��ж϶����ļ�β��
	//�����ͻ������һ��ѭ��, ���Բ���ֱ���� !mStream.eof() ���ж�  
	while (mStream.peek() != EOF || mCharBuff.size() > 0)
	{
		//���ų��հ� ���ո���Ʊ��
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
			wstring err = L"��";
			err += to_wstring(mLineNo);
			err += L"��: δʶ��ı�ʶ�� ";
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
