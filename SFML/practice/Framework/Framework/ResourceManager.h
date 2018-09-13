#pragma once
#include <memory>
#include <string>
#include "EventDispatcher.h"
#include "EventBase.h"
#include <unordered_map>
#include "JsonObject.h"
#include "SFML\Graphics.hpp"

class ResourceManager
{
public:
	ResourceManager() = default;
	~ResourceManager() = default;
	static ResourceManager& getInstance();

	void loaderProperties(const std::string& url);
	void loaderTextures(const std::string& url);


	void loadTextureCompleted(const EventBase& e);
	void loadTextureError(const EventBase& e);

	void loadPropertyCompleted(const EventBase& e);
	void loadPropertyError(const EventBase& e);

	std::unordered_map<std::string, std::shared_ptr<JsonObject>> getPropeties();
	std::unordered_map<std::string, std::shared_ptr<sf::Texture>> getTextures();
private:
	static std::unique_ptr<ResourceManager> mInstance;
	std::unordered_map<std::string, std::shared_ptr<sf::Texture>> mTextures;
	std::unordered_map<std::string, std::shared_ptr<JsonObject>> mProperties;
};