#ifndef assembler_synthesizer_hpp
#define assembler_synthesizer_hpp

#include <iostream>
#include <vector>
#include <string>
#include <map>

using namespace std;

class synthesizer {
  public:
    synthesizer();
    synthesizer(const vector<vector<string>> &infile);
    void loadTextVector(const vector<vector<string>> &infile);
    vector<vector<string>> getObjCode();
    void runSynthesis();

  private:
    void appendObjCode(string data);

    void STP();
    void CALL();
    void RTN();
    void LSL();
    void LSR();
    void CMP();
    void JMP();
    void ADD();
    void SUB();
    void MUL();
    void MAS2();
    void MAS(); //deprecated
    void MOV();
    void SET();
    void PLD();
    void PST();
    void NOP();
    void ORG();
    void DCW();
    void jmpPoint();
    void resolveJMPpoints();


    vector<vector<string>> textin;
    vector<vector<string>> objCode;
    int memAddr;

    map<string,int> addrLUT;
    map<string,int>::iterator it;

    string instrWord;
    vector<string> objLine;

    vector<string> tmp;
    int instr;
    int opcodeh;
    int tir;
    int rd, rs, rm;
    int cond;
    int operand;
};


synthesizer::synthesizer()  {
  memAddr=0;
  addrLUT.clear();
}

synthesizer::synthesizer(const vector<vector<string>> &infile)  {
  memAddr=0;
  textin=infile;
  addrLUT.clear();
}

void synthesizer::loadTextVector(const vector<vector<string>> &infile) {
  textin=infile;
}

vector<vector<string>> synthesizer::getObjCode()  {
  return objCode;
}

void synthesizer::appendObjCode(string data)  {
  objLine.clear();
  objLine.push_back(to_string(memAddr));
  objLine.push_back(data);
  objCode.push_back(objLine);
  memAddr++;
}

void synthesizer::runSynthesis()  {
  for(int i=0;i<textin.size();i++) {
    tmp=textin[i];
    tir=0;
    objLine.clear();
    if(tmp[1]=="stp")  {
      STP();
    }
    else if(tmp[1]=="call")  {
      CALL();
    }
    else if(tmp[1]=="rtn") {
      RTN();
    }
    else if(tmp[1]=="lsl") {
      LSL();
    }
    else if(tmp[1]=="lsr") {
      LSR();
    }
    else if(tmp[1]=="cmp") {
      CMP();
    }
    else if(tmp[1]=="jmp") {
      JMP();
    }
    else if(tmp[1]=="add") {
      ADD();
    }
    else if(tmp[1]=="sub") {
      SUB();
    }
    else if(tmp[1]=="mul")  {
      MUL();
    }
    else if(tmp[1]=="mas") {
      MAS2();
    }
    else if(tmp[1]=="mov") {
      MOV();
    }
    else if(tmp[1]=="set") {
      SET();
    }
    else if(tmp[1]=="pld") {
      PLD();
    }
    else if(tmp[1]=="pst") {
      PST();
    }
    else if(tmp[1]=="nop") {
      NOP();
    }
    else if(tmp[1]=="org") {
      ORG();
    }
    else if(tmp[1]=="dcw") {
      DCW();
    }
    else if(tmp[1].find(":")!=string::npos) {
      jmpPoint();
    }
    else  {
      cerr<<"Unknown syntax at line "<<tmp[0]<<endl<<endl;
      exit(1);
    }
  }
  resolveJMPpoints();
}


void synthesizer::STP() {
  instr=(31<<11);
  instrWord=to_string(instr);
  appendObjCode(instrWord);
}

void synthesizer::CALL()  {
  if(tmp.size()<5)  {
    cerr<<"Syntax Error for CALL at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=0;
  tir=1;
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for CALL at line "<<tmp[0]<<endl;
    exit(1);
  }

  int offset;
  try {
    offset=stoi(tmp[4]);
    if(offset>7)  {
      cerr<<"Window offset exceeds window range in CALL at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for CALL at line "<<tmp[0]<<" , Invalid offset value"<<endl;
    exit(1);
  }
  instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(offset<<5);
  instrWord=to_string(instr);
  appendObjCode(instrWord);
  appendObjCode(tmp[3]);
  return;
}

void synthesizer::RTN() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error for RTN at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=14;
  tir=0;
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for RTN at line "<<tmp[0]<<endl;
    exit(1);
  }

  int offset;
  try {
    offset=stoi(tmp[3]);
    if(offset>7)  {
      cerr<<"Window offset exceeds window range in RTN at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for RTN at line "<<tmp[0]<<" , Invalid offset value"<<endl;
    exit(1);
  }
  instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(offset<<5);
  instrWord=to_string(instr);
  appendObjCode(instrWord);
  return;
}

void synthesizer::LSL() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error for LSL at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=12;
  tir=0;
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for LSL at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("r")!=string::npos)  {
    tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
  }
  try {
    rs=stoi(tmp[3]);
    if(rs>7)  {
      cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for LSL at line "<<tmp[0]<<endl;
    exit(1);
  }
  instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5);
  instrWord=to_string(instr);
  appendObjCode(instrWord);
  return;
}

void synthesizer::LSR() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error for LSR at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=13;
  tir=0;
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for LSR at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("r")!=string::npos)  {
    tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
  }
  try {
    rs=stoi(tmp[3]);
    if(rs>7)  {
      cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for LSR at line "<<tmp[0]<<endl;
    exit(1);
  }
  int a=0;
  if(tmp.size()>4)  {
    if(tmp[4]=="a") {
      a=1;
    }
  }
  instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(a<<4);
  instrWord=to_string(instr);
  appendObjCode(instrWord);
  return;
}

void synthesizer::CMP() {
  if(tmp.size()<6)  {
    cerr<<"Syntax Error in CMP at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=1;
  if(tmp[3].find("#")!=string::npos)  {
    tir=1;
  }
  else  {
    tir=0;
  }
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error in CMP at line "<<tmp[0]<<endl;
    exit(1);
  }

  int cond;
  if(tmp[4]=="eq")  {
    cond=0;
  }
  else if(tmp[4]=="nq") {
    cond=1;
  }
  else if(tmp[4]=="gr") {
    cond=2;
  }
  else if(tmp[4]=="ls") {
    cond=3;
  }
  else if(tmp[4]=="ez") {
    cond=4;
  }
  else if(tmp[4]=="mi") {
    cond=5;
  }
  else if(tmp[4]=="np") {
    cond=6;
  }
  else  {
    cerr<<"Invalid COND in CMP at line "<<tmp[0]<<endl;
    exit(1);
  }

  int offset=0;
  try {
    offset=stoi(tmp[5]);
    if(offset>3)  {
      cerr<<"Max offset is 3, specified offset of "<<tmp[5]<<" in CMP at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for CMP at line "<<tmp[0]<<", invalid offset"<<endl;
    exit(1);
  }

  if(tir) {
    try {
      tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
      operand=stoi(tmp[3]);
      operand=operand&65535;
    }
    catch(...)  {
      cerr<<"Syntax Error for CMP at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(cond<<2)+offset;
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(to_string(operand));
    return;
  }
  else  {
    if(tmp[3].find("r")!=string::npos)  {
      tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
    }
    try {
      rs=stoi(tmp[3]);
      if(rs>7)  {
        cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error in CMP at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(cond<<2)+offset;
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }
}

void synthesizer::JMP() {
  if(tmp.size()<3)  {
    cerr<<"Syntax Error in JMP at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=2;
  if(tmp[2][0]=='r'&&isdigit(tmp[2][1])&&tmp[2].length()==2)  {
    tir=0;
  }
  else  {
    tir=1;
  }

  if(tir) {
    instr=(opcodeh<<12)+(tir<<11);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(tmp[2]);
    return;
  }
  else  {
    if(tmp[2].find("r")!=string::npos)  {
      tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
    }
    try {
      rd=stoi(tmp[2]);
      if(rd>7)  {
        cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error in JMP at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }


}

void synthesizer::ADD() {
  if(tmp.size()<5)  {
    cerr<<"Syntax Error for ADD at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=4;
  if(tmp[4].find("#")!=string::npos)  {
    tir=1;
  }
  else  {
    tir=0;
  }

  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for ADD at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("r")!=string::npos)  {
    tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
  }
  try {
    rs=stoi(tmp[3]);
    if(rs>7)  {
      cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for ADD at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tir) {
    try {
      tmp[4]=tmp[4].substr(1,tmp[4].length()-1);
      operand=stoi(tmp[4]);
      operand=operand&65535;
    }
    catch(...)  {
      cerr<<"Invalid value for operand in ADD at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(to_string(operand));
    return;
  }
  else  {
    if(tmp[4].find("r")!=string::npos)  {
      tmp[4]=tmp[4].substr(1,tmp[4].length()-1);
    }
    try {
      rm=stoi(tmp[4]);
      if(rm>7)  {
        cerr<<"Invalid register selected for Rm at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error for ADD at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(rm<<2);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }
}

void synthesizer::SUB() {
  if(tmp.size()<5)  {
    cerr<<"Syntax Error for SUB at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=5;
  if(tmp[4].find("#")!=string::npos)  {
    tir=1;
  }
  else  {
    tir=0;
  }

  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for SUB at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("r")!=string::npos)  {
    tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
  }
  try {
    rs=stoi(tmp[3]);
    if(rs>7)  {
      cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for SUB at line "<<tmp[0]<<endl;
    exit(1);
  }

  int ez=0;
  int sl=0;
  if(tmp.size()>=6) {
    if(tmp[5]=="j") {
      ez=1;
    }
    if(tmp.size()>=7)  {
      if(tmp[6]=="1") {
        sl=1;
      }
    }
  }

  if(tir) {
    try {
      tmp[4]=tmp[4].substr(1,tmp[4].length()-1);
      operand=stoi(tmp[4]);
      operand=operand&65535;
    }
    catch(...)  {
      cerr<<"Invalid value for operand in ADD at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(ez<<1)+sl;
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(to_string(operand));
    return;
  }
  else  {
    if(tmp[4].find("r")!=string::npos)  {
      tmp[4]=tmp[4].substr(1,tmp[4].length()-1);
    }
    try {
      rm=stoi(tmp[4]);
      if(rm>7)  {
        cerr<<"Invalid register selected for Rm at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error for SUB at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(rm<<2)+(ez<<1)+sl;
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }
}

void synthesizer::MUL() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error for MUL at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=3;
  if(tmp[3].find("#")!=string::npos)  {
    tir=1;
  }
  else  {
    tir=0;
  }

  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for MUL at line "<<tmp[0]<<endl;
    exit(1);
  }

  int p=0;
  if(tmp.size()>4)  {
    if(tmp[4]=="pm")  {
      p=1;
    }
  }

  if(tir) {
    try {
      tmp[3]=tmp[3].substr(1);
      operand=stoi(tmp[3]);
      operand=operand&65535;
    }
    catch(...)  {
      cerr<<"Invalid value for operand in MUL at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(p<<4);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(to_string(operand));
    return;
  }
  else  {
    if(tmp[3].find("r")!=string::npos)  {
      tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
    }
    try {
      rs=stoi(tmp[3]);
      if(rs>7)  {
        cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error for MUL at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(p<<4);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }
}

void synthesizer::MAS2()  {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error for MAS at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=6;
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for MAS at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("#")!=string::npos)  {
    tir=1;
  }
  else  {
    tir=0;
  }

  if(tir) {
    try {
      tmp[3]=tmp[3].substr(1);
      operand=stoi(tmp[3]);
      operand=operand&65535;
    }
    catch(...)  {
      cerr<<"Invalid value for operand in MAS at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(to_string(operand));
    return;
  }
  else  {
    if(tmp[3].find("r")!=string::npos)  {
      tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
    }
    try {
      rs=stoi(tmp[3]);
      if(rs>7)  {
        cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error for MAS at line "<<tmp[0]<<endl;
      exit(1);
    }

    int as=0;
    if(tmp.size()>4)  {
      if(tmp[4]=="s") {
        as=1;
      }
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(as<<4);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }
}

void synthesizer::MAS()  {  //deprecated
  if(tmp.size()<5)  {
    cerr<<"Syntax Error for MAS at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=6;
  if(tmp[4].find("#")!=string::npos)  {
    tir=1;
  }
  else  {
    tir=0;
  }

  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for MAS at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("r")!=string::npos)  {
    tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
  }
  try {
    rs=stoi(tmp[3]);
    if(rs>7)  {
      cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for MAS at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tir) {
    try {
      tmp[4]=tmp[4].substr(1,tmp[4].length()-1);
      operand=stoi(tmp[4]);
      operand=operand&65535;
    }
    catch(...)  {
      cerr<<"Invalid value for operand in MAS at line "<<tmp[0]<<endl;
      exit(1);
    }
    int p=0;
    if(tmp.size()>=6) {
      if(tmp[5]=="p") {
        p=1;
      }
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(p<<4);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(to_string(operand));
    return;
  }
  else  {
    if(tmp[4].find("r")!=string::npos)  {
      tmp[4]=tmp[4].substr(1,tmp[4].length()-1);
    }
    try {
      rm=stoi(tmp[4]);
      if(rm>7)  {
        cerr<<"Invalid register selected for Rm at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error for MAS at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(rm<<2);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }
}

void synthesizer::MOV() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error in MOV at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=7;
  if(tmp[3].find("#")!=string::npos)  {
    tir=1;
  }
  else  {
    tir=0;
  }

  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    rd=stoi(tmp[2]);
    if(rd>7)  {
      cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
      exit(1);
    }
  }
  catch(...)  {
    cerr<<"Syntax Error for MOV at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tir) {
    try {
      tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
      operand=stoi(tmp[3]);
      operand=operand&65535;
    }
    catch(...)  {
      cerr<<"Invalid value for operand in MOV at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    appendObjCode(to_string(operand));
    return;
  }
  else  {
    if(tmp[3].find("r")!=string::npos)  {
      tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
    }
    try {
      rs=stoi(tmp[3]);
      if(rs>7)  {
        cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
    catch(...)  {
      cerr<<"Syntax Error in MOV at line "<<tmp[0]<<endl;
      exit(1);
    }
    instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5);
    instrWord=to_string(instr);
    appendObjCode(instrWord);
    return;
  }
}

void synthesizer::SET() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error in SET at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=11;
  tir=0;
  int an;
  int bn;
  int oa;
  int ob;
  int m=0;
  if(tmp.size()>4&&tmp[4]=="i") {
    m=1;
  }

  if(tmp[2]=="x") {
    an=0;
    rd=0;
    oa=0;
  }
  else  {
    an=1;
    try {
      if(tmp[2].length()<=2)  {
        if(tmp[2][0]=='r')  {
          tmp[2]=tmp[2].substr(1,1);
        }
        rd=stoi(tmp[2]);
        if(rd>7)  {
          cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
          exit(1);
        }
        oa=0;
      }
      else  {
        if(tmp[2][0]=='[')  {
          tmp[2]=tmp[2].substr(1);
        }
        if(tmp[2].back()==']')  {
          tmp[2]=tmp[2].substr(0,tmp[2].length()-1);
        }
        if(tmp[2][0]=='r')  {
          tmp[2]=tmp[2].substr(1);
        }
        string rds=tmp[2].substr(0,1);
        rd=stoi(rds);
        if(rd>7)  {
          cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
          exit(1);
        }
        operand=stoi(tmp[2].substr(tmp[2].find("#")+1));
        if(tmp[2].substr(tmp[2].find("#")-1,1)=="-")  {
          operand*=-1;
        }
        tir=1;
        oa=1;
      }
    }
    catch(...)  {
      cerr<<"Syntax Error 1 in SET at line "<<tmp[0]<<endl;
      exit(1);
    }
  }

  if(tmp[3]=="x") {
    bn=0;
    rs=0;
    ob=0;
  }
  else  {
    bn=1;
    try {
      if(tmp[3].length()<=2)  {
        if(tmp[3][0]=='r')  {
          tmp[3]=tmp[3].substr(1,1);
        }
        rs=stoi(tmp[3]);
        if(rs>7)  {
          cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
          exit(1);
        }
        ob=0;
      }
      else  {
        if(tmp[3][0]=='[')  {
          tmp[3]=tmp[3].substr(1);
        }
        if(tmp[3].back()==']')  {
          tmp[3]=tmp[3].substr(0,tmp[3].length()-1);
        }
        if(tmp[3][0]=='r')  {
          tmp[3]=tmp[3].substr(1);
        }
        string rss=tmp[3].substr(0,1);
        rs=stoi(rss);
        if(rs>7)  {
          cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
          exit(1);
        }
        int rsop=stoi(tmp[3].substr(tmp[3].find("#")+1));
        if(tmp[3].substr(tmp[3].find("#")-1,1)=="-")  {
          rsop*=-1;
        }
        if(oa==1&&rsop!=operand) {
          cerr<<"Unmatched offsets in SET at line "<<tmp[0]<<endl;
          exit(1);
        }
        else if(oa==0)  {
          operand=rsop;
        }
        tir=1;
        ob=1;
      }
    }
    catch(...)  {
      cerr<<"Syntax Error 2 in SET at line "<<tmp[0]<<endl;
      exit(1);
    }
  }

  instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(m<<4)+(an<<3)+(bn<<2)+(oa<<1)+ob;
  instrWord=to_string(instr);
  appendObjCode(instrWord);
  if(tir) {
    operand=operand&65535;
    appendObjCode(to_string(operand));
  }
  return;
}

void synthesizer::PLD() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error in PLD at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=8;
  tir=0;
  int an;
  int bn;
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    if(tmp[2]=="x") {
      an=0;
      rd=0;
    }
    else  {
      rd=stoi(tmp[2]);
      an=1;
      if(rd>7)  {
        cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
  }
  catch(...)  {
    cerr<<"Syntax Error in PLD at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("r")!=string::npos)  {
    tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
  }
  try {
    if(tmp[3]=="x") {
      bn=0;
      rs=0;
    }
    else  {
      rs=stoi(tmp[3]);
      bn=1;
      if(rs>7)  {
        cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
  }
  catch(...)  {
    cerr<<"Syntax Error in PLD at line "<<tmp[0]<<endl;
    exit(1);
  }

  int m=0;
  if(tmp.size()>4)  {
    if(tmp[4]=="i") {
      m=1;
    }
  }
  instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(m<<4)+(an<<3)+(bn<<2);
  instrWord=to_string(instr);
  appendObjCode(instrWord);
  return;
}

void synthesizer::PST() {
  if(tmp.size()<4)  {
    cerr<<"Syntax Error in PST at line "<<tmp[0]<<endl;
    exit(1);
  }
  opcodeh=9;
  tir=0;
  int an;
  int bn;
  if(tmp[2].find("r")!=string::npos)  {
    tmp[2]=tmp[2].substr(1,tmp[2].length()-1);
  }
  try {
    if(tmp[2]=="x") {
      an=0;
      rd=0;
    }
    else  {
      rd=stoi(tmp[2]);
      an=1;
      if(rd>7)  {
        cerr<<"Invalid register selected for Rd at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
  }
  catch(...)  {
    cerr<<"Syntax Error in PST at line "<<tmp[0]<<endl;
    exit(1);
  }

  if(tmp[3].find("r")!=string::npos)  {
    tmp[3]=tmp[3].substr(1,tmp[3].length()-1);
  }
  try {
    if(tmp[3]=="x") {
      bn=0;
      rs=0;
    }
    else  {
      rs=stoi(tmp[3]);
      bn=1;
      if(rs>7)  {
        cerr<<"Invalid register selected for Rs at line "<<tmp[0]<<endl;
        exit(1);
      }
    }
  }
  catch(...)  {
    cerr<<"Syntax Error in PST at line "<<tmp[0]<<endl;
    exit(1);
  }

  int m=0;
  if(tmp.size()>4)  {
    if(tmp[4]=="i") {
      m=1;
    }
  }
  instr=(opcodeh<<12)+(tir<<11)+(rd<<8)+(rs<<5)+(m<<4)+(an<<3)+(bn<<2);
  instrWord=to_string(instr);
  appendObjCode(instrWord);
  return;
}

void synthesizer::NOP() {
  appendObjCode("0");
  return;
}

void synthesizer::ORG() {
  if(tmp.size()<3)  {
    cerr<<"Syntax Error in ORG at line "<<tmp[0]<<endl;
    exit(1);
  }
  try {
    int addr=stoi(tmp[2]);
    memAddr=addr;
    return;
  }
  catch(...)  {
    cerr<<"Syntax Error in ORG at line "<<tmp[0]<<endl;
    exit(1);
  }
}

void synthesizer::DCW() {
  if(tmp.size()<3)  {
    cerr<<"Syntax Error in DCW at line "<<tmp[0]<<endl;
    exit(1);
  }
  try {
    int a=stoi(tmp[2]);
    a=a&65535;
    appendObjCode(tmp[2]);
    return;
  }
  catch(...)  {
    cerr<<"Syntax Error in DCW at line "<<tmp[0]<<endl;
    exit(1);
  }
}

void synthesizer::jmpPoint() {
  int endpoint=tmp[1].find(":");
  string tag=tmp[1].substr(0,endpoint);
  if(isdigit(tag[0])) {
    cerr<<"Syntax error at line "<<tmp[0]<<" ,jump point names cannot start with a digit"<<endl;
    exit(1);
  }
  if(addrLUT.find(tag)==addrLUT.end()) {
    addrLUT.insert(pair<string,int>(tag,memAddr));
    return;
  }
  else  {
    cerr<<"Detected repeat definition of jump point "<<tag<<" at line "<<tmp[0]<<endl;
    exit(1);
  }
}

void synthesizer::resolveJMPpoints()  {
  for(int i=0;i<objCode.size();i++) {
    if(!isdigit(objCode[i][1][0])) {
      it=addrLUT.find(objCode[i][1]);
      if(it!=addrLUT.end()) {
        objCode[i][1]=to_string(it->second);
      }
      else  {
        cerr<<"Undefined reference to jump point "<<objCode[i][1]<<" at address "<<objCode[i][0]<<endl;
        exit(1);
      }
    }
  }
  return;
}



#endif
