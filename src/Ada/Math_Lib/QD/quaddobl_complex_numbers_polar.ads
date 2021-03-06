with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with QuadDobl_Complex_Numbers;           use QuadDobl_Complex_Numbers;

package QuadDobl_Complex_Numbers_Polar is

-- DESCRIPTION :
--   Offers a polar view on the quad double complex numbers.

  function Radius ( c : Complex_Number ) return quad_double;

  -- DESCRIPTION :
  --   Returns the radius of the complex number.

  function Angle ( c : Complex_Number ) return quad_double;

  -- DESCRIPTION :
  --   Returns the angle of the complex number.

  function Root ( c : Complex_Number; n,i : natural32 ) return Complex_Number;

  -- DESCRIPTION :
  --   Returns the ith root of the equation x^n - c = 0.

end QuadDobl_Complex_Numbers_Polar;
