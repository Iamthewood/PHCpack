with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Quad_Double_Vectors;
with Continuation_Parameters;            use Continuation_Parameters;
with QuadDobl_Continuation_Data;         use QuadDobl_Continuation_Data;
with QuadDobl_Continuation_Data_io;      use QuadDobl_Continuation_Data_io;
with QuadDobl_Path_Trackers;             use QuadDobl_Path_Trackers;

package body QuadDobl_IncFix_Continuation is

  tol : constant double_float := 10.0E-14;

  procedure Silent_Continue
               ( sols : in out Solution_List;
                 target : in Complex_Number := Create(integer(1)) ) is

    res,res_last : Solution_List;
    tmp : Solution_List := sols;
    patpp : constant Pred_Pars := Continuation_Parameters.Create_for_Path;
    endpp : constant Pred_Pars := Continuation_Parameters.Create_End_Game;
    patcp : constant Corr_Pars := Continuation_Parameters.Create_for_Path;
    endcp : constant Corr_Pars := Continuation_Parameters.Create_End_Game;
    pathdir : Quad_Double_Vectors.Link_to_Vector;
    errv : quad_double;
    order : constant integer32
          := integer32(Continuation_Parameters.endext_order);

    procedure Continue_along_Path is
      new Linear_Single_Normal_Silent_Continue(Norm,H,dH,dH);

    procedure Continue_End_Game is
      new Linear_Single_Conditioned_Silent_Continue(Norm,H,dH,dH);

  begin
    while not Is_Null(tmp) loop
      declare
        ls : constant Link_to_Solution := Head_Of(tmp);
        s : Solu_Info := Deep_Create(ls.all);
      begin
        Continue_along_Path(s,target,tol,false,patpp,patcp);
        Continue_End_Game(s,target,tol,false,order,pathdir,errv,endpp,endcp);
        Append(res,res_last,Deep_Create(s));
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Copy(res,sols); Clear(res);
  end Silent_Continue;

  procedure Reporting_Continue
               ( file : in file_type; sols : in out Solution_List;
                 target : in Complex_Number := Create(integer(1)) ) is

    res,res_last : Solution_List;
    tmp : Solution_List := sols;
    patpp : constant Pred_Pars := Continuation_Parameters.Create_for_Path;
    endpp : constant Pred_Pars := Continuation_Parameters.Create_End_Game;
    patcp : constant Corr_Pars := Continuation_Parameters.Create_for_Path;
    endcp : constant Corr_Pars := Continuation_Parameters.Create_End_Game;
    pathdir : Quad_Double_Vectors.Link_to_Vector;
    tol_zero : constant double_float := endcp.epsaf;
    errv : quad_double;
    order : constant integer32
          := integer32(Continuation_Parameters.endext_order);
    len : constant natural32 := Length_Of(sols);
    cnt,nbfail,nbregu,nbsing,kind : natural32 := 0;

    procedure Continue_along_Path is
      new Linear_Single_Normal_Reporting_Continue(Norm,H,dH,dH);

    procedure Continue_End_Game is
      new Linear_Single_Conditioned_Reporting_Continue(Norm,H,dH,dH);

  begin
    new_line(file);
    put_line(file,"THE SOLUTIONS :");
    put(file,len,1); put(file," ");
    put(file,Head_Of(sols).n,1); new_line(file);
    for i in 1..76 loop put(file,"="); end loop;
    new_line(file); flush(file);
    for i in 1..len loop
      declare
        ls : constant Link_to_Solution := Head_Of(tmp);
        s : Solu_Info := Deep_Create(ls.all);
      begin
        Continue_along_Path(file,s,target,tol,false,patpp,patcp);
        Continue_End_Game(file,s,target,tol,false,
                          order,pathdir,errv,endpp,endcp);
        Write_Next_Solution
          (file,cnt,s,tol_zero,tol_zero,nbfail,nbregu,nbsing,kind);
        text_io.flush(file);
        Append(res,res_last,Deep_Create(s));
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Copy(res,sols); Clear(res);
    put(file,"Number of path failures      : ");
    put(file,nbfail,1); new_line(file);
    put(file,"Number of regular solutions  : ");
    put(file,nbregu,1); new_line(file);
    put(file,"Number of singular solutions : ");
    put(file,nbsing,1); new_line(file);
    new_line(file);
  end Reporting_Continue;

end QuadDobl_IncFix_Continuation;
