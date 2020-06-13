#include "simulatorFunctions.hpp"

using namespace std;

int main(int argc, char** argv)  {
  if(argc<2)  {
    cerr<<"No instruction file given"<<endl;
    exit(1);
  }
  string instrFile=argv[1];
  if(instrFile=="-h"||instrFile=="--help")  {
    printHelp();
    return 0;
  }
  pair<vector<vector<uint16_t>>,int> instr,data;
  vector<vector<uint16_t>> empty;
  string arg;
  long cycles;
  long cycleLimit=-1;
  int st=0;
  empty.clear();
  data=make_pair(empty,65536);

  ifstream infile=openFile(instrFile);
  instr=parseSMF(infile);

  if(argc>2)  {
    for(int i=2;i<argc;i++) {
      arg=argv[i];
      if(arg=="-d") {
        string dataFile=argv[i+1];
        ifstream datfile=openFile(dataFile);
        data=parseSMF(datfile);
        i++;
      }
      else if(arg=="-l")  {
        try {
          string crabs=argv[i+1];
          long tmp=stol(crabs);
          if(tmp>0) {
            cycleLimit=tmp;
          }
        }
        catch(...)  {}
        i++;
      }
      else if(arg=="-st")  {
        st=1;
      }
      else if(arg=="-h"||arg=="--help")  {
        printHelp();
        return 0;
      }
    }
  }

  cout<<"Starting simulation ";
  char s;
  CPU cpu(instr,data);
  if(st)  {
    cout<<"(Step Through Mode)"<<endl<<endl;
    cout<<"Press Enter to run next instruction, press 'q' to quit"<<endl<<endl;
    cycles=stepThrough(cpu,cycleLimit);
  }
  else  {
    cout<<"(Full Run Mode)"<<endl<<endl;
    cycles=simulateAll(cpu,cycleLimit);
  }

  cout<<endl<<"done!   CPU Cycles Taken: "<<cycles<<endl;

  return 0;
}
