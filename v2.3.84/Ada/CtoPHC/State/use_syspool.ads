with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;
with C_Double_Arrays;                   use C_Double_Arrays;

function use_syspool ( job : integer32;
                       a : C_intarrs.Pointer;
		       b : C_intarrs.Pointer;
                       c : C_dblarrs.Pointer ) return integer32;

-- DESCRIPTION :
--   Provides a gateway to the systems pool.

-- ON ENTRY :
--   job      = 0 : initialize system pool with n = a[0];
--            = 1 : get the size of the system pool returned in a[0];
--            = 2 : reads a system p iand with k = a[0], the data of p
--                  for the k-th system in the pool is created;
--            = 3 : writes the k-th system, with k = a[0];
--            = 4 : takes system of the container to create k-th system
--                  in the pool, k = a[0];
--            = 5 : refines a solution using the k-th system in the container,
--                  k = a[0], n = a[1], m = b[0] and c contains the floating
--                  part of the solution.
-- 
--   a        memory allocated a natural number, either the size
--            of the systems pool or the index of a system in the pool;
--   b        used to pass and return multiplicity of a solution;
--   c        for the floating-point numbers in a solution.

-- ON RETURN :
--   0 if the operation was successful, otherwise something went wrong,
--   or job not in the right range.