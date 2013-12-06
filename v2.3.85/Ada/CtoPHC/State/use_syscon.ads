with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;
with C_Double_Arrays;                   use C_Double_Arrays;

function use_syscon ( job : integer32;
                      a : C_intarrs.Pointer;
		      b : C_intarrs.Pointer;
                      c : C_dblarrs.Pointer ) return integer32;

-- DESCRIPTION :
--   Provides a gateway to the systems container.

-- ON ENTRY :
--   job    =   0 : read polynomial system and put in container;
--          =   1 : write the polynomial system in the container;
--          =   2 : return in a[0] the dimension of the polynomial system;
--          =   3 : initializes the container with the dimension in a[0];
--          =   4 : return in a[0] the number of terms in the i-th polynomial;
--          =   5 : return in c the coefficient (real and imaginary part),
--                    and in b the exponent vector (i = a[1], j = a[2])
--                  of the j-th term in the i-th polynomial;
--          =   6 : add to the i-th polynomial the term with coefficient
--                      in c and exponent vector in b;
--          =   7 : the systems container is cleared;
--          =   8 : returns in a the total degree of the system;
--          =   9 : clears the symbol table;
--          =  10 : creates an evaluator for the system in the container;
--          =  11 : creates an evaluator for the Jacobian matrix.
--          =  20 : returns in b[0] the degree of polynomial with index a[0]
--                  stored in the standard polynomial systems container.
--
-- the operations in the Laurent systems container :
--
--   job    = 100 : read polynomial system and put in container;
--          = 101 : write the polynomial system in the container;
--          = 102 : return in a[0] the dimension of the polynomial system;
--          = 103 : initializes the container with the dimension in a[0];
--          = 104 : return in a[0] the number of terms in the i-th polynomial;
--          = 105 : return in c the coefficient (real and imaginary part),
--                    and in b the exponent vector (i = a[1], j = a[2])
--                  of the j-th term in the i-th polynomial;
--          = 106 : add to the i-th polynomial the term with coefficient
--                      in c and exponent vector in b;
--          = 107 : the systems container is cleared;

-- the operations in the double double polynomial systems container :
-- 
--   job    = 200 : read polynomial system and put in container;
--          = 201 : write the polynomial system in the container;
--          = 202 : return in a[0] the dimension of the polynomial system;
--          = 203 : initializes the container with the dimension in a[0];
--          = 204 : return in a[0] the number of terms in the i-th polynomial;
--          = 205 : return in c the coefficient (real and imaginary part),
--                     and in b the exponent vector (i = a[1], j = a[2])
--                  of the j-th term in the i-th polynomial;
--          = 206 : add to the i-th polynomial the term with coefficient
--                      in c and exponent vector in b;
--          = 207 : the systems container is cleared;
--          = 208 : puts a polynomial given as a string in the system 
--                  container, with the input parameters as follows:
--                    a[0] : number of characters in the string,
--                    a[1] : index of the polynomial in the system,
--                    b : string converted to an integer array.
--          = 209 : returns in b[0] the degree of polynomial with index a[0]
--                  stored in the double double polynomial systems container.
--
-- the operations in the quad double polynomial systems container :
-- 
--   job    = 210 : read polynomial system and put in container;
--          = 211 : write the polynomial system in the container;
--          = 212 : return in a[0] the dimension of the polynomial system;
--          = 213 : initializes the container with the dimension in a[0];
--          = 214 : return in a[0] the number of terms in the i-th polynomial;
--          = 215 : return in c the coefficient (real and imaginary part),
--                     and in b the exponent vector (i = a[1], j = a[2])
--                  of the j-th term in the i-th polynomial;
--          = 216 : add to the i-th polynomial the term with coefficient
--                      in c and exponent vector in b;
--          = 217 : the systems container is cleared;
--          = 218 : puts a polynomial given as a string in the system 
--                  container, with the input parameters as follows:
--                    a[0] : number of characters in the string,
--                    a[1] : index of the polynomial in the system,
--                    b : string converted to an integer array.
--          = 219 : returns in b[0] the degree of polynomial with index a[0]
--                  stored in the quad double polynomial systems container.
--
-- the operations in the multiprecision polynomial systems container :
-- 
--   job    = 220 : read polynomial system and put in container;
--          = 221 : write the polynomial system in the container;
--          = 222 : return in a[0] the dimension of the polynomial system;
--          = 223 : initializes the container with the dimension in a[0];
--          = 224 : return in a[0] the number of terms in the i-th polynomial;
--          = 227 : the systems container is cleared;
--          = 228 : puts a polynomial given as a string in the system 
--                  container, with the input parameters as follows:
--                    a[0] : number of characters in the string,
--                    a[1] : index of the polynomial in the system,
--                    a[2] : the number of decimal places of the numbers
--                           to set the precision for the parsing operations,
--                    b : string converted to an integer array.
--          = 229 : returns in b[0] the degree of polynomial with index a[0]
--                  stored in the multiprecision polynomial systems container.
--
-- the operations to pass polynomials as strings :
--
--   job    =  67 : loads a polynomial from the container into a string:
--                    a[0] : index of the polynomial k on entry,
--                           and number of characters in the string on return,
--                    b : characters in the string representation of
--                        the k-th polynomial in the container,
--                  this is the reverse of operation 76,
--          =  68 : loads a polynomial from the double double systems
--                  container into a string:
--                    a[0] : index of the polynomial k on entry,
--                           and number of characters in the string on return,
--                    b : characters in the string representation of
--                        the k-th polynomial in the container,
--                  this is the reverse of operation 208,    
--          =  69 : loads a polynomial from the quad double systems
--                  container into a string:
--                    a[0] : index of the polynomial k on entry,
--                           and number of characters in the string on return,
--                    b : characters in the string representation of
--                        the k-th polynomial in the container,
--                  this is the reverse of operation 218,    
--          =  70 : loads a polynomial from the multiprecision systems
--                  container into a string:
--                    a[0] : index of the polynomial k on entry,
--                           and number of characters in the string on return,
--                    b : characters in the string representation of
--                        the k-th polynomial in the container,
--                  this is the reverse of operation 228,    
--          =  74 : puts a Laurent polynomial given as a string in the system 
--                  container, with the input parameters as follows:
--                    a[0] : number of characters in the string,
--                    a[1] : index of the polynomial in the system,
--                    b : string converted to an integer array.
--          =  76 : puts a polynomial given as a string in the system 
--                  container, with the input parameters as follows:
--                    a[0] : number of characters in the string,
--                    a[1] : index of the polynomial in the system,
--                    b : string converted to an integer array,
--                  this is the reverse of operation 67.
--
-- the operations to drop variables from a polynomial :
--  
--   job    =  12 : replaces the system in the standard double container
--                  by a system with variable of index a[0] removed;
--          =  13 : replaces the system in the double double container
--                  by a system with variable of index a[0] removed;
--          =  14 : replaces the system in the quad double container
--                  by a system with variable of index a[0] removed;
--          =  15 : replaces the system in the standard double container
--                  by a system with variable with name in b and
--                  number of characters in a[0] removed;
--          =  16 : replaces the system in the double double container
--                  by a system with variable with name in b and
--                  number of characters in a[0] removed;
--          =  17 : replaces the system in the quad double container
--                  by a system with variable with name in b and
--                  number of characters in a[0] removed;
-- 
--   a        memory allocated for array of integers, a = (n,i,j),
--            where n is the dimension,
--                  i is index to the polynomial in the system to work on;
--                  j is index to the mononomial in the i-th polynomial;
--   b        memory allocated for array of integers, used for exponents;
--   c        memory allocated for array of double floating-point numbers,
--            used for real and imaginary part of complex coefficient.

-- ON RETURN :
--   0 if the operation was successful, otherwise something went wrong,
--   e.g.: indices to monomial out of range, or job not in the proper range.