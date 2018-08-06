#include <iostream>	
#include <SFML\Graphics.hpp>
#include "Loader.h"
#include "EventManager.h"


void Loader::load(const std::string & url, error, completed)
{
	mURL = url;

	sf::Texture	 temTexture;
	if (!temTexture.loadFromFile(url))
	{
		std::cout<<"未找到对应文件 :"<<url<<std::endl;
		//error
		EventManager::getInstance().dispatch(EventType::LoadCompleted);
	}
	//completed
}

Loader::Loader(const std::string & name):mName(name)
{
}
