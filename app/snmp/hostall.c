#include <unistd.h>
#include <netdb.h>
#include <stdio.h>
#include <arpa/inet.h>

#define BUF 256

int main(){
   struct hostent* h;
   char hostname[BUF];
   char ip[BUF];

   if(gethostname(hostname, BUF) != 0){
      printf("gethostbyname failed\n");
      return -1;
   }

   printf("Hostname: %s\n", hostname);

   h = gethostbyname(hostname);

   if(!h){
      printf("gethostbyname failed\n");
      return -1;
   }

   while(*h->h_addr_list){
      printf("Addr: %s\n", inet_ntop(h->h_addrtype, *h->h_addr_list, ip, BUF));
      *h->h_addr_list++;
   }

   return 0;
}
