#include "assemblerFunctions.hpp"
#include "synthesizer.hpp"

using namespace std;

int main(int argc, char** argv) {
  if(argc==1) {
    cerr<<"no input file detected"<<endl;
    exit(1);
  }

  string inputFile=argv[1];
  ifstream infile;
  try {
    infile.open(inputFile);
    if(infile.fail()) {
      throw runtime_error("unable to open file");
    }
  }
  catch(...)  {
    cerr<<"Unable to open "<<inputFile<<endl;
    exit(1);
  }
  string outFileName=inputFile.substr(0,inputFile.find("."));
  outFileName.append(".mif");
  if(argc>2)  {
    for(int i=2;i<argc;i++) {
      string arg=argv[i];
      if(arg=="-o"&&argc>i+1) {
        outFileName=argv[i+1];
        i++;
      }
    }
  }

  cout<<"Parsing "<<inputFile<<"..."<<endl;
  synthesizer s(parseFile(infile));
  cout<<"Assembling machine code..."<<endl;
  s.runSynthesis();
  cout<<"Generating MIF file..."<<endl;
  generateMIF(s.getObjCode(),outFileName);
  cout<<"Done! Generated: "<<outFileName<<endl<<endl;

  return 0;
}
