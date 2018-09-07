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
//	wcout << L"�ʷ������ɹ�!" << endl;
//
//	Parser p(l);
//	p.parse();
//	wcout << L"�﷨�����ɹ�!" << endl;
//
//	Excuter e(p);
//	e.excute();
//	auto jsonObj = e.getJsonObj();
//	wcout << L"����ִ�гɹ�!" << endl;
//	//cout << jsonObj->toString() << endl;
//
//	auto value = jsonObj->searchString("stax.gm.staxMatch0.sound");
//	cout << value << endl;
//
//	auto value1 = jsonObj->searchArray("stax.gm.dust.flowing");
//	cout << value1->getObject(0)->searchString("texture") << endl;
//	
//	auto value2 = jsonObj->searchArray("stax.gm.life.dead");
//	cout << value2->getString(0) << value2->getString(1) << endl;
//
//	system("pause");
//	return 0;
//}