#include <stdio.h>
#include <stdlib.h>


extern int fibonacci(int);

int main(int argc, char **argv) {
   int n, fib;

   printf("Enter n: ");

   scanf("%d", &n);

   fib = fibonacci(n);

   printf("Fibonacci is %d \n", fib);


   return 0;
}