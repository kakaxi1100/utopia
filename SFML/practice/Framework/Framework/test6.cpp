//#include <iostream>
//#include "Lexer.h"
//
//using namespace std;
//
//int main() {
//	wcout.imbue(std::locale("chs"));
//
//	ifstream readFile("Assets/Text/test.txt");
//	if (!readFile.is_open())
//	{
//		cout << "Error" << endl;
//	}
//	else
//	{
//		//����Ҫ�������������ʾ�����ַ���
//		wcout << LR"(��)"<<"test" << endl;
//	}
//	Lexer l(readFile);
//	l.stateNormal();
//	//while (readFile.peek() != EOF)
//	//{
//	//	//cout << l.getCharCode() << endl;
//	//	/*l.stateNormal();*/
//	//}
//
//	system("pause");
//	return 0;
//}