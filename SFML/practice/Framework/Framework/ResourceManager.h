#pragma once
#include <memory>
#include <string>
#include "EventDispatcher.h"
#include "EventBase.h"

class ResourceManager : public EventDispatcher
{
public:
	ResourceManager() = default;
	~ResourceManager() = default;
	static ResourceManager& getInstance();

	void loaderProperties(const std::string& url);
	void loaderTextures(const std::string& url);


	void loadTextureError(const EventBase& e);
	void loadTextureCompleted(const EventBase& e);

	void loadPropertyError(const EventBase& e);
	void loadPropertyCompleted(const EventBase& e);
private:
	static std::unique_ptr<ResourceManager> mInstance;
};