#pragma once
#include "SFML\Graphics.hpp"
#include <memory>
#include "EventBase.h"

class LoaderTextureEvent : public EventBase
{
public:
	LoaderTextureEvent() = default;
	~LoaderTextureEvent() = default;

	std::shared_ptr<sf::Texture> data;
	std::string path;
private:
};