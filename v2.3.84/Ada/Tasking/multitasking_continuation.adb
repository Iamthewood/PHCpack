with Communications_with_User;           use Communications_with_User;
with Timing_Package;                     use Timing_Package;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Complex_Polynomials;       use Standard_Complex_Polynomials;
with Standard_Complex_Poly_Systems_io;   use Standard_Complex_Poly_Systems_io;
with Standard_Complex_Solutions_io;      use Standard_Complex_Solutions_io;
with DoblDobl_Complex_Solutions_io;      use DoblDobl_Complex_Solutions_io;
with QuadDobl_Complex_Solutions_io;      use QuadDobl_Complex_Solutions_io;
with Standard_System_and_Solutions_io;   use Standard_System_and_Solutions_io;
with Drivers_for_Homotopy_Creation;      use Drivers_for_Homotopy_Creation;
with Continuation_Parameters;
with Drivers_for_Poly_Continuation;      use Drivers_for_Poly_Continuation;
with PHCpack_Operations;
with Multitasking,Semaphore;

package body Multitasking_Continuation is

  procedure Silent_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    PHCpack_Operations.Silent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Path_Tracker;

  procedure Silent_Path_Tracker
               ( ls : in DoblDobl_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    PHCpack_Operations.Silent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Path_Tracker;

  procedure Silent_Path_Tracker
               ( ls : in QuadDobl_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    PHCpack_Operations.Silent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Path_Tracker;

  procedure Silent_Path_Tracker
               ( id,nb : in integer32;
                 ls : in Standard_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    put_line("Task " & Multitasking.to_String(natural32(id))
                     & " received solution " 
                     & Multitasking.to_String(natural32(nb)) & ".");
    PHCpack_Operations.Silent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Path_Tracker;

  procedure Silent_Path_Tracker
               ( id,nb : in integer32;
                 ls : in DoblDobl_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    put_line("Task " & Multitasking.to_String(natural32(id))
                     & " received solution " 
                     & Multitasking.to_String(natural32(nb)) & ".");
    PHCpack_Operations.Silent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Path_Tracker;

  procedure Silent_Path_Tracker
               ( id,nb : in integer32;
                 ls : in QuadDobl_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    put_line("Task " & Multitasking.to_String(natural32(id))
                     & " received solution " 
                     & Multitasking.to_String(natural32(nb)) & ".");
    PHCpack_Operations.Silent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Path_Tracker;

  procedure Silent_Laurent_Path_Tracker
               ( ls : in Standard_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    PHCpack_Operations.Silent_Laurent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Laurent_Path_Tracker;

  procedure Silent_Laurent_Path_Tracker
               ( id,nb : in integer32;
                 ls : in Standard_Complex_Solutions.Link_to_Solution ) is

    length : double_float := 0.0;
    nbstep,nbfail,nbiter,nbsyst : natural32 := 0;
    fail : boolean := true;

  begin
    put_line("Task " & Multitasking.to_String(natural32(id))
                     & " received solution " 
                     & Multitasking.to_String(natural32(nb)) & ".");
    PHCpack_Operations.Silent_Laurent_Path_Tracker
      (ls,length,nbstep,nbfail,nbiter,nbsyst,fail);
  end Silent_Laurent_Path_Tracker;

  procedure Silent_Multitasking_Path_Tracker
               ( sols : in out Standard_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use Standard_Complex_Solutions;
    ptr : Solution_List;
    cnt : integer32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Path_Tracker(ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Silent_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Silent_Multitasking_Path_Tracker;

  procedure Silent_Multitasking_Path_Tracker
               ( sols : in out DoblDobl_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use DoblDobl_Complex_Solutions;
    ptr : Solution_List;
    cnt : integer32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Path_Tracker(ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Silent_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Silent_Multitasking_Path_Tracker;

  procedure Silent_Multitasking_Path_Tracker
               ( sols : in out QuadDobl_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use QuadDobl_Complex_Solutions;
    ptr : Solution_List;
    cnt : integer32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Path_Tracker(ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Silent_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Silent_Multitasking_Path_Tracker;

  procedure Reporting_Multitasking_Path_Tracker
               ( sols : in out Standard_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use Standard_Complex_Solutions;
    ptr : Solution_List;
    cnt : integer32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myjob : integer32;
      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myjob := cnt;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Path_Tracker(i,myjob,ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Reporting_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Reporting_Multitasking_Path_Tracker;

  procedure Reporting_Multitasking_Path_Tracker
               ( sols : in out DoblDobl_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use DoblDobl_Complex_Solutions;
    ptr : Solution_List;
    cnt : integer32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myjob : integer32;
      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myjob := cnt;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Path_Tracker(i,myjob,ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Reporting_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Reporting_Multitasking_Path_Tracker;

  procedure Reporting_Multitasking_Path_Tracker
               ( sols : in out QuadDobl_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use QuadDobl_Complex_Solutions;
    ptr : Solution_List;
    cnt : integer32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myjob : integer32;
      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myjob := cnt;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Path_Tracker(i,myjob,ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Reporting_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Reporting_Multitasking_Path_Tracker;

  procedure Silent_Multitasking_Laurent_Path_Tracker
               ( sols : in out Standard_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use Standard_Complex_Solutions;
    ptr : Solution_List;
    cnt : natural32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Laurent_Path_Tracker(ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Silent_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Silent_Multitasking_Laurent_Path_Tracker;

  procedure Reporting_Multitasking_Laurent_Path_Tracker
               ( sols : in out Standard_Complex_Solutions.Solution_List;
                 n : in integer32 ) is

    use Standard_Complex_Solutions;
    ptr : Solution_List;
    cnt : integer32 := 0;
    s : Semaphore.Lock;

    procedure Next_Solution ( i,n : in integer32 ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      myjob : integer32;
      myptr : Solution_List;
      ls : Link_to_Solution;

    begin
      loop
        Semaphore.Request(s);
        if cnt = 0 then
          cnt := 1;
          ptr := sols;
        else
          cnt := cnt + 1;
          if not Is_Null(ptr)
           then ptr := Tail_Of(ptr);
          end if;
        end if;
        myjob := cnt;
        myptr := ptr;
        Semaphore.Release(s);
        exit when Is_Null(myptr);
        ls := Head_Of(myptr);
        Silent_Laurent_Path_Tracker(i,myjob,ls);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Reporting_Workers(Next_Solution);

  begin
    do_jobs(n);
  end Reporting_Multitasking_Laurent_Path_Tracker;

  procedure Driver_to_Path_Tracker
               ( file : in file_type;
                 p : in Standard_Complex_Poly_Systems.Poly_Sys;
                 ls : in String_Splitters.Link_to_Array_of_Strings;
                 n : in integer32 ) is

    q : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    st_qsols : Standard_Complex_Solutions.Solution_List;
    dd_qsols : DoblDobl_Complex_Solutions.Solution_List;
    qd_qsols : QuadDobl_Complex_Solutions.Solution_List;
    timer : Timing_Widget;
    deci : natural32 := 0;
    ans : character;

  begin
    put(file,natural32(p'last),p);
    new_line;
    put_line("Reading a start system and its solutions ...");
    get(q,st_qsols);
    declare
      pp : Standard_Complex_Poly_Systems.Poly_Sys(p'range);
      t : Complex_Number;
      proj : boolean;
    begin
      Standard_Complex_Poly_Systems.Copy(p,pp);
      Driver_for_Homotopy_Construction(file,ls,pp,q.all,st_qsols,t,deci);
      proj := (Number_of_Unknowns(q(q'first)) > natural32(q'last));
      if proj
       then Ask_Symbol;
      end if;
    end;
    new_line;
    Continuation_Parameters.Tune(0,deci);
    Driver_for_Continuation_Parameters(file);
    new_line;
    put("Do you want to monitor the progress on screen ? (y/n) ");
    Ask_Yes_or_No(ans);
    if ans = 'y' then
      tstart(timer);
      if deci <= 16 then
        Reporting_Multitasking_Path_Tracker(st_qsols,n);
      elsif deci <= 32 then
        dd_qsols := DoblDobl_Complex_Solutions.Create(st_qsols);
        Reporting_Multitasking_Path_Tracker(dd_qsols,n);
      else 
        qd_qsols := QuadDobl_Complex_Solutions.Create(st_qsols);
        Reporting_Multitasking_Path_Tracker(qd_qsols,n);
      end if;
      tstop(timer);
    else
      tstart(timer);
      Silent_Multitasking_Path_Tracker(st_qsols,n);
      tstop(timer);
    end if;
    put_line(file,"THE SOLUTIONS :");
    if deci <= 16 then
      put(file,Standard_Complex_Solutions.Length_Of(st_qsols),
          natural32(Standard_Complex_Solutions.Head_Of(st_qsols).n),st_qsols);
    elsif deci <= 32 then
      put(file,DoblDobl_Complex_Solutions.Length_Of(dd_qsols),
          natural32(DoblDobl_Complex_Solutions.Head_Of(dd_qsols).n),dd_qsols);
    else
      put(file,QuadDobl_Complex_Solutions.Length_Of(qd_qsols),
          natural32(QuadDobl_Complex_Solutions.Head_Of(qd_qsols).n),qd_qsols);
    end if;
    new_line(file);
    print_times(file,timer,"multitasking continuation");
  end Driver_to_Path_Tracker;

end Multitasking_Continuation;
