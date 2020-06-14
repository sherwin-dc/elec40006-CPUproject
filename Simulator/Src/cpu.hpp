#ifndef cpu_hpp
#define cpu_hpp

#include <string>
#include "RegisterFile.hpp"
#include "RAM.hpp"

using namespace std;

class CPU {
  public:
    CPU(const pair<vector<vector<uint16_t>>,int> &instr, const pair<vector<vector<uint16_t>>,int> &data);

    void executeSingle();
    const int getStatus();

    uint16_t getRegister(int reg);
    const uint16_t getPC();
    uint16_t getIA();
    uint16_t getIB();
    uint16_t getDA();
    uint16_t getDB();
    const int IRsize();
    const int DRsize();
    const string getOP();
    const string getType();
    const uint16_t getCurrentAddr();
    const int getFramePointer();

  private:
    void decodeInstr(uint16_t in);

    void NOP();
    void CALL();
    void CMP();
    void JMP();
    void MUL();
    void ADD();
    void SUB();
    void MAS();
    void MOV();
    void PLD();
    void PST();
    void SET();
    void LSL();
    void LSR();
    void RTN();
    void STP();

    RegisterFile regfile;
    RAM iRAM;
    RAM dRAM;

    uint16_t pc, addrA, addrB, cAddr, cPC;
    uint16_t rd, rs, rm;
    uint16_t ia;
    uint16_t n;
    uint16_t mulCarry;
    int opcodeh, tir, cond, a, skiplen, p, as, m, an, bn, oa, ob, done;
    string op, type;
};

CPU::CPU(const pair<vector<vector<uint16_t>>,int> &instr, const pair<vector<vector<uint16_t>>,int> &data) {
  iRAM.loadData(instr.first,instr.second);
  dRAM.loadData(data.first,data.second);
  pc=0;
  rd=0;
  rs=0;
  rm=0;
  ia=0;
  n=0;
  addrA=0;
  addrB=1;
  done=0;
  cAddr=0;
  cPC=0;
  op="";
  type="";
  iRAM.setAddrA(addrA);
  iRAM.setAddrB(addrB);
}

void CPU::executeSingle() {
  decodeInstr(ia);
  cAddr=addrA;
  cPC=pc;

  if(opcodeh==0)  {
    if(tir) {
      CALL();
    }
    else  {
      NOP();
    }
  }
  else if(opcodeh==1)  {
    CMP();
  }
  else if(opcodeh==2) {
    JMP();
  }
  else if(opcodeh==3) {
    MUL();
  }
  else if(opcodeh==4) {
    ADD();
  }
  else if(opcodeh==5) {
    SUB();
  }
  else if(opcodeh==6) {
    MAS();
  }
  else if(opcodeh==7) {
    MOV();
  }
  else if(opcodeh==8)  {
    if(tir==0)  {
      PLD();
    }
  }
  else if(opcodeh==9) {
    if(tir==0)  {
      PST();
    }
  }
  else if(opcodeh==11)  {
    SET();
  }
  else if(opcodeh==12)  {
    if(tir==0)  {
      LSL();
    }
  }
  else if(opcodeh==13)  {
    if(tir==0)  {
      LSR();
    }
  }
  else if(opcodeh==14)  {
    if(tir==0)  {
      RTN();
    }
  }
  else if (opcodeh==15) {
    if(tir) {
      STP();
    }
  }

  iRAM.setAddrA(addrA);
  iRAM.setAddrB(addrB);
  ia=iRAM.readPortA();
  n=iRAM.readPortB();

}

void CPU::decodeInstr(uint16_t in)  {
  opcodeh=(in>>12)&15;
  tir=(in>>11)&1;
  rd=(in>>8)&7;
  rs=(in>>5)&7;
  rm=(in>>2)&7;
  cond=rm;
  skiplen=in&3;
  a=(in>>4)&1;
  p=(in>>4)&1;
  as=p;
  m=(in>>4)&1;
  an=(in>>3)&1;
  bn=(in>>2)&1;
  oa=(in>>1)&1;
  ob=in&1;
}

void CPU::NOP() {
  op="NOP";
  type="R";
  addrA=pc;
  addrB=addrA+1;
  pc++;
}

void CPU::CALL()  {
  op="CALL";
  type="I";
  regfile.writeRegister(rd,pc+1);
  addrA=n;
  addrB=n+1;
  pc=n+1;
  regfile.incFramePointer(int(rs));
}

void CPU::CMP() {
  op="CMP";
  uint16_t v1, v2;
  int jmpFlag=0;
  v1=regfile.readRegister(rd);
  if(tir) {
    type="I";
    v2=n;
  }
  else  {
    type="R";
    v2=regfile.readRegister(rs);
  }
  switch(cond)  {
    case 0: {
      if(v1==v2)  {
        jmpFlag=1;
      }
      break;
    }
    case 1: {
      if(v1!=v2)  {
        jmpFlag=1;
      }
      break;
    }
    case 2: {
      if(v1>v2) {
        jmpFlag=1;
      }
      break;
    }
    case 3: {
      if(v1<v2) {
        jmpFlag=1;
      }
      break;
    }
    case 4: {
      if(v1==0) {
        jmpFlag=1;
      }
      break;
    }
    case 5: {
      if((v1>>15)==1) {
        jmpFlag=1;
      }
      break;
    }
    case 6: {
      if(v1==65535) {
        jmpFlag=1;
      }
      break;
    }
  }
  if(jmpFlag) {
    addrA=pc+tir+skiplen+1;
    addrB=addrA+1;
    pc=pc+tir+skiplen+2;
  }
  else  {
    addrA=pc+tir;
    addrB=addrA+1;
    pc=pc+tir+1;
  }
}

void CPU::JMP() {
  op="JMP";
  if(tir) {
    type="I";
    addrA=n;
    addrB=n+1;
    pc=n+1;
  }
  else  {
    type="R";
    addrA=rd;
    addrB=rd+1;
    pc=rd+1;
  }
}

void CPU::MUL() {
  op="MUL";
  if(tir) {
    type="I";
    if(p) {
      mulCarry=(mulCarry*n)&65535;
    }
    else  {
      mulCarry=(regfile.readRegister(rd)*n)&65535;
    }
  }
  else  {
    type="R";
    if(p) {
      mulCarry=(mulCarry*regfile.readRegister(rs))&65535;
    }
    else  {
      mulCarry=(regfile.readRegister(rd)*regfile.readRegister(rs))&65535;
    }
  }
  addrA=pc+tir;
  addrB=addrA+1;
  pc=pc+tir+1;
}

void CPU::ADD() {
  op="ADD";
  uint16_t tmp;
  if(tir) {
    type="I";
    tmp=regfile.readRegister(rs)+n;
    regfile.writeRegister(rd,tmp);
  }
  else  {
    type="R";
    tmp=regfile.readRegister(rs)+regfile.readRegister(rm);
    regfile.writeRegister(rd,tmp);
  }
  addrA=pc+tir;
  addrB=addrA+1;
  pc=pc+tir+1;
}

void CPU::SUB() {
  op="SUB";
  uint16_t tmp;
  if(tir) {
    type="I";
    tmp=regfile.readRegister(rs)-n;
    regfile.writeRegister(rd,tmp);
  }
  else  {
    type="R";
    tmp=regfile.readRegister(rs)-regfile.readRegister(rm);
    regfile.writeRegister(rd,tmp);
  }
  addrA=pc+tir;
  addrB=addrA+1;
  pc=pc+tir+1;
}

void CPU::MAS() {
  op="MAS";
  if(tir) {
    type="I";
    regfile.writeRegister(rd,mulCarry+n);
  }
  else  {
    type="R";
    uint16_t val;
    if(as)  {
      val=mulCarry-regfile.readRegister(rs);
    }
    else  {
      val=mulCarry+regfile.readRegister(rs);
    }
    regfile.writeRegister(rd,val);
  }
  addrA=pc+tir;
  addrB=addrA+1;
  pc=pc+tir+1;
}

void CPU::MOV() {
  op="MOV";
  if(tir) {
    type="I";
    regfile.writeRegister(rd,n);
  }
  else  {
    type="R";
    regfile.writeRegister(rd,regfile.readRegister(rs));
  }
  addrA=pc+tir;
  addrB=addrA+1;
  pc=pc+tir+1;
}

void CPU::PLD() {
  op="PLD";
  type="R";
  if(m) {
    if(bn)  {
      regfile.writeRegister(rs,iRAM.readPortB());
    }
  }
  else  {
    if(an)  {
      regfile.writeRegister(rd,dRAM.readPortA());
    }
    if(bn)  {
      regfile.writeRegister(rs,dRAM.readPortB());
    }
  }
  addrA++;
  addrB=addrA+1;
  pc++;
}

void CPU::PST() {
  op="PST";
  type="R";
  if(m) {
    if(bn)  {
      iRAM.writePortB(regfile.readRegister(rs));
    }
  }
  else  {
    if(an)  {
      dRAM.writePortA(regfile.readRegister(rd));
    }
    if(bn)  {
      dRAM.writePortB(regfile.readRegister(rs));
    }
  }
  addrA++;
  addrB=addrA+1;
  pc++;
}

void CPU::SET() {
  op="SET";
  if(tir) {
    type="I";
  }
  else  {
    type="R";
  }
  if(m) {
    if(bn)  {
      if(tir&&ob) {
        iRAM.setAddrB(regfile.readRegister(rs)+n);
      }
      else  {
        iRAM.setAddrB(regfile.readRegister(rs));
      }
    }
  }
  else  {
    if(an)  {
      if(tir&&oa) {
        dRAM.setAddrA(regfile.readRegister(rd)+n);
      }
      else  {
        dRAM.setAddrA(regfile.readRegister(rd));
      }
    }
    if(bn)  {
      if(tir&&ob) {
        dRAM.setAddrB(regfile.readRegister(rs)+n);
      }
      else  {
        dRAM.setAddrB(regfile.readRegister(rs));
      }
    }
  }
  addrA=addrA+tir+1;
  addrB=addrA+1;
  pc=pc+tir+1;
}

void CPU::LSL() {
  op="LSL";
  type="R";
  regfile.writeRegister(rd,(regfile.readRegister(rs)<<1));
  addrA=pc;
  addrB=addrA+1;
  pc++;
}

void CPU::LSR() {
  op="LSR";
  type="R";
  if(a) {
    uint16_t tmp=regfile.readRegister(rs);
    regfile.writeRegister(rd,(tmp>>1)+(tmp&32768));
  }
  else  {
    regfile.writeRegister(rd,(regfile.readRegister(rs)>>1));
  }
  addrA=pc;
  addrB=addrA+1;
  pc++;
}

void CPU::RTN() {
  op="RTN";
  type="R";
  uint16_t rtnaddr=regfile.readRegister(rd);
  regfile.decFramePointer(int(rs));
  addrA=rtnaddr;
  addrB=rtnaddr+1;
  pc=rtnaddr+1;
}

void CPU::STP() {
  op="STP";
  type="R";
  done=1;
}

const int CPU::getStatus() {
  return done;
}

uint16_t CPU::getRegister(int reg) {
  return regfile.readRegister(reg);
}

const uint16_t CPU::getPC() {
  return cPC;
}

uint16_t CPU::getIA()  {
  return iRAM.readPortA();
}

uint16_t CPU::getIB() {
  return iRAM.readPortB();
}

uint16_t CPU::getDA() {
  return dRAM.readPortA();
}

uint16_t CPU::getDB()  {
  return dRAM.readPortB();
}

const int CPU::IRsize() {
  return iRAM.getSize();
}

const int CPU::DRsize() {
  return dRAM.getSize();
}

const string CPU::getOP()  {
  return op;
}

const string CPU::getType()  {
  return type;
}

const uint16_t CPU::getCurrentAddr()  {
  return cAddr;
}

const int CPU::getFramePointer()  {
  return regfile.readFramePointer();
}

#endif
