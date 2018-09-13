#include "ResourceManager.h"
#include "LoaderManager.h"
#include <filesystem>
#include "LoaderJsonEvent.h"
#include "LoaderTextureEvent.h"

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

void ResourceManager::loaderTextures(const std::string & url)
{
	for (auto &p : recursive_directory_iterator(url))
	{
		if (is_regular_file(p))
		{
			LoaderManager::getInstance().create()
										.addEventListener(bind(&ResourceManager::loadTextureCompleted, this, placeholders::_1),
														  bind(&ResourceManager::loadTextureError, this, placeholders::_1))
										.loadTexture(p.path().string());
		}
	}
}

void ResourceManager::loaderProperties(const std::string & url)
{
	for (auto &p : recursive_directory_iterator(url))
	{
		if (is_regular_file(p))
		{
			LoaderManager::getInstance().create()
										.addEventListener(bind(&ResourceManager::loadPropertyCompleted, this, placeholders::_1),
														  bind(&ResourceManager::loadPropertyError, this, placeholders::_1))
										.loadProperty(p.path().string());
		}
	}
}


void ResourceManager::loadTextureCompleted(const EventBase & e)
{
	auto evt = dynamic_cast<const LoaderTextureEvent&>(e);
	mTextures.insert({ evt.path, evt.data });
}


void ResourceManager::loadPropertyCompleted(const EventBase & e)
{
	auto evt = dynamic_cast<const LoaderJsonEvent&>(e);
	mProperties.insert({ evt.path, evt.data });
}

void ResourceManager::loadTextureError(const EventBase & e)
{
}

void ResourceManager::loadPropertyError(const EventBase & e)
{
}

std::unordered_map<std::string, std::shared_ptr<JsonObject>> ResourceManager::getPropeties()
{
	return mProperties;
}

std::unordered_map<std::string, std::shared_ptr<sf::Texture>> ResourceManager::getTextures()
{
	return mTextures;
}
