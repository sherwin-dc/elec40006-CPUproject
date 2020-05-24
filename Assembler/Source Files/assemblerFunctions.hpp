#ifndef assembler_functions
#define assembler_functions

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include "binaryNumbers.hpp"

using namespace std;


void stringRemoveChar(string *instring, string rmchar);
vector<vector<string>> parseFile(ifstream &infile);
void generateMIF(const vector<vector<string>> &objcode, string filename="out.mif", int depth=65536, int width=16);


void stringRemoveChar(string *instring, string rmchar) {
  int point=instring->find(rmchar);
  while(point!=string::npos)  {
    instring->erase(point,1);
    point=instring->find(rmchar);
  }
}


vector<vector<string>> parseFile(ifstream &infile)  {
  vector<vector<string>> outData;
  string line;
  int lineNumber=0;
  while(getline(infile,line)) {
    string a;
    vector<string> out;

    lineNumber++;
    int startpoint=0;
    int endpoint, endlimit;
    endlimit=line.find("//");
    line=line.substr(0,endlimit);
    while(line.back()==' ') {
      line=line.substr(0,line.length()-1);
    }
    if(line.length()>0) {
      out.push_back(to_string(lineNumber));
      while(1)  {
        endpoint=line.find(" ",startpoint);
        if(endpoint==string::npos)  {
          a=line.substr(startpoint,line.length()-startpoint);
          stringRemoveChar(&a," ");
          if(a.find("//")==string::npos)  {
            for(int i=0;i<a.length();i++) {
              a[i]=tolower(a[i]);
            }
            out.push_back(a);
          }
          outData.push_back(out);
          break;
        }
        else  {
          a=line.substr(startpoint,(endpoint-startpoint));
          for(int i=0;i<a.length();i++) {
            a[i]=tolower(a[i]);
          }
          out.push_back(a);
          startpoint=endpoint+1;
        }
      }
    }
  }

  return outData;
}


void generateMIF(const vector<vector<string>> &inobj, string filename, int depth, int width)  {
  ofstream outputFile{filename};
  outputFile<<"DEPTH = "<<to_string(depth)<<";"<<endl;
  outputFile<<"WIDTH = "<<to_string(width)<<";"<<endl;
  outputFile<<"ADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN"<<endl;

  Hex address;
  Hex instr;

  address.DectoHex(depth-1);
  outputFile<<"[0.."<<address<<"]: 0;"<<endl;

  for(int i=0;i<inobj.size();i++) {
    try {
      address.DectoHex(stoi(inobj[i][0]));
      instr.DectoHex(stoi(inobj[i][1]));
      if(stoi(inobj[i][0])==0)  {
        outputFile<<"0"<<" : ";
      }
      else  {
        outputFile<<address<<" : ";
      }
      if(stoi(inobj[i][1])==0)  {
        outputFile<<"0"<<";"<<endl;
      }
      else  {
        outputFile<<instr<<";"<<endl;
      }
    }
    catch(...)  {
      cerr<<"error encountered in generating MIF file at address "<<inobj[i][0]<<endl;
      exit(1);
    }
  }
  outputFile<<"END"<<endl;
  return;
}


#endif
