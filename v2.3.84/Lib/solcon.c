/* This file "solcon.c" contains the prototypes of the operations
 * declared in "solcon.h". */

#include <stdio.h>

extern void adainit( void );
extern int _ada_use_c2phc ( int task, int *a, int *b, double *c );
extern void adafinal( void );

int solcon_read_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(30,a,b,c);
   return fail;
}

int solcon_read_dobldobl_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(340,a,b,c);
   return fail;
}

int solcon_read_quaddobl_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(390,a,b,c);
   return fail;
}

int solcon_write_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(31,a,b,c);
   return fail;
}

int solcon_write_dobldobl_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(341,a,b,c);
   return fail;
}

int solcon_write_quaddobl_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(391,a,b,c);
   return fail;
}

int solcon_number_of_solutions ( int *length )
{
   int *a,fail;
   double *c;
   fail = _ada_use_c2phc(32,a,length,c);
   return fail;
}

int solcon_number_of_dobldobl_solutions ( int *length )
{
   int *a,fail;
   double *c;
   fail = _ada_use_c2phc(342,a,length,c);
   return fail;
}

int solcon_number_of_quaddobl_solutions ( int *length )
{
   int *a,fail;
   double *c;
   fail = _ada_use_c2phc(392,a,length,c);
   return fail;
}

int solcon_dimension_of_solutions ( int *dimension )
{
   int *a,fail;
   double *c;
   fail = _ada_use_c2phc(33,a,dimension,c);
   return fail;
}

int solcon_dimension_of_dobldobl_solutions ( int *dimension )
{
   int *a,fail;
   double *c;
   fail = _ada_use_c2phc(343,a,dimension,c);
   return fail;
}

int solcon_dimension_of_quaddobl_solutions ( int *dimension )
{
   int *a,fail;
   double *c;
   fail = _ada_use_c2phc(393,a,dimension,c);
   return fail;
}

int solcon_retrieve_solution ( int n, int k, int *m, double *sol )
{
   int fail;
   fail = _ada_use_c2phc(34,&k,m,sol);
   return fail;
}

int solcon_retrieve_dobldobl_solution ( int n, int k, int *m, double *sol )
{
   int fail;
   fail = _ada_use_c2phc(344,&k,m,sol);
   return fail;
}

int solcon_retrieve_quaddobl_solution ( int n, int k, int *m, double *sol )
{
   int fail;
   fail = _ada_use_c2phc(394,&k,m,sol);
   return fail;
}

int solcon_replace_solution ( int n, int k, int m, double *sol )
{
   int b[2],fail;
   b[0] = n;
   b[1] = m;
   fail = _ada_use_c2phc(35,&k,b,sol);
   return fail;
}

int solcon_append_solution ( int n, int m, double *sol )
{
   int *a,fail;
   int b[2];
   b[0] = n;
   b[1] = m;
   fail = _ada_use_c2phc(36,a,b,sol);
   return fail;
}

int solcon_append_dobldobl_solution ( int n, int m, double *sol )
{
   int *a,fail;
   int b[2];
   b[0] = n;
   b[1] = m;
   fail = _ada_use_c2phc(346,a,b,sol);
   return fail;
}

int solcon_append_quaddobl_solution ( int n, int m, double *sol )
{
   int *a,fail;
   int b[2];
   b[0] = n;
   b[1] = m;
   fail = _ada_use_c2phc(396,a,b,sol);
   return fail;
}

int solcon_clear_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(37,a,b,c);
   return fail;
}

int solcon_clear_dobldobl_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(347,a,b,c);
   return fail;
}

int solcon_clear_quaddobl_solutions ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(397,a,b,c);
   return fail;
}

int solcon_open_solution_input_file ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(130,a,b,c);
   return fail;
}

int solcon_create_solution_output_file ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(131,a,b,c);
   return fail;
}

int solcon_scan_solution_banner ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(132,a,b,c);
   return fail;
}

int solcon_write_solution_banner_to_defined_output_file ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(139,a,b,c);
   return fail;
}

int solcon_read_solution_dimensions ( int *len, int *dim )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(133,len,dim,c);
   return fail;
}

int solcon_write_solution_dimensions ( int len, int dim )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(134,&len,&dim,c);
   return fail;
}

int solcon_write_solution_dimensions_to_defined_output_file
      ( int len, int dim )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(140,&len,&dim,c);
   return fail;
}

int solcon_compute_total_degree_solution
      ( int n, int i, int *m, double *sol )
{
   int fail,a[2];

   a[0] = n;
   a[1] = i;

   fail = _ada_use_c2phc(142,a,m,sol);

   return fail;
}

int solcon_next_linear_product_solution
      ( int n, int *i, int *m, double *sol )
{
   int fail,a[2];

   a[0] = n,
   a[1] = *i;

   fail = _ada_use_c2phc(143,a,m,sol);

   *i = a[1];

   return fail;
}

int solcon_get_linear_product_solution
      ( int n, int i, int *m, double *sol )
{
   int fail,a[2];

   a[0] = n,
   a[1] = i;

   fail = _ada_use_c2phc(144,a,m,sol);

   return fail;
}

int solcon_read_next_solution ( int n, int *m, double *sol )
{
   int fail;
   fail = _ada_use_c2phc(135,&n,m,sol);
   return fail;
}

int solcon_read_next_witness_point ( int k, int n, int *m, double *sol )
{
   int fail,a[2];

   a[0] = k;
   a[1] = n;
   fail = _ada_use_c2phc(145,a,m,sol);
   return fail;
}

int solcon_extrinsic_product
      ( int a, int b, int n1, int n2, double *s1, double *s2,
        int pn, double *ps )
{
   int i,inds1;

   ps[0] = 0.0; ps[1] = 0.0;

   for(i=2; i<2*(n1-a)+2; i++) ps[i] = s1[i];

   inds1 = 2*(n1-a);
   for(i=2; i<2*(n2-b)+2; i++) ps[inds1+i] = s2[i];

   i=inds1+i;
   while (i<2*pn+5) ps[i++] = 0.0;

   return 0;
}

int add_one_to_double_loop_counters ( int *i, int *j, int n, int m )
{
   if(++(*j) >= m)
   {
      *j = 0;
      (*i)++;
   }
   return ( (*i) >= n ? 1 : 0);
}

int get_next_start_product
      ( int *i, int *j, int monitor,
        int n1, int n2, int dim1, int dim2, int deg1, int deg2, int cd, 
        double *sol1, double *sol2, double *ps )
{
   int fail,m,done,dim,deg;

   if(dim1 >= dim2)
   {
      if(((*i) == 0) && ((*j) == 0))
         fail = solcon_read_next_witness_point(1,n1,&m,sol1);
      fail = solcon_read_next_witness_point(2,n2,&m,sol2);
      fail = solcon_extrinsic_product(dim1,dim2,n1,n2,sol1,sol2,cd,ps);
      done = add_one_to_double_loop_counters(i,j,deg1,deg2);
      if((*j == 0) && (done == 0))
      {
         fail = solcon_read_next_witness_point(1,n1,&m,sol1);
         fail = solcon_reset_input_file(2,&deg,&dim);
         if(monitor == 1)
            printf("after resetting 2 : n = %d  degree = %d\n",dim,deg);
      }
   }
   else
   {
      if(((*i) == 0) && ((*j) == 0))
         fail = solcon_read_next_witness_point(2,n2,&m,sol2);
      fail = solcon_read_next_witness_point(1,n1,&m,sol1);
      fail = solcon_extrinsic_product(dim2,dim1,n2,n1,sol2,sol1,cd,ps);
      done = add_one_to_double_loop_counters(j,i,deg2,deg1);
      if((*i == 0) && (done == 0))
      {
         fail = solcon_read_next_witness_point(2,n2,&m,sol2);
         fail = solcon_reset_input_file(1,&deg,&dim);
         if(monitor == 1)
            printf("after resetting 1 : n = %d  degree = %d\n",dim,deg);
      }
   }
   return (fail && done);
}

int solcon_reset_input_file ( int k, int *d, int *n )
{
   int fail,b[2];
   double *c;

   fail = _ada_use_c2phc(167,&k,b,c);
   *d = b[0];
   *n = b[1];

   return fail;
}

int solcon_write_next_solution ( int *k, int n, int m, double *sol )
{
   int b[2],fail;
   b[0] = n;
   b[1] = m;
   fail = _ada_use_c2phc(136,k,b,sol);
   return fail;
}

int solcon_write_next_solution_to_defined_output_file
       ( int *k, int n, int m, double *sol )
{
   int b[2],fail;
   b[0] = n;
   b[1] = m;
   fail = _ada_use_c2phc(141,k,b,sol);
   return fail;
}

int solcon_close_solution_input_file ( int k )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(137,&k,b,c);
   return fail;
}

int solcon_close_solution_output_file ( void )
{
   int *a,*b,fail;
   double *c;
   fail = _ada_use_c2phc(138,a,b,c);
   return fail;
}

int solcon_length_solution_string ( int k, int *n )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(200,&k,n,c);
   return fail;
}

int solcon_length_dobldobl_solution_string ( int k, int *n )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(370,&k,n,c);
   return fail;
}

int solcon_length_quaddobl_solution_string ( int k, int *n )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(420,&k,n,c);
   return fail;
}

int solcon_write_solution_string ( int k, int n, char *s )
{
   int a[2],b[n],fail,i;
   double *c;
   a[0] = k; a[1] = n;
   fail = _ada_use_c2phc(201,a,b,c);
   for(i=0; i<n; i++) s[i] = b[i];
   s[n] = '\0';
   return fail;
}

int solcon_write_dobldobl_solution_string ( int k, int n, char *s )
{
   int a[2],b[n],fail,i;
   double *c;
   a[0] = k; a[1] = n;
   fail = _ada_use_c2phc(371,a,b,c);
   for(i=0; i<n; i++) s[i] = b[i];
   s[n] = '\0';
   return fail;
}

int solcon_write_quaddobl_solution_string ( int k, int n, char *s )
{
   int a[2],b[n],fail,i;
   double *c;
   a[0] = k; a[1] = n;
   fail = _ada_use_c2phc(421,a,b,c);
   for(i=0; i<n; i++) s[i] = b[i];
   s[n] = '\0';
   return fail;
}

int solcon_length_solution_intro ( int k, int *n )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(202,&k,n,c);
   return fail;
}

int solcon_write_solution_intro ( int k, int n, char *s )
{
   int a[2],b[n],fail,i;
   double *c;
   a[0] = k; a[1] = n;
   fail = _ada_use_c2phc(203,a,b,c);
   for(i=0; i<n; i++) s[i] = b[i];
   s[n] = '\0';
   return fail;
}

int solcon_length_solution_vector ( int k, int *n )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(204,&k,n,c);
   return fail;
}

int solcon_write_solution_vector ( int k, int n, char *s )
{
   int a[2],b[n],fail,i;
   double *c;
   a[0] = k; a[1] = n;
   fail = _ada_use_c2phc(205,a,b,c);
   for(i=0; i<n; i++) s[i] = b[i];
   s[n] = '\0';
   return fail;
}

int solcon_length_solution_diagnostics ( int k, int *n )
{
   int fail;
   double *c;
   fail = _ada_use_c2phc(206,&k,n,c);
   return fail;
}

int solcon_write_solution_diagnostics ( int k, int n, char *s )
{
   int a[2],b[n],fail,i;
   double *c;
   a[0] = k; a[1] = n;
   fail = _ada_use_c2phc(207,a,b,c);
   for(i=0; i<n; i++) s[i] = b[i];
   s[n] = '\0';
   return fail;
}

int solcon_append_solution_string ( int nv, int nc, char *s )
{
   int a[2], b[nc],fail,i;
   double *c;

   a[0] = nv; a[1] = nc;
   for(i=0; i<nc; i++) b[i] = s[i];
   fail = _ada_use_c2phc(208,a,b,c);
   return fail;
}

int solcon_append_dobldobl_solution_string ( int nv, int nc, char *s )
{
   int a[2], b[nc],fail,i;
   double *c;

   a[0] = nv; a[1] = nc;
   for(i=0; i<nc; i++) b[i] = s[i];
   fail = _ada_use_c2phc(378,a,b,c);
   return fail;
}

int solcon_append_quaddobl_solution_string ( int nv, int nc, char *s )
{
   int a[2], b[nc],fail,i;
   double *c;

   a[0] = nv; a[1] = nc;
   for(i=0; i<nc; i++) b[i] = s[i];
   fail = _ada_use_c2phc(428,a,b,c);
   return fail;
}

int solcon_replace_solution_string ( int k, int nv, int nc, char *s )
{
   int a[3], b[nc],fail,i;
   double *c;
   a[0] = k; a[1] = nv; a[2] = nc;
   for(i=0; i<nc; i++) b[i] = s[i];
   fail = _ada_use_c2phc(209,a,b,c);
   return fail;
}

int solcon_standard_drop_coordinate_by_index ( int k )
{ 
   int fail,*b;
   double *c;
   fail = _ada_use_c2phc(38,&k,b,c);
   return fail;
}

int solcon_standard_drop_coordinate_by_name ( int nc, char *s )
{ 
   int fail,i;
   int b[nc];
   double *c;
   for(i=0; i<nc; i++) b[i] = (int) s[i];
   fail = _ada_use_c2phc(146,&nc,b,c);
   return fail;
}

int solcon_dobldobl_drop_coordinate_by_index ( int k )
{ 
   int fail,*b;
   double *c;
   fail = _ada_use_c2phc(348,&k,b,c);
   return fail;
}

int solcon_dobldobl_drop_coordinate_by_name ( int nc, char *s )
{ 
   int fail,i;
   int b[nc];
   double *c;
   for(i=0; i<nc; i++) b[i] = (int) s[i];
   fail = _ada_use_c2phc(349,&nc,b,c);
   return fail;
}

int solcon_quaddobl_drop_coordinate_by_index ( int k )
{ 
   int fail,*b;
   double *c;
   fail = _ada_use_c2phc(398,&k,b,c);
   return fail;
}

int solcon_quaddobl_drop_coordinate_by_name ( int nc, char *s )
{ 
   int fail,i;
   int b[nc];
   double *c;
   for(i=0; i<nc; i++) b[i] = (int) s[i];
   fail = _ada_use_c2phc(399,&nc,b,c);
   return fail;
}
