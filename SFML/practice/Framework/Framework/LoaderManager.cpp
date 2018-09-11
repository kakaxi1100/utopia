#include "LoaderManager.h"

using namespace std;

int LoaderManager::mLoaderCount = 1;
unique_ptr<LoaderManager> LoaderManager::mInstance = nullptr;
LoaderManager & LoaderManager::getInstance()
{
	if (mInstance == nullptr)
	{
		mInstance = make_unique<LoaderManager>();
	}

	return *mInstance;
}

LoaderManager & LoaderManager::create(const std::string & name)
{
	string temName = name;
	shared_ptr<Loader> loader;
	if (name == "")
	{
		temName = "loader" + to_string(mLoaderCount);
		++mLoaderCount;
	}

	loader = make_shared<Loader>(temName);
	mCurLoader = loader;

	return getInstance();
}

LoaderManager & LoaderManager::addEventListener(std::function<void(const EventBase&)> completed, std::function<void(const EventBase&)> error)
{
	EventManager::getInstance().addEventListener(EventType::LoadError, error, mCurLoader->getName());
	EventManager::getInstance().addEventListener(EventType::LoadCompleted, completed, mCurLoader->getName());
	return getInstance();
}

void LoaderManager::loadTexture(const std::string & url)
{
	mCurLoader->loadTexture(url);
	mCurLoader = nullptr;
}

void LoaderManager::loadProperty(const std::string & url)
{
	mCurLoader->loadProperty(url);
	mCurLoader = nullptr;
}

Loader & LoaderManager::getCurLoader()
{
	return *mCurLoader;
}
