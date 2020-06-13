
#include <iostream>

using namespace std;

int fib(const int n);

int main() {

	int n;
	cin >> n;
	int z = fib(n);
	cout << endl << z << endl;

}

int fib(const int n) {

	int y;
	if ( n <= 1) {

		y=1;
	} else {
		y=fib(n-1);
		y=y + fib(n-2);
	}

	return y;


}
