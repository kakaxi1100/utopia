#pragma once
#include "GameBoard.h"
#include "Apple.h"
#include "Snake.h"
#include <memory>
class Game
{
public:
	Game();
	~Game() = default;

	void init();
	void update();
	void checkEat();
	void checkCollision();
	static std::shared_ptr<Game> getInstance();
private:
	GameBoard gameBoard;
	Apple apple;
	Snake snake;

	static std::shared_ptr<Game> mInstance;
};