with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Quad_Double_Matrices;
with QuadDobl_Complex_Matrices;

package QuadDobl_Random_Matrices is

-- DESCRIPTION :
--   Offers routines to generate matrices of random quad doubles.

  function Random_Matrix ( n,m : natural32 )
                         return Quad_Double_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a matrix of range 1..n,1..m with random quad doubles.

  function Random_Matrix ( n,m : natural32 )
                         return QuadDobl_Complex_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a matrix of range 1..n,1..m
  --   with random complex quad double numbers.

end QuadDobl_Random_Matrices;
