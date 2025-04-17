#include "storage.hpp"

int main() {
  Storage storage;
  int res = 0;
  while(res == 0) {
    res = storage.Process();
  }
  std::cout << "Exited with error\n";
  return 0;
}