//#include <iostream>
//#include <memory>
//#include <functional>
//#include <vector>
//
//using namespace std;
//
//class Test
//{
//public:
//	Test();
//	~Test();
//
//	shared_ptr<Test> other;
//private:
//
//};
//
//Test::Test()
//{
//}
//
//Test::~Test()
//{
//}
//
//void testfun(int a)
//{
//	cout << "Test fun" << endl;
//}
//
//int main() 
//{
//	shared_ptr<Test> te = nullptr;
//
//	{
//		shared_ptr<Test> t = make_shared<Test>();
//		te = t;
//	}
//
//	function<void(int)> foo = testfun;
//	
//	if (foo == nullptr)
//	{
//		cout<<"1"<<endl;
//	}
//	else
//	{
//
//	}
//
//	vector<shared_ptr<Test>> vec;
//	vec.push_back(te);
//	vec.push_back(te);
//	vec.push_back(te);
//
//	system("pause");
//	return 0;
//}