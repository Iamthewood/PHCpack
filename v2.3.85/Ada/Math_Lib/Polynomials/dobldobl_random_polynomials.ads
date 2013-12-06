with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with DoblDobl_Complex_Numbers;          use DoblDobl_Complex_Numbers;
with DoblDobl_Complex_Polynomials;      use DoblDobl_Complex_Polynomials;

package DoblDobl_Random_Polynomials is

-- DESCRIPTION :
--   This package provides some routines to generate random sparse
--   and dense polynomials in several variables and of various degrees.

  function Random_Coefficient ( c : natural32 ) return Complex_Number;
 
  -- DESCRIPTION :
  --   Returns a coefficient for a monomial, as follows:
  --     c = 0 : on complex unit circle (this is default);
  --     c = 1 : the constant one (useful for templates);
  --     c = 2 : a random float between -1.0 and +1.0.

  function Random_Monomial ( n,d : natural32 ) return Term;

  -- DESCRIPTION :
  --   Returns one random monomial in n variables of degree <= d.
  --   The coefficient equals one.

  function Random_Term ( n,d,c : natural32 ) return Term;

  -- DESCRIPTION :
  --   Returns a random term of n variables and with degree <= d,
  --   and coefficient generated by Random_Coefficient(c).

  function Random_Dense_Poly ( n,d,c : natural32 ) return Poly;

  -- DESCRIPTION :
  --   Returns a dense polynomial of degree d in n variables, with
  --   all monomials up to degree d have a nonzero coefficient,
  --   generated by Random_Coefficient(c).

  function Random_Sparse_Poly ( n,d,m,c : natural32 ) return Poly;

  -- DESCRIPTION :
  --   Returns a sparse polynomial of degree d in n variables, where no
  --   more than m monomials of degree <= d have a nonzero coefficient,
  --   generated by Random_Coefficient(c).

end DoblDobl_Random_Polynomials;