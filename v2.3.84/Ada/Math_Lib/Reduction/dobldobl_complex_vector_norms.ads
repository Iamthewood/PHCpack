with Double_Double_Numbers;              use Double_Double_Numbers;
with DoblDobl_Complex_Vectors;           use DoblDobl_Complex_Vectors;

package DoblDobl_Complex_Vector_Norms is

-- DESCRIPTION :
--   Provides function to compute various norms of vectors
--   of complex double doubles.

  function Norm2 ( v : Vector ) return double_double;

  -- DESCRIPTION :
  --   Returns the 2-norm of the complex vector v.

  function Sum_Norm ( v : Vector ) return double_double;

  -- DESCRIPTION :
  --   Returns the sum of all absolute values of the components of v.

  function Max_Norm ( v : Vector ) return double_double;

  -- DESCRIPTION :
  --   Returns the absolute value of the largest element in v.

end DoblDobl_Complex_Vector_Norms;
