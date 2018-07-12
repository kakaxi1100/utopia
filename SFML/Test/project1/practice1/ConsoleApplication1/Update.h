#pragma once
#include "Window.h"
class Update
{
public:
	Update() = default;
	~Update() = default;

	void update();
private:
	sf::Clock mClock;
};
