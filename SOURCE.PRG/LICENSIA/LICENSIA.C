#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "crypt.h"

int main()
{
 int i,j;
 char key[10],in[42],out[40];
 char *l1="\nFUNCTION PutLicen",
      *l2="\nPARAMETERS y,x,color\nPRIVATE s,l,old\n  old=setcolor(color)",
      *l3="\n  if setkey_cl(s)==0\n     if decrypt_cl(@l,@l,40)==0\n        setkey_cl(\"\")    // Сбpос ключей для шифpования\n        @ y,x SAY l\n     endif\n  endif\n  setcolor(old)\nRETURN 0\n";

 j=1;
 while(1) {

   // input key for DES
   fprintf(stderr,"\n\nEnter for exit programm\nInput key [8 characters] for DES : ");
   if( !fgets( key,10,stdin) ) {
      fprintf(stderr,"\n-> Error reading key for DES.");
      return EXIT_FAILURE;
     }
   key[strlen(key)-1]='\0';     // deleted '\n' from key

   if( ! *key ) break;

   for(i=0;i<40;i++) in[i]=' ';   // fills in[] blanks
   in[i]='\0';

   // input licensia
   fprintf(stderr,"\nInput licensia [40 characters] : ");
   if( !fgets( in,42,stdin) ) {
      fprintf(stderr,"\n-> Error reading licensia.");
      return EXIT_FAILURE;
     }
   in[strlen(in)-1]=' ';  // deleted '\n' from in

   //crypt licensia
   setkey( key );
   encrypts( in,out,40 );
   
   // out key & crypting licensia
   printf("%s%2.2d",l1,j);
   printf("%s",l2);
   printf("\n  s=chr(%3.3d)",(unsigned char)key[0]);
   for(i=1;i<8 && key[i]; i++) printf("+chr(%3.3d)",(unsigned char)key[i]);

   printf("\n  l=chr(%3.3d)",(unsigned char)out[0]);
   for(i=1;i<40;i++)  {
        if( !(i%8) ) printf(";\n   ");
        printf("+chr(%3.3d)",(unsigned char)out[i]);
      }
   printf("%s",l3);
   j++;
  }

 return EXIT_SUCCESS;
}
