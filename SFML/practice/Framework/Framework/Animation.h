#pragma once
#include <vector>
#include <memory>
#include "AnimationFrame.h"

class Animation
{
public:
	Animation() = default;
	Animation(unsigned int frameRate);
	Animation(unsigned int frameRate, int loop);
	~Animation() = default;

	void addFrame(std::shared_ptr<AnimationFrame> frame);
	void setLoop(int loop);

	void play();
	void stop();
	void pause();
	void gotoAndPlay(unsigned int frameIndex);
	void gotoAndPlay(std::string frameName);
	void gotoAndStop(unsigned int frameIndex);
	void gotoAndStop(std::string frameName);
	void gotoAndPause(unsigned int frameIndex);
	void gotoAndPause(std::string frameName);

	void update(float dt);
private:
	void render();
private:
	unsigned int mIndex = 0;
	int mLoop = 0;
	bool mIsPlaying = true;
	unsigned int mFrameRate;
	float mWave;
	float mDuration = 0;
	std::vector<std::shared_ptr<AnimationFrame>> mFrames;
};