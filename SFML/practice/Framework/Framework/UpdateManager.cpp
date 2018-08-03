#include "UpdateManager.h"
#include "WindowManager.h"
#include <iostream>

using namespace std;

unique_ptr<UpdateManager> UpdateManager::mInstance = nullptr;

UpdateManager::UpdateManager(float frameRate)
{
	setFrameRate(frameRate);
	mTime = sf::seconds(mFrameTime);
	updateCore();
}

UpdateManager & UpdateManager::getInstance(float frameRate)
{
	if (mInstance == nullptr)
	{
		mInstance = make_unique<UpdateManager>(frameRate);
	}

	return *mInstance;
}

void UpdateManager::setFrameRate(float frameRate)
{
	mFrameTime = 1.0 / static_cast<float>(frameRate);
}

void UpdateManager::updateCore()
{
	//clear
	WindowManager::getInstance().clear();

	//这个部分肯定也是必须抽出去的
	//否则会一直有新东西添加进来
	//logic update
	//render update
	//display
	WindowManager::getInstance().display();
}

void UpdateManager::update()
{
	try
	{
		while (true)
		{	//every time
			WindowManager::getInstance().handleEvent();
		
			//per tick
			mTime = mClock.getElapsedTime();
			while (mTime.asSeconds() >= mFrameTime)
			{
				updateCore();
				mTime = mTime - sf::seconds(mFrameTime);
				//重置
				if (mTime.asSeconds() <= mFrameTime)
				{
					mTime = mClock.restart();
					mTime = mClock.getElapsedTime();
				}
			} 
		}
	}
	catch (const std::exception&)
	{

	}
}
