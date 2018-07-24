#include "GameBoard.h"
#include "Window.h"
#include <SFML\Graphics.hpp>

GameBoard::GameBoard()
{
	for (size_t i = 0; i < GameBoard::ROWS; i++)
	{
		for (size_t j = 0; j < GameBoard::COLS; j++)
		{
			if (i == 0 || i == ROWS - 1 || j == 0 || j == COLS - 1)
			{
				mMap[i][j] = 1;
			}
			else
			{
				mMap[i][j] = 0;
			}
		}
	}
}

void GameBoard::init()
{
	render();
}

void GameBoard::render()
{
	for (size_t i = 0; i < GameBoard::ROWS; i++)
	{
		for (size_t j = 0; j < GameBoard::COLS; j++)
		{
			auto rectangle = std::make_shared<sf::RectangleShape>(sf::Vector2f(GridW, GridH));
			if (mMap[i][j] == 1)
			{
				rectangle->setFillColor(sf::Color::Magenta);
			}
			else
			{
				rectangle->setFillColor(sf::Color::Black);
			}

			rectangle->setPosition(i * GridH + GridH / 2.0f, j * GridW + GridW / 2.0f);
			//std::shared_ptr<sf::Drawable> p(&rectangle);
			//Window::getInstance()->addToDrawList(rectangle);
			Window::getInstance()->renderWindow.draw(*rectangle);
		}
	}
}

void GameBoard::update()
{
	render();
}

std::array<std::array<int, GameBoard::COLS>, GameBoard::ROWS> GameBoard::getMap()
{
	return mMap;
}
