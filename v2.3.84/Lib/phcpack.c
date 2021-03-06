/* file phcpack.c contains the definitions of the functions in phcpack.h */

#include<stdlib.h>
#include<stdio.h>
#include<math.h>

#define v 0 /* verbose flag */

extern void adainit( void );
extern int _ada_use_c2phc ( int task, int *a, int *b, double *c );
extern void adafinal( void );

/* most BASIC operations in PHCpack : */

int version_string ( int *n, char *s )
{
   int fail,i;
   int b[40];
   double *c;

   fail = _ada_use_c2phc(999,n,b,c);

   for(i=0; i<(*n); i++) s[i] = (char) b[i];
   s[*n+1] = '\0';

   return fail;
}

int set_seed ( int seed )
{
   int *b,fail;
   double *c;

   fail = _ada_use_c2phc(998,&seed,b,c);

   return fail;
}

int solve_system ( int *root_count )
{
   int *b,fail;
   double *c;
   fail = _ada_use_c2phc(77,root_count,b,c);
   return fail;
}

int solve_Laurent_system ( int *root_count, int silent )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(75,root_count,&silent,c);
   return fail;
}

int mixed_volume ( int *mv )
{
   int *b,fail;
   double *c;
   fail = _ada_use_c2phc(78,mv,b,c);
   return fail;
}

int stable_mixed_volume ( int *mv, int *smv )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(79,mv,smv,c);
   return fail;
}

int deflate ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(196,a,b,c);
   return fail;
}

int Newton_step ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(199,a,b,c);
   return fail;
}

int dobldobl_Newton_step ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(198,a,b,c);
   return fail;
}

int quaddobl_Newton_step ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(197,a,b,c);
   return fail;
}

/* wrapping the operations from C_to_PHCpack */

int read_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(11,a,b,c);
   return fail;
}

int read_dobldobl_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(231,a,b,c);
   return fail;
}

int read_quaddobl_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(241,a,b,c);
   return fail;
}

int write_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(12,a,b,c);
   return fail;
}

int write_dobldobl_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(232,a,b,c);
   return fail;
}

int write_quaddobl_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(242,a,b,c);
   return fail;
}

int read_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(13,a,b,c);
   return fail;
}

int read_dobldobl_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(233,a,b,c);
   return fail;
}

int read_quaddobl_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(243,a,b,c);
   return fail;
}

int write_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(14,a,b,c);
   return fail;
}

int write_dobldobl_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(234,a,b,c);
   return fail;
}

int write_quaddobl_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(244,a,b,c);
   return fail;
}

int write_start_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(15,a,b,c);
   return fail;
}

int write_dobldobl_start_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(235,a,b,c);
   return fail;
}

int write_quaddobl_start_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(245,a,b,c);
   return fail;
}

int tune_continuation_parameters ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(70,a,b,c);
   return fail;
}

int determine_output_during_continuation ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(71,a,b,c);
   return fail;
}

int retrieve_continuation_parameters ( double *c )
{
   int *a,*b,fail;
   fail = _ada_use_c2phc(72,a,b,c);
   return fail;
}

int set_continuation_parameters ( double *c )
{
   int *a,*b,fail;
   fail = _ada_use_c2phc(73,a,b,c);
   return fail;
}

int autotune_continuation_parameters
 ( int difficulty_level, int digits_of_precision )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(193,&difficulty_level,&digits_of_precision,c);
   return fail;
}

int show_continuation_parameters ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(194,a,b,c);
   return fail;
}

int create_homotopy ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(152,a,b,c);
   return fail;
}

int create_dobldobl_homotopy ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(172,a,b,c);
   return fail;
}

int create_quaddobl_homotopy ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(182,a,b,c);
   return fail;
}

int create_homotopy_with_given_gamma ( double gamma_re, double gamma_im )
{
   int *a,*b,fail;
   double c[2];
   c[0] = gamma_re; c[1] = gamma_im;
   fail = _ada_use_c2phc(153,a,b,c);
   return fail;
}

int create_dobldobl_homotopy_with_given_gamma
 ( double gamma_re, double gamma_im )
{
   int *a,*b,fail;
   double c[2];
   c[0] = gamma_re; c[1] = gamma_im;
   fail = _ada_use_c2phc(173,a,b,c);
   return fail;
}

int create_quaddobl_homotopy_with_given_gamma
 ( double gamma_re, double gamma_im )
{
   int *a,*b,fail;
   double c[2];
   c[0] = gamma_re; c[1] = gamma_im;
   fail = _ada_use_c2phc(183,a,b,c);
   return fail;
}

int clear_homotopy ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(154,a,b,c);
   return fail;
}

int refine_root ( int n, int *m, double *c )
{
   int *a,fail;
   int b[2];

   b[0] = n; b[1] = *m;
   fail = _ada_use_c2phc(149,a,b,c);
   *m = b[1];

   return fail;
}

int solve_by_homotopy_continuation ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(16,a,b,c);
   return fail;
}

int solve_by_dobldobl_homotopy_continuation ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(236,a,b,c);
   return fail;
}

int solve_by_quaddobl_homotopy_continuation ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(246,a,b,c);
   return fail;
}

int write_target_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(17,a,b,c);
   return fail;
}

int write_dobldobl_target_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(237,a,b,c);
   return fail;
}

int write_quaddobl_target_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(247,a,b,c);
   return fail;
}

int clear_data ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(18,a,b,c);
   return fail;
}

int clear_dobldobl_data ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(238,a,b,c);
   return fail;
}

int clear_quaddobl_data ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(248,a,b,c);
   return fail;
}

int define_output_file ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(19,a,b,c);
   return fail;
}

int define_output_file_with_string ( int n, char *s )
{
   int i,b[n],fail;
   double *c;
   for(i=0; i<n; i++) b[i] = (int) s[i];
   fail = _ada_use_c2phc(191,&n,b,c);
   return fail;
}

int close_output_file ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(192,a,b,c);
   return fail;
}

int write_string_to_defined_output_file ( int n, char *s )
{
   int i,b[n],fail;
   double *c;

   for(i=0; i<n; i++) b[i] = (int) s[i];

   fail = _ada_use_c2phc(158,&n,b,c);

   return fail;
}

int write_integers_to_defined_output_file ( int n, int *a )
{
   int i,fail;
   double *c;

   fail = _ada_use_c2phc(159,&n,a,c);

   return fail;
}

int write_doubles_to_defined_output_file ( int n, double *a )
{
   int i,*b,fail;

   fail = _ada_use_c2phc(160,&n,b,a);

   return fail;
}

/* TRANSFER of data between PHCpack and the containers : */

int copy_target_system_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(1,a,b,c);
   return fail;
}

int copy_dobldobl_target_system_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(251,a,b,c);
   return fail;
}

int copy_quaddobl_target_system_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(261,a,b,c);
   return fail;
}

int copy_container_to_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(2,a,b,c);
   return fail;
}

int copy_dobldobl_container_to_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(252,a,b,c);
   return fail;
}

int copy_quaddobl_container_to_target_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(262,a,b,c);
   return fail;
}

int copy_start_system_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(3,a,b,c);
   return fail;
}

int copy_dobldobl_start_system_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(253,a,b,c);
   return fail;
}

int copy_quaddobl_start_system_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(263,a,b,c);
   return fail;
}

int copy_container_to_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(4,a,b,c);
   return fail;
}

int copy_dobldobl_container_to_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(254,a,b,c);
   return fail;
}

int copy_quaddobl_container_to_start_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(264,a,b,c);
   return fail;
}

int copy_target_solutions_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(5,a,b,c);
   return fail;
}

int copy_dobldobl_target_solutions_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(255,a,b,c);
   return fail;
}

int copy_quaddobl_target_solutions_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(265,a,b,c);
   return fail;
}

int copy_container_to_target_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(6,a,b,c);
   return fail;
}

int copy_dobldobl_container_to_target_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(256,a,b,c);
   return fail;
}

int copy_quaddobl_container_to_target_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(266,a,b,c);
   return fail;
}

int copy_start_solutions_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(7,a,b,c);
   return fail;
}

int copy_dobldobl_start_solutions_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(257,a,b,c);
   return fail;
}

int copy_quaddobl_start_solutions_to_container ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(267,a,b,c);
   return fail;
}

int copy_container_to_start_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(8,a,b,c);
   return fail;
}

int copy_dobldobl_container_to_start_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(258,a,b,c);
   return fail;
}

int copy_quaddobl_container_to_start_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(268,a,b,c);
   return fail;
}

/* OPERATIONS on data in the containers : */

int validate_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(9,a,b,c);
   return fail;
}

int print_system ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(21,a,b,c);
   return fail;
}
