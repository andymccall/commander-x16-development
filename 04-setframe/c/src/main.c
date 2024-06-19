
/* 
 * Title:           04-setframe - C Example
 *
 * Description:     A program that sets the frame to red
 * Author:          Andy McCall, mailme@andymccall.co.uk
 * 
 * Created:		     2024-06-14 @ 15:27
 * Last Updated:	  2024-06-14 @ 15:27
 * 
 * Modinfo:
 * 
 */

#include <cx16.h>
#include <conio.h>

const int VIDEOMODE_22x23 = 0x7;

int main(void) {

   int status;

   /* Set the video mode to a mode with a border */
   status = videomode(VIDEOMODE_22x23);

   /* Set the border to red using VERA calls */
   VERA.display.border = COLOR_RED;

   /* Alternative way using conio.h */
   /* bordercolor(COLOR_RED); */

   return 0;

}
