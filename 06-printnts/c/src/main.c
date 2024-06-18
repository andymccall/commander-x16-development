/* 
 * Title:           06-printnts - C Example
 *
 * Description:     A program that prints null terminated strings to
 *                  the console via a reusable function
 * Author:          Andy McCall, mailme@andymccall.co.uk
 * 
 * Created:		    2024-06-14 @ 15:27
 * Last Updated:	2024-06-14 @ 15:27
 * 
 * Modinfo:
 * 
 */

#include <stdio.h>

void print_string(char * str) {
    char * t;    
    for (t = str; *t != '\0'; t++) {
       printf("%c",*t);
    }
}

int main(void) {

   print_string("Hello, World!");

   return 0;

}
