with text_io;                            use text_io;
with Timing_Package;                     use Timing_Package;
with String_Splitters;                   use String_Splitters;
with Communications_with_User;           use Communications_with_User;
with File_Scanning;                      use File_Scanning;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Multprec_Floating_Numbers;          use Multprec_Floating_Numbers;
with Standard_Complex_Vectors;           use Standard_Complex_Vectors;
with Symbol_Table;
with Standard_Complex_Polynomials;       use Standard_Complex_Polynomials;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_Systems_io;   use Standard_Complex_Poly_Systems_io;
with Standard_to_Multprec_Convertors;    use Standard_to_Multprec_Convertors;
with Multprec_Complex_Poly_Systems;      use Multprec_Complex_Poly_Systems;
--with Multprec_Complex_Poly_Systems_io;   use Multprec_Complex_Poly_Systems_io;
with Multprec_Complex_Poly_SysFun;       use Multprec_Complex_Poly_SysFun;
with Multprec_Complex_Poly_Strings;      use Multprec_Complex_Poly_Strings;
with Standard_Complex_Solutions;
with Standard_Complex_Solutions_io;      use Standard_Complex_Solutions_io;
with Multprec_Complex_Solutions;
with Multprec_Complex_Solutions_io;      use Multprec_Complex_Solutions_io;
with Multprec_System_and_Solutions_io;   use Multprec_System_and_Solutions_io;
with Drivers_for_Condition_Tables;       use Drivers_for_Condition_Tables;
with Standard_Root_Refiners;             use Standard_Root_Refiners;
with Multprec_Root_Refiners;             use Multprec_Root_Refiners;
with Multprec_Residual_Evaluations;      use Multprec_Residual_Evaluations;
with Symmetry_Group;                     use Symmetry_Group;
with Symbolic_Symmetry_Group_io;         use Symbolic_Symmetry_Group_io;
with Drivers_for_Symmetry_Group_io;      use Drivers_for_Symmetry_Group_io;
with Drivers_for_Orbits_of_Solutions;    use Drivers_for_Orbits_of_Solutions;
with Driver_for_Winding_Numbers;
with Drivers_to_Deflate_Singularities;   use Drivers_to_Deflate_Singularities;
with Standard_Multiplicity_Structure;    use Standard_Multiplicity_Structure;
with Drivers_to_DD_QD_Root_Refiners;     use Drivers_to_DD_QD_Root_Refiners;
with Root_Refining_Parameters;           use Root_Refining_Parameters;
with valipoco;
with Bye_Bye_Message;

procedure mainvali ( infilename,outfilename : in string ) is

  procedure Display_Verification_Info is

  -- DESCRIPTION :
  --   Displays information about available verification methods on screen.

    i : array(1..13) of string(1..65);

  begin
    i(1):="A condition table for a list of solutions places the solutions in";
    i(2):="the list in various frequency tables, determining their  position";
    i(3):="based on logarithms of the corrector norms, condition number, and";
    i(4):="residual value.                                                  ";
    i(5):="Basic verification consists in the application of Newton's method";
    i(6):="on  the  list  of solutions.  There are facilities to extract the";
    i(7):="generating solutions when the symmetry group is submitted.       ";
    i(8):="  Winding  numbers  can  be  computed  by  homotopy  continuation";
    i(9):="methods.   The user must provide a start system with solutions at";
   i(10):="t < 1.                                                           ";
   i(11):="Polyhedral verification is based on  the  output  file  of  poco,";
   i(12):="where the polyhedral  end  game was turned on.  This verification";
   i(13):="puts up a frequency table of computed path directions.           ";
    for k in i'range loop
      put_line(i(k));
    end loop;
  end Display_Verification_Info;

-- READING THE INPUT :

  procedure Scan_System
               ( file : in out file_type; filename : in string;
                 lp : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                 sysonfile : out boolean ) is

  -- DESCRIPTION :
  --   Checks whether the given file name corresponds to a file with
  --   a polynomial system in a correct format.
  --   If this is the case, then sysonfile is true on return and lp
  --   contains the system.

  begin
    if filename /= "" then
      Open(file,in_file,filename);
      get(file,lp);
      sysonfile := true;
    else
      sysonfile := false;
    end if;
   -- if lp /= null then
   --   put("in Scan_System : ");
   --   put(" #equations = "); put(lp'last,1); new_line;
   -- end if;
  exception
    when others =>
      new_line;
      put("Could not open file with name "); put_line(filename);
      lp := null;
      sysonfile := false;
      return;
  end Scan_System;

--  procedure Scan_System
--               ( file : in out file_type; filename : in string;
--                 lp : in out Multprec_Complex_Poly_Systems.Link_to_Poly_Sys;
--                 sysonfile : out boolean ) is
--
--  -- DESCRIPTION :
--  --   Checks whether the given file name corresponds to a file with
--  --   a polynomial system in a correct format.
--  --   If this is the case, then sysonfile is true on return and lp
--  --   contains the system.
--
--  begin
--    if filename /= "" then
--      Open(file,in_file,filename);
--      get(file,lp);
--      sysonfile := true;
--    else
--      sysonfile := false;
--    end if;
--   -- if lp /= null then
--   --   put("in Scan_System : ");
--   --   put(" #equations = "); put(lp'last,1); new_line;
--   -- end if;
--  exception
--    when others =>
--      new_line;
--      put("Could not open file with name "); put_line(filename);
--      lp := null;
--      sysonfile := false;
--      return;
--  end Scan_System;

  procedure Read_System
              ( file : in out file_type; filename : in string;
                lp : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                sysonfile : out boolean ) is

  -- DESCRIPTION :
  --   Searches first the system on file, using the given filename.
  --   If necessary other files will be openend.

    ans : character;
    n : integer32;

  begin
    Scan_System(file,filename,lp,sysonfile);
    if lp = null then
      loop
        new_line;
        put("Is the system on a file ? (y/n/i=info) ");
        Ask_Alternative(ans,"yni");
        if ans = 'i' then
          new_line;
          Standard_Complex_Poly_Systems_io.Display_Format;
          new_line;
        end if;
        exit when ans /= 'i';
      end loop;
      new_line;
      if ans = 'y' then
        put_line("Reading the name of the input file.");
        Read_Name_and_Open_File(file);
        get(file,lp);
        sysonfile := true;
        n := lp'length;
      else
        put("Give the dimension : "); get(n);
        lp := new Standard_Complex_Poly_Systems.Poly_Sys(1..n);
        put("Give "); put(n,1); put(" "); put(n,1);
        put_line("-variate polynomials :");
        get(natural32(n),lp.all);
        skip_line;  -- skip end_of_line symbol
        sysonfile := false;
      end if;
    end if;
   -- put_line("at end of Read_System : ");
   -- put("#equations : "); put(lp'last,1);
   -- put(", #variables : "); put(Number_of_Unknowns(lp(lp'first)),1);
   -- new_line;
  end Read_System;

--  procedure Read_System
--               ( file : in out file_type; filename : in string;
--                 lp : in out Multprec_Complex_Poly_Systems.Link_to_Poly_Sys;
--                 sysonfile : out boolean ) is
--
--  -- DESCRIPTION :
--  --   Searches first the system on file, using the given filename.
--  --   If necessary other files will be openend.
--
--    ans : character;
--    n : natural;
--
--  begin
--    Scan_System(file,filename,lp,sysonfile);
--    if lp = null then
--      loop
--        new_line;
--        put("Is the system on a file ? (y/n/i=info) ");
--        Ask_Alternative(ans,"yni");
--        if ans = 'i' then
--          new_line;
--          Standard_Complex_Poly_Systems_io.Display_Format;
--          new_line;
--        end if;
--        exit when ans /= 'i';
--      end loop;
--      new_line;
--      if ans = 'y' then
--        put_line("Reading the name of the input file.");
--        Read_Name_and_Open_File(file);
--        get(file,lp);
--        sysonfile := true;
--        n := lp'length;
--      else
--        put("Give the dimension : "); get(n);
--        lp := new Multprec_Complex_Poly_Systems.Poly_Sys(1..n);
--        put("Give "); put(n,1); put(" "); put(n,1);
--        put_line("-variate polynomials :");
--        get(n,lp.all);
--        skip_line;  -- skip end_of_line symbol
--        sysonfile := false;
--      end if;
--    end if;
--   -- put_line("at end of Read_System : ");
--   -- put("#equations : "); put(lp'last,1);
--   -- put(", #variables : "); put(Number_of_Unknowns(lp(lp'first)),1);
--   -- new_line;
--  end Read_System;

  procedure Scan_Solutions
              ( file : in out file_type; sysonfile : in boolean;
                sols : in out Standard_Complex_Solutions.Solution_List;
                found : out boolean ) is
  begin
    if sysonfile then
      Scan_and_Skip(file,"THE SOLUTIONS",found);
      if found
       then get(file,sols);
       end if;
       Close(file);
    else
      found := false;
    end if;
  exception
    when others
      => put_line("Something is wrong with the solutions, will ignore...");
         Close(file);
         found := false;
  end Scan_Solutions;

  procedure Read_Solutions
              ( file : in out file_type; sysonfile : in boolean;
                sols : in out Standard_Complex_Solutions.Solution_List ) is

    found : boolean;

  begin
    Scan_Solutions(file,sysonfile,sols,found);
    if not found then
      new_line;
      put_line("Reading the name of the file for the solutions.");
      Read_Name_and_Open_File(file);
      get(file,sols);
      Close(file);
    end if;
  end Read_Solutions;

  procedure Refine_Roots
                 ( file : in file_type;
                   p : in Standard_Complex_Poly_Systems.Poly_Sys;
                   solsfile,invar,allperms,signsym : in boolean;
                   v : in List_of_Permutations;
                   epsxa,epsfa,tolsing : in double_float;
                   maxit : in natural32; deflate : in out boolean;
                   wout : in boolean;
                   sols,refsols
                         : in out Standard_Complex_Solutions.Solution_List ) is

  -- DESCRIPTION :
  --   Refines the roots and computes generating solutions when required.

  -- ON ENTRY :
  --   file        for writing results on;
  --   p           the polynomial system under consideration;
  --   solsfile    whether refined solution have to go to separate file;
  --   invar       whether generating solutions have to be computed;
  --   allperms    whether invariant under all permutations;
  --   signsym     whether there is sign-symmetry;
  --   v           group representation, only needed when invar;
  --   sols        solutions that need to be refined.

  -- ON RETURN :
  --   sols        solutions after applying some Newton iteration;
  --   refsols     refined solutions, with the exception of failures and
  --               the non-generating solutions.

    numit : natural32 := 0;

  begin
    if solsfile or invar then
      if p'last /= Standard_Complex_Solutions.Head_Of(sols).n then
        Reporting_Root_Sharpener
          (file,p,sols,refsols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
      else 
        Reporting_Root_Refiner
          (file,p,sols,refsols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
        if invar
         then Driver_for_Orbits_of_Solutions
                (file,refsols,v,allperms,signsym,epsxa);
        end if;
      end if;
    else
      if p'last /= Standard_Complex_Solutions.Head_Of(sols).n then
        Reporting_Root_Sharpener
          (file,p,sols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
      else
        Reporting_Root_Refiner
          (file,p,sols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
      end if;
    end if;
  end Refine_Roots;

  procedure Refine_Roots
         ( file : in file_type;
           p : in Standard_Complex_Poly_Systems.Poly_Sys;
           solsfile : in boolean;
           epsxa,epsfa,tolsing : in double_float;
           maxit : in natural32; deflate : in out boolean; wout : in boolean;
           sols,refsols : in out Standard_Complex_Solutions.Solution_List ) is

  -- DESCRIPTION : 
  --   Root refinement without computing of generating solutions.

    numit : natural32 := 0;

  begin
    if solsfile then
      if p'last /= Standard_Complex_Solutions.Head_Of(sols).n then
        Reporting_Root_Sharpener
          (file,p,sols,refsols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
      else
        Reporting_Root_Refiner
          (file,p,sols,refsols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
      end if;
    else
      if p'last /= Standard_Complex_Solutions.Head_Of(sols).n then
        Reporting_Root_Sharpener
          (file,p,sols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
      else
        Reporting_Root_Refiner
          (file,p,sols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
      end if;
    end if;
  end Refine_Roots;

  procedure End_of_Input_Message is
  begin
    new_line;
    put_line("No more input expected.  See output file for results.");
    new_line;
  end End_of_Input_Message;

-- VALIDATION PROCEDURES :

  procedure Winding_Verification is

  -- DESCRIPTION :
  --   Verification by computing winding numbers by homotopy continuation.

    use Standard_Complex_Solutions;

    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    timer : Timing_Widget;
    infile,solsft,outfile : file_type;
    ans : character;
    sysonfile,solsfile,deflate,wout : boolean;
    sols,refsols: Standard_Complex_Solutions.Solution_List;
    epsxa,epsfa,tolsing : double_float;
    maxit : natural32;

  begin
    Read_System(infile,infilename,lp,sysonfile);
    Create_Output_File(outfile,outfilename);
    put(outfile,natural32(lp'last),lp.all);
    Read_Solutions(infile,sysonfile,sols);
    new_line;
    put("Do you want the refined solutions on separate file ? (y/n) ");
    Ask_Yes_or_No(ans);
    if ans = 'y' then
      solsfile := true;
      put_line("Reading the name of the file to write the solutions on.");
      Read_Name_and_Create_File(solsft);
    else
      solsfile := false;
    end if;
    Standard_Default_Root_Refining_Parameters
      (epsxa,epsfa,tolsing,maxit,deflate,wout);
    Standard_Menu_Root_Refining_Parameters
      (outfile,epsxa,epsfa,tolsing,maxit,deflate,wout);
    Driver_for_Winding_Numbers(outfile,lp.all,sols);
    tstart(timer);
    Refine_Roots(outfile,lp.all,solsfile,
                 epsxa,epsfa,tolsing,maxit,deflate,wout,sols,refsols);
    tstop(timer);
    if solsfile then
      put(solsft,Length_Of(refsols),natural32(Head_Of(refsols).n),refsols);
      Close(solsft);
    end if;
    new_line(outfile);
    print_times(outfile,timer,"Root Refinement");
    Close(outfile);
  end Winding_Verification;

  procedure Standard_Weeding_Validation is

  -- DESCRIPTION :
  --   Validation by refining the roots and weeding out the solution set.

    use Standard_Complex_Solutions;

    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    timer : Timing_Widget;
    infile,solsft,outfile : file_type;
    n,maxit : natural32;
    ans : character;
    sysonfile,solsfile,deflate,wout : boolean;
    invar,allperms,signsym,allsigns : boolean;
    g,v : List_of_Permutations;
    sols,refsols: Standard_Complex_Solutions.Solution_List;
    epsxa,epsfa,tolsing : double_float;

  begin
    Read_System(infile,infilename,lp,sysonfile);
    Create_Output_File(outfile,outfilename);
    put(outfile,natural32(lp'last),lp.all);
    Read_Solutions(infile,sysonfile,sols);
    new_line;
    put("Is the system invariant under group actions ? (y/n) ");
    Ask_Yes_or_No(ans);
    if ans = 'y' then
      invar := true; n := lp'length;
      Read_Symmetry_Group(n,g,v,allperms,signsym,allsigns);
      new_line(outfile);
      put_line(outfile,"THE SYMMETRY GROUP : ");
      new_line(outfile);
      Symbolic_Symmetry_Group_io.put(outfile,v);
      new_line(outfile);
    else
      invar := false;
    end if;
    new_line;
    put("Do you want the refined solutions on separate file ? (y/n) ");
    Ask_Yes_or_No(ans);
    if ans = 'y' then
      solsfile := true;
      put_line("Reading the name of the file to write the solutions on.");
      Read_Name_and_Create_File(solsft);
    else
      solsfile := false;
    end if;
    Standard_Default_Root_Refining_Parameters
      (epsxa,epsfa,tolsing,maxit,deflate,wout);
    Standard_Menu_Root_Refining_Parameters
      (outfile,epsxa,epsfa,tolsing,maxit,deflate,wout);
    End_of_Input_Message;
   -- put("starting root refinement with #variables : ");
   -- put(Head_Of(sols).n,1); new_line;
    tstart(timer);
    Refine_Roots(outfile,lp.all,solsfile,invar,allperms,signsym,v,
                 epsxa,epsfa,tolsing,maxit,deflate,wout,sols,refsols);
    tstop(timer);
    if solsfile then
      put(solsft,Length_Of(refsols),natural32(Head_Of(refsols).n),refsols);
      Close(solsft);
    end if;
    new_line(outfile);
    print_times(outfile,timer,"Root Refinement");
    Close(outfile);
  end Standard_Weeding_Validation;

  procedure Multprec_Residual_Evaluator is

  -- DESCRIPTION :
  --   Evaluation of residuals using multi-precision arithmetic.

    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    timer : Timing_Widget;
    infile,outfile : file_type;
    sysonfile : boolean;
    sols : Standard_Complex_Solutions.Solution_List;

  begin
    Read_System(infile,infilename,lp,sysonfile);
    Create_Output_File(outfile,outfilename);
    put(outfile,natural32(lp'last),lp.all);
    Read_Solutions(infile,sysonfile,sols);
    new_line(outfile);
    put_line(outfile,"the solutions in standard precision : ");
    put(outfile,Standard_Complex_Solutions.Length_Of(sols),
        natural32(lp'last),sols);
    declare
      mpsols : Multprec_Complex_Solutions.Solution_List
             := Multprec_Complex_Solutions.Create(sols);
      mp : constant Multprec_Complex_Poly_Systems.Poly_Sys(lp'range)
         := Convert(lp.all);
      mp_eval : constant Multprec_Complex_Poly_SysFun.Eval_Poly_Sys(mp'range)
              := Create(mp);
      deci,size : natural32 := 0;
    begin
      new_line;
      put("Give the number of decimal places : "); get(deci);
      size := Decimal_to_Size(deci);
      Multprec_Complex_Solutions.Set_Size(mpsols,size);
      new_line(outfile);
      put(outfile,"THE RESIDUALS with "); put(outfile,deci,1);
      put_line(outfile," decimal places :");
      tstart(timer);
      Residuals(outfile,mp_eval,mpsols);            
      tstop(timer);
    end;
    new_line(outfile);
    print_times(outfile,timer,"Multi-Precision Residual Evaluation");
    Close(outfile);
  end Multprec_Residual_Evaluator;

  procedure Call_Multprec_Root_Refiner
               ( file : in file_type; n,m : in natural32;
                 ls : in Link_to_Array_of_Strings;
                 sols : in out Multprec_Complex_Solutions.Solution_List ) is

    timer : Timing_Widget;
    epsxa,epsfa,tolsing : Floating_Number;
    maxit,numit,deci,size : natural32 := 0;
    deflate,wout : boolean;
    p : Multprec_Complex_Poly_Systems.Poly_Sys(1..integer32(n));

  begin
    new_line;
    Multprec_Default_Root_Refining_Parameters
      (epsxa,epsfa,tolsing,maxit,deci,deflate,wout);
    Multprec_Menu_Root_Refining_Parameters
      (file,epsxa,epsfa,tolsing,maxit,deci,deflate,wout);
    size := Decimal_to_Size(deci);
   -- put("Give the size of the numbers : "); get(size);
   -- Symbol_Table.Init(m);
    if Symbol_Table.Number < m
     then Symbol_Table.Init(m);
    end if;
   -- put("m = "); put(m,1); new_line;
   -- for i in ls'range loop
   --   put("p["); put(i,1); put("] = "); put_line(ls(i).all);
   -- end loop;
   -- put_line("parsing the system from strings ...");
    p := Parse(m,size,ls.all);
   -- put_line("done parsing the system");
    Multprec_Complex_Solutions.Set_Size(sols,size);
    End_of_Input_Message;
    numit := 0;
    tstart(timer);
    if p'last /= Multprec_Complex_Solutions.Head_Of(sols).n then
      Reporting_Root_Sharpener
        (file,p,sols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
    else
      Reporting_Root_Refiner
        (file,p,sols,epsxa,epsfa,tolsing,numit,maxit,deflate,wout);
    end if;
    tstop(timer);
    new_line(file);
    print_times(file,timer,"Multi-Precision Root Refinement");
  end Call_Multprec_Root_Refiner;

  procedure Multprec_Weeding_Validation is

  -- DESCRIPTION :
  --   Newton's method using multi-precision arithmetic.

    n,m : natural32;
    ls : Link_to_Array_of_Strings;
    infile,outfile : file_type;
    sols : Multprec_Complex_Solutions.Solution_List;

  begin
    if infilename = "" then
      get(n,m,ls,sols);
    else
      Open_Input_File(infile,infilename);
      get(infile,n,m,ls,sols);
      Close(infile);
    end if;
   -- put_line("reading the strings and solutions from file ...");
    Create_Output_File(outfile,outfilename);
    put(outfile,n,1);
    if m /= n
     then put(outfile,"  "); put(outfile,m,1);
    end if;
    new_line(outfile);
    for i in ls'range loop
      put_line(outfile,ls(i).all);
    end loop;
    if Multprec_Complex_Solutions.Length_Of(sols) > 0 then
      new_line(outfile);
      put_line(outfile,"the given solutions : ");
      put(outfile,Multprec_Complex_Solutions.Length_Of(sols),
          natural32(Multprec_Complex_Solutions.Head_Of(sols).n),sols);
      put_line("calling the multiprecision root refiner ...");
      Call_Multprec_Root_Refiner(outfile,n,m,ls,sols);
    end if;
    Close(outfile);
  end Multprec_Weeding_Validation;

  procedure Polyhedral_End_Game_Validation is

  -- DESCRIPTION :
  --   Validation of the polyhedral end game.

    pocofile,resultfile : file_type;

  begin
    new_line;
    put_line("Reading name of the output file of poco.");
    Read_Name_and_Open_File(pocofile);
    new_line;
    put_line("Reading name of output file.");
    Read_Name_and_Create_File(resultfile);
    End_of_Input_Message;
    valipoco(pocofile,resultfile);
    Close(pocofile);
    new_line(resultfile);
    put(resultfile,Bye_Bye_Message);
    Close(resultfile);
  end Polyhedral_End_Game_Validation;

  procedure Newton_with_Deflation is

    use Standard_Complex_Solutions;

    infile,outfile : file_type;
    sysonfile : boolean;
    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : Standard_Complex_Solutions.Solution_List;

  begin
    Read_System(infile,infilename,lp,sysonfile);
    if outfilename = "" then
      put_line("Reading the name of the output file...");
      declare
        new_outfilename : constant string := Read_String;
      begin
        Create_Output_File(outfile,new_outfilename);
        put(outfile,natural32(lp'last),lp.all);
        Read_Solutions(infile,sysonfile,sols);
        new_line(outfile);
        put_line(outfile,"the solutions on input :");
        put(outfile,Length_Of(sols),natural32(Head_Of(sols).n),sols);
        Deflate_Singularities(outfile,new_outfilename,lp.all,sols);
      end;
    else
      Create_Output_File(outfile,outfilename);
      put(outfile,natural32(lp'last),lp.all);
      Read_Solutions(infile,sysonfile,sols);
      new_line(outfile);
      put_line(outfile,"the solutions on input :");
      put(outfile,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      Deflate_Singularities(outfile,outfilename,lp.all,sols);
    end if;
  end Newton_with_Deflation;

  procedure Multiplicity_Structure is

    use Standard_Complex_Solutions;

    infile,outfile : file_type;
    sysonfile : boolean;
    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : Standard_Complex_Solutions.Solution_List;

  begin
    Read_System(infile,infilename,lp,sysonfile);
    if outfilename = "" then
      new_line;
      put_line("Reading the name of the output file ...");
      Read_Name_and_Create_File(outfile);
    else
      Create_Output_File(outfile,outfilename);
    end if;
    put(outfile,natural32(lp'last),lp.all);
    Read_Solutions(infile,sysonfile,sols);
    Driver_to_Multiplicity_Structure(outfile,lp.all,sols);
  end Multiplicity_Structure;

  procedure Display_and_Dispatch_Menu is

    ans : character;

  begin
    loop
      new_line;
      put_line("MENU with Verification Methods : ");
      put_line
         ("  0. Scanning (huge) solution files and creating condition tables;");
      put_line
       ("  1. Basic Verification : refining and weeding out the solution set;");
      put_line
         ("  2. Evaluation of the residuals using multi-precision arithmetic;");
      put_line
         ("  3. Newton's method using multi-precision arithmetic;");
      put_line
         ("  4. Winding-Number Computation by homotopy continuation;");
      put_line
         ("  5. Polyhedral Verification : frequency table of path directions;");
      put_line
         ("  6. Newton's method with deflation for isolated singularities;");
      put_line
         ("  7. Multiplicity structure of isolated singular solutions;");
      put_line
         ("  8. Newton's method in double double or quad double arithmetic.");
      put("Type 0, 1, 2, 3, 4, 5, 6, 7, or 8 to select, or i for info : ");
      Ask_Alternative(ans,"012345678i");
      case ans is
        when 'i' => new_line;
                    Display_Verification_Info;
        when '0' => Main_Driver_to_Scan_Solution_Lists(infilename,outfilename);
        when '1' => Standard_Weeding_Validation;
        when '2' => Multprec_Residual_Evaluator;
        when '3' => Multprec_Weeding_Validation;
        when '4' => Winding_Verification;
        when '5' => Polyhedral_End_Game_Validation;
        when '6' => Newton_with_Deflation;
        when '7' => Multiplicity_Structure;
        when '8' => DD_QD_Root_Refinement;
        when others => null;
      end case;
      exit when ans /= 'i';
    end loop;
  end Display_and_Dispatch_Menu;

begin
  Display_and_Dispatch_Menu;
end mainvali;
