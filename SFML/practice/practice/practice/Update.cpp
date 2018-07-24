#include "Update.h"
#include "Window.h"
#include "Game.h"

std::shared_ptr<Update> Update::mInstance = nullptr;

Update::Update()
{
	mTime = mClock.getElapsedTime();
	mFrameRate = 1.0f / 10.0f;
}

std::shared_ptr<Update> Update::getInstance()
{
	if (mInstance == nullptr)
	{
		mInstance = std::make_shared<Update>();
	}
	return mInstance;
}

void Update::update()
{
	try
	{
		while (true)
		{
			//Per frame
			mTime = mClock.getElapsedTime();
			if (mTime.asSeconds() >= mFrameRate)
			{
				Window::getInstance()->renderWindow.clear(sf::Color::Black);
				Game::getInstance()->update();
				Window::getInstance()->update(mFrameRate);
				mTime = mClock.restart();
				Window::getInstance()->renderWindow.display();
			}

			//Per every time
			Window::getInstance()->handleEvent();
		}
	}
	catch (const std::exception&)
	{

	}
}
