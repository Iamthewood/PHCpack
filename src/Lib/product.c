/* file product.c contains definitions of the prototypes of product.h */

#include <stdio.h>

extern void adainit( void );
extern int _ada_use_c2phc ( int task, int *a, int *b, double *c );
extern void adafinal( void );

int supporting_set_structure ( void )
{
   int fail,*a,*b;
   double *c;

   fail = _ada_use_c2phc(110,a,b,c);

   return fail;
}

int write_set_structure ( void )
{
   int fail,*a,*b;
   double *c;

   fail = _ada_use_c2phc(111,a,b,c);

   return fail;
}

int set_structure_string ( int *nc, char *s )
{
   int fail,i;
   int buffer[1024];
   double *c;

   fail = _ada_use_c2phc(116,nc,buffer,c);

   for(i=0; i<*nc; i++)
      s[i] = (char) buffer[i];
   s[*nc] = '\0';

   return fail;
}

int parse_set_structure ( int nc, char *s )
{
   int fail,i;
   int buffer[nc];
   double *c;

   for(i=0; i<nc; i++)
      buffer[i] = (int) s[i];

   fail = _ada_use_c2phc(117,&nc,buffer,c);

   return fail;
}

int is_set_structure_supporting ( int *inout )
{
   int fail,*b;
   double *c;

   fail = _ada_use_c2phc(118,inout,b,c);

   return fail;
}

int linear_product_root_count ( int *r )
{
   int fail,*b;
   double *c;

   fail = _ada_use_c2phc(112,r,b,c);

   return fail;
}

int random_linear_product_system ( void )
{
   int fail,*a,*b;
   double *c;

   fail = _ada_use_c2phc(113,a,b,c);

   return fail;
}

int solve_linear_product_system ( void )
{
   int fail,*a,*b;
   double *c;

   fail = _ada_use_c2phc(114,a,b,c);

   return fail;
}

int clear_set_structure ( void )
{
   int fail,*a,*b;
   double *c;

   fail = _ada_use_c2phc(115,a,b,c);

   return fail;
}

int m_homogeneous_Bezout_number ( int *bzn, int *ncp, char *partition )
{
   int fail,i;
   int sc[2];
   int sv[256];
   double *c;

   fail = _ada_use_c2phc(530,sc,sv,c);

   *bzn = sc[0];
   *ncp = sc[1]+1;
   for(i=0; i<sc[1]; i++)
      partition[i] = (char) sv[i];
   partition[sc[1]] = '\0';

   return fail;
}

int m_partition_Bezout_number ( int *bzn, int ncp, char *partition )
{
   int fail,i;
   int b[ncp];
   double *c;
   *bzn = ncp;

   for(i=0; i<ncp; i++) b[i] = (int) partition[i];

   fail = _ada_use_c2phc(531,bzn,b,c);

   return fail;
}

int m_homogeneous_start_system ( int ncp, char *partition )
{
   int fail,i;
   int b[ncp];
   double *c;

   for(i=0; i<ncp; i++) b[i] = (int) partition[i];

   fail = _ada_use_c2phc(532,&ncp,b,c);

   return fail;
}
