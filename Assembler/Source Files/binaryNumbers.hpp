#ifndef binary_numbers_processing_hpp
#define binary_numbers_processing_hpp

#include <iostream>
#include <vector>
#include <string>
#include "numbersProcessing.hpp"
#include "stringTextFunctions.hpp"

using namespace std;

class Hex;

class Bin {
  public:
    ~Bin();
    template <typename T>
    int DectoBin(T number);
    template <typename T>
    int write(T number, int count, int startpoint=0);
    int setBit(bool value, int bitPos);
    const bool getBit(int bitPos);
    const int getBitCount();
    const int toDecInt();
    const long toDecLong();
    const Bin getBitField(int start, int end);
    const Hex BintoHex();


    friend ostream& operator<<(ostream &dst, const Bin& data);

    Bin& operator =(const Bin& obj) {
      if(this!=&obj)  {
        this->binNum=obj.binNum;
        this->bitcount=obj.bitcount;
      }
      return *this;
    }

    Bin operator + (Bin& obj) {
        if(this->bitcount<=32 && obj.bitcount<=32)  {
          Bin aa;
          aa.DectoBin(this->toDecInt() + obj.toDecInt());
          return aa;
        }
        else {
          Bin bb;
          bb.DectoBin(this->toDecLong() + obj.toDecLong());
          return bb;
        }
    }

    Bin operator - (Bin& obj) {
        if(this->bitcount<=32 && obj.bitcount<=32)  {
          Bin aa;
          aa.DectoBin(this->toDecInt() - obj.toDecInt());
          return aa;
        }
        else {
          Bin bb;
          bb.DectoBin(this->toDecLong() - obj.toDecLong());
          return bb;
        }
    }

    Bin operator * (Bin& obj) {
        Bin aa;
        aa.DectoBin(this->toDecLong() * obj.toDecLong());
        return aa;
    }

    Bin operator / (Bin& obj) {
        Bin aa;
        aa.DectoBin(this->toDecLong() / obj.toDecLong());
        return aa;
    }

    Bin& operator +=(Bin& obj) {
      DectoBin(toDecLong() + obj.toDecLong());
      return *this;
    }

    Bin& operator -=(Bin& obj)  {
      DectoBin(toDecLong() - obj.toDecLong()) ;
      return *this;
    }

    Bin& operator ++(int)  {
      DectoBin(toDecLong()+1);
      return *this;
    }

    Bin& operator --(int) {
      DectoBin(toDecLong()-1);
      return *this;
    }


  private:
    vector<bool> binNum;
    int bitcount=0;
};


ostream& operator<< (ostream &dst, const Bin& data) {
  for(int i=0;i<data.bitcount;i++) {
    dst << data.binNum[i];
  }
  return dst;
}

template <typename T>
int Bin::DectoBin(T number) {
  try {
    bitcount = sizeof(number) * 8;
    binNum.resize(bitcount);
    for(int i=0;i<bitcount;i++) {
      binNum[bitcount-1-i]=(number>>i)&1;
    }
    return 1;
  }
  catch(...)  {
    return 0;
  }
}

template <typename T>
int Bin::write(T number, int count, int startpoint) {
  try {
    bitcount=count;
    binNum.resize(count);
    for(int i=0;i<count;i++)  {
      binNum[bitcount-1-i]=(number>>(i+startpoint))&1;
    }
    return 1;
  }
  catch(...)  {
    return 0;
  }
}

int Bin::setBit(bool value, int bitPos) {
  if(safeIndex(bitPos,binNum)+1) {
    binNum[bitcount-1-bitPos]=value;
    return 1;
  }
  else  {
    return 0;
  }
}

const bool Bin::getBit(int bitPos) {
  return binNum[bitcount-1-bitPos];
}

const int Bin::getBitCount()  {
  return bitcount;
}

const int Bin::toDecInt()  {
  int output=0;
  for(int i=0;i<bitcount;i++) {
    output+=binNum[bitcount-1-i]<<i;
  }
  return output;
}

const long Bin::toDecLong() {
  long output=0;
  for(int i=0;i<bitcount;i++) {
    output+=binNum[bitcount-1-i]<<i;
  }
  return output;
}

const Bin Bin::getBitField(int start, int end) {
  if(end>bitcount-1)  {
    end=bitcount-1;
  }
  if(start>bitcount-1)  {
    start=bitcount-1;
  }
  int length=end-start+1;
  Bin output;
  output.write(0,length);
  for(int i=0;i<length;i++) {
    output.setBit(getBit(i+start),i);
  }
  return output;
}

Bin::~Bin() {}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Hex {
  public:
    ~Hex();
    template <typename T>
    int DectoHex(T number);
    const int toDecInt();
    const long toDecLong();
    const Bin HextoBin();

    friend ostream& operator << (ostream &dst, const Hex& data);

    Hex& operator =(const Hex& obj) {
      if(this!=&obj)  {
        this->hexNum=obj.hexNum;
        this->nybbles=obj.nybbles;
      }
      return *this;
    }

    Hex& operator =(const string& str)  {
      try {
        string lstr = tolower(str);
        hexNum.resize(0);
        if(lstr.substr(0,2)=="0x")  {
          lstr=lstr.substr(2,lstr.length()-2);
        }
        for(int i=0;i<lstr.length();i++)  {
          if((isdigit(lstr[i])||(lstr[i]>='a'&&lstr[i]<='f')))  {
            hexNum.push_back(lstr[i]);
          }
          else  {
            throw runtime_error("invalid hex input");
          }
        }
      }
      catch(...)  {
      }
      nybbles=hexNum.size();
      return *this;
    }

    Hex operator +(Hex& obj)  {
      Hex output;
      output.DectoHex(toDecLong() + obj.toDecLong());
      return output;
    }

    Hex operator -(Hex& obj)  {
      Hex output;
      output.DectoHex(toDecLong() - obj.toDecLong());
      return output;
    }

    Hex operator *(Hex& obj)  {
      Hex output;
      output.DectoHex(toDecLong() * obj.toDecLong());
      return output;
    }

    Hex operator /(Hex& obj)  {
      Hex output;
      output.DectoHex(toDecLong() / obj.toDecLong());
      return output;
    }

    Hex& operator +=(Hex& obj) {
      DectoHex(toDecLong() + obj.toDecLong());
      return *this;
    }

    Hex& operator -=(Hex& obj)  {
      DectoHex(toDecLong() - obj.toDecLong());
      return *this;
    }

    Hex& operator ++(int) {
      DectoHex(toDecLong()+1);
      return *this;
    }

    Hex& operator --(int) {
      DectoHex(toDecLong()-1);
      return *this;
    }


  protected:
    int writeNybble(char data, int npos);
    const char getNybble(int npos);
    const int nybbleCount();

  private:
    vector<char> hexNum;
    int nybbles;

};

ostream& operator << (ostream &dst, const Hex& data)  {
  for(int i=0;i<data.nybbles;i++)  {
    dst << data.hexNum[i];
  }
  return dst;
}

int Hex::writeNybble(char data, int npos) {
  if(npos<=nybbles) {
    hexNum[nybbles-1-npos]=data;
    return 1;
  }
  else  {
    return 0;
  }
}

const char Hex::getNybble(int npos)  {
  return hexNum[nybbles-1-npos];
}

const int Hex::nybbleCount() {
  return nybbles;
}

template<typename T>
int Hex::DectoHex(T number) {
  try {
    nybbles=sizeof(number)*2;
    hexNum.resize(nybbles);
    int temp;
    for(int i=0;i<nybbles;i++)  {
      temp=(number>>(i*4))&15;
      switch(temp)  {
        case 0:
          writeNybble('0',i);
          break;
        case 1:
          writeNybble('1',i);
          break;
        case 2:
          writeNybble('2',i);
          break;
        case 3:
          writeNybble('3',i);
          break;
        case 4:
          writeNybble('4',i);
          break;
        case 5:
          writeNybble('5',i);
          break;
        case 6:
          writeNybble('6',i);
          break;
        case 7:
          writeNybble('7',i);
          break;
        case 8:
          writeNybble('8',i);
          break;
        case 9:
          writeNybble('9',i);
          break;
        case 10:
          writeNybble('a',i);
          break;
        case 11:
          writeNybble('b',i);
          break;
        case 12:
          writeNybble('c',i);
          break;
        case 13:
          writeNybble('d',i);
          break;
        case 14:
          writeNybble('e',i);
          break;
        case 15:
          writeNybble('f',i);
          break;
      }
    }
    vector<char> carry=hexNum;
    hexNum.resize(0);
    bool flag=0;
    for(int i=0;i<carry.size();i++) {
      if(carry[i]=='0'&&!flag) {
        continue;
      }
      else  {
        hexNum.push_back(carry[i]);
        flag=1;
      }
    }
    nybbles=hexNum.size();
    return 1;
  }
  catch(...)  {
    return 0;
  }
}

const int Hex::toDecInt()  {
  int output=0;
  int temp;
  for(int i=0;i<nybbles;i++)  {
    switch(getNybble(i)) {
      case '0':
        temp=0;
        break;
      case '1':
        temp=1;
        break;
      case '2':
        temp=2;
        break;
      case '3':
        temp=3;
        break;
      case '4':
        temp=4;
        break;
      case '5':
        temp=5;
        break;
      case '6':
        temp=6;
        break;
      case '7':
        temp=7;
        break;
      case '8':
        temp=8;
        break;
      case '9':
        temp=9;
        break;
      case 'a':
        temp=10;
        break;
      case 'b':
        temp=11;
        break;
      case 'c':
        temp=12;
        break;
      case 'd':
        temp=13;
        break;
      case 'e':
        temp=14;
        break;
      case 'f':
        temp=15;
        break;
    }
    output+=temp<<(i*4);
  }
  return output;
}

const long Hex::toDecLong() {
  long output=0;
  int temp;
  for(int i=0;i<nybbles;i++)  {
    switch(getNybble(i)) {
      case '0':
        temp=0;
        break;
      case '1':
        temp=1;
        break;
      case '2':
        temp=2;
        break;
      case '3':
        temp=3;
        break;
      case '4':
        temp=4;
        break;
      case '5':
        temp=5;
        break;
      case '6':
        temp=6;
        break;
      case '7':
        temp=7;
        break;
      case '8':
        temp=8;
        break;
      case '9':
        temp=9;
        break;
      case 'a':
        temp=10;
        break;
      case 'b':
        temp=11;
        break;
      case 'c':
        temp=12;
        break;
      case 'd':
        temp=13;
        break;
      case 'e':
        temp=14;
        break;
      case 'f':
        temp=15;
        break;
    }
    output+=temp<<(i*4);
  }
  return output;
}

const Bin Hex::HextoBin()  {
  Bin output;
  output.DectoBin(toDecLong());
  return output;
}

Hex::~Hex() {}


const Hex Bin::BintoHex() {
  Hex output;
  output.DectoHex(toDecLong());
  return output;
}


#endif
