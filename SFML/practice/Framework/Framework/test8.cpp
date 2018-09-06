//#include <iostream>
//#include <memory>
//
//using namespace std;
//class Test
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
//
//int main()
//{
//	shared_ptr<ToTest> tt;
//	{
//		shared_ptr<Test> t = make_shared<Test>();
//		tt = make_shared<ToTest>(*t);
//		cout << "nested" << tt->test.value << endl;
//	}
//
//	cout << "outer" << tt->test.value << endl;
//
//	return 0;
//}