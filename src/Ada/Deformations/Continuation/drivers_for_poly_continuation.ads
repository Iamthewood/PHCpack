with text_io;                            use text_io;
with String_Splitters;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Complex_Poly_Systems;
with Standard_Complex_Laur_Systems;      use Standard_Complex_Laur_Systems;
with DoblDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems;
with Multprec_Complex_Poly_Systems;
with Standard_Complex_Solutions;
with DoblDobl_Complex_Solutions;
with QuadDobl_Complex_Solutions;
with Multprec_Complex_Solutions;

package Drivers_for_Poly_Continuation is

-- DESCRIPTION :
--   This package contains three drivers for two types of homotopies:
--   artificial and natural parameter.

  procedure Ask_Symbol;

  -- DESCRIPTION :
  --   This procedure asks for the symbol to display the additional unknown
  --   when continuation happens in projective space.

  procedure Driver_for_Process_io ( file : in file_type );
  procedure Driver_for_Process_io ( file : in file_type; oc : out natural32 );

  -- DESCRIPTION :
  --   Choice of kind of output information during continuation.

  -- ON ENTRY :
  --   file     must be opened for output.

  -- ON RETURN :
  --   oc       number between 0 and 8 indicating the output code:
  --              0 : no intermediate output information during continuation;
  --              1 : only the final solutions at the end of the paths;
  --              2 : intermediate solutions at each step along the paths;
  --              3 : information of the predictor: t and step length;
  --              4 : information of the corrector: corrections and residuals;
  --              5 : intermediate solutions and information of the predictor;
  --              6 : intermediate solutions and information of the corrector;
  --              7 : information of predictor and corrector;
  --              8 : intermediate solutions, info of predictor and corrector.

  procedure Driver_for_Continuation_Parameters;
  procedure Driver_for_Continuation_Parameters ( file : in file_type );

  -- DESCRIPTION :
  --   This procedure allows to determine all continuation parameters.
  --   Writes the final settings on file when there is a file given.

  procedure Check_Continuation_Parameter
                ( sols : in out Standard_Complex_Solutions.Solution_List );
  procedure Check_Continuation_Parameter
                ( sols : in out DoblDobl_Complex_Solutions.Solution_List );
  procedure Check_Continuation_Parameter
                ( sols : in out QuadDobl_Complex_Solutions.Solution_List );
  procedure Check_Continuation_Parameter
                ( sols : in out Multprec_Complex_Solutions.Solution_List );

  -- DESCRIPTION ;
  --   Reads the value of the continuation parameter for the first solution.
  --   If different from zero, the user is given the opportunity to change it.

  procedure Driver_for_Polynomial_Continuation
                ( file : in file_type;
                  p : in Standard_Complex_Poly_Systems.Poly_Sys;
                  ls : in String_Splitters.Link_to_Array_of_Strings;
                  sols : out Standard_Complex_Solutions.Solution_list;
                  mpsols : out Multprec_Complex_Solutions.Solution_list;
                  target : out Complex_Number );
  procedure Driver_for_Laurent_Continuation
                ( file : in file_type; p : in Laur_Sys;
                  sols : out Standard_Complex_Solutions.Solution_list;
                 -- mpsols : out Multprec_Complex_Solutions.Solution_list;
                  target : out Complex_Number );

  -- DESCRIPTION :
  --   This is a driver for the polynomial continuation routine
  --   with an artificial parameter homotopy.
  --   It reads the start system and start solutions and enables the
  --   user to determine all relevant parameters.
  
  -- ON ENTRY :
  --   file       to write diagnostics and results on;
  --   p          a polynomial system;
  --   ls         string representations of the input polynomials.

  -- ON RETURN :
  --   sols       the computed solutions;
  --   mpsols     multi-precision representation of the solutions.

  procedure Driver_for_Parameter_Continuation
                ( file : in file_type;
                  p : in Standard_Complex_Poly_Systems.Poly_Sys;
                  k : in natural32; target : in Complex_Number;
                  sols : out Standard_Complex_Solutions.Solution_list );

  -- DESCRIPTION :
  --   This is a driver for the polynomial continuation routine
  --   with a natural parameter homotopy.
  --   The start solutions will be read from file.

  -- ON ENTRY :
  --   file       to write diagnostics and results on;
  --   p          a polynomial system, with n equations and n+1 unknowns;
  --   k          index of t = xk;
  --   target     target value for the continuation parameter.

  -- ON RETURN :
  --   sols       the computed solutions.

-- DRIVERS FOR DOUBLE DOUBLE, QUAD DOUBLE & MULTIPRECISION CONTINUATION :

  procedure Driver_for_Polynomial_Continuation
                ( file : in file_type;
                  p : in DoblDobl_Complex_Poly_Systems.Poly_Sys;
                  sols : out DoblDobl_Complex_Solutions.Solution_list;
                  target : out Complex_Number );
  procedure Driver_for_Polynomial_Continuation
                ( file : in file_type;
                  p : in QuadDobl_Complex_Poly_Systems.Poly_Sys;
                  sols : out QuadDobl_Complex_Solutions.Solution_list;
                  target : out Complex_Number );
  procedure Driver_for_Polynomial_Continuation
                ( file : in file_type; dp : in natural32;
                  p : in Multprec_Complex_Poly_Systems.Poly_Sys;
                  sols : out Multprec_Complex_Solutions.Solution_list;
                  target : out Complex_Number );

  -- DESCRIPTION :
  --   This is a driver for the polynomial continuation routine
  --   with an artificial parameter homotopy.
  --   It reads the start system and start solutions and enables the
  --   user to determine all relevant parameters.
  
  -- ON ENTRY :
  --   file       to write diagnostics and results on;
  --   dp         decimal places in the working precision;
  --   p          a polynomial system.

  -- ON RETURN :
  --   sols       the computed solutions;
  --   target     end target value for the continuation parameter.

-- CALLING THE PATH TRACKERS :

  procedure Driver_for_Standard_Continuation
                ( file : in file_type;
                  sols : in out Standard_Complex_Solutions.Solution_List;
                  proj : in boolean; target : Complex_Number := Create(1.0) );
  procedure Driver_for_Standard_Laurent_Continuation
                ( file : in file_type;
                  sols : in out Standard_Complex_Solutions.Solution_List;
                  proj : in boolean; target : Complex_Number := Create(1.0) );
  procedure Driver_for_Multprec_Continuation
                ( file : in file_type;
                  sols : in out Multprec_Complex_Solutions.Solution_List;
                  proj : in boolean; deci : in natural32;
                  target : Complex_Number := Create(1.0) );
  procedure Driver_for_DoblDobl_Continuation
                ( file : in file_type;
                  sols : in out DoblDobl_Complex_Solutions.Solution_List;
                  target : Complex_Number := Create(1.0) );
  procedure Driver_for_QuadDobl_Continuation
                ( file : in file_type;
                  sols : in out QuadDobl_Complex_Solutions.Solution_List;
                  target : Complex_Number := Create(1.0) );

  -- DESCRIPTION :
  --   Given a homotopy, contained in the Homotopy package,
  --   respectively Standard_Homotopy, Standard_Laurent_Homotopy,
  --   Multprec_Homotopy, DoblDobl_Homotopy, or QuadDobl_Homotopy.
  --   The continuation procedure will be invoked.
  --   The user may tune all continuation parameters.
   
  -- ON ENTRY :
  --   file       to write intermediate results and diagnostics on;
  --   sols       start solutions for the continuation;
  --   deci       number of decimal places;
  --   proj       true when a projective-perpendicular corrector will be used;
  --   target     target value for the continuation parameter.

  -- ON RETURN :
  --   sols       the computed solutions.

end Drivers_for_Poly_Continuation;
