#include <iostream>
#include "Lexer.h"

using namespace std;
int main()
{
	wcout.imbue(std::locale("chs"));

	ifstream readFile("Assets/Text/test.txt");
	Lexer l(readFile);
	l.stateNormal();

	wcout << L"�ʷ������ɹ�!" << endl;

	system("pause");
	return 0;
}