
#include <iostream>
#include <linux/perf_event.h>
#include <linux/hw_breakpoint.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>

using namespace std;


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

int main() {

struct perf_event_attr pea;
  int fd1;
  uint64_t id1;

memset(&pea, 0, sizeof(struct perf_event_attr));
  pea.type = PERF_TYPE_HARDWARE;
  pea.size = sizeof(struct perf_event_attr);
  pea.config = PERF_COUNT_HW_INSTRUCTIONS; // Count no of instructions executed
  pea.disabled = 1;
  pea.exclude_kernel = 1;
  pea.exclude_hv = 1;
  pea.precise_ip = 3;
  pea.read_format = PERF_FORMAT_ID | PERF_FORMAT_TOTAL_TIME_RUNNING;


  fd1 = syscall(__NR_perf_event_open, &pea, 0, -1, -1, 0);
  ioctl(fd1, PERF_EVENT_IOC_ID, &id1); // Get a id for the counter
  cout << "Perf Event ID is " << id1 << endl <<endl;
  // Struct to read the file descriptor
  struct read_format {
    uint64_t value;
   // uint64_t time_enabled;
    uint64_t time_running;
    uint64_t id;
};
  
	int n;
	cout << "Value of n: ";
	cin >> n;
	
	// Begin Counting
ioctl(fd1, PERF_EVENT_IOC_RESET, PERF_IOC_FLAG_GROUP);
ioctl(fd1, PERF_EVENT_IOC_ENABLE, PERF_IOC_FLAG_GROUP);

	int z = fib(n);
	
	// End Counting
ioctl(fd1, PERF_EVENT_IOC_DISABLE, PERF_IOC_FLAG_GROUP);
	
	// Read fd
char buf[4096];
struct read_format* rf = (struct read_format*) buf;
read(fd1, buf, sizeof(buf));

	cout << endl << "Return value: " << z << endl << endl;
	cout << "ID: " << rf->id << endl;
	//cout << "Time running: " << rf->time_running << endl;
	cout << "No of instructions: " << rf->value << endl;
	
}

