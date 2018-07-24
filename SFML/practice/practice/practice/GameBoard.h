#pragma once
#include <array>

class GameBoard
{
public:
	GameBoard();
	~GameBoard() = default;
	
	static const int ROWS = 50;
	static const int COLS = 50;
	static const int GridH = 10;
	static const int GridW = 10;
	void init();
	void render();
	void update();
	std::array<std::array<int, COLS>, ROWS> getMap();
private:
	std::array<std::array<int, COLS>, ROWS>mMap;
};
