#include "Apple.h"
#include <cstdlib>
#include "GameBoard.h"
#include <SFML\Graphics.hpp>
#include <memory>
#include "Window.h"
#include <iostream>

void Apple::regenerate()
{
	std::cout<<rand()<<std::endl;
	mRow = rand() % GameBoard::ROWS;
	mCol = rand() % GameBoard::COLS;
}

void Apple::init()
{
	regenerate();
	render();
}

void Apple::update()
{
	render();
}

void Apple::render()
{
	auto circle = std::make_shared<sf::CircleShape>(5.0f);
	circle->setFillColor(sf::Color::Red);
	circle->setPosition(mCol * GameBoard::GridW + GameBoard::GridW / 2.0f, mRow * GameBoard::GridH + GameBoard::GridH / 2.0f);
	//Window::getInstance()->addToDrawList(circle);
	Window::getInstance()->renderWindow.draw(*circle);
}

int & Apple::getRow()
{
	return mRow;
}

int & Apple::getCol()
{
	return mCol;
}
