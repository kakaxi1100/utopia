#pragma once
#include <memory>
#include <SFML\Graphics.hpp>

class WindowManager
{
public:
	WindowManager();
	//WindowManager(const WindowManager&) = default;
	~WindowManager();
	static WindowManager& getInstance();
	void create();
	void handleEvent();
	void draw(sf::Drawable& l_drawable);
	void clear(sf::Color color = sf::Color(0,0,0));//这个默认参数没用, 因为clear在update里面执行了
	void display();
private:
	static std::unique_ptr<WindowManager> mInstance;
	sf::RenderWindow mRenderWindow;
};
