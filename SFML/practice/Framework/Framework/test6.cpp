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
		//这里要加上这个才能显示中文字符串
		std::wcout.imbue(std::locale("chs"));
		wcout << LR"(我)"<<"test" << endl;
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