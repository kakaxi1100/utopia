#include "WindowManager.h"
#include <iostream>

using namespace std;

std::unique_ptr<WindowManager> WindowManager::mInstance = nullptr;

WindowManager::WindowManager()
{
	create();
}

WindowManager::~WindowManager()
{
	mRenderWindow.close();
}

WindowManager & WindowManager::getInstance()
{
	if (mInstance == nullptr)
	{
		mInstance = make_unique<WindowManager>();
	}

	return *mInstance;
}

void WindowManager::create()
{
	mRenderWindow.create(sf::VideoMode(640, 480, 32), "");
}

void WindowManager::handleEvent()
{
	if (mRenderWindow.isOpen())
	{
		sf::Event event;
		while (mRenderWindow.pollEvent(event))
		{
			//�������Ʋ��Ǻܺ�,��Ϊ������µ��¼����
			//����Ҫ������д����,��Ҫ�����������ȡ��ȥ
			switch (event.type)
			{
			case sf::Event::Closed:
				mRenderWindow.close();
				break;
			case sf::Event::KeyPressed:
				if (event.key.code == sf::Keyboard::W)
				{
					cout << "Key Down:: " << "W" << endl;
				}
				break;
			case sf::Event::MouseButtonPressed:
				if (event.mouseButton.button == sf::Mouse::Left)
				{
					cout << "Mouse Down:: " << "Left" << endl;
				}
				break;
			default:
				break;
			} 
		}
	}
}

void WindowManager::draw(sf::Drawable & drawable)
{
	mRenderWindow.draw(drawable);
}

void WindowManager::clear(sf::Color color)
{
	mRenderWindow.clear(color);
}

void WindowManager::display()
{
	mRenderWindow.display();
}
