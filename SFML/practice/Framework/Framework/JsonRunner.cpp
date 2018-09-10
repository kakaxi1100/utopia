#include "JsonRunner.h"
#include "Lexer.h"
#include "Parser.h"
#include "Excuter.h"

using namespace std;
std::shared_ptr<JsonObject> JsonRunner::decode(std::string path)
{

	ifstream readFile("Assets/Text/test.txt");
	Lexer l(readFile);
	l.read();

	Parser p(l);
	p.parse();

	Excuter e(p);
	e.excute();

	auto jsonObj = e.getJsonObj();

	return jsonObj;
}
