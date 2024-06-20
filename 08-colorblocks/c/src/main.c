
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

#include <cx16.h>
#include <stdio.h>
#include <conio.h>

void print_block(unsigned char color) {

   bgcolor(color);
   printf(" ");

   return;
}


void restore_colors(int txtcol, int bgcol) {
   textcolor(txtcol);
   bgcolor(bgcol);
}


int main(void) {

   int txtcol, bgcol;

   txtcol = textcolor(COLOR_WHITE);
   bgcol = bgcolor(COLOR_BLUE);

   clrscr();

   print_block(COLOR_BLACK);
   print_block(COLOR_WHITE);
   print_block(COLOR_CYAN);
   print_block(COLOR_PURPLE);  
   print_block(COLOR_GREEN);
   print_block(COLOR_BLUE);
   print_block(COLOR_YELLOW);
   print_block(COLOR_ORANGE);
   print_block(COLOR_BROWN);
   print_block(COLOR_PINK);
   print_block(COLOR_LIGHTRED);
   print_block(COLOR_GRAY1);  
   print_block(COLOR_GRAY2);
   print_block(COLOR_LIGHTGREEN);
   print_block(COLOR_LIGHTBLUE);
   print_block(COLOR_GRAY3);

   restore_colors(txtcol, bgcol);

   return 0;

}
