#include "Window.h"

Window::~Window()
{

}

Window::Window(const sf::Vector2u& size, const std::string& title, const sf::Uint32& style):mTitle(title),mSize(size),mStyle(style)
{
	mWindow.create({ mSize.x, mSize.y }, mTitle, mStyle);
}

sf::RenderWindow & Window::getInstance()
{
	if (&mWindow == nullptr)
	{
		mWindow.create({ 640, 480 }, "Empty");
	}
	return mWindow;
}

void Window::update()
{
	if (mWindow.isOpen())
	{
		sf::Event event;
		while (mWindow.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
			{
				mWindow.close();
			}
		}
		mWindow.clear(sf::Color::Black);
		for (auto drawObj : mDrawList)
		{
			mWindow.draw(drawObj);
		}
		mWindow.display();
	}
}