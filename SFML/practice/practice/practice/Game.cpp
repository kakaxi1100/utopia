#include "Game.h"
#include <iostream>

std::shared_ptr<Game> Game::mInstance = nullptr;

Game::Game()
{
	init();
}

void Game::init()
{
	gameBoard.init();
	apple.init();
	snake.init();
}

void Game::update()
{
	checkEat();
	checkCollision();
	gameBoard.update();
	apple.update();
	snake.update();
}

void Game::checkEat()
{
	if (apple.getRow() == snake.getHead().x && apple.getCol() == snake.getHead().y)
	{
		std::cout<<"Eat"<<std::endl;
		apple.regenerate();
		snake.addBodySegment();
	}
}

void Game::checkCollision()
{
	auto map = gameBoard.getMap();
	int headX = snake.getHead().x;
	int headY = snake.getHead().y;
	if (headX < GameBoard::ROWS && headX >= 0 && headY < GameBoard::COLS && headY >=0)
	{
		if (map[headX][headY] == 1)
		{
			std::cout << "Collision" << std::endl;
		}
	}
}

std::shared_ptr<Game> Game::getInstance()
{
	if (mInstance == nullptr)
	{
		mInstance = std::make_shared<Game>();
	}
	return mInstance;
}
