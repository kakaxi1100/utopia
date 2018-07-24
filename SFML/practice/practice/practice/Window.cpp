#include "Window.h"

std::shared_ptr<Window> Window::mWindow = nullptr;

void Window::update(float dt)
{
	//if (getInstance()->mRenderWindow.isOpen())
	//{
	//	mWindow->mRenderWindow.clear(sf::Color::Black);
	//	//Draw here
	//	for (auto drawable : mDrawList)
	//	{
	//		mWindow->mRenderWindow.draw(*drawable);
	//	}
	//	mWindow->mRenderWindow.display();
	//}
}

void Window::handleEvent()
{
	sf::Event event;
	while (getInstance()->renderWindow.pollEvent(event))
	{
		if (event.type == sf::Event::Closed)
		{
			getInstance()->renderWindow.close();
		}
	}
}

void Window::create(const std::string & title, const sf::Vector2u & size)
{
	Window::getInstance()->renderWindow.create({ size.x, size.y, 32 }, title);
}

std::shared_ptr<Window> Window::getInstance()
{
	if (mWindow == nullptr)
	{
		mWindow = std::make_shared<Window>();
	}
	return mWindow;
}

//void Window::addToDrawList(std::shared_ptr<sf::Drawable> drawObj)
//{
//	mDrawList.push_back(drawObj);
//}
