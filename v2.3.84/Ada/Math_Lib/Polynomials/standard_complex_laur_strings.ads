with String_Splitters;                   use String_Splitters;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Complex_Laurentials;       use Standard_Complex_Laurentials;
with Standard_Complex_Laur_Systems;      use Standard_Complex_Laur_Systems;

package Standard_Complex_Laur_Strings is

-- DESCRIPTION :
--   This package converts Laurent polynomials in several variables 
--   and with standard complex floating-point coefficients into strings,
--   and vice versa.

  procedure Read_Exponent ( s : in string; k : in out integer;
                            e : out integer32 );

  -- DESCRIPTION :
  --   Starts reading an integer number in the string at position k.

  -- ON ENTRY :
  --   s          string where s(k) is a digit;
  --   k          position to start the parsing.

  -- ON RETURN :
  --   k          position in s just after last digit read;
  --   e          value of the number read.

  procedure Parse ( s : in string; k : in out integer;
                    n : in natural32; p : in out Poly );

  -- DESCRIPTION :
  --   Parses the string s for a polynomial p in n variables,
  --   starting at s(k).

  function Parse ( n : natural32; s : string ) return Poly;

  -- DESCRIPTION :
  --   This function returns a polynomial in n variables,
  --   as a result of parsing the string s.

  function Parse ( n,m : natural32; s : string ) return Laur_Sys;

  -- DESCRIPTION :
  --   Returns a system of n polynomials in m variables.

  function Parse ( m : natural32; s : Array_of_Strings ) return Laur_Sys;

  -- DESCRIPTION :
  --   Parses the strings in s into polynomials in m variables.

  function Write ( p : Poly ) return string;

  -- DESCRIPTION :
  --   This function writes the polynomial to a string.

  function Write ( p : Laur_Sys ) return string;

  -- DESCRIPTION :
  --   This function writes the polynomial system to a string.

end Standard_Complex_Laur_Strings;
