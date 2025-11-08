#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  printf("Starting buddy test from user space...\n");
  
  // This calls the system call stub you defined
  buddytest(); 
  
  printf("Buddy test finished.\n");
  exit(0);
}