#include <iostream>
#include <fstream>
#include <filesystem>
#include "UpdateManager.h"
#include "WindowManager.h"
#include "EventManager.h"
#include "EventBase.h"
#include "Loader.h"
#include "LoaderManager.h"

void loadErrorFun(const EventBase& e)
{
	std::cout<< "loadErrorFun" << std::endl;
}

void loadCompleteFun(const EventBase& e)
{
	std::cout << "loadCompleteFun" << std::endl;
}

using namespace std;
using namespace std::experimental::filesystem;
int main()
{
	/*Loader loader("TestLoader");


	EventManager::getInstance().addEventListener(EventType::LoadError, loadErrorFun, loader.getName());
	EventManager::getInstance().addEventListener(EventType::LoadCompleted, loadCompleteFun, loader.getName());
	loader.load("Assets/Images/staxChicken_01.png");*/

	//for (auto &p : recursive_directory_iterator("Assets/Images"))
	//{
	//	if (is_regular_file(p))
	//	{
	//		//cout << p.path()<< endl;
	//		//cout << p.path().filename() << endl;
	//		//cout << p.path().stem() << endl;
	//		//cout << p.path().extension() << endl;

	//		Loader loader(p.path().filename().string());
	//		EventManager::getInstance().addEventListener(EventType::LoadError, loadErrorFun, loader.getName());
	//		EventManager::getInstance().addEventListener(EventType::LoadCompleted, loadCompleteFun, loader.getName());
	//		loader.loadTexture(p.path().string());
	//	}
	//}

	for (auto &p : recursive_directory_iterator("Assets/Images"))
	{
		if (is_regular_file(p))
		{
			LoaderManager::getInstance().create().addEventListener(loadCompleteFun, loadErrorFun).loadTexture(p.path().string());
		}
	}

	system("pause");
	return 0;
}