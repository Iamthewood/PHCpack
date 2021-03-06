with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with QuadDobl_Complex_Solutions;         use QuadDobl_Complex_Solutions;
with QuadDobl_Continuation_Data;         use QuadDobl_Continuation_Data;

package QuadDobl_Continuation_Data_io is

-- DESCRIPTION :
--   Writes the information provided in the solution info data type
--   after the tracking of a path.

  procedure Write_Statistics
               ( file : in file_type;
                 i,nstep,nfail,niter,nsyst : in natural32 );

  -- DESCRIPTION :
  --   Writes the computational statistics of the i-th path on file.

  -- REQUIRED :
  --   Of course the file must be opened for output, but as this
  --   procedure writes a banner, it is assumed that this procedure
  --   is invoked before the writing of the actual solution vector.

  -- ON ENTRY :
  --   file      file to write the statistics on;
  --   i         number of the solution;
  --   nstep     number of steps;
  --   nfail     number of failures along the path;
  --   niter     number of Newton iterations;
  --   nsyst     number of linear systems solved.

  procedure Write_Diagnostics
               ( file : in file_type; s : in Solution;
                 tol_zero,tol_sing : in double_float;
                 nbfail,nbregu,nbsing : in out natural32;
                 kind : out natural32 );
  procedure Write_Diagnostics
               ( file : in file_type; s : in Solu_Info;
                 tol_zero,tol_sing : in double_float;
                 nbfail,nbregu,nbsing : in out natural32;
                 kind : out natural32 );

  -- DESCRIPTION :
  --   Writes a preliminary diagnostic about the solution,
  --   updating the count for failures, regular and singular solutions.

  -- ON ENTRY :
  --   file      for writing the diagnostic on;
  --   s         a presumed solution;
  --   tol_zero  tolerance to decide whether a number is zero;
  --   tol_sing  tolerance for the inverse of the condition number,
  --             to decide whether a solution is regular or not.

  -- ON RETURN :
  --   nbfail    updated counter for number of failures;
  --   nbregu    updated counter for number of regular solutions;
  --   nbsing    updated counter for number of singular solutions;
  --   kind      = 0 if the path diverged to infinity;
  --             = 1 if the path converged to a regular solution;
  --             = 2 if the path converged to a singular solution.

  procedure Write_Solution ( file : in file_type; s : in Solution;
                             length_path : in quad_double );
  procedure Write_Solution ( file : in file_type; s : in Solu_Info );

  -- DESCRIPTION :
  --   Writes the solution and the length of the path on file.

  procedure Write_Next_Solution
               ( file : in file_type;
                 cnt : in out natural32; s : in Solu_Info );
  procedure Write_Next_Solution
               ( file : in file_type;
                 cnt : in out natural32; s : in Solu_Info;
                 tol_zero,tol_sing : in double_float;
                 nbfail,nbregu,nbsing : in out natural32;
                 kind : out natural32 );

  -- DESCRIPTION :
  --   Writes the next solution to file.

  -- REQUIRED :
  --   The file must be opened for output.  For format consistency,
  --   a successful Write_First must have been executed.

  -- ON ENTRY :
  --   file      file opened for output;
  --   cnt       number of solutions already written to file;
  --   s         solution to be written to file;
  --   tol_zero  tolerance to decide whether a number is zero;
  --   tol_sing  tolerance for the inverse of the condition number,
  --             to decide whether a solution is regular or not.

  -- ON RETURN :
  --   cnt       updated counter for number of solutions written to file;
  --   nbfail    updated counter for number of failures;
  --   nbregu    updated counter for number of regular solutions;
  --   nbsing    updated counter for number of singular solutions;
  --   kind      = 0 if the path diverged to infinity;
  --             = 1 if the path converged to a regular solution;
  --             = 2 if the path converged to a singular solution.

end QuadDobl_Continuation_Data_io;
