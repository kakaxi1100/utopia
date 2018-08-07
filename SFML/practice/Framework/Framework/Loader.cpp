#include <iostream>	
#include <SFML\Graphics.hpp>
#include "Loader.h"
#include "EventManager.h"


void Loader::load(const std::string & url)
{
	mURL = url;

	sf::Texture	 temTexture;
	EventBase tempEvt;
	if (!temTexture.loadFromFile(url))
	{
		std::cout<<"δ�ҵ���Ӧ�ļ�: "<<url<<std::endl;
		//error
		EventManager::getInstance().dispatch(EventType::LoadError, tempEvt, mName);
	}
	else
	{
		//completed
		std::cout << "�ɹ������ļ�: " << url << std::endl;
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
