
/* 
 * Title:           03-setmode - C Example
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

   int status;

   status = videomode(VIDEOMODE_20x15);

   return 0;

}
