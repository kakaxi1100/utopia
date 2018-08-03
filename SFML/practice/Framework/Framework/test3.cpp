//#include <iostream>
//#include "EventBase.h"
//#include "EventDispatcher.h"
//#include "EventManager.h"
//
//using namespace std;
//class Test1 :public EventDispatcher
//{
//public:
//	Test1() {
//		EventManager::getInstance().addEventListener(EventType::TEST1, bind(&EventDispatcher::testFun, this, placeholders::_1), "Test1");
//	};
//
//	void testFun(const EventBase& evt) override {
//		std::cout << "Test1 testFun" << std::endl;
//	};
//};
//
//class Test2 :public EventDispatcher
//{
//public:
//	Test2() {
//		EventManager::getInstance().addEventListener(EventType::TEST1, bind(&EventDispatcher::testFun, this, placeholders::_1), "Test2");
//	};
//
//	void testFun(const EventBase& evt) override {
//		std::cout << "Test2 testFun" << std::endl;
//	};
//};
//
//class Test3 :public EventDispatcher
//{
//public:
//	Test3() {
//		EventManager::getInstance().addEventListener(EventType::TEST1, bind(&EventDispatcher::testFun, this, placeholders::_1), "Test2");
//	};
//
//	void testFun(const EventBase& evt) override {
//		std::cout << "Test3 testFun" << std::endl;
//	};
//};
//
//
//class Test4 :public EventDispatcher
//{
//public:
//	Test4() {
//		
//	};
//
//	void notify()
//	{
//		EventBase e;
//		EventManager::getInstance().dispatch(EventType::TEST1, e);
//	}
//};
//
//
//int main()
//{
//	EventBase evt;
//
//	Test1 t1;
//	Test2 t2;
//	Test3 t3;
//	Test4 t4;
//
//	t4.notify();
//	//EventManager::getInstance().dispatch(EventType::TEST1, evt);
//
//	EventManager::getInstance().removeEventListener(EventType::TEST1, "Test2");
//
//	//EventManager::getInstance().dispatch(EventType::TEST1, evt);
//
//	t4.notify();
//
//	system("pause");
//	return 0;
//}