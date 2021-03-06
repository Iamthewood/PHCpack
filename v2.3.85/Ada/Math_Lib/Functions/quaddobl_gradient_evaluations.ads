with Standard_Natural_Vectors;
with Standard_Natural_VecVecs;
with QuadDobl_Complex_Vectors;
with QuadDobl_Complex_VecVecs;

package QuadDobl_Gradient_Evaluations is

-- DESCRIPTION :
--   This package offers routines to evaluate a polynomial in several
--   variables with quad double complex coefficients and to compute its
--   gradient, the vector of all partial derivatives.

  procedure Split_Common_Factor
              ( e : in Standard_Natural_Vectors.Vector;
                f,b : out Standard_Natural_Vectors.Vector );

  -- DESCRIPTION :
  --   Splits the exponent vector e into a common factor f
  --   and a bit vector b of zeroes and ones.
  --   For all i in e'range: e(i) = f(i) + b(i), b(i) is 0 or 1.

  -- REQUIRED : f'range = b'range = e'range.

  procedure Split_Common_Factors
              ( e : in Standard_Natural_VecVecs.VecVec;
                f,b : out Standard_Natural_VecVecs.VecVec );

  -- DESCRIPTION :
  --   Splits the exponents vectors in e into common factors f
  --   and bit vectors b.

  -- REQUIRED : f'range = b'range = e'range.

  function Reverse_Speel
              ( b : Standard_Natural_VecVecs.VecVec;
                x : QuadDobl_Complex_Vectors.Vector )
              return QuadDobl_Complex_VecVecs.VecVec;

  -- DESCRIPTION :
  --   Evaluates the monomials defined by the exponent vectors in b
  --   at x, returning the function value and the gradient of the
  --   monomials at x.  On returns, the vectors are of range 0..x'last,
  --   the 0-th position holds the function value and the i-th position
  --   contains the derivative with respect to the i-th variable at x.

  -- REQUIRED : the vectors in b are 0/1 vectors.

  function Gradient_Monomials
             ( f,b : Standard_Natural_VecVecs.VecVec;
               x : QuadDobl_Complex_Vectors.Vector )
             return QuadDobl_Complex_VecVecs.VecVec;

  -- DESCRIPTION :
  --   Applies the reverse mode to compute the gradient of the Speelpenning
  --   products defined by the vectors in b and multiplies the results with
  --   the factors in f, all evaluated at x.

  function Gradient_Sum_of_Monomials
             ( f,b : Standard_Natural_VecVecs.VecVec;
               x : QuadDobl_Complex_Vectors.Vector )
             return QuadDobl_Complex_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns the evaluation of the sum of the monomials defined by the
  --   Speelpenning products in b and common factors in f, evaluated at x,
  --   along with the gradient vectors.  The range of the vector on return
  --   is 0..x'last with its 0-th component the function value and the i-th
  --   component the i-th derivative of the sum at x.
  --   Note: this evaluation corresponds to a polynomial where all
  --   coefficients are equal to one.

  function Gradient_of_Polynomial
             ( f,b : Standard_Natural_VecVecs.VecVec;
               c,x : QuadDobl_Complex_Vectors.Vector )
             return QuadDobl_Complex_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns the value of the polynomial and its gradient at x,
  --   with exponents in f, b, and coefficients in c.

end QuadDobl_Gradient_Evaluations;
