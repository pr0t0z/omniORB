#include "eg3_servant.h"
#include <iostream>

using namespace std;

char* Echo_i::echoString(const char* mesg) {
  cout << "Upcall: " << mesg << endl;
  return CORBA::string_dup(mesg);
}
