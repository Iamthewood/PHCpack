/* reads a target and start system and then solves the target system,
   using the start system in an artificial-parameter homotopy */

#include <stdio.h>
#include <stdlib.h>
#include "phcpack.h"

int run_standard_continuation ( void );
/* runs in standard floating-point arithmetic */

int run_dobldobl_continuation ( void );
/* runs in double double arithmetic */

int run_quaddobl_continuation ( void );
/* runs in quad double arithmetic */

int run_multprec_continuation ( void );
/* runs in multiprecision arithmetic */

int main ( int argc, char *argv[] )
{
   int fail,choice;
   char ch;

   adainit();

   printf("\nMENU for running increment-and-fix continuation :\n");
   printf("  1. run in standard double arithmetic;\n");
   printf("  2. run in double double arithmetic;\n");
   printf("  3. run in quad double arithmetic.\n");
   printf("  4. run in multiprecision arithmetic.\n");
   printf("Type 1, 2, 3, or 4 to select precision : ");
   scanf("%d",&choice);
   scanf("%c",&ch);     /* skip new line */

   if(choice == 1)
      fail = run_standard_continuation();
   else if(choice == 2)
      fail = run_dobldobl_continuation();
   else if(choice == 3)
      fail = run_quaddobl_continuation();
   else if(choice == 4)
      fail = run_multprec_continuation();
   else
      printf("Invalid choice, please try again.\n");

   adafinal();

   return 0;
}

int run_standard_continuation ( void )
{
   int fail;

   printf("\nCalling the standard path trackers in PHCpack...\n");
   fail = read_target_system();
   fail = read_start_system();
   fail = define_output_file();
   fail = write_target_system();
   fail = write_start_system();
   fail = write_start_solutions();
   printf("\n");
   fail = tune_continuation_parameters();
   printf("\n");
   fail = determine_output_during_continuation();
   printf("\nSee the output file for results ...\n");
   fail = solve_by_homotopy_continuation();

   return fail;
}

int run_dobldobl_continuation ( void )
{
   int fail;

   printf("\nCalling the double double path trackers in PHCpack...\n");
   fail = read_dobldobl_target_system();
   fail = read_dobldobl_start_system();
   fail = define_output_file();
   fail = write_dobldobl_target_system();
   fail = write_dobldobl_start_system();
   fail = write_dobldobl_start_solutions();
   printf("\n");
   fail = autotune_continuation_parameters(0,24);
   fail = tune_continuation_parameters();
   printf("\n");
   fail = determine_output_during_continuation();
   printf("\nSee the output file for results ...\n");
   fail = solve_by_dobldobl_homotopy_continuation();

   return fail;
}

int run_quaddobl_continuation ( void )
{
   int fail;

   printf("\nCalling the quad double path trackers in PHCpack...\n");
   fail = read_quaddobl_target_system();
   fail = read_quaddobl_start_system();
   fail = define_output_file();
   fail = write_quaddobl_target_system();
   fail = write_quaddobl_start_system();
   fail = write_quaddobl_start_solutions();
   printf("\n");
   fail = autotune_continuation_parameters(0,48);
   fail = tune_continuation_parameters();
   printf("\n");
   fail = determine_output_during_continuation();
   printf("\nSee the output file for results ...\n");
   fail = solve_by_quaddobl_homotopy_continuation();

   return fail;
}

int run_multprec_continuation ( void )
{
   int fail,deci;
   char ch;

   printf("\nCalling the multiprecision path trackers in PHCpack...\n");

   printf("-> give the number of decimal places : ");
   scanf("%d", &deci);
   scanf("%c",&ch);     /* skip new line */

   fail = read_multprec_target_system(deci);
   fail = read_multprec_start_system(deci);
   fail = define_output_file();
   fail = write_multprec_target_system();
   fail = write_multprec_start_system();
   fail = write_multprec_start_solutions();
   printf("\n");
   fail = autotune_continuation_parameters(0,deci);
   fail = tune_continuation_parameters();
   printf("\n");
   fail = determine_output_during_continuation();
   fail = solve_by_multprec_homotopy_continuation(deci);

   return fail;
}
