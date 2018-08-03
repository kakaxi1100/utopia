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

	//������ֿ϶�Ҳ�Ǳ�����ȥ��
	//�����һֱ���¶�����ӽ���
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
				//����
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
