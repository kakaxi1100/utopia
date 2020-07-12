#include <iostream>
#include <string>
#include <memory>

using namespace std;

class Simple
{
public:
	Simple();
	int getValue() const;
private:
	int* mIntPtr;
	int constTest = 0;
};

Simple::Simple() {

}

int Simple::getValue() const
{
	
	return constTest;
}

int main() 
{
	return 0;
}