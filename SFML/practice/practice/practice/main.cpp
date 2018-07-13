#include <SFML\Graphics.hpp>

int main(int argv, char** argc)
{
	sf::RenderWindow window({ 640, 480 }, "hello");

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
			{
				window.close();
			}
		}

		window.clear();
		window.display();
	}

	return 0;
}