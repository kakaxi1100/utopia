#include <SFML/Graphics.hpp>
#include <iostream>

using namespace sf;
void main2(int argc, char** argv[]) 
{
	Clock clock;
	RenderWindow window(VideoMode(640, 480), "First window!");
	Texture mushroomTexture;
	mushroomTexture.loadFromFile("surge.png");
	Sprite mushroom(mushroomTexture);
	Vector2u size = mushroomTexture.getSize();
	mushroom.setOrigin(size.x / 2, size.y / 2);
	Vector2f increment(0.4f, 0.4f);

	clock.restart();
	Time time = clock.getElapsedTime();
	time = clock.getElapsedTime();
	std::cout << time.asMicroseconds() << std::endl;
	//std::cout << time.asMicroseconds() << std::endl;

	while (window.isOpen()) 
	{
		Event event;
		while (window.pollEvent(event)) 
		{
			if (event.type == Event::Closed) 
			{
				// Close window button clicked.
				window.close();
			}
		}

		if ((mushroom.getPosition().x + (size.x / 2) >
			window.getSize().x && increment.x > 0) ||
			(mushroom.getPosition().x - (size.x / 2) < 0 &&
				increment.x < 0))
		{
			// Reverse the direction on X axis.
			increment.x = -increment.x;
		}

		if ((mushroom.getPosition().y + (size.y / 2) >
			window.getSize().y && increment.y > 0) ||
			(mushroom.getPosition().y - (size.y / 2) < 0 &&
				increment.y < 0))
		{
			// Reverse the direction on Y axis.
			increment.y = -increment.y;
		}

		mushroom.setPosition(mushroom.getPosition() + increment);


		window.clear(Color::Black);
		window.draw(mushroom); // Drawing our sprite.
		// Draw here.
		window.display();
	}

	//»á±»×èÈû
	RenderWindow window2(VideoMode(640, 480), "tow window!");
	while (window2.isOpen())
	{
		Event event;
		while (window2.pollEvent(event))
		{
			if (event.type == Event::Closed)
			{
				// Close window button clicked.
				window2.close();
			}
		}
		window2.clear(Color::Black);
		window2.display();
	}
}