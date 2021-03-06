with Standard_Complex_Ring;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Standard_Complex_Polynomials;
with Standard_Complex_Poly_Functions;
with Standard_Complex_Poly_Systems;
with Generic_Poly_System_Functions;

package Standard_Complex_Poly_SysFun is
  new Generic_Poly_System_Functions(Standard_Complex_Ring,
                                    Standard_Complex_Vectors,
                                    Standard_Complex_VecVecs,
                                    Standard_Complex_Polynomials,
                                    Standard_Complex_Poly_Functions,
                                    Standard_Complex_Poly_Systems);

-- DESCRIPTION :
--   Defines functions for evaluating systems of polynomials over the
--   standard complex numbers.
