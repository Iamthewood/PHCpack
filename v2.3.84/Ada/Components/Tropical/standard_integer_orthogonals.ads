with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer64_Vectors;         use Standard_Integer64_Vectors;
with Standard_Integer64_Matrices;        use Standard_Integer64_Matrices;

package Standard_Integer_Orthogonals is

-- DESCRIPTION :
--   Applies the Gram-Schmidt orthogonalization procedure
--   to a set of integer vectors.

  function gcd ( A : Matrix; k : integer ) return integer64;

  -- DESCRIPTION :
  --   Returns the greatest common divisor of the elements in
  --   the k-th column of A.

  procedure Normalize ( A : in out Matrix; k : in integer );

  -- DESCRIPTION :
  --   Divides all entries in the k-th column of A
  --   by their greatest common divisor.

  function Orthogonalize ( A : Matrix ) return Matrix;

  -- DESCRIPTION :
  --   Returns an orthogonal basis of the space spanned by 
  --   the vectors in the columns of A.

  function Complement ( A : Matrix ) return Vector;

  -- DESCRIPTION :
  --   Returns one vector perpendicular to the columns of A.

end Standard_Integer_Orthogonals;
