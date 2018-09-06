#pragma once
#include <string>
#include <memory>

class JsonKey
{
public:
	JsonKey(std::shared_ptr<std::string> key);
	~JsonKey() = default;

	std::shared_ptr<std::string> getValue() const;
	std::string toString();
private:
	std::shared_ptr<std::string> mKey;
};
