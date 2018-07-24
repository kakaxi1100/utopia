#include <iostream>
#include "EventManager.h"
#include "CustomEvent.h"

using namespace std;

template<typename... Args>
void foo(int i, const Args&... rest) {};

void testFun(const EventBase& evt)
{

}

void test2Fun(const EventBase& evt)
{
	auto event = dynamic_cast<const CustomEvent&>(evt);
	cout << "TEST2"<< " " <<event.i<< endl;
}
int main()
{
	//foo(10, "hello", &EventManager::getInstance());
	CustomEvent evt;
	evt.i = 20;

	auto test = EventManager::getInstance();
	test.addEventListener(EventType::TEST1, test2Fun);
	test.hasEvent(EventType::TEST1);
	test.removeEventListener(EventType::TEST1);
	test.hasEvent(EventType::TEST1);
	test.dispatch(EventType::TEST1, evt);

	system("pause");
}