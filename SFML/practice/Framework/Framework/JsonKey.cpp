#include "JsonKey.h"

JsonKey::JsonKey(std::shared_ptr<std::string> key):mKey(key)
{
}

std::shared_ptr<std::string> JsonKey::getValue() const
{
	return mKey;
}

std::string JsonKey::toString()
{
	return *mKey;
}
