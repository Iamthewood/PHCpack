with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;
with C_Double_Arrays;                   use C_Double_Arrays;

function use_celcon ( job : integer32;
                      a : C_intarrs.Pointer;
                      b : C_intarrs.Pointer;
                      c : C_dblarrs.Pointer ) return integer32;

-- DESCRIPTION :
--   Provides a gateway to the cells container.

-- ON ENTRY :
--   job      =  0 : read mixed-cell configuration from file,
--                   and initializes the container;
--            =  1 : writes the mixed-cell configuration in the container;
--            =  2 : returns in a the number of cells in the container;
--            =  3 : returns in a the dimension of the lifted points
--                   in the container;
--            =  4 : returns in a the number of different supports
--                   and in b the number of occurrences of support;
--            =  5 : returns in a the number of different supports
--                   and in b the number of points in each support;
--            =  6 : returns in c the point of support a on place b;
--            =  7 : returns the inner normal in c for cell number in a;
--            =  8 : returns in b the number of points of each support
--                   in cell number a;
--            =  9 : given in a the cell number and with b = (i,j),
--                   returns in c the j-th point from the i-th list.
--            = 10 : returns in b the mixed volume of the cell a;
--            = 11 : sets the number of different supports to a[0],
--                   and in b[i] the number of occurrences of the
--                   (i+1)-th support list;
--            = 12 : appends the point in c to the i-th support, i = a[0],
--                   b[0] must contain the length of the point;
--            = 13 : appends a mixed cell to the cells container,
--                   a[0] = number of different supports, r = a[0],
--                   a[1] = dimension of the lifted points, n = a[1],
--                   a[2] = length of the vector b,
--                   b[0] = total number of points in the cell,
--                   b[k] = number of points in k-th support,
--                   b[1+r+k] = label for the k-th point in cell,
--                   c = coordinates for the inner normal to the cell;
--            = 14 : clears the cell container;
--            = 15 : retrieves a mixed cell from the cell container,
--                   on entry: a[0] = number of the cell, on return
--                   are b and c, like in job 13, i.e.:
--                   b[0] = total number of points in the cell,
--                   b[k] = number of points in k-th support,
--                   b[1+r+k] = label for the k-th point in cell,
--                   c = coordinates for the inner normal to the cell.
--            = 16 : creates a random coefficient system, using the
--                   type of mixture and supports in the cells container;
--            = 17 : prompts the user for a polynomial system and stores it
--                   as random coefficient system in the cells container;
--            = 18 : writes the random coefficient system to the output;
--            = 19 : copy random coefficient system to systems container;
--            = 20 : copy system in systems container to cells container;
--            = 21 : create a polyhedral homotopy to solve a random system;
--            = 22 : solve start system corresponding with the k-th cell,
--                   where k is given on input as the value of a,
--                   on return in b is the number of solutions found;
--            = 23 : track the path starting at the i-th start solution 
--                   corresponding to the k-th mixed cell, on entry:
--                   a[0] = k, index to the corresponding mixed cell,
--                   b[0] = i, index to a start solution,
--                   b[1] = output code for the path trackers,
--                   on return: a target solution has been added;
--            = 24 : copy i-th target solution of the k-th cell to the
--                   solutions container, on entry: a = k and b = i.

-- ON RETURN :
--   0 if operation was successful, otherwise something went wrong...
