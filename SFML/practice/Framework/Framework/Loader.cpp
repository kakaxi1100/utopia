#include <iostream>	
#include <SFML\Graphics.hpp>
#include "Loader.h"
#include "EventManager.h"
#include "LoaderTextureEvent.h"
#include "LoaderJsonEvent.h"
#include "JsonRunner.h"


void Loader::loadTexture(const std::string & url)
{
	mURL = url;

	std::shared_ptr<sf::Texture> texture = std::make_shared<sf::Texture>();
	LoaderTextureEvent tempEvt;
	if (!texture->loadFromFile(url))
	{
		std::cout<<"Texture文件加载失败: "<<url<<std::endl;
		//error
		EventManager::getInstance().dispatch(EventType::LoadError, tempEvt, mName);
	}
	else
	{
		tempEvt.data = texture;
		tempEvt.path = url;
		//completed
		std::cout << "Texture文件加载成功: " << url << std::endl;
		EventManager::getInstance().dispatch(EventType::LoadCompleted, tempEvt, mName);
	}
	std::cout << "what the fuck" << std::endl;
}

void Loader::loadProperty(const std::string & url)
{
	std::shared_ptr<JsonObject> obj = JsonRunner::decode(url);
	LoaderJsonEvent tempEvt;
	if (obj == nullptr)
	{
		std::cout << "Json文件加载失败: " << url << std::endl;
		EventManager::getInstance().dispatch(EventType::LoadError, tempEvt, mName);
	}
	else 
	{
		tempEvt.data = obj;
		tempEvt.path = url;
		std::cout << "Json文件加载成功: " << url << std::endl;
		EventManager::getInstance().dispatch(EventType::LoadCompleted, tempEvt, mName);
	}

}

const std::string Loader::getName()
{
	return mName;
}

Loader::Loader(const std::string & name):mName(name)
{

}
