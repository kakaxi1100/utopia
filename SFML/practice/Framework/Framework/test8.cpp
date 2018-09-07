//#include <iostream>
//#include <memory>
//
//using namespace std;
//class Test : public std::enable_shared_from_this<Test>
//{
//public:
//	Test::Test()
//	{
//	}
//
//	Test::~Test()
//	{
//		cout << "Test dead!" << endl;
//	}
//
//	shared_ptr<Test> getValue()
//	{
//		return shared_from_this();
//	}
//
//	int value = 1;
//private:
//
//};
//
//class ToTest
//{
//public:
//	ToTest::ToTest(Test& t):test(t)
//	{
//	}
//
//	~ToTest()
//	{
//		cout << "ToTest dead!" << endl;
//	}
//
//	Test& test;
//private:
//};
//
//class RefTest
//{
//public:
//
//	RefTest::RefTest()
//	{
//		tt = make_shared<Test>();
//	}
//
//	RefTest::~RefTest()
//	{
//		cout << "RefTest dead!" << endl;
//	}
//
//	shared_ptr<Test> getTest() 
//	{
//		return tt->getValue();
//	}
//private:
//	shared_ptr<Test> tt;
//};
//
//
//int main()
//{
//	RefTest rf;
//	{
//		auto tt = rf.getTest();
// 	}
//
//	/*shared_ptr<ToTest> tt;
//	{
//		shared_ptr<Test> t = make_shared<Test>();
//		tt = make_shared<ToTest>(*t);
//		cout << "nested" << tt->test.value << endl;
//	}
//
//	cout << "outer" << tt->test.value << endl;*/
//
//	system("pause");
//	return 0;
//}