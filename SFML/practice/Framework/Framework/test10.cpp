//#include <iostream>
//#include "Lexer.h"
//#include "Parser.h"
//#include "Excuter.h"
//
//using namespace std;
//
//int main()
//{
//	wcout.imbue(std::locale("chs"));
//
//	ifstream readFile("Assets/Text/test.txt");
//	Lexer l(readFile);
//	l.stateNormal();
//	//cout << l.toString() << endl;
//
//	Parser p(l);
//	p.parse();
//	//cout << p.toString() << endl;
//
//	Excuter e(p);
//	e.excute();
//	//cout << e.toString() << endl;
//
//	auto jsonObj = e.getJsonObj();
//	//cout << jsonObj->toString() << endl;
//
//	auto value = jsonObj->searchString("stax.gm.staxChicken.normal.cheat");
//	cout << value << endl;
//
//
//	system("pause");
//	return 0;
//}