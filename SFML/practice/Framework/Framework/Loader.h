#pragma once
#include <string>

class Loader
{
public:
	Loader(const std::string& name = "");
	~Loader() = default;

	void load(const std::string& url);
	void completed();
private:
	std::string mURL;
	std::string mName;
};
