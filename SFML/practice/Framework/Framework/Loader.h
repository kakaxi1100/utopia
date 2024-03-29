#pragma once
#include <string>

class Loader
{
public:
	Loader(const std::string& name = "");
	~Loader() = default;

	void loadTexture(const std::string& url);
	void loadProperty(const std::string& url);

	const std::string getName();
private:
	std::string mURL;
	std::string mName;
};
