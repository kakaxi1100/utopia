#pragma once
#include <deque>
#include <SFML\Graphics.hpp>
#include "Direction.h"
class Snake
{
public:
	Snake() = default;
	~Snake() = default;

	void init();
	void render();
	void addBodySegment(unsigned int r = 5, unsigned int c = 5);
	void update();
	void move();
	sf::Vector2u& getHead();
private:
	Direction direction;
	std::deque<sf::Vector2u> mBody;
};
