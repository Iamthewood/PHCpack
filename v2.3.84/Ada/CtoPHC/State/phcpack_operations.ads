with text_io;                             use text_io;
with Standard_Natural_Numbers;            use Standard_Natural_Numbers;
with Standard_Integer_Numbers;            use Standard_Integer_Numbers;
with Standard_Floating_Numbers;           use Standard_Floating_Numbers;
with Standard_Complex_Numbers;
with DoblDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers;
with Standard_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems;
with Standard_Complex_Solutions;
with DoblDobl_Complex_Solutions;
with QuadDobl_Complex_Solutions;

package PHCpack_Operations is

-- DESCRIPTION :
--   Provides the most common operations of PHCpack,
--   with data management for polynomial systems and solutions.

  file_okay : boolean := false;    -- if output file defined
  output_file : file_type;         -- output file defined by user

  procedure Define_Output_File;
  procedure Define_Output_File ( name : in string );
  function Is_File_Defined return boolean;
 -- function Retrieve_Output_File return file_type;
  procedure Close_Output_File;

  -- DESCRIPTION :
  --   The "Determine_Output_File" lets the user define an output file,
  --   which can be retrieved by "Retrieve_Output_File".
  --   If "Is_File_Defined" returns true, then it is okay to write to
  --   "Retrieve_Output_File", otherwise "standard_output" is returned.

  procedure Tuned_Continuation_Parameters;
  function Are_Continuation_Parameters_Tuned return boolean;

  -- DESCRIPTION :
  --   The "Tuned_Continuation_Parameters" indicates the values
  --   of the continuation parameters have already been set,
  --   and no automatic tuning of these parameters is necessary.
  --   After calling "Tuned_Continuation_Parameters", the result
  --   of "Are_Continuation_Parameters_Tuned" is true.

-- MANAGING PERSISTENT DATA :

  procedure Store_Start_System
              ( p : in Standard_Complex_Poly_Systems.Poly_Sys );
  procedure Store_Start_System
              ( p : in DoblDobl_Complex_Poly_Systems.Poly_Sys );
  procedure Store_Start_System
              ( p : in QuadDobl_Complex_Poly_Systems.Poly_Sys );
  procedure Store_Start_Solutions
              ( sols : in Standard_Complex_Solutions.Solution_List );
  procedure Store_Start_Solutions
              ( sols : in DoblDobl_Complex_Solutions.Solution_List );
  procedure Store_Start_Solutions
              ( sols : in QuadDobl_Complex_Solutions.Solution_List );
  procedure Store_Target_System
              ( p : in Standard_Complex_Poly_Systems.Poly_Sys );
  procedure Store_Target_System
              ( p : in DoblDobl_Complex_Poly_Systems.Poly_Sys );
  procedure Store_Target_System
              ( p : in QuadDobl_Complex_Poly_Systems.Poly_Sys );
  procedure Store_Target_Solutions
              ( sols : in Standard_Complex_Solutions.Solution_List );
  procedure Store_Target_Solutions
              ( sols : in DoblDobl_Complex_Solutions.Solution_List );
  procedure Store_Target_Solutions
              ( sols : in QuadDobl_Complex_Solutions.Solution_List );

  procedure Retrieve_Start_System
              ( p : out Standard_Complex_Poly_Systems.Link_to_Poly_Sys );
  procedure Retrieve_Start_System
              ( p : out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys );
  procedure Retrieve_Start_System
              ( p : out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys );
  procedure Retrieve_Start_Solutions
              ( sols : out Standard_Complex_Solutions.Solution_List );
  procedure Retrieve_Start_Solutions
              ( sols : out DoblDobl_Complex_Solutions.Solution_List );
  procedure Retrieve_Start_Solutions
              ( sols : out QuadDobl_Complex_Solutions.Solution_List );
  procedure Retrieve_Target_System
              ( p : out Standard_Complex_Poly_Systems.Link_to_Poly_Sys );
  procedure Retrieve_Target_System
              ( p : out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys );
  procedure Retrieve_Target_System
              ( p : out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys );
  procedure Retrieve_Target_Solutions
              ( sols : out Standard_Complex_Solutions.Solution_List );
  procedure Retrieve_Target_Solutions
              ( sols : out DoblDobl_Complex_Solutions.Solution_List );
  procedure Retrieve_Target_Solutions
              ( sols : out QuadDobl_Complex_Solutions.Solution_List );

  procedure Store_Gamma_Constant
              ( gamma : in Standard_Complex_Numbers.Complex_Number );
  procedure Store_Gamma_Constant
              ( gamma : in DoblDobl_Complex_Numbers.Complex_Number );
  procedure Store_Gamma_Constant
              ( gamma : in QuadDobl_Complex_Numbers.Complex_Number );

  procedure Create_Homotopy;
  procedure Create_Homotopy
              ( gamma : in Standard_Complex_Numbers.Complex_Number );
  procedure Create_DoblDobl_Homotopy;
  procedure Create_DoblDobl_Homotopy
              ( gamma : in DoblDobl_Complex_Numbers.Complex_Number );
  procedure Create_QuadDobl_Homotopy;
  procedure Create_QuadDobl_Homotopy
              ( gamma : in QuadDobl_Complex_Numbers.Complex_Number );

  -- DESCRIPTION :
  --   Creates a linear homotopy between target and start system,
  --   which must be already stored.  If no gamma is provided, then
  --   a random complex constant will be generated.

  -- REQUIRED : start and target system have been stored.

  procedure Clear_Homotopy;
  procedure Clear_DoblDobl_Homotopy;
  procedure Clear_QuadDobl_Homotopy;

  -- DESCRIPTION :
  --   Allocated memory for the linear homotopy is cleared.

  procedure Create_Cascade_Homotopy;
  procedure Create_DoblDobl_Cascade_Homotopy;
  procedure Create_QuadDobl_Cascade_Homotopy;

  -- DESCRIPTION :
  --   Creates the homotopy to go down one level in the cascade
  --   to remove one slice from the start system.

  -- REQUIRED :
  --   The start system has been stored and contains at least one
  --   slack variable and at least one slicing hyperplane at the end.
  --   Otherwise, if there is no start system yet, then the stored 
  --   target system will be used as start system.

  procedure Create_Diagonal_Homotopy ( a,b : in natural32 );

  -- DESCRIPTION :
  --   Creates the homotopy to start the cascade in a diagonal homotopy
  --   to intersect two positive dimensional solution sets.

  -- REQUIRED :
  --   The target and start system stored internally have their symbols
  --   matched and the dimensions are sorted: a >= b.

  -- ON ENTRY :
  --   a        dimension of the first set stored as the target system;
  --   b        dimension of the second set stored as the start system.

  -- ON RETURN :
  --   The start system is the system to start the cascade and
  --   the target system is the system read to perform a cascade on.

  procedure Start_Diagonal_Cascade_Solutions ( a,b : in natural32 );

  -- DESCRIPTION :
  --   Makes the start solutions to start the cascade homotopy to
  --   intersect the witness sets stored in target and start system
  --   with corresponding witness points in target and start solutions.

  -- REQUIRED :
  --   The target and start system stored represent witness sets
  --   of dimensions a and b respectively.

  -- ON ENTRY :
  --   a        dimension of the first set stored as the target system;
  --   b        dimension of the second set stored as the start system.

  -- ON RETURN :
  --   The start solutions are replaced by the solutions to start the
  --   diagonal cascade.  The target solutions are cleared.

  procedure Silent_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );
  procedure Silent_Path_Tracker
               ( ls : in DoblDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );
  procedure Silent_Path_Tracker
               ( ls : in QuadDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );
  procedure Reporting_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );
  procedure Reporting_Path_Tracker
               ( ls : in DoblDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );
  procedure Reporting_Path_Tracker
               ( ls : in QuadDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );

  -- DESCRIPTION :
  --   Uses the created homotopy to track one path starting at the
  --   given solution.  The reporting version writes extra output
  --   to the defined output file.

  -- REQUIRED : the homotopy has been initialized.

  -- ON ENTRY :
  --   ls        solution of the start system.

  -- ON RETURN :
  --   ls        solution at the end of the solution path;
  --   length    measure for the length of the path;
  --   nbstep    number of steps along the path;
  --   nbfail    number of failures along the path;
  --   nbiter    number of corrector iterations along the path;
  --   nbsyst    number of linear systems solved along the path;
  --   crash     true if some exception occurred.

  procedure Silent_Laurent_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );
  procedure Reporting_Laurent_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean );

  -- DESCRIPTION :
  --   Uses the created homotopy to track one path starting at the
  --   given solution.  The reporting version writes extra output
  --   to the defined output file.

  -- REQUIRED : Standard_Laurent_Homotopy has been initialized.

  -- ON ENTRY :
  --   ls        solution of the start system.

  -- ON RETURN :
  --   ls        solution at the end of the solution path;
  --   length    measure for the length of the path;
  --   nbstep    number of steps along the path;
  --   nbfail    number of failures along the path;
  --   nbiter    number of corrector iterations along the path;
  --   nbsyst    number of linear systems solved along the path;
  --   crash     true if some exception occurred.

  function Solve_by_Homotopy_Continuation return integer32;
  function Solve_by_DoblDobl_Homotopy_Continuation return integer32;
  function Solve_by_QuadDobl_Homotopy_Continuation return integer32;

  -- DESCRIPTION :
  --   Tracks the paths starting at the current start solutions.
  --   A normal termination returns 0.  Otherwise, the return value
  --   of this function signals an exception.

  procedure Clear;

  -- DESCRIPTION :
  --   Deallocation of the persistent data for standard homotopies.

  procedure DoblDobl_Clear;

  -- DESCRIPTION :
  --   Deallocation of the persistent data for double double homotopies.

  procedure QuadDobl_Clear;

  -- DESCRIPTION :
  --   Deallocation of the persistent data for quad double homotopies.

end PHCpack_Operations;
