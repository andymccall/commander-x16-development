/*
 * Title:           13-numberguess - C Example
 *
 * Description:     A number guessing game where the user guesses a number between 1 and 10.
 *                  The user has to guess the number and is given feedback on whether their guess
 *                  is too high or too low. The game keeps track of the number of attempts and
 *                  allows the user to play again. The game also uses the time taken to press enter
 *                  as a seed for the random number generator, ensuring a different number each time.
 *
 * Author:          Andy McCall, mailme@andymccall.co.uk
 *
 * Created:         2025-06-04 @ 15:27
 * Last Updated:    2025-06-04 @ 15:27
 *
 * Modinfo:
 *
 */

#include <stdio.h> 
#include <stdlib.h>
#include <time.h>

// A helper function to clear the input buffer
void clear_input_buffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}

int main() {

    // All variable declarations must be at the beginning of the main function block
   char play_again;
   int best = 0;

   // Variables needed inside the do-while loop, declared here for cc65 compatibility
   clock_t start_time;
   clock_t end_time;
   clock_t elapsed_time;
   int number;
   int guess;
   int attempts;

   putchar(142);

   printf("\n");
   printf("welcome cx16 number guessing game!\n");
   printf("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n");
   printf("\n");

   do {

      /* Measure the time between the prompt and the user pressing enter */
      printf("generating a new number!\n\n");
      printf("press enter to start...\n");

      start_time = clock();
      getchar();
      end_time = clock();

      /* Calculate the elapsed time and use it as a seed */
      elapsed_time = end_time - start_time;
      srand((unsigned int)elapsed_time);
      number = rand() % 10 + 1;
      attempts = 1;

      /* Prompt the user to guess a number */
      printf("\n");
      printf("guess a number between 1 and 10: ");

      /* Check the number and give feedback */
      do {
         scanf("%d", &guess);
         printf("\n");

         if (guess != number) {
            if (guess < number) {
               printf("too low!\n");
            } else {
               printf("too high!\n");
            }
            printf("guess again: ");
            attempts++;
         }
      } while (guess != number);

      // Update best score if current attempts are lower or if it's the first game
      if (attempts < best || best == 0) {
         best = attempts;
      }

      /* Congratulate the user */
      printf("\ncongratulations!\n\n");
      printf("you guessed the number in %d tries!\n\n", attempts);

      /* Ask the user if they want to play again */
      printf("do you want to play again? (y/n): ");
      scanf(" %c", &play_again); // Note the space before %c to consume any leftover newline character
      printf("\n\n");

   } while (play_again == 'y' || play_again == 'Y');

   printf("thanks for playing, your lowest number of guesses was %d!\n\n", best);
   clear_input_buffer();
   getchar(); // Wait for the user to press enter before exiting

   return 0;
}
