with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Vectors;           use Standard_Integer_Vectors;
with Standard_Integer_VecVecs;           use Standard_Integer_VecVecs;
with Lists_of_Integer_Vectors;           use Lists_of_Integer_Vectors;

package Lists_of_Vectors_Utilities is

-- DESCRIPTION :
--   This package offers some utilities for working with
--   lists of integer vectors.

  procedure Compute_Normal ( v : in VecVec; n : out Link_to_Vector;
                             deg : out integer32 );

  function  Compute_Normal ( v : VecVec ) return Link_to_Vector;

  -- DESCRIPTION :
  --   Returns the normal vector to the space generated by the
  --   points in v.  If deg = 0, then more than one solution is possible.

  function Pointer_to_Last ( L : List ) return List;

  -- DESCRIPTION :
  --   Returns a pointer to the last element of the list.

  procedure Move_to_Front ( L : in out List; v : in Vector );

  -- DESCRIPTION :
  --   Searches the vector v in the list L.  When found, then this
  --   vector v is swapped with the first element of the list.

  function Difference ( L1,L2 : List ) return List;

  -- DESCRIPTION :
  --   Returns the list of points in L1 that do not belong to L2.

  function Different_Points ( L : List ) return List;

  -- DESCRIPTION :
  --   Returns a lists of all different points out of L.

  procedure Remove_Duplicates ( L : in out List );

  -- DESCRIPTION :
  --   Removes duplicate points out of the list L.

end Lists_of_Vectors_Utilities;
