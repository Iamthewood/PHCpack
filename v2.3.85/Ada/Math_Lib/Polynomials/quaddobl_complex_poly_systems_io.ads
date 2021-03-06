with text_io;                           use text_io;
with QuadDobl_Complex_Poly_Systems;     use QuadDobl_Complex_Poly_Systems;

package QuadDobl_Complex_Poly_Systems_io is

-- DESCRIPTION :
--   This package provides basic input/output routines of polynomial systems
--   with quad double complex coefficients.

  procedure get ( p : out Link_to_Poly_Sys );
  procedure get ( file : in file_type; p : out Poly_Sys );
  procedure get ( file : in file_type; p : out Link_to_Poly_Sys );

  -- DESCRIPTION :
  --   Reads in a system with multiprecision coefficients and converts
  --   the result to a system with quad double complex coefficients.

  procedure put ( p : in Poly_Sys );
  procedure put ( file : in file_type; p : in Poly_Sys );

  -- DESCRIPTION :
  --   Writes the polynomials to screen or file.   
  --   The polynomials are separated by semicolons and a new line
  --   is started for each new polynomial.

  procedure put_line ( p : in Poly_Sys );
  procedure put_line ( file : in file_type; p : in Poly_Sys );

  -- DESCRIPTION :
  --   A new line is started for each new monomial.

end QuadDobl_Complex_Poly_Systems_io;
