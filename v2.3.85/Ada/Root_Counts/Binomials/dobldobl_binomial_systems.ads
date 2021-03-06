with Standard_Integer_Numbers;         use Standard_Integer_Numbers;
with DoblDobl_Complex_Vectors;         use DoblDobl_Complex_Vectors;
with Standard_Integer64_Matrices;      use Standard_Integer64_Matrices;
with DoblDobl_Complex_Solutions;       use DoblDobl_Complex_Solutions;
with DoblDobl_Complex_Poly_Systems;    use DoblDobl_Complex_Poly_Systems;
with DoblDobl_Complex_Laur_Systems;    use DoblDobl_Complex_Laur_Systems;

package DoblDobl_Binomial_Systems is

-- DESCRIPTION :
--   A binomial system is a system with exactly two terms with nonzero
--   (standard complex) coefficient in every equation.
--   We represent a binomial system as x^A - c = 0, where the matrix A
--   contains in its columns the exponent vector of the unknowns in x.
--   This package offers functions to define and evaluate a binomial system.

-- FORMAT of a BINOMIAL SYSTEM :  p(x) = 0 => x^A = c

  procedure Parse ( p : in Poly_Sys; nq : in integer32;
                    A : out Matrix; c : out Vector; fail : out boolean );

  procedure Parse ( p : in Laur_Sys; nq : in integer32;
                    A : out Matrix; c : out Vector; fail : out boolean );

  -- DESCRIPTION :
  --   Parses the equations of p into the format x^A = c.

  -- REQUIRED :
  --   p'range = A'range(2) = c'range = 1..nq, nq = #equations;
  --   A'range(1) = 1..nv, nv = #equations.

  -- ON ENTRY :
  --   p        a polynomial system, not necessarily square;
  --   nq       number of equations in p.

  -- ON RETURN :
  --   A        the exponent vectors in the columns, if not fail;
  --   c        coefficient vector, if not fail;
  --   fail     true if not exactly two monomials in every equation,
  --            false otherwise.

  function Create ( A : Matrix; c : Vector ) return Poly_Sys;
  function Create ( A : Matrix; c : Vector ) return Laur_Sys;

  -- DESCRIPTION :
  --   Returns the system p(x) = x^A - c = 0,
  --   modulo monomial multiplications to avoid negative exponents.

  -- REQUIRED : A'range(2) = c'range.

-- EVALUATION of a BINOMIAL SYSTEM :

  function Eval ( A : Matrix; x : Vector ) return Vector;

  -- DESCRIPTION : returns x^A.

  function Eval ( A : Matrix; c,x : Vector ) return Vector;

  -- DESCRIPTION : returns x^A - c.

  function Eval ( A : Matrix; s : Solution_List ) return Solution_List;

  -- DESCRIPTION :
  --   The solutions on return are vectors Eval(A,x), for all x in s.

end DoblDobl_Binomial_Systems;
