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
			//��������״̬
			mCharBuff.push_back(charCode);
			stateInt();
		}
		else if (charCode == DOT_CODE)
		{
			//����״̬
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
			//��������token
			shared_ptr<string> value = make_shared<string>("");
			while (mCharBuff.size() > 0)
			{
				*value += char(mCharBuff.front());
				mCharBuff.pop_front();
			}
			shared_ptr<Token> token = make_shared<Token>(mLineNo, Token::NUMBER, value);
			mTokenList.push_back(token);

			//���һ���ַ�Ҫ����
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
			//���ɸ�����token
			shared_ptr<string> value = make_shared<string>("");
			while (mCharBuff.size() > 0)
			{
				*value += char(mCharBuff.front());
				mCharBuff.pop_front();
			}
			shared_ptr<Token> token = make_shared<Token>(mLineNo, Token::NUMBER, value);
			mTokenList.push_back(token);

			//���һ���ַ�Ҫ����
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
			//�����ַ���token
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
