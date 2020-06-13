#ifndef simulator_functions_hpp
#define simulator_functions_hpp

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <utility>
#include "cpu.hpp"

using namespace std;

long stepThrough(CPU &cpu, long climit=-1);
long simulateAll(CPU &cpu, long climit=-1);


pair<vector<vector<uint16_t>>, int> parseSMF(ifstream &infile) {
  vector<vector<uint16_t>> outData;
  vector<uint16_t> linedata;
  string line;
  int size=65536;
  while(getline(infile,line)) {
    if(line.find("DEPTH=")!=string::npos) {
      size=stoi(line.substr(line.find("=")+1));
    }
    else  {
      linedata.clear();
      linedata.push_back(stoi(line.substr(0,line.find("")-1)));
      linedata.push_back(stoi(line.substr(line.find(" ")+1)));
      outData.push_back(linedata);
    }
  }
  return make_pair(outData,size);
}

void printCPUState(CPU &cpu)  {
  vector<uint16_t> registers;
  uint16_t pc, ia, ib, da, db;

  pc=cpu.getPC();
  for(int i=0;i<8;i++)  {
    registers.push_back(cpu.getRegister(i));
  }
  ia=cpu.getIA();
  ib=cpu.getIB();
  da=cpu.getDA();
  db=cpu.getDB();

  cout<<"PC= "<<pc<<"  "<<"Addr= "<<cpu.getCurrentAddr()<<"  ";
  cout<<"OP= "<<cpu.getOP()<<"  "<<"Type= "<<cpu.getType()<<"  ";
  for(int i=0;i<8;i++)  {
    cout<<"R"<<i<<"= "<<registers[i]<<"  ";
  }
  cout<<"IA= "<<ia<<"  "<<"IB= "<<ib<<"  ";
  cout<<"DA= "<<da<<"  "<<"DB= "<<db<<"  ";
  cout<<"FP= "<<cpu.getFramePointer();
  cout<<endl;

}

long stepThrough(CPU &cpu, long climit)  {
  long cycleCount=-1;
  int flag=1;
  char s;
  while(!cpu.getStatus()&&flag) {
    cycleCount++;
    if(climit>0&&cycleCount>climit) {
      cout<<endl<<"CPU Cycle Limit of "<<climit<<" cycles reached! Terminating Simulation!"<<endl;
      exit(1);
    }
    cout<<endl<<"Cycle "<<cycleCount<<":  ";
    cpu.executeSingle();
    printCPUState(cpu);
    while(1)  {
      s=cin.get();
      if(s=='\n') {
        break;
      }
      else if(s=='q') {
        flag=0;
        cout<<endl<<"quitting...Terminating simulation early"<<endl;
        break;
      }
      else  {
        cin.ignore();
      }
    }
  }
  return cycleCount;
}

long simulateAll(CPU &cpu, long climit)  {
  long cycleCount=-1;
  while(!cpu.getStatus()) {
    cycleCount++;
    if(climit>0&&cycleCount>climit) {
      cout<<endl<<"CPU Cycle Limit of "<<climit<<" cycles reached! Terminating Simulation!"<<endl;
      exit(1);
    }
    cout<<endl<<"Cycle "<<cycleCount<<":  ";
    cpu.executeSingle();
    printCPUState(cpu);
  }
  return cycleCount;
}

ifstream openFile(string filename)  {
  ifstream file;
  try{
    file.open(filename);
    if(file.fail()) {
      throw runtime_error("unable to open file");
    }
  }
  catch(...)  {
    cerr<<"Unable to open "<<filename<<endl;
    exit(1);
  }
  return file;
}

void printHelp()  {
  cout<<endl;
  cout<<"simulate INSTRUCTION FILE [OPTIONS]"<<endl<<endl;
  cout<<"INSTRUCTION FILE - instruction memory initialization file"<<endl<<endl;
  cout<<"-d   data memory initialization file"<<endl;
  cout<<"-l   max cycle limit"<<endl;
  cout<<"-st   run simulation in step through mode"<<endl;
  cout<<"-h   show help"<<endl<<endl;
  cout<<"Memory initialization files need to be .smf (simulation memory file)"<<endl;
  cout<<"Use Assembler to generate .smf files from assembly code"<<endl<<endl;
}


#endif
