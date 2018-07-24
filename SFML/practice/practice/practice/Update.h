#pragma once
#include <SFML\Graphics.hpp>
#include <memory>
#include <iostream>

class Update
{
public:
	Update();
	~Update() = default;
	static std::shared_ptr<Update> getInstance();
	void update();
private:
	float mFrameRate;
	sf::Clock mClock;
	sf::Time mTime;
	static std::shared_ptr<Update> mInstance;
};
