#pragma once
#include <memory>
#include <SFML\System.hpp>
class UpdateManager
{
public:
	UpdateManager(float frameRate);
	~UpdateManager() = default;
	static UpdateManager& getInstance(float frameRate = 60.0);
	void setFrameRate(float frameRate);
	void updateCore();
	void update();
private:
	static std::unique_ptr<UpdateManager> mInstance;
	float mFrameTime;
	float mElapsed;
	sf::Time mTime;
	sf::Clock mClock;
};
