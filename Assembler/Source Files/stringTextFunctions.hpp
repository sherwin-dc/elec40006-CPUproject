#ifndef string_text_functions_hpp
#define string_text_functions_hpp

#include <string>
#include <iostream>
#include <iomanip>
#include <vector>
using namespace std;

// Function declarations
string toupper(const string &s);
string tolower(const string &s);
void toupper(char* charArray);
void tolower(char* charArray);
vector<string> toWords (istream &dst);
vector<string> toWords (const string &in);
vector<vector<string>> toSentences (istream &dst, bool punct=false);
vector<vector<string>> toSentences (const string &in, bool punct=false);
vector<vector<string>> toLines (istream &dst, bool punct=false);
vector<vector<string>> toLines (const string &in, bool punct=false);
string sentenceVectorToWords(const vector<string> &in);
int countSubString(const string &source, const string & target);

template <typename T>
ostream& operator << (ostream &dst, const vector<T> &input);

// Overloading default toupper(chars only) to work on strings.
string toupper(const string &s){
    string out;
    for(int i=0; i<s.size(); i++){
        if(isalpha( s[i]) ){
            out.push_back( toupper(s[i]) );
        } else {
            out.push_back( s[i] );
        }
    }
    return out;
}

// Overloading default tolower(chars only) to work on strings.
string tolower(const string &s){
    string out;
    for(int i=0; i<s.size(); i++){
        if(isalpha( s[i]) ){
            out.push_back( tolower(s[i]) );
        } else {
            out.push_back( s[i] );
        }
    }
    return out;
}

// Overloading default toupper(chars only) to work on whole char arrays.
// Modifies exisiting array, old data is lost.
void toupper(char* charArray){
    for(int i=0; i<sizeof(charArray); i++){
        if(isalpha(charArray[i])){
            charArray[i] = tolower(charArray[i]);
        }
    }
}

// Overloading default toupper(chars only) to work on whole char arrays.
// Modifies exisiting array, old data is lost.
void tolower(char* charArray){
    for(int i=0; i<sizeof(charArray); i++){
        if(isalpha(charArray[i])){
            charArray[i] = toupper(charArray[i]);
        }
    }
}

// Returns a vector of (space delimited) words from an input stream.
// Punctuation is not filtered out.
vector<string> toWords (istream &dst){
    vector<string> out;
    string currWord;

    while(1){
        dst >> currWord;
        if(dst.fail()){
            break;
        }
        out.push_back(currWord);
    }
    return out;
}

// Returns a vector of (space delimited) words from an input string.
// Punctuation is not filtered out.
vector<string> toWords (const string &in){
    vector<string> out;
    int index = 0;
    out.push_back("");
    for(int i=0; i<in.size(); i++){
        if(in[i]!=' '){
            out[index].push_back(in[i]);
        } else if ( in[i+1]!= ' ') {
            out.push_back("");
            index++;
        }
    }
    return out;
}

// Returns a vector of sentences from an input stream.
// Sentence delimiters: '.', '!', '?'
// Intermediate punctuation might be filtered out based on the bool punct.
vector<vector<string>> toSentences (istream &dst, bool punct){
    vector<string> currSentence;
    string currWord;
    vector<vector<string>> out;

    while(1){
        char x;
        dst.get(x);
        if(dst.fail()){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            if(!currSentence.empty()){
                out.push_back(currSentence);
            }
            break;
        }

        if (x==' '){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            currWord = "";
        } else if (x=='.'||x=='!'||x=='?'){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            if(!currSentence.empty()){
                out.push_back(currSentence);
            }
            currSentence = {};
            currWord = "";
        } else if( isalnum(x) || (ispunct(x) && punct) ) {
            currWord.push_back(x);
        }
    }

    return out;

}

vector<vector<string>> toSentences (const string &in, bool punct){
    vector<string> currSentence;
    string currWord;
    vector<vector<string>> out;

    for(int i=0; i<in.size(); i++){
        char x = in[i];

        if (x==' '){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            currWord = "";
        } else if (x=='.'||x=='!'||x=='?'){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            if(!currSentence.empty()){
                out.push_back(currSentence);
            }
            currSentence = {};
            currWord = "";
        } else if( isalnum(x) || (ispunct(x) && punct) ) {
            currWord.push_back(x);
        }
    }

    if(currWord!=""){
        currSentence.push_back(currWord);
    }
    if(!currSentence.empty()){
        out.push_back(currSentence);
    }

    return out;
}

vector<vector<string>> toLines (istream &dst, bool punct){
    vector<string> currSentence;
    string currWord;
    vector<vector<string>> out;

    while(1){
        char x;
        dst.get(x);
        if(dst.fail()){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            if(!currSentence.empty()){
                out.push_back(currSentence);
            }
            break;
        }

        if (x==' '){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            currWord = "";
        } else if (x=='\n'){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            if(!currSentence.empty()){
                out.push_back(currSentence);
            }
            currSentence = {};
            currWord = "";
        } else if( isalnum(x) || (ispunct(x) && punct) ) {
            currWord.push_back(x);
        }
    }

    return out;
}

vector<vector<string>> toLines (const string &in, bool punct){
vector<string> currSentence;
    string currWord;
    vector<vector<string>> out;

    for(int i=0; i<in.size(); i++){
        char x = in[i];

        if (x==' '){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            currWord = "";
        } else if (x=='\n'){
            if(currWord!=""){
                currSentence.push_back(currWord);
            }
            if(!currSentence.empty()){
                out.push_back(currSentence);
            }
            currSentence = {};
            currWord = "";
        } else if( isalnum(x) || (ispunct(x) && punct) ) {
            currWord.push_back(x);
        }
    }

    if(currWord!=""){
        currSentence.push_back(currWord);
    }
    if(!currSentence.empty()){
        out.push_back(currSentence);
    }

    return out;
}

string sentenceVectorToWords(const vector<string> &in){
    string out;
    for(int i=0; i<in.size(); i++){
        out += in[i];
        if(i!=in.size()-1){
            out.push_back(' ');
        }
    }
    return out;
}

// Overloading cout to print out vectors with comma delimiter, ending with a newline.
template <typename T>
ostream& operator << (ostream &dst, const vector<T> &input){
    for(int i=0; i<input.size(); i++){
        dst << "\"" << input[i] << "\"";
        if( i != (input.size()-1) ){
            dst << ", ";
        }
    }
    return dst;
}

//count the number of times target substring appear in source string
int countSubString(const string &source, const string &target) {
  int count=0;
  int startpoint=0;
  while(source.find(target,startpoint)!=string::npos)  {
    count++;
    startpoint=source.find(target,startpoint)+1;
  }
  return count;
}


#endif
