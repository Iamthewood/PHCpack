with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Complex_Vectors;           use Standard_Complex_Vectors;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;

package Drivers_for_Scaling is

-- DESCRIPTION :
--   This package provides driver routines to perform scaling.

  procedure Display_Info;

  -- DESCRIPTION :
  --   Display information about the scaling procedures on screen.

  procedure Equation_Scaling
                  ( file : in file_type; p : in out Poly_Sys );

  -- DESCRIPTION :
  --   Performs equation scaling on the the system p.
  --   Writes timing information on file.

  procedure Variable_Scaling
                  ( file : in file_type; p : in out Poly_Sys;
                    basis : out natural32; scvc : out Link_to_Vector );

  -- DESCRIPTION :
  --   Performs variable scaling on the system p.
  --   Writes timing information on file.

  procedure Write_Results ( file : in file_type; p : in Poly_Sys;
                            basis : in natural32; scvc : in Link_to_Vector );

  -- DESCRIPTION :
  --   Writes the results of the scaling procedure on file.
  --   These results are the scaled system p, and in case basis /= 0,
  --   the scaling coefficients in the vectors scvc.

  procedure Driver_for_Scaling
                  ( file : in file_type; p : in out Poly_Sys;
                    basis : out natural32; scvc : out Link_to_Vector );

  -- DESCRIPTION :
  --   This is an interactive driver for phc running in full mode.

  -- ON ENTRY :
  --   file         file to write intermediate results and diagnostics on;
  --   p            a polynomial system.

  -- ON RETURN :
  --   p            the scaled polynomial system;
  --   basis        number basis used for scaling, used as flag:
  --                if basis /= 0, then variable scaling has been applied;
  --   scvc         scaling coefficients, only /= null when basis /= 0.

end Drivers_for_Scaling;