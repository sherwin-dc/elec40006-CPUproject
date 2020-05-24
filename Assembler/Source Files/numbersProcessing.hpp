#ifndef numbers_processing_hpp
#define numbers_processing_hpp

#include <vector>
#include <algorithm>
#include <map>
#include <utility>

using namespace std;

template <class T>
int safeIndex(int ix, const vector<T> &v)  {  //returns -1 if index out of range, else returns the index
  if(ix>=v.size())  {
    return -1;
  }
  else {
    return ix;
  }
}


#endif
