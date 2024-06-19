
/* 
 * Title:           04-setscreen - C Example
 *
 * Description:     A program that sets the screen to red
 * Author:          Andy McCall, mailme@andymccall.co.uk
 * 
 * Created:		     2024-06-19 @ 19:44
 * Last Updated:	  2024-06-19 @ 19:44
 * 
 * Modinfo:
 * 
 */

#include <cx16.h>
#include <conio.h>

int main(void) {

   textcolor(COLOR_BLACK);
   bgcolor(COLOR_RED);
   clrscr();

   return 0;

}
