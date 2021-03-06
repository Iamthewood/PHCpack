with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Integer_Vectors;
with Lists_of_Floating_Vectors;
with Arrays_of_Floating_Vector_Lists;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;
with Standard_Complex_Laur_Systems;      use Standard_Complex_Laur_Systems;

package Induced_Permutations is

-- DESCRIPTION :
--   This package provides tools to deal with supports, 
--   permuted by MixedVol and needed for processing with
--   the black box polyhedral homotopies and solver.

  procedure Remove_Artificial_Origin
              ( L : in out Lists_of_Floating_Vectors.List;
                b : in double_float );
  procedure Remove_Artificial_Origin
              ( L : in out Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                b : in double_float );

  -- DESCRIPTION :
  --   Removes the artificial origin from the lists L.
  --   The artificial origin has lifting value equal to b.

  function Is_Subset
             ( lifted,original : Lists_of_Floating_Vectors.List )
             return boolean;

  -- DESCRIPTION :
  --   Returns true if every point in lifted without its lifting
  --   belongs to the original list.

  function Permutation
             ( s,ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists;
               mix : Standard_Integer_Vectors.Vector )
             return Standard_Integer_Vectors.Vector;

  -- DESCRIPTION :
  --   Given lifted supports in ls ordered along type of mixture in mix,
  --   and the original supports in s, the vector p on return has s'range
  --   and p(k) is the new position of the k-th list in s for the 
  --   corresponding lifted support in ls to be a subset.
  --   In case of multiple correspondences, the smallest enclosing list
  --   of the lifted support is selected.

  procedure Permute ( p : in Standard_Integer_Vectors.Vector;
                      f : in out Poly_Sys );
  procedure Permute ( p : in Standard_Integer_Vectors.Vector;
                      f : in out Laur_Sys );

  -- DESCRIPTION :
  --   Applies the permutation p to the system f.

end Induced_Permutations;
