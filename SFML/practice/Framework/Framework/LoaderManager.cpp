#include "LoaderManager.h"

using namespace std;

unique_ptr<LoaderManager> LoaderManager::mInstance = nullptr;
LoaderManager & LoaderManager::getInstance()
{
	if (mInstance == nullptr)
	{
		mInstance = make_unique<LoaderManager>();
	}

	return *mInstance;
}
