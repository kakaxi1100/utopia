//#include <iostream>
//#include "EventManager.h"
//#include "EventBase.h"
//#include <string>
//
//using namespace std;
//
//template<typename... Args>
//void foo(int i, const Args&... rest) {};
//
//class CustomEvent : public EventBase
//{
//public:
//	int i = 10;
//public:
//	CustomEvent() = default;
//	virtual ~CustomEvent() = default;
//private:
//
//};
//
//class CustomEvent2 : public EventBase
//{
//public:
//	string name = "hello";
//public:
//	CustomEvent2() = default;
//	virtual ~CustomEvent2() = default;
//
//private:
//
//};
//
//class TestClass : public EventDispatcher
//{
//public:
//	TestClass() = default;
//	~TestClass() = default;
//
//	virtual void classFun(const EventBase& evt) override{
//		auto event = dynamic_cast<const CustomEvent&>(evt);
//		cout<< event.i << " Test CLASSFUN" << endl;
//	}
//private:
//
//};
//
//void testFun(const EventBase& evt)
//{
//
//}
//
//void test2Fun(const EventBase& evt)
//{
//	auto event = dynamic_cast<const CustomEvent&>(evt);
//	cout << "TEST2"<< " " <<event.i<< endl;
//}
//
//void test3Fun(const EventBase& evt)
//{
//	auto event = dynamic_cast<const CustomEvent2&>(evt);
//	cout << "TEST3 "<< event.name << endl;
//}
//
//
//int main1()
//{
//	//foo(10, "hello", &EventManager::getInstance());
//	CustomEvent evt;
//	evt.i = 20;
//
//	CustomEvent2 evt2;
//
//	TestClass t;
//
//	EventDispatcher& t2 = t;
//
//	auto t3 = dynamic_cast<const TestClass&>(t2);
//
//	auto test = EventManager::getInstance();
//	/*test.addEventListener(EventType::TEST1, test3Fun);
//	test.dispatch(EventType::TEST1, evt2);*/
//	void(EventDispatcher::*fff)(const EventBase&) = &EventDispatcher::classFun;
//	std::function<void(const EventBase&)> foo = bind(fff, t3, placeholders::_1);
//	foo(evt);
//
//	//test.addEventListener(EventType::TEST2, &t, &EventDispatcher::classFun);
//	test.addEventListener(EventType::TEST2, foo);
//	test.dispatch(EventType::TEST2, evt);
//
//	test.removeEventListener(EventType::TEST2, "");
//
//	system("pause");
//	return 0;
//}