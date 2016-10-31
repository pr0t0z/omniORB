#include <echo.hh>

using namespace POA_Example;

class Echo_i : public Echo {
public:
  inline Echo_i() {}
  virtual ~Echo_i() {}
  virtual char* echoString(const char* mesg);
};
