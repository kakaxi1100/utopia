#include <iostream>

using namespace std;

int main() 
{
	int v = 10;
	auto f = [v]() mutable ->int  {return ++v; };

	system("pause");
}