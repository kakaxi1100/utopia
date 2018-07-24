#include <SFML\Graphics.hpp>
#include "Update.h"
#include "Window.h"
#include "GameBoard.h"
#include "Apple.h"
#include "Snake.h"
#include "Game.h"

int main1(int argv, char** argc)
{
	Window::getInstance()->create("Hello World!", { 520, 520 });
	//sf::RectangleShape rectangle(sf::Vector2f(32.0f, 32.0f));
	//rectangle.setFillColor(sf::Color::Red);
	//rectangle.setPosition(320, 240);

	//std::shared_ptr<sf::Drawable> p(&rectangle);
	//Window::getInstance()->addToDrawList(p);
	/*GameBoard gb;
	gb.render();

	Apple apple;
	apple.regenerate();
	apple.render();

	Snake snake;
	snake.addBodySegment();
	snake.addBodySegment();
	snake.addBodySegment();
	snake.update();
	snake.render();*/

	Game game;
	Update::getInstance()->update();

	/*sf::RenderWindow window({ 640, 480 }, "hello");

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
			{
				window.close();
			}
		}

		window.clear();
		window.display();
	}*/

	return 0;
}