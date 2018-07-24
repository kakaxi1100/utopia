#include "Snake.h"
#include "Window.h"
#include <SFML\Graphics.hpp>
#include "GameBoard.h"
#include <iostream>
#include "Direction.h"

void Snake::init()
{
	addBodySegment();
	addBodySegment();
	addBodySegment();
	update();
}

void Snake::addBodySegment(unsigned int r , unsigned int c )
{
	if (mBody.size() == 0)
	{
		mBody.push_back(sf::Vector2u(r, c));
	}
	else
	{
		auto temp = mBody.back();

		mBody.push_back(sf::Vector2u(temp.x, temp.y));
	}
}

void Snake::render()
{
	for (auto iter = std::begin(mBody); iter != std::end(mBody); ++iter)
	{
		int row = iter->x;
		int col = iter->y;

		auto rectangle = std::make_shared<sf::RectangleShape>(sf::Vector2f(GameBoard::GridW, GameBoard::GridH));
		if (iter == std::begin(mBody))
		{
			rectangle->setFillColor(sf::Color::Yellow);
		}
		else
		{
			rectangle->setFillColor(sf::Color::Green);
		}
		rectangle->setPosition(col * GameBoard::GridW + GameBoard::GridW / 2.0f, row * GameBoard::GridH + GameBoard::GridH / 2.0f);
		Window::getInstance()->renderWindow.draw(*rectangle);
	}
}

void Snake::update()
{
	move();
	auto front = mBody.front();
	auto back = mBody.back();
	mBody.pop_back();
	switch (direction)
	{
	case Direction::UP:
		back.x = front.x - 1;
		back.y = front.y;
		break;
	case Direction::DOWN:
		back.x = front.x + 1;
		back.y = front.y;
		break;
	case Direction::LEFT:
		back.y = front.y - 1;
		back.x = front.x;
		break;
	case Direction::RIGHT:
		back.y = front.y + 1;
		back.x = front.x;
		break;
	default:
		break;
	}
	mBody.push_front(back);
	render();
}

void Snake::move()
{
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Up))
	{
		std::cout << "UP" << std::endl;
		direction = Direction::UP;
	}
	else if (sf::Keyboard::isKeyPressed(sf::Keyboard::Down)) 
	{
		std::cout << "DOWN" << std::endl;
		direction = Direction::DOWN;
	}
	else if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
	{
		std::cout << "LEFT" << std::endl;
		direction = Direction::LEFT;
	}
	else if (sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
	{
		std::cout << "RIGHT" << std::endl;
		direction = Direction::RIGHT;
	}
}

sf::Vector2u & Snake::getHead()
{
	return mBody.at(0);
}
