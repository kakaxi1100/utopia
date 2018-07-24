#pragma once
#include <SFML\Graphics.hpp>
#include <memory>
#include <string>
#include <vector>

class Window
{
public:
	Window() = default;
	~Window() = default;
	void update(float dt);
	void handleEvent();
	void create(const std::string & title, const sf::Vector2u & size);
	static std::shared_ptr<Window> getInstance();
	//void addToDrawList(std::shared_ptr<sf::Drawable> drawObj);
	sf::RenderWindow renderWindow;
private:
	static std::shared_ptr<Window> mWindow;
	//std::vector<std::shared_ptr<sf::Drawable>> mDrawList;
};