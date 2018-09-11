#include "JsonRunner.h"
#include "Lexer.h"
#include "Parser.h"
#include "Excuter.h"
#include <iostream>

using namespace std;
std::shared_ptr<JsonObject> JsonRunner::decode(std::string path)
{

	ifstream readFile(path);
	if (!readFile.is_open())
	{
		cout << "�ļ���ʧ��!" << path << endl;
		return nullptr;
	}
	try
	{
		Lexer l(readFile);
		l.read();

		Parser p(l);
		p.parse();

		Excuter e(p);
		e.excute();

		auto jsonObj = e.getJsonObj();

		return jsonObj;
	}
	catch (const std::exception&)
	{
		return nullptr;
	}
}
