with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Timing_Package;                     use Timing_Package;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Complex_Laur_Systems;
with Multprec_Complex_Laurentials_io;
with Multprec_Complex_Laur_Systems;
with DoblDobl_Polynomial_Convertors;     use DoblDobl_Polynomial_Convertors;
with QuadDobl_Polynomial_Convertors;     use QuadDobl_Polynomial_Convertors;
with Standard_Complex_Solutions;
with DoblDobl_Complex_Solutions_io;
with QuadDobl_Complex_Solutions_io;
with Multprec_Complex_Solutions;
with Standard_System_and_Solutions_io;
with Multprec_System_and_Solutions_io;
with DoblDobl_Root_Refiners;             use DoblDobl_Root_Refiners;
with QuadDobl_Root_Refiners;             use QuadDobl_Root_Refiners;

package body Drivers_to_dd_qd_Root_Refiners is

  procedure Standard_to_DoblDobl_Complex
              ( p : out DoblDobl_Complex_Laur_Systems.Link_to_Laur_Sys;
                s : out DoblDobl_Complex_Solutions.Solution_List ) is

    q : Standard_Complex_Laur_Systems.Link_to_Laur_Sys;
    sols : Standard_Complex_Solutions.Solution_List;

  begin
    Standard_System_and_Solutions_io.get(q,sols);
    declare
      sq : constant DoblDobl_Complex_Laur_Systems.Laur_Sys
         := Standard_Laur_Sys_to_DoblDobl_Complex(q.all);
    begin
      p := new DoblDobl_Complex_Laur_Systems.Laur_Sys'(sq);
    end;
    s := DoblDobl_Complex_Solutions.Create(sols);
  end Standard_to_DoblDobl_Complex;

  procedure Multprec_to_DoblDobl_Complex
              ( p : out DoblDobl_Complex_Laur_Systems.Link_to_Laur_Sys;
                s : out DoblDobl_Complex_Solutions.Solution_List ) is

    q : Multprec_Complex_Laur_Systems.Link_to_Laur_Sys;
    sols : Multprec_Complex_Solutions.Solution_List;

  begin
    Multprec_Complex_Laurentials_io.Set_Working_Precision(5);
    Multprec_System_and_Solutions_io.get(q,sols);
    declare
      sq : constant DoblDobl_Complex_Laur_Systems.Laur_Sys
         := Multprec_Laur_Sys_to_DoblDobl_Complex(q.all);
    begin
      p := new DoblDobl_Complex_Laur_Systems.Laur_Sys'(sq);
    end;
    s := DoblDobl_Complex_Solutions.Create(sols);
  end Multprec_to_DoblDobl_Complex;

  procedure Standard_to_QuadDobl_Complex
              ( p : out QuadDobl_Complex_Laur_Systems.Link_to_Laur_Sys;
                s : out QuadDobl_Complex_Solutions.Solution_List ) is

    q : Standard_Complex_Laur_Systems.Link_to_Laur_Sys;
    sols : Standard_Complex_Solutions.Solution_List;

  begin
    Standard_System_and_Solutions_io.get(q,sols);
    declare
      sq : constant QuadDobl_Complex_Laur_Systems.Laur_Sys
         := Standard_Laur_Sys_to_QuadDobl_Complex(q.all);
    begin
      p := new QuadDobl_Complex_Laur_Systems.Laur_Sys'(sq);
    end;
    s := QuadDobl_Complex_Solutions.Create(sols);
  end Standard_to_QuadDobl_Complex;

  procedure Multprec_to_QuadDobl_Complex
              ( p : out QuadDobl_Complex_Laur_Systems.Link_to_Laur_Sys;
                s : out QuadDobl_Complex_Solutions.Solution_List ) is

    q : Multprec_Complex_Laur_Systems.Link_to_Laur_Sys;
    sols : Multprec_Complex_Solutions.Solution_List;

  begin
    Multprec_Complex_Laurentials_io.Set_Working_Precision(10);
    Multprec_System_and_Solutions_io.get(q,sols);
    declare
      sq : constant QuadDobl_Complex_Laur_Systems.Laur_Sys
         := Multprec_Laur_Sys_to_QuadDobl_Complex(q.all);
    begin
      p := new QuadDobl_Complex_Laur_Systems.Laur_Sys'(sq);
    end;
    s := QuadDobl_Complex_Solutions.Create(sols);
  end Multprec_to_QuadDobl_Complex;

  procedure DD_QD_Root_Refinement is

    ans : character;
    timer : Timing_Widget;
    file : file_type;
    dd_p : DoblDobl_Complex_Laur_Systems.Link_to_Laur_Sys;
    qd_p : QuadDobl_Complex_Laur_Systems.Link_to_Laur_Sys;
    dd_s : DoblDobl_Complex_Solutions.Solution_List;
    qd_s : QuadDobl_Complex_Solutions.Solution_List;

  begin
    new_line;
    put_line("MENU for Newton in double double or quad double arithmetic :");
    put_line("  1. use complex double double arithmetic;");
    put_line("  2. use complex quad double arithmetic.");
    put("Type 1 or 2 to make a choice : ");
    Ask_Alternative(ans,"12");
    if ans = '1' then
     -- Standard_to_DoblDobl_Complex(dd_p,dd_s);
      Multprec_to_DoblDobl_Complex(dd_p,dd_s);
      new_line;
      put_line("Reading the name of the output file ...");
      Read_Name_and_Create_File(file);
      new_line; put("refining "); 
      put(DoblDobl_Complex_Solutions.Length_Of(dd_s),1);
      put(" solutions ...");
      tstart(timer);
      DoblDobl_Root_Refiner(dd_p.all,dd_s);
      tstop(timer);
      put_line(" see the output file for results"); new_line;
      DoblDobl_Complex_Solutions_io.write(file,dd_s);
      new_line(file);
      print_times(file,timer,"double double Newton refinement");
      close(file);
    else
     -- Standard_to_QuadDobl_Complex(qd_p,qd_s);
      Multprec_to_QuadDobl_Complex(qd_p,qd_s);
      new_line;
      put_line("Reading the name of the output file ...");
      Read_Name_and_Create_File(file);
      new_line; put("refining "); 
      put(QuadDobl_Complex_Solutions.Length_Of(qd_s),1);
      put(" solutions ...");
      tstart(timer);
      QuadDobl_Root_Refiner(qd_p.all,qd_s);
      tstop(timer);
      put_line(" see the output file for results"); new_line;
      QuadDobl_Complex_Solutions_io.write(file,qd_s);
      new_line(file);
      print_times(file,timer,"quad double Newton refinement");
      close(file);
    end if;
  end DD_QD_Root_Refinement;

end Drivers_to_dd_qd_Root_Refiners;
