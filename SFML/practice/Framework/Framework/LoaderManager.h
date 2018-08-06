#pragma once
#include <memory>

class LoaderManager
{
public:
	LoaderManager() = default;
	~LoaderManager() = default;
	static LoaderManager& getInstance();
private:
	static std::unique_ptr<LoaderManager> mInstance;
};
