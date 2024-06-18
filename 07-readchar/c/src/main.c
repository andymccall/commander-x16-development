
/* 
 * Title:           07-readchar - Assembler Example
 *
 * Description:     A program that prints strings to the console
;                   based on menu input
 * Author:          Andy McCall, mailme@andymccall.co.uk
 * 
 * Created:		     2024-06-14 @ 15:27
 * Last Updated:	  2024-06-14 @ 15:27
 * 
 * Modinfo:
 * 
 */

#include <stdio.h>

const char *menu_header  = "MENU";
const char *hello_menu   = "[1] SAY HELLO";
const char *goodbye_menu = "[2] SAY GOODBYE";
const char *quit_menu    = "[3] QUIT";
const char *prompt       = "SELECTION >";
const char *hello_msg    = "HELLO!";
const char *goodbye_msg  = "GOODBYE!";
const char *quit_msg     = "QUITTING...";

void showmenu() {
   printf("%s\n", menu_header);
   printf("\n");
   printf("%s\n", hello_menu);
   printf("%s\n", goodbye_menu);
   printf("%s\n", quit_menu);
   printf("\n");
   printf("%s ", prompt);
}

int main(void) {

   int chr;

   do {
      showmenu();
   
      chr = getchar();
      printf("\n");

      switch (chr) {
         case '1':
            printf("%s\n",hello_msg);
            break;
         case '2':
            printf("%s\n",goodbye_msg);
            break;
         case '3':
            printf("%s\n",quit_msg);
            break;
         default:
            break;
       }
      printf("\n");
   } while (chr != '3');
   
   return 0;

}
