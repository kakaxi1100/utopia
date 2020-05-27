#include <SFML\Graphics.hpp>
#include <ctime>
#include <iostream>

using namespace sf;
using std::cout;
using std::endl;

int main1() 
{
	cout << __func__ << endl;

	RenderWindow window(VideoMode(320, 480), "Tetris!");

	Texture t1, t2, t3;
	t1.loadFromFile("tetris/images/tiles.png");
	t2.loadFromFile("tetris/images/background.png");
	t3.loadFromFile("tetris/images/frame.png");

	Sprite tiles(t1), background(t2), frame(t3);

	Clock clock;

	while (window.isOpen())
	{
		float time = clock.getElapsedTime().asSeconds();

		Event event;
		while(window.pollEvent(event))
		{
			switch (event.type)
			{
			case Event::Closed:
				window.close();
				break;
			default:
				break;
			}
		}

		window.clear();

		window.draw(background);
		window.draw(frame);

		window.display();
	}

	return 0;
}