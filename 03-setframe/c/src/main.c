
/* 
 * Title:           03-setframe - C Example
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

int main(void) {

   VERA.display.border = COLOR_RED;

   return 0;

}
