--with Standard_Complex_Polynomials;
--use Standard_Complex_Polynomials;

with Communications_with_User;           use Communications_with_User;
with Timing_Package;                     use Timing_Package;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Complex_Numbers_io;        use Standard_Complex_Numbers_io;
with Double_Double_Numbers;              use Double_Double_Numbers;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with DoblDobl_Complex_Numbers_io;        use DoblDobl_Complex_Numbers_io;
with QuadDobl_Complex_Numbers_io;        use QuadDobl_Complex_Numbers_io;
with Standard_Random_Numbers;
with DoblDobl_Random_Numbers;
with QuadDobl_Random_Numbers;
with Standard_Floating_Vectors;
with Double_Double_Vectors;
with Quad_Double_Vectors;
with Standard_Complex_Norms_Equals;
with DoblDobl_Complex_Vector_Norms;
with QuadDobl_Complex_Vector_Norms;
with Standard_Complex_Polynomials;
with Standard_Complex_Poly_Systems_io;   use Standard_Complex_Poly_Systems_io;
with DoblDobl_Complex_Polynomials;
with DoblDobl_Complex_Poly_Systems_io;   use DoblDobl_Complex_Poly_Systems_io;
with QuadDobl_Complex_Polynomials;
with QuadDobl_Complex_Poly_Systems_io;   use QuadDobl_Complex_Poly_Systems_io;
with Standard_Homotopy;
with DoblDobl_Homotopy;
with QuadDobl_Homotopy;
with Standard_Laurent_Homotopy;
with Continuation_Parameters;
with Standard_Continuation_Data;
with Standard_Path_Trackers;
with DoblDobl_Continuation_Data;
with DoblDobl_Path_Trackers;
with QuadDobl_Continuation_Data;
with QuadDobl_Path_Trackers;
with Standard_IncFix_Continuation;
with DoblDobl_IncFix_Continuation;
with QuadDobl_IncFix_Continuation;
with Standard_Root_Refiners;
with Witness_Sets,Witness_Sets_io;
with Extrinsic_Diagonal_Homotopies;      use Extrinsic_Diagonal_Homotopies;

package body PHCpack_Operations is

-- INTERNAL DATA :

  empty_homotopy,zero_constant,auto_tune : boolean;
  empty_dobldobl_homotopy,empty_quaddobl_homotopy : boolean;
  zero_dobldobl_constant,zero_quaddobl_constant : boolean;

  st_start_sys,st_target_sys : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
  dd_start_sys,dd_target_sys : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
  qd_start_sys,qd_target_sys : QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
  st_start_sols,st_target_sols : Standard_Complex_Solutions.Solution_List;
  dd_start_sols,dd_target_sols : DoblDobl_Complex_Solutions.Solution_List;
  qd_start_sols,qd_target_sols : QuadDobl_Complex_Solutions.Solution_List;

  st_gamma_constant : Standard_Complex_Numbers.Complex_Number;
  dd_gamma_constant : DoblDobl_Complex_Numbers.Complex_Number;
  qd_gamma_constant : QuadDobl_Complex_Numbers.Complex_Number;

-- OPERATIONS :

  procedure Define_Output_File is
  begin
    new_line;
    put_line("Reading the name of the output file...");
    Read_Name_and_Create_File(output_file);
    file_okay := true;
  end Define_Output_File;

  procedure Define_Output_File ( name : in string ) is
  begin
    create(output_file,out_file,name);
    file_okay := true;
  end Define_Output_File;

  function Is_File_Defined return boolean is
  begin
    return file_okay;
  end Is_File_Defined;

--  function Retrieve_Output_File return file_type is
--  begin
--    if file_okay
--     then return output_file;
--     else return standard_output;
--    end if;
--  end Retrieve_Output_File;

  procedure Close_Output_File is
  begin
    close(output_file);
  end Close_Output_File;

  procedure Tuned_Continuation_Parameters is
  begin
    auto_tune := false;
  end Tuned_Continuation_Parameters;

  function Are_Continuation_Parameters_Tuned return boolean is
  begin
    return not auto_tune;
  end Are_Continuation_Parameters_Tuned;

-- MANAGING PERSISTENT DATA :

  procedure Store_Start_System
              ( p : in Standard_Complex_Poly_Systems.Poly_Sys ) is
  begin
   -- Clear(st_start_sys); -- no clear as patch for extrinsic diagonal homotopy
    st_start_sys := new Standard_Complex_Poly_Systems.Poly_Sys(p'range);
    for i in p'range loop
      Standard_Complex_Polynomials.Copy(p(i),st_start_sys(i));
    end loop;
  exception
    when others =>
       put_line("Exception raised in Store_Start_System");
       put_line("The system p is "); put(p); raise;
  end Store_Start_System;

  procedure Store_Start_System
              ( p : in DoblDobl_Complex_Poly_Systems.Poly_Sys ) is
  begin
    dd_start_sys := new DoblDobl_Complex_Poly_Systems.Poly_Sys(p'range);
    for i in p'range loop
      DoblDobl_Complex_Polynomials.Copy(p(i),dd_start_sys(i));
    end loop;
  exception
    when others =>
       put_line("Exception raised in Store_Start_System");
       put_line("The system p is "); put(p); raise;
  end Store_Start_System;

  procedure Store_Start_System
              ( p : in QuadDobl_Complex_Poly_Systems.Poly_Sys ) is
  begin
    qd_start_sys := new QuadDobl_Complex_Poly_Systems.Poly_Sys(p'range);
    for i in p'range loop
      QuadDobl_Complex_Polynomials.Copy(p(i),qd_start_sys(i));
    end loop;
  exception
    when others =>
       put_line("Exception raised in Store_Start_System");
       put_line("The system p is "); put(p); raise;
  end Store_Start_System;

  procedure Store_Start_Solutions
              ( sols : in Standard_Complex_Solutions.Solution_List ) is
  begin
    Standard_Complex_Solutions.Clear(st_start_sols);
    Standard_Complex_Solutions.Copy(sols,st_start_sols);
  end Store_Start_Solutions;

  procedure Store_Start_Solutions
              ( sols : in DoblDobl_Complex_Solutions.Solution_List ) is
  begin
    DoblDobl_Complex_Solutions.Clear(dd_start_sols);
    DoblDobl_Complex_Solutions.Copy(sols,dd_start_sols);
  end Store_Start_Solutions;

  procedure Store_Start_Solutions
              ( sols : in QuadDobl_Complex_Solutions.Solution_List ) is
  begin
    QuadDobl_Complex_Solutions.Clear(qd_start_sols);
    QuadDobl_Complex_Solutions.Copy(sols,qd_start_sols);
  end Store_Start_Solutions;

  procedure Store_Target_System
              ( p : in Standard_Complex_Poly_Systems.Poly_Sys ) is
  begin
   -- Clear(st_target_sys); -- patch for extrinsic diagonal homotopy
   -- put_line("in Store_Target_System ...");
    st_target_sys := new Standard_Complex_Poly_Systems.Poly_Sys(p'range);
    for i in p'range loop
      Standard_Complex_Polynomials.Copy(p(i),st_target_sys(i));
    end loop;
   -- put_line("after Store_Target_System, st_target_sys :");
   -- put(st_target_sys.all);
  end Store_Target_System;

  procedure Store_Target_System
              ( p : in DoblDobl_Complex_Poly_Systems.Poly_Sys ) is
  begin
   -- put_line("in Store_Target_System ...");
    dd_target_sys := new DoblDobl_Complex_Poly_Systems.Poly_Sys(p'range);
    for i in p'range loop
      DoblDobl_Complex_Polynomials.Copy(p(i),dd_target_sys(i));
    end loop;
   -- put_line("after Store_Target_System, dd_target_sys :");
   -- put(dd_target_sys.all);
  end Store_Target_System;

  procedure Store_Target_System
              ( p : in QuadDobl_Complex_Poly_Systems.Poly_Sys ) is
  begin
   -- put_line("in Store_Target_System ...");
    qd_target_sys := new QuadDobl_Complex_Poly_Systems.Poly_Sys(p'range);
    for i in p'range loop
      QuadDobl_Complex_Polynomials.Copy(p(i),qd_target_sys(i));
    end loop;
   -- put_line("after Store_Target_System, qd_target_sys :");
   -- put(qd_target_sys.all);
  end Store_Target_System;

  procedure Store_Target_Solutions
              ( sols : in Standard_Complex_Solutions.Solution_List ) is
  begin
    Standard_Complex_Solutions.Clear(st_target_sols);
    Standard_Complex_Solutions.Copy(sols,st_target_sols);
  end Store_Target_Solutions;

  procedure Store_Target_Solutions
              ( sols : in DoblDobl_Complex_Solutions.Solution_List ) is
  begin
    DoblDobl_Complex_Solutions.Clear(dd_target_sols);
    DoblDobl_Complex_Solutions.Copy(sols,dd_target_sols);
  end Store_Target_Solutions;

  procedure Store_Target_Solutions
              ( sols : in QuadDobl_Complex_Solutions.Solution_List ) is
  begin
    QuadDobl_Complex_Solutions.Clear(qd_target_sols);
    QuadDobl_Complex_Solutions.Copy(sols,qd_target_sols);
  end Store_Target_Solutions;

  procedure Retrieve_Start_System
              ( p : out Standard_Complex_Poly_Systems.Link_to_Poly_Sys ) is
  begin
    p := st_start_sys;
  end Retrieve_Start_System;

  procedure Retrieve_Start_System
              ( p : out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys ) is
  begin
    p := dd_start_sys;
  end Retrieve_Start_System;

  procedure Retrieve_Start_System
              ( p : out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys ) is
  begin
    p := qd_start_sys;
  end Retrieve_Start_System;

  procedure Retrieve_Start_Solutions
              ( sols : out Standard_Complex_Solutions.Solution_List ) is
  begin
    sols := st_start_sols;
  end Retrieve_Start_Solutions;

  procedure Retrieve_Start_Solutions
              ( sols : out DoblDobl_Complex_Solutions.Solution_List ) is
  begin
    sols := dd_start_sols;
  end Retrieve_Start_Solutions;

  procedure Retrieve_Start_Solutions
              ( sols : out QuadDobl_Complex_Solutions.Solution_List ) is
  begin
    sols := qd_start_sols;
  end Retrieve_Start_Solutions;

  procedure Retrieve_Target_System
              ( p : out Standard_Complex_Poly_Systems.Link_to_Poly_Sys ) is
  begin
    p := st_target_sys;
  end Retrieve_Target_System;

  procedure Retrieve_Target_System
              ( p : out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys ) is
  begin
    p := dd_target_sys;
  end Retrieve_Target_System;

  procedure Retrieve_Target_System
              ( p : out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys ) is
  begin
    p := qd_target_sys;
  end Retrieve_Target_System;

  procedure Retrieve_Target_Solutions
              ( sols : out Standard_Complex_Solutions.Solution_List ) is
  begin
    sols := st_target_sols;
  end Retrieve_Target_Solutions;

  procedure Retrieve_Target_Solutions
              ( sols : out DoblDobl_Complex_Solutions.Solution_List ) is
  begin
    sols := dd_target_sols;
  end Retrieve_Target_Solutions;

  procedure Retrieve_Target_Solutions
              ( sols : out QuadDobl_Complex_Solutions.Solution_List ) is
  begin
    sols := qd_target_sols;
  end Retrieve_Target_Solutions;

  procedure Store_Gamma_Constant
              ( gamma : in Standard_Complex_Numbers.Complex_Number ) is
  begin
    zero_constant := false;
    st_gamma_constant := gamma;
  end Store_Gamma_Constant;

  procedure Store_Gamma_Constant
              ( gamma : in DoblDobl_Complex_Numbers.Complex_Number ) is
  begin
    zero_dobldobl_constant := false;
    dd_gamma_constant := gamma;
  end Store_Gamma_Constant;

  procedure Store_Gamma_Constant
              ( gamma : in QuadDobl_Complex_Numbers.Complex_Number ) is
  begin
    zero_quaddobl_constant := false;
    qd_gamma_constant := gamma;
  end Store_Gamma_Constant;

  procedure Copy_Labels is

  -- DESCRIPTION :
  --   Copies the multiplicity labels from start to target solutions,
  --   only in case these labels are > 1 and if m field of target is 1.

    tmp_start : Standard_Complex_Solutions.Solution_List := st_start_sols;
    tmp_target : Standard_Complex_Solutions.Solution_List := st_target_sols;
    ls_start,ls_target : Standard_Complex_Solutions.Link_to_Solution;

    use Standard_Complex_Solutions;

  begin
    while not Is_Null(tmp_start) loop
      ls_start := Head_Of(tmp_start);
      if ls_start.m > 1 then
        ls_target := Head_Of(tmp_target);
        if ls_target.m = 1 then
          ls_target.m := ls_start.m;
          Set_Head(tmp_target,ls_target);
        end if;
      end if;
      tmp_start := Tail_Of(tmp_start);
      tmp_target := Tail_Of(tmp_target);
    end loop;
  end Copy_Labels;

  procedure Copy_DoblDobl_Labels is

  -- DESCRIPTION :
  --   Copies the multiplicity labels from start to target solutions,
  --   only in case these labels are > 1 and if m field of target is 1.

    tmp_start : DoblDobl_Complex_Solutions.Solution_List := dd_start_sols;
    tmp_target : DoblDobl_Complex_Solutions.Solution_List := dd_target_sols;
    ls_start,ls_target : DoblDobl_Complex_Solutions.Link_to_Solution;

    use DoblDobl_Complex_Solutions;

  begin
    while not Is_Null(tmp_start) loop
      ls_start := Head_Of(tmp_start);
      if ls_start.m > 1 then
        ls_target := Head_Of(tmp_target);
        if ls_target.m = 1 then
          ls_target.m := ls_start.m;
          Set_Head(tmp_target,ls_target);
        end if;
      end if;
      tmp_start := Tail_Of(tmp_start);
      tmp_target := Tail_Of(tmp_target);
    end loop;
  end Copy_DoblDobl_Labels;

  procedure Copy_QuadDobl_Labels is

  -- DESCRIPTION :
  --   Copies the multiplicity labels from start to target solutions,
  --   only in case these labels are > 1 and if m field of target is 1.

    tmp_start : QuadDobl_Complex_Solutions.Solution_List := qd_start_sols;
    tmp_target : QuadDobl_Complex_Solutions.Solution_List := qd_target_sols;
    ls_start,ls_target : QuadDobl_Complex_Solutions.Link_to_Solution;

    use QuadDobl_Complex_Solutions;

  begin
    while not Is_Null(tmp_start) loop
      ls_start := Head_Of(tmp_start);
      if ls_start.m > 1 then
        ls_target := Head_Of(tmp_target);
        if ls_target.m = 1 then
          ls_target.m := ls_start.m;
          Set_Head(tmp_target,ls_target);
        end if;
      end if;
      tmp_start := Tail_Of(tmp_start);
      tmp_target := Tail_Of(tmp_target);
    end loop;
  end Copy_QuadDobl_Labels;

  procedure Create_Homotopy is

    gamma : constant Standard_Complex_Numbers.Complex_Number
          := Standard_Random_Numbers.Random1;

  begin
    Create_Homotopy(gamma);
  end Create_Homotopy;

  procedure Create_DoblDobl_Homotopy is

    gamma : constant DoblDobl_Complex_Numbers.Complex_Number
          := DoblDobl_Random_Numbers.Random1;

  begin
    Create_DoblDobl_Homotopy(gamma);
  end Create_DoblDobl_Homotopy;

  procedure Create_QuadDobl_Homotopy is

    gamma : constant QuadDobl_Complex_Numbers.Complex_Number
          := QuadDobl_Random_Numbers.Random1;

  begin
    Create_QuadDobl_Homotopy(gamma);
  end Create_QuadDobl_Homotopy;

  procedure Create_Homotopy
              ( gamma : in Standard_Complex_Numbers.Complex_Number ) is
  begin
    if not empty_homotopy then
      Standard_Homotopy.Clear;
      empty_homotopy := true;
    else
      empty_homotopy := false;
    end if;
   -- put_line("the target system : "); put(st_target_sys.all);
   -- put_line("the start system : "); put(st_start_sys.all);
   -- put(" number of unknowns in first target eq : ");
   -- put(Number_of_Unknowns(st_target_sys(st_target_sys'first)),1);
   -- put(" number of unknowns in first start eq : ");
   -- put(Number_of_Unknowns(st_start_sys(st_start_sys'first)),1); new_line;
   -- put(" number of unknowns in last target eq : ");
   -- put(Number_of_Unknowns(st_target_sys(st_target_sys'last)),1);
   -- put(" number of unknowns in last start eq : ");
   -- put(Number_of_Unknowns(st_start_sys(st_start_sys'last)),1); new_line;
   -- put(" number of equations in target : "); put(st_target_sys'last,1);
   -- put(" number of equations in start : "); put(st_start_sys'last,1);
   -- new_line;
    Standard_Homotopy.Create(st_target_sys.all,st_start_sys.all,2,gamma);
    empty_homotopy := false;
  exception
    when others => put_line("exception raised when creating a homotopy");
                   raise;
  end Create_Homotopy;

  procedure Create_DoblDobl_Homotopy
              ( gamma : in DoblDobl_Complex_Numbers.Complex_Number ) is
  begin
    if not empty_dobldobl_homotopy then
      DoblDobl_Homotopy.Clear;
      empty_dobldobl_homotopy := true;
    else
      empty_dobldobl_homotopy := false;
    end if;
    DoblDobl_Homotopy.Create(dd_target_sys.all,dd_start_sys.all,2,gamma);
    empty_dobldobl_homotopy := false;
  exception
    when others => put_line("exception raised when creating a homotopy");
                   raise;
  end Create_DoblDobl_Homotopy;

  procedure Create_QuadDobl_Homotopy
              ( gamma : in QuadDobl_Complex_Numbers.Complex_Number ) is
  begin
    if not empty_quaddobl_homotopy then
      QuadDobl_Homotopy.Clear;
      empty_quaddobl_homotopy := true;
    else
      empty_quaddobl_homotopy := false;
    end if;
    QuadDobl_Homotopy.Create(qd_target_sys.all,qd_start_sys.all,2,gamma);
    empty_quaddobl_homotopy := false;
  exception
    when others => put_line("exception raised when creating a homotopy");
                   raise;
  end Create_QuadDobl_Homotopy;

  procedure Clear_Homotopy is
  begin
    Standard_Homotopy.Clear;
    empty_homotopy := true;
  exception 
    when others => put_line("exception raised when clearing a homotopy");
                   raise;
  end Clear_Homotopy;

  procedure Clear_DoblDobl_Homotopy is
  begin
    DoblDobl_Homotopy.Clear;
    empty_dobldobl_homotopy := true;
  exception 
    when others => put_line("exception raised when clearing a homotopy");
                   raise;
  end Clear_DoblDobl_Homotopy;

  procedure Clear_QuadDobl_Homotopy is
  begin
    QuadDobl_Homotopy.Clear;
    empty_quaddobl_homotopy := true;
  exception 
    when others => put_line("exception raised when clearing a homotopy");
                   raise;
  end Clear_QuadDobl_Homotopy;

  procedure Swap_Embed_Symbols
              ( p : in out Standard_Complex_Poly_Systems.Poly_Sys ) is

  -- DESCRIPTION :
  --   Ensures that the symbols "zz" that control the embedding occur
  --   at the end of the symbol table, permuting the symbol table and
  --   the order of the variables in the system p.

    nvar : constant natural32 := natural32(p'last);
    nslk : constant natural32 := Witness_Sets_io.Count_Embed_Symbols(nvar,"zz");

  begin
    Witness_Sets_io.Swap_Symbols_to_End(nvar,nslk,"zz",p);
    Witness_Sets_io.Sort_Embed_Symbols(nvar,nvar-nslk,nslk,p);
  end Swap_Embed_Symbols;

  procedure Swap_Embed_Symbols
              ( p : in out DoblDobl_Complex_Poly_Systems.Poly_Sys ) is

  -- DESCRIPTION :
  --   Ensures that the symbols "zz" that control the embedding occur
  --   at the end of the symbol table, permuting the symbol table and
  --   the order of the variables in the system p.

    nvar : constant natural32 := natural32(p'last);
    nslk : constant natural32 := Witness_Sets_io.Count_Embed_Symbols(nvar,"zz");

  begin
    Witness_Sets_io.Swap_Symbols_to_End(nvar,nslk,"zz",p);
    Witness_Sets_io.Sort_Embed_Symbols(nvar,nvar-nslk,nslk,p);
  end Swap_Embed_Symbols;

  procedure Swap_Embed_Symbols
              ( p : in out QuadDobl_Complex_Poly_Systems.Poly_Sys ) is

  -- DESCRIPTION :
  --   Ensures that the symbols "zz" that control the embedding occur
  --   at the end of the symbol table, permuting the symbol table and
  --   the order of the variables in the system p.

    nvar : constant natural32 := natural32(p'last);
    nslk : constant natural32 := Witness_Sets_io.Count_Embed_Symbols(nvar,"zz");

  begin
    Witness_Sets_io.Swap_Symbols_to_End(nvar,nslk,"zz",p);
    Witness_Sets_io.Sort_Embed_Symbols(nvar,nvar-nslk,nslk,p);
  end Swap_Embed_Symbols;

  procedure Create_Cascade_Homotopy is

    use Standard_Complex_Poly_Systems;

    gamma : constant Standard_Complex_Numbers.Complex_Number
          := Standard_Complex_Numbers.Create(1.0);

  begin
    if st_start_sys /= null then
     -- put("The start system "); put(st_start_sys.all);
      declare
      begin
        Clear(st_target_sys);
      exception
        when others => put_line("raised exception when clearing target...");
      end;
      Swap_Embed_Symbols(st_start_sys.all);
      declare
        p : constant Poly_Sys(st_start_sys'range)
          := Witness_Sets.Remove_Slice(st_start_sys.all);
      begin
        st_target_sys := new Poly_Sys'(p);
      exception
        when others => put_line("raised exception when removing slice...");
                       raise;
      end;
      PHCpack_Operations.Create_Homotopy(gamma);
    elsif st_target_sys /= null then
      Swap_Embed_Symbols(st_target_sys.all);
      st_start_sys := new Poly_Sys(st_target_sys'range);
      Copy(st_target_sys.all,st_start_sys.all);
      Clear(st_target_sys);
      st_target_sys
        := new Poly_Sys'(Witness_Sets.Remove_Slice(st_start_sys.all));
      PHCpack_Operations.Create_Homotopy(gamma);
    end if;
  end Create_Cascade_Homotopy;

  procedure Create_DoblDobl_Cascade_Homotopy is

    use DoblDobl_Complex_Poly_Systems;

    gamma : constant DoblDobl_Complex_Numbers.Complex_Number
          := DoblDobl_Complex_Numbers.Create(integer(1));

  begin
    if dd_start_sys /= null then
     -- put("The start system "); put(dd_start_sys.all);
      declare
      begin
        Clear(dd_target_sys);
      exception
        when others => put_line("raised exception when clearing target...");
      end;
      Swap_Embed_Symbols(dd_start_sys.all);
      declare
        p : constant Poly_Sys(dd_start_sys'range)
          := Witness_Sets.Remove_Slice(dd_start_sys.all);
      begin
        dd_target_sys := new Poly_Sys'(p);
      exception
        when others => put_line("raised exception when removing slice...");
                       raise;
      end;
      PHCpack_Operations.Create_DoblDobl_Homotopy(gamma);
    elsif dd_target_sys /= null then
      Swap_Embed_Symbols(dd_target_sys.all);
      dd_start_sys := new Poly_Sys(dd_target_sys'range);
      Copy(dd_target_sys.all,dd_start_sys.all);
      Clear(dd_target_sys);
      dd_target_sys
        := new Poly_Sys'(Witness_Sets.Remove_Slice(dd_start_sys.all));
      PHCpack_Operations.Create_DoblDobl_Homotopy(gamma);
    end if;
  end Create_DoblDobl_Cascade_Homotopy;

  procedure Create_QuadDobl_Cascade_Homotopy is

    use QuadDobl_Complex_Poly_Systems;

    gamma : constant QuadDobl_Complex_Numbers.Complex_Number
          := QuadDobl_Complex_Numbers.Create(integer(1));

  begin
    if qd_start_sys /= null then
     -- put("The start system "); put(qd_start_sys.all);
      declare
      begin
        Clear(qd_target_sys);
      exception
        when others => put_line("raised exception when clearing target...");
      end;
      Swap_Embed_Symbols(qd_start_sys.all);
      declare
        p : constant Poly_Sys(qd_start_sys'range)
          := Witness_Sets.Remove_Slice(qd_start_sys.all);
      begin
        qd_target_sys := new Poly_Sys'(p);
      exception
        when others => put_line("raised exception when removing slice...");
                       raise;
      end;
      PHCpack_Operations.Create_QuadDobl_Homotopy(gamma);
    elsif qd_target_sys /= null then
      Swap_Embed_Symbols(qd_target_sys.all);
      qd_start_sys := new Poly_Sys(qd_target_sys'range);
      Copy(qd_target_sys.all,qd_start_sys.all);
      Clear(qd_target_sys);
      qd_target_sys
        := new Poly_Sys'(Witness_Sets.Remove_Slice(qd_start_sys.all));
      PHCpack_Operations.Create_QuadDobl_Homotopy(gamma);
    end if;
  end Create_QuadDobl_Cascade_Homotopy;

  procedure Create_Diagonal_Homotopy ( a,b : in natural32 ) is

    use Standard_Complex_Poly_Systems;

    cd : natural32;
    gamma : constant Standard_Complex_Numbers.Complex_Number
          := Standard_Complex_Numbers.Create(1.0);

  begin
   -- new_line;
   -- put("Intersecting sets of dimension ");
   -- put(a,1); put(" and "); put(b,1); put_line(".");
    if a >= b then
      cd := Cascade_Dimension(st_target_sys.all,st_start_sys.all,a,b);
     -- put("The dimension of the cascade : "); put(cd,1); new_line;
     -- put("target system :" ); put(st_target_sys.all);
     -- put("start system :" ); put(st_start_sys.all);
      declare
        start,target : Poly_Sys(1..integer32(cd));
      begin
       -- put_line("before extrinsic cascade homotopy...");
        Extrinsic_Cascade_Homotopy
          (st_target_sys.all,st_start_sys.all,a,b,start,target);
       -- put_line("after extrinsic cascade : ");
       -- put_line("start system : "); put(start);
       -- put_line("target system : "); put(target);
        declare
        begin
          Clear(st_start_sys); st_start_sys := new Poly_Sys'(start);
          Clear(st_target_sys); st_target_sys := new Poly_Sys'(target);
        exception 
          when others =>
            put_line("exception raised in clear"); raise;
        end;
      end;
    else
      cd := Cascade_Dimension(st_start_sys.all,st_target_sys.all,b,a);
      declare
        start,target : Poly_Sys(1..integer32(cd));
      begin
        Extrinsic_Cascade_Homotopy
          (st_start_sys.all,st_target_sys.all,b,a,start,target);
        Clear(st_start_sys); st_start_sys := new Poly_Sys'(start);
        Clear(st_target_sys); st_target_sys := new Poly_Sys'(target);
      end;
    end if;
    PHCpack_Operations.Create_Homotopy(gamma);
  end Create_Diagonal_Homotopy;

  procedure Start_Diagonal_Cascade_Solutions ( a,b : in natural32 ) is

    use Standard_Complex_Polynomials,Standard_Complex_Solutions;

    k : constant natural32
      := Number_of_Unknowns(st_target_sys(st_target_sys'first)) - a;
    sols1 : constant Solution_List
          := Witness_Sets.Remove_Embedding(st_target_sols,a);
    sols2 : constant Solution_List
          := Witness_Sets.Remove_Embedding(st_start_sols,b);
    sols : constant Solution_List := Product(sols1,sols2);
    embsols : Solution_List;

  begin
    put_line("inside start_diagonal_cascade_solutions ...");
    put("length of sols1 : "); put(Length_Of(sols1),1); new_line;
    put("length of sols2 : "); put(Length_Of(sols2),1); new_line;
    put("number of product solutions : "); put(Length_Of(sols),1); new_line;
    if a+b < k
     then embsols := Witness_Sets.Add_Embedding(sols,b);
     else embsols := Witness_Sets.Add_Embedding(sols,k-a);
    end if;
    Clear(st_start_sols); Clear(st_target_sols);
    st_start_sols := embsols;
    put("number of start solutions : ");
    put(Length_Of(st_start_sols),1); new_line;
  end Start_Diagonal_Cascade_Solutions;

  procedure Silent_Path_Tracker 
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use Standard_Complex_Numbers,Standard_Complex_Norms_Equals;
    use Standard_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Silent_Continue
            (Max_Norm,Standard_Homotopy.Eval,
             Standard_Homotopy.Diff,Standard_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Silent_Continue
            (Max_Norm,Standard_Homotopy.Eval,
             Standard_Homotopy.Diff,Standard_Homotopy.Diff);

    t1 : constant Complex_Number := Create(1.0);
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Standard_Floating_Vectors.Link_to_Vector;
    e : double_float := 0.0;
    s : Standard_Continuation_Data.Solu_Info;

  begin
    ls.t := Create(0.0);
    s := Standard_Continuation_Data.Shallow_Create(ls);
    Track_Path_along_Path(s,t1,tol,false,pp1,cp1);
    Track_Path_at_End(s,t1,tol,false,0,v,e,pp2,cp2);
    ls.t := Create(REAL_PART(ls.t),s.length_path);
    ls.err := s.cora; ls.rco := s.rcond; ls.res := s.resa;
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true; return;
  end Silent_Path_Tracker;

  procedure Silent_Path_Tracker 
               ( ls : in DoblDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use DoblDobl_Complex_Numbers,DoblDobl_Complex_Vector_Norms;
    use DoblDobl_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Silent_Continue
            (Max_Norm,DoblDobl_Homotopy.Eval,
             DoblDobl_Homotopy.Diff,DoblDobl_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Silent_Continue
            (Max_Norm,DoblDobl_Homotopy.Eval,
             DoblDobl_Homotopy.Diff,DoblDobl_Homotopy.Diff);

    t1 : constant Complex_Number := Create(integer(1));
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Double_Double_Vectors.Link_to_Vector;
    e : double_double := create(0.0);
    s : DoblDobl_Continuation_Data.Solu_Info;
    len : double_double;

  begin
    ls.t := Create(integer(0));
    s := DoblDobl_Continuation_Data.Shallow_Create(ls);
    Track_Path_along_Path(s,t1,tol,false,pp1,cp1);
    Track_Path_at_End(s,t1,tol,false,0,v,e,pp2,cp2);
    len := Double_Double_Numbers.create(s.length_path);
    ls.t := DoblDobl_Complex_Numbers.Create(REAL_PART(ls.t),len);
    ls.err := create(s.cora);
    ls.rco := create(s.rcond);
    ls.res := create(s.resa);
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true; return;
  end Silent_Path_Tracker;

  procedure Silent_Path_Tracker 
               ( ls : in QuadDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use QuadDobl_Complex_Numbers,QuadDobl_Complex_Vector_Norms;
    use QuadDobl_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Silent_Continue
            (Max_Norm,QuadDobl_Homotopy.Eval,
             QuadDobl_Homotopy.Diff,QuadDobl_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Silent_Continue
            (Max_Norm,QuadDobl_Homotopy.Eval,
             QuadDobl_Homotopy.Diff,QuadDobl_Homotopy.Diff);

    t1 : constant Complex_Number := Create(integer(1));
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Quad_Double_Vectors.Link_to_Vector;
    e : quad_double := create(0.0);
    s : QuadDobl_Continuation_Data.Solu_Info;
    dd_len : double_double;
    qd_len : quad_double;

  begin
    ls.t := Create(integer(0));
    s := QuadDobl_Continuation_Data.Shallow_Create(ls);
    Track_Path_along_Path(s,t1,tol,false,pp1,cp1);
    Track_Path_at_End(s,t1,tol,false,0,v,e,pp2,cp2);
    dd_len := Double_Double_Numbers.create(s.length_path);
    qd_len := Quad_Double_Numbers.create(dd_len);
    ls.t := QuadDobl_Complex_Numbers.Create(REAL_PART(ls.t),qd_len);
    ls.err := create(s.cora);
    ls.rco := create(s.rcond);
    ls.res := create(s.resa);
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true; return;
  end Silent_Path_Tracker;

  procedure Silent_Laurent_Path_Tracker 
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use Standard_Complex_Numbers,Standard_Complex_Norms_Equals;
    use Standard_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Silent_Continue
            (Max_Norm,Standard_Laurent_Homotopy.Eval,
             Standard_Laurent_Homotopy.Diff,Standard_Laurent_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Silent_Continue
            (Max_Norm,Standard_Laurent_Homotopy.Eval,
             Standard_Laurent_Homotopy.Diff,Standard_Laurent_Homotopy.Diff);

    t1 : constant Complex_Number := Create(1.0);
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Standard_Floating_Vectors.Link_to_Vector;
    e : double_float := 0.0;
    s : Standard_Continuation_Data.Solu_Info;

  begin
    ls.t := Create(0.0);
    s := Standard_Continuation_Data.Shallow_Create(ls);
    Track_Path_along_Path(s,t1,tol,false,pp1,cp1);
    Track_Path_at_End(s,t1,tol,false,0,v,e,pp2,cp2);
    ls.t := Create(REAL_PART(ls.t),s.length_path);
    ls.err := s.cora; ls.rco := s.rcond; ls.res := s.resa;
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true; return;
  end Silent_Laurent_Path_Tracker;

  procedure Reporting_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use Standard_Complex_Numbers,Standard_Complex_Norms_Equals;
    use Standard_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Reporting_Continue
            (Max_Norm,Standard_Homotopy.Eval,
             Standard_Homotopy.Diff,Standard_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Reporting_Continue
            (Max_Norm,Standard_Homotopy.Eval,
             Standard_Homotopy.Diff,Standard_Homotopy.Diff);

    t1 : constant Complex_Number := Create(1.0);
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Standard_Floating_Vectors.Link_to_Vector;
    e : double_float := 0.0;
    s : Standard_Continuation_Data.Solu_Info;

  begin
    ls.t := Create(0.0);
    s := Standard_Continuation_Data.Shallow_Create(ls);
    if file_okay then
      Track_Path_along_Path(output_file,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(output_file,s,t1,tol,false,0,v,e,pp2,cp2);
    else
      Track_Path_along_Path(standard_output,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(standard_output,s,t1,tol,false,0,v,e,pp2,cp2);
    end if;
    ls.t := Create(REAL_PART(ls.t),s.length_path);
    ls.err := s.cora; ls.rco := s.rcond; ls.res := s.resa;
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true;
  end Reporting_Path_Tracker;

  procedure Reporting_Path_Tracker
               ( ls : in DoblDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use DoblDobl_Complex_Numbers,DoblDobl_Complex_Vector_Norms;
    use DoblDobl_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Reporting_Continue
            (Max_Norm,DoblDobl_Homotopy.Eval,
             DoblDobl_Homotopy.Diff,DoblDobl_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Reporting_Continue
            (Max_Norm,DoblDobl_Homotopy.Eval,
             DoblDobl_Homotopy.Diff,DoblDobl_Homotopy.Diff);

    t1 : constant Complex_Number := Create(integer(1));
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Double_Double_Vectors.Link_to_Vector;
    e : double_double := create(0.0);
    s : DoblDobl_Continuation_Data.Solu_Info;
    len : double_double;

  begin
    ls.t := DoblDobl_Complex_Numbers.Create(integer(0));
    s := DoblDobl_Continuation_Data.Shallow_Create(ls);
    if file_okay then
      Track_Path_along_Path(output_file,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(output_file,s,t1,tol,false,0,v,e,pp2,cp2);
    else
      Track_Path_along_Path(standard_output,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(standard_output,s,t1,tol,false,0,v,e,pp2,cp2);
    end if;
    len := Double_Double_Numbers.create(s.length_path);
    ls.t := DoblDobl_Complex_Numbers.Create(REAL_PART(ls.t),len);
    ls.err := Double_Double_Numbers.create(s.cora);
    ls.rco := Double_Double_Numbers.create(s.rcond);
    ls.res := Double_Double_Numbers.create(s.resa);
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true;
  end Reporting_Path_Tracker;

  procedure Reporting_Path_Tracker
               ( ls : in QuadDobl_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use QuadDobl_Complex_Numbers,QuadDobl_Complex_Vector_Norms;
    use QuadDobl_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Reporting_Continue
            (Max_Norm,QuadDobl_Homotopy.Eval,
             QuadDobl_Homotopy.Diff,QuadDobl_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Reporting_Continue
            (Max_Norm,QuadDobl_Homotopy.Eval,
             QuadDobl_Homotopy.Diff,QuadDobl_Homotopy.Diff);

    t1 : constant Complex_Number := Create(integer(1));
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Quad_Double_Vectors.Link_to_Vector;
    e : quad_double := create(0.0);
    s : QuadDobl_Continuation_Data.Solu_Info;
    dd_len : double_double;
    qd_len : quad_double;

  begin
    ls.t := QuadDobl_Complex_Numbers.Create(integer(0));
    s := QuadDobl_Continuation_Data.Shallow_Create(ls);
    if file_okay then
      Track_Path_along_Path(output_file,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(output_file,s,t1,tol,false,0,v,e,pp2,cp2);
    else
      Track_Path_along_Path(standard_output,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(standard_output,s,t1,tol,false,0,v,e,pp2,cp2);
    end if;
    dd_len := Double_Double_Numbers.create(s.length_path);
    qd_len := Quad_Double_Numbers.create(dd_len);
    ls.t := QuadDobl_Complex_Numbers.Create(REAL_PART(ls.t),qd_len);
    ls.err := Quad_Double_Numbers.create(s.cora);
    ls.rco := Quad_Double_Numbers.create(s.rcond);
    ls.res := Quad_Double_Numbers.create(s.resa);
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true;
  end Reporting_Path_Tracker;

  procedure Reporting_Laurent_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution;
                 length : out double_float;
                 nbstep,nbfail,nbiter,nbsyst : out natural32;
                 crash : out boolean ) is

    use Standard_Complex_Numbers,Standard_Complex_Norms_Equals;
    use Standard_Path_Trackers;

    procedure Track_Path_along_Path is
      new Linear_Single_Normal_Reporting_Continue
            (Max_Norm,Standard_Laurent_Homotopy.Eval,
             Standard_Laurent_Homotopy.Diff,Standard_Laurent_Homotopy.Diff);

    procedure Track_Path_at_End is
      new Linear_Single_Conditioned_Reporting_Continue
            (Max_Norm,Standard_Laurent_Homotopy.Eval,
             Standard_Laurent_Homotopy.Diff,Standard_Laurent_Homotopy.Diff);

    t1 : constant Complex_Number := Create(1.0);
    tol : constant double_float := 1.0E-12;
   -- tol_zero : constant double_float := 1.0E-8;
    pp1 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_for_Path;
    pp2 : constant Continuation_Parameters.Pred_Pars
        := Continuation_Parameters.Create_End_Game;
    cp1 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_for_Path;
    cp2 : constant Continuation_Parameters.Corr_Pars
        := Continuation_Parameters.Create_End_Game;
    v : Standard_Floating_Vectors.Link_to_Vector;
    e : double_float := 0.0;
    s : Standard_Continuation_Data.Solu_Info;

  begin
    ls.t := Create(0.0);
    s := Standard_Continuation_Data.Shallow_Create(ls);
    if file_okay then
      Track_Path_along_Path(output_file,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(output_file,s,t1,tol,false,0,v,e,pp2,cp2);
    else
      Track_Path_along_Path(standard_output,s,t1,tol,false,pp1,cp1);
      Track_Path_at_End(standard_output,s,t1,tol,false,0,v,e,pp2,cp2);
    end if;
    ls.t := Create(REAL_PART(ls.t),s.length_path);
    ls.err := s.cora; ls.rco := s.rcond; ls.res := s.resa;
    length := s.length_path;
    nbstep := s.nstep; nbfail := s.nfail;
    nbiter := s.niter; nbsyst := s.nsyst;
    crash := false;
  exception
    when others => crash := true;
  end Reporting_Laurent_Path_Tracker;

  function Solve_by_Homotopy_Continuation return integer32 is

    use Standard_Complex_Numbers,Standard_Complex_Norms_Equals;
    use Standard_IncFix_Continuation;

    k : constant natural32 := 2;
    r : Complex_Number; 
    epsxa : constant double_float := 1.0E-13;
    epsfa : constant double_float := 1.0E-13;
    tolsing : constant double_float := 1.0E-8;
    numit : natural32 := 0;
    max : constant natural32 := 4;
    deflate : boolean := false;
    timer : Timing_Widget;

    procedure Sil_Cont is
      new Silent_Continue(Max_Norm,Standard_Homotopy.Eval,
                          Standard_Homotopy.Diff,Standard_Homotopy.Diff);

    procedure Rep_Cont is
      new Reporting_Continue(Max_Norm,Standard_Homotopy.Eval,
                             Standard_Homotopy.Diff,Standard_Homotopy.Diff);

  begin
    if zero_constant
     then r := Create(0.793450603947633,-0.608634651572795);
     else r := st_gamma_constant;
    end if;
    if empty_homotopy then
      Standard_Homotopy.Create(st_target_sys.all,st_start_sys.all,k,r);
      empty_homotopy := false; -- for dynamic load balancing
      if file_okay then
        new_line(output_file);
        put_line(output_file,"HOMOTOPY PARAMETERS :");
        put(output_file,"  k : "); put(output_file,k,2);
        new_line(output_file);
        put(output_file,"  gamma : "); put(output_file,r);
        new_line(output_file); new_line(output_file);
      end if;
    end if;
    if auto_tune
     then Continuation_Parameters.Tune(2);
    end if;
    Standard_Complex_Solutions.Clear(st_target_sols);
    Standard_Complex_Solutions.Copy(st_start_sols,st_target_sols);
    Standard_Complex_Solutions.Set_Continuation_Parameter
      (st_target_sols,Create(0.0));
    if file_okay then
      tstart(timer);
      Rep_Cont(output_file,st_target_sols,false,Create(1.0));
      Standard_Root_Refiners.Reporting_Root_Refiner
        (output_file,st_target_sys.all,st_target_sols,epsxa,epsfa,
         tolsing,numit,max,deflate,false);
      tstop(timer);
      new_line(output_file);
      print_times(output_file,timer,"Solving by Homotopy Continuation");
    else
      Sil_Cont(st_target_sols,false,Create(1.0));
      Standard_Root_Refiners.Silent_Root_Refiner
        (st_target_sys.all,st_target_sols,epsxa,epsfa,tolsing,numit,max,deflate);
    end if;
    Copy_Labels;
   -- Standard_Homotopy.Clear;  -- for dynamic load balancing
    return 0;
  exception
    when others => return 1;
  end Solve_by_Homotopy_Continuation;

  function Solve_by_DoblDobl_Homotopy_Continuation return integer32 is

    use DoblDobl_Complex_Numbers,DoblDobl_Complex_Vector_Norms;
    use DoblDobl_IncFix_Continuation;

    k : constant natural32 := 2;
    r : Complex_Number; 
   -- epsxa : constant double_float := 1.0E-24;
   -- epsfa : constant double_float := 1.0E-24;
   -- tolsing : constant double_float := 1.0E-16;
   -- numit : natural := 0;
   -- max : constant natural := 4;
   -- deflate : boolean := false;
    timer : Timing_Widget;

    procedure Sil_Cont is
      new Silent_Continue(Max_Norm,DoblDobl_Homotopy.Eval,
                          DoblDobl_Homotopy.Diff,DoblDobl_Homotopy.Diff);

    procedure Rep_Cont is
      new Reporting_Continue(Max_Norm,DoblDobl_Homotopy.Eval,
                             DoblDobl_Homotopy.Diff,DoblDobl_Homotopy.Diff);

  begin
    if zero_constant
     then r := DoblDobl_Complex_Numbers.Create
                 (Double_Double_Numbers.create(0.793450603947633),
                  Double_Double_Numbers.create(-0.608634651572795));
     else r := dd_gamma_constant;
    end if;
    if empty_dobldobl_homotopy then
      DoblDobl_Homotopy.Create(dd_target_sys.all,dd_start_sys.all,k,r);
      empty_dobldobl_homotopy := false; -- for dynamic load balancing
      if file_okay then
        new_line(output_file);
        put_line(output_file,"HOMOTOPY PARAMETERS :");
        put(output_file,"  k : "); put(output_file,k,2);
        new_line(output_file);
        put(output_file,"  gamma : "); put(output_file,r);
        new_line(output_file); new_line(output_file);
      end if;
    end if;
    if auto_tune
     then Continuation_Parameters.Tune(2);
    end if;
    DoblDobl_Complex_Solutions.Clear(dd_target_sols);
    DoblDobl_Complex_Solutions.Copy(dd_start_sols,dd_target_sols);
    DoblDobl_Complex_Solutions.Set_Continuation_Parameter
      (dd_target_sols,Create(integer(0)));
    if file_okay then
      tstart(timer);
      Rep_Cont(output_file,dd_target_sols,Create(integer(1)));
     -- Standard_Root_Refiners.Reporting_Root_Refiner
     --   (output_file,st_target_sys.all,st_target_sols,epsxa,epsfa,
     --    tolsing,numit,max,deflate,false);
      tstop(timer);
      new_line(output_file);
      print_times(output_file,timer,"Solving by Homotopy Continuation");
    else
      Sil_Cont(dd_target_sols,Create(integer(1)));
     -- Standard_Root_Refiners.Silent_Root_Refiner
     --   (st_target_sys.all,st_target_sols,epsxa,epsfa,
     --    tolsing,numit,max,deflate);
    end if;
    Copy_DoblDobl_Labels;
   -- DoblDobl_Homotopy.Clear;  -- for dynamic load balancing
    return 0;
  exception
    when others => return 1;
  end Solve_by_DoblDobl_Homotopy_Continuation;

  function Solve_by_QuadDobl_Homotopy_Continuation return integer32 is

    use QuadDobl_Complex_Numbers,QuadDobl_Complex_Vector_Norms;
    use QuadDobl_IncFix_Continuation;

    k : constant natural32 := 2;
    r : Complex_Number; 
   -- epsxa : constant double_float := 1.0E-54;
   -- epsfa : constant double_float := 1.0E-54;
   -- tolsing : constant double_float := 1.0E-32;
   -- numit : natural := 0;
   -- max : constant natural := 4;
   -- deflate : boolean := false;
    timer : Timing_Widget;

    procedure Sil_Cont is
      new Silent_Continue(Max_Norm,QuadDobl_Homotopy.Eval,
                          QuadDobl_Homotopy.Diff,QuadDobl_Homotopy.Diff);

    procedure Rep_Cont is
      new Reporting_Continue(Max_Norm,QuadDobl_Homotopy.Eval,
                             QuadDobl_Homotopy.Diff,QuadDobl_Homotopy.Diff);

  begin
    if zero_constant
     then r := QuadDobl_Complex_Numbers.Create
                 (Quad_Double_Numbers.create(0.793450603947633),
                  Quad_Double_Numbers.create(-0.608634651572795));
     else r := qd_gamma_constant;
    end if;
    if empty_quaddobl_homotopy then
      QuadDobl_Homotopy.Create(qd_target_sys.all,qd_start_sys.all,k,r);
      empty_quaddobl_homotopy := false; -- for dynamic load balancing
      if file_okay then
        new_line(output_file);
        put_line(output_file,"HOMOTOPY PARAMETERS :");
        put(output_file,"  k : "); put(output_file,k,2);
        new_line(output_file);
        put(output_file,"  gamma : "); put(output_file,r);
        new_line(output_file); new_line(output_file);
      end if;
    end if;
    if auto_tune
     then Continuation_Parameters.Tune(2);
    end if;
    QuadDobl_Complex_Solutions.Clear(qd_target_sols);
    QuadDobl_Complex_Solutions.Copy(qd_start_sols,qd_target_sols);
    QuadDobl_Complex_Solutions.Set_Continuation_Parameter
      (qd_target_sols,Create(integer(0)));
    if file_okay then
      tstart(timer);
      Rep_Cont(output_file,qd_target_sols,Create(integer(1)));
     -- Standard_Root_Refiners.Reporting_Root_Refiner
     --   (output_file,st_target_sys.all,st_target_sols,epsxa,epsfa,
     --    tolsing,numit,max,deflate,false);
      tstop(timer);
      new_line(output_file);
      print_times(output_file,timer,"Solving by Homotopy Continuation");
    else
      Sil_Cont(qd_target_sols,Create(integer(1)));
     -- Standard_Root_Refiners.Silent_Root_Refiner
     --   (st_target_sys.all,st_target_sols,epsxa,epsfa,
     --   tolsing,numit,max,deflate);
    end if;
    Copy_QuadDobl_Labels;
   -- QuadDobl_Homotopy.Clear;  -- for dynamic load balancing
    return 0;
  exception
    when others => return 1;
  end Solve_by_QuadDobl_Homotopy_Continuation;

  procedure Clear is
  begin
    Standard_Complex_Poly_Systems.Clear(st_start_sys);
    Standard_Complex_Solutions.Clear(st_start_sols);
    Standard_Complex_Poly_Systems.Clear(st_target_sys);
    Standard_Complex_Solutions.Clear(st_target_sols);
    if not empty_homotopy then
      Standard_Homotopy.Clear;
      empty_homotopy := true;
    end if;
  end Clear;

  procedure DoblDobl_Clear is
  begin
    DoblDobl_Complex_Poly_Systems.Clear(dd_start_sys);
    DoblDobl_Complex_Solutions.Clear(dd_start_sols);
    DoblDobl_Complex_Poly_Systems.Clear(dd_target_sys);
    DoblDobl_Complex_Solutions.Clear(dd_target_sols);
    if not empty_dobldobl_homotopy then
      DoblDobl_Homotopy.Clear;
      empty_dobldobl_homotopy := true;
    end if;
  end DoblDobl_Clear;

  procedure QuadDobl_Clear is
  begin
    QuadDobl_Complex_Poly_Systems.Clear(qd_start_sys);
    QuadDobl_Complex_Solutions.Clear(qd_start_sols);
    QuadDobl_Complex_Poly_Systems.Clear(qd_target_sys);
    QuadDobl_Complex_Solutions.Clear(qd_target_sols);
    if not empty_quaddobl_homotopy then
      QuadDobl_Homotopy.Clear;
      empty_quaddobl_homotopy := true;
    end if;
  end QuadDobl_Clear;

begin
  auto_tune := true;
  file_okay := false;
  empty_homotopy := true;
  empty_dobldobl_homotopy := true;
  empty_quaddobl_homotopy := true;
  zero_constant := true;
  zero_dobldobl_constant := true;
  zero_quaddobl_constant := true;
end PHCpack_Operations;
