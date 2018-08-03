#include <iostream>
#include <fstream>
#include <filesystem>
#include "UpdateManager.h";
#include "WindowManager.h";

using namespace std;
using namespace std::experimental::filesystem::v1;
int main()
{
	//UpdateManager::getInstance(1).update();
	
	directory_entry t;

	path testPath("Assets/Images/staxCow_04.png");
	int i = 0;
	for (path::iterator itr = testPath.begin(); itr != testPath.end(); ++itr)
	{
		cout << "path part: " << i++ << " = " << *itr << endl;
	}

	system("pause");
	return 0;
}