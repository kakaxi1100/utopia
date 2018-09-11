#pragma once
#include <memory>
#include "Loader.h"
#include <string>
#include "EventManager.h"

class LoaderManager
{
public:
	LoaderManager() = default;
	~LoaderManager() = default;
	static LoaderManager& getInstance();

	LoaderManager& create(const std::string& name = "");
	LoaderManager& addEventListener(std::function<void(const EventBase&)> completed, std::function<void(const EventBase&)> error);
	void loadTexture(const std::string& url);
	void loadProperty(const std::string& url);

	Loader& getCurLoader();
private:
	static std::unique_ptr<LoaderManager> mInstance;
	static int mLoaderCount;
	std::shared_ptr<Loader> mCurLoader;
};
