#pragma once

class Apple
{
public:
	Apple() = default;
	~Apple() = default;

	void regenerate();
	void init();
	void update();
	void render();
	int& getRow();
	int& getCol();
private:
	int mRow = 0;
	int mCol = 0;
};

