#pragma once
#include <vector>
#include <SFML\Graphics.hpp>

class Window
{
public:
	Window() = delete;
	Window(const sf::Vector2u& size, const std::string& title, const sf::Uint32& style);
	~Window();

	sf::RenderWindow& getInstance();
	void update();
private:
	std::string mTitle;
	sf::Vector2i mSize;
	sf::Uint32 mStyle;
	sf::RenderWindow mWindow;
	std::vector<sf::Drawable&> mDrawList;
};