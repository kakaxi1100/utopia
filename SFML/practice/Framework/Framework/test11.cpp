#include <iostream>
#include "JsonRunner.h"

using namespace std;

int main()
{

	auto obj = JsonRunner::decode("Assets/Text/test.txt");
	/*cout << obj << endl;
	cout << obj->toString() << endl;*/
	cout << obj->searchArray("stax.gm.staxChicken.normal")->getObject(0)->searchString("texture") << endl;
	cout << obj->searchString("stax.gm.staxSheep.normal.cheat") << endl;


	system("pause");
	return 0;
}