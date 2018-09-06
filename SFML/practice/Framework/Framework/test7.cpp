#include <iostream>
#include "Lexer.h"
#include "Parser.h"
#include "Excuter.h"

using namespace std;

int main()
{
	wcout.imbue(std::locale("chs"));

	ifstream readFile("Assets/Text/test.txt");
	Lexer l(readFile);
	l.stateNormal();
	wcout << L"�ʷ������ɹ�!" << endl;

	Parser p(l);
	p.parse();
	wcout << L"�﷨�����ɹ�!" << endl;

	Excuter e(p);
	e.excute();
	auto jsonObj = e.getJsonObj();
	wcout << L"����ִ�гɹ�!" << endl;
	//cout << jsonObj->toString() << endl;

	auto value = jsonObj->searchString("stax.gm.staxMatch0.sound");
	cout << value << endl;

	system("pause");
	return 0;
}