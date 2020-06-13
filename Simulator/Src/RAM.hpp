#ifndef ram_hpp
#define ram_hpp

#include <iostream>
#include <vector>
#include <map>

using namespace std;


class RAM{
  public:
    RAM();
    RAM(vector<vector<uint16_t>> objcode,int memSize);
    void loadData(vector<vector<uint16_t>> objcode, int memSize);
    void setAddrA(uint16_t addr);
    uint16_t readPortA();
    void writePortA(uint16_t value);
    void setAddrB(uint16_t addr);
    uint16_t readPortB();
    void writePortB(uint16_t value);
    void resetRAM();
    const int getSize();

    RAM& operator=(const RAM &other) {
      contents=other.contents;
      addrA=other.addrA;
      addrB=other.addrB;
      size=other.size;
      return *this;
    }

  private:
    map<uint16_t,uint16_t> contents;
    map<uint16_t,uint16_t>::iterator itpa, itpb;
    uint16_t addrA, addrB, dataA, dataB;
    int size;
};

RAM::RAM()  {
  addrA=0;
  addrB=0;
}

RAM::RAM(vector<vector<uint16_t>> objcode, int memSize)  {
  size=memSize;
  for(int i=0;i<objcode.size();i++) {
    contents.insert(pair<uint16_t,uint16_t>(objcode[i][0],objcode[i][1]));
  }
  addrA=0;
  addrB=0;
}

void RAM::loadData(vector<vector<uint16_t>> objcode, int memSize) {
  size=memSize;
  for(int i=0;i<objcode.size();i++) {
    contents.insert(pair<uint16_t,uint16_t>(objcode[i][0],objcode[i][1]));
  }
}

void RAM::setAddrA(uint16_t addr) {
  if(addr>size-1)  {
    cerr<<"Accessing invalid address on Port A"<<endl;
    exit(1);
  }
  addrA=addr;
}

uint16_t RAM::readPortA() {
  itpa=contents.find(addrA);
  if(itpa==contents.end())  {
    return 0;
  }
  else  {
    return itpa->second;
  }
}

void RAM::writePortA(uint16_t value)  {
  itpa=contents.find(addrA);
  if(itpa!=contents.end())  {
    itpa->second=value;
  }
  else  {
    contents.insert(pair<uint16_t,uint16_t>(addrA,value));
  }
}

void RAM::setAddrB(uint16_t addr) {
  if(addr>size-1)  {
    cerr<<"Accessing invalid address on Port A"<<endl;
    exit(1);
  }
  addrB=addr;
}

uint16_t RAM::readPortB() {
  itpb=contents.find(addrB);
  if(itpb==contents.end())  {
    return 0;
  }
  else  {
    return itpb->second;
  }
}

void RAM::writePortB(uint16_t value)  {
  itpb=contents.find(addrB);
  if(itpb!=contents.end())  {
    itpb->second=value;
  }
  else  {
    contents.insert(pair<uint16_t,uint16_t>(addrB,value));
  }
}

void RAM::resetRAM()  {
  addrA=0;
  addrB=0;
}

const int RAM::getSize() {
  return size;
}


#endif
