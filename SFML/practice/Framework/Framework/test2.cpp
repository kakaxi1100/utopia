#include <iostream>
#include <unordered_map>
#include <string>
#include <functional>
#include <memory>

using namespace std;

class EventBase
{
public:
	EventBase() = default;
	virtual ~EventBase() = default;
};

class EventChild :public EventBase
{
public:
	EventChild() = default;
	~EventChild() = default;

	string name = "hehehhe";
};

class Base
{
public:
	Base() = default;
	virtual ~Base() = default;
	virtual void test(int a) {
		cout << a << endl;
	};

	virtual void test2(EventBase& e) {
		cout << "BASE TEST2"<< endl;
	}
};


class C1 : public Base
{
public:
	C1() = default;
	~C1() = default;

	void test(int a) override
	{
		cout << "TEST" << endl;
	}

	virtual void test2(EventBase& e) override {
		auto t = dynamic_cast<EventChild*>(&e);
		cout<<t->name << "C1 TEST2" << endl;
	}
};

int main2()
{

	unordered_map < string, void(Base::*)()> tt;
	//unordered_map < string, string> tt;
	Base*a = new Base();
	Base* b = new C1();
	Base c;
	//b->test();
	//dynamic_cast<C1*>(b)->C1::test();

	//tt.insert({"hehe", &Base::test});
	//function<void(int)> fun = bind(&Base::test, b, placeholders::_1);
	//fun(1);

	unordered_map<string, function<void(EventBase&)>> test;
	EventBase e;
	EventChild ec;
	shared_ptr<Base> d = make_shared<C1>();
	C1 eb;

	void(Base::*fff)(EventBase&) = &Base::test2;

	function<void(EventBase&)> testfun = bind(&Base::test2, eb, placeholders::_1);
	test.insert({ "test1", testfun });
	test["test1"](ec);

	system("pause");
	return 0;
}