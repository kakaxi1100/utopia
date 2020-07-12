#include <iostream>
#include <string>
#include <memory>

#define _CRTDBG_MAP_ALLOC
#include <cstdlib>
#include <crtdbg.h>

//#ifdef _DEBUG
//#ifndef DBG_NEW
//#define DBG_NEW new ( _NORMAL_BLOCK , __FILE__ , __LINE__ )
//#define new DBG_NEW
//#endif // !DBG_NEW
//#endif // _DEBUG

#define new new ( _NORMAL_BLOCK , __FILE__ , __LINE__ )

using namespace std;

class Simple
{
public:
	Simple(int c):Simple((double)c * 10) { cout << "int" << endl; }
	Simple(double c) { cout << "dobule" << endl; }
	~Simple() { delete mIntPtr; }
private:
	int* mIntPtr;
};



int main() 
{
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);

	Simple* simplePtr = new Simple(1);
	
	
	system("pause");
	return 0;
}