#include "ResourceManager.h"
#include "LoaderManager.h"
#include <filesystem>

using namespace std;
using namespace std::experimental::filesystem;

unique_ptr<ResourceManager> ResourceManager::mInstance = nullptr;
ResourceManager & ResourceManager::getInstance()
{
	if (mInstance == nullptr)
	{
		mInstance = make_unique<ResourceManager>();
	}

	return *mInstance;
}

void ResourceManager::loaderProperties(const std::string & url)
{
	for (auto &p : recursive_directory_iterator(url))
	{
		if (is_regular_file(p))
		{
			LoaderManager::getInstance().create()
										.addEventListener(bind(&EventDispatcher::loadTextureCompleted, this, placeholders::_1),
														  bind(&EventDispatcher::loadTextureError, this, placeholders::_1))
										.loadTexture(p.path().string());
		}
	}
}

void ResourceManager::loaderTextures(const std::string & url)
{
	for (auto &p : recursive_directory_iterator(url))
	{
		if (is_regular_file(p))
		{
			LoaderManager::getInstance().create()
										.addEventListener(bind(&EventDispatcher::loadPropertyCompleted, this, placeholders::_1),
														  bind(&EventDispatcher::loadPropertyError, this, placeholders::_1))
										.loadTexture(p.path().string());
		}
	}
}

void ResourceManager::loadTextureError(const EventBase & e)
{
}

void ResourceManager::loadTextureCompleted(const EventBase & e)
{
}


void ResourceManager::loadPropertyError(const EventBase & e)
{
}

void ResourceManager::loadPropertyCompleted(const EventBase & e)
{
}

