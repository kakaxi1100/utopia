#include <iostream>
#include "Lexer.h"

using namespace std;

int main() {
	ifstream readFile("Assets/Text/test.txt");
	if (!readFile.is_open())
	{
		cout << "Error" << endl;
	}
	else
	{
		//����Ҫ�������������ʾ�����ַ���
		std::wcout.imbue(std::locale("chs"));
		wcout << LR"(��)"<<"test" << endl;
	}
	Lexer l(readFile);
	l.stateNormal();
	//while (readFile.peek() != EOF)
	//{
	//	//cout << l.getCharCode() << endl;
	//	/*l.stateNormal();*/
	//}

	system("pause");
	return 0;
}