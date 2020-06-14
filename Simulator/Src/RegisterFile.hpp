#ifndef register_file_hpp
#define register_file_hpp

#include <iostream>
#include <vector>

using namespace std;

class RegisterFile{
  public:
    RegisterFile();
    uint16_t readRegister(int reg);
    void writeRegister(int reg, uint16_t data);
    void incFramePointer(int a);
    void decFramePointer(int a);
    const int readFramePointer();

  private:
    vector<uint16_t> regStack;
    int fpointer;
};


RegisterFile::RegisterFile()  {
  regStack.resize(128);
  for(int i=0;i<regStack.size();i++) {
    regStack[i]=0;
  }
  fpointer=0;
}

uint16_t RegisterFile::readRegister(int reg)  {
  if(reg>7) {
    cerr<<"reading invalid register"<<endl;
    exit(1);
  }
  return regStack[fpointer+reg];
}

void RegisterFile::writeRegister(int reg, uint16_t data)  {
  regStack[fpointer+reg]=data;
  return;
}

void RegisterFile::incFramePointer(int a) {
  fpointer=fpointer+a;
  if(fpointer>120)  {
    cerr<<"frame pointer moved out of range to "<<fpointer<<endl;
    exit(1);
  }
  return;
}

void RegisterFile::decFramePointer(int a) {
  fpointer=fpointer-a;
  if(fpointer<0)  {
    fpointer=0;
  }
  return;
}

const int RegisterFile::readFramePointer()  {
  return fpointer;
}

#endif
