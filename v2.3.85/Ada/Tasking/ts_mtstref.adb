with text_io,integer_io;                use text_io,integer_io;
with Communications_with_User;          use Communications_with_User;
with Timing_Package;                    use Timing_Package;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Complex_Poly_Systems;     use Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_SysFun;      use Standard_Complex_Poly_SysFun;
with Standard_Complex_Jaco_Matrices;    use Standard_Complex_Jaco_Matrices;
with Standard_Complex_Solutions;        use Standard_Complex_Solutions;
with Standard_System_and_Solutions_io;  use Standard_System_and_Solutions_io;
with Standard_Root_Refiners;            use Standard_Root_Refiners;
with Multitasking,Semaphore;

procedure ts_mtstref is

-- DESCRIPTION :
--   Test on multitasking a solution list of a polynomial system.

  procedure Refine_Solution
               ( id,nb : in natural; ls : in Link_to_Solution;
                 f : in Eval_Poly_Sys; jf : in Eval_Jaco_Mat ) is

  -- DESCRIPTION :
  --   Task with identification number id reports the receipt of
  --   solution with number nb, with data in ls.

    epsxa : constant double_float := 1.0E-16;
    epsfa : constant double_float := 1.0E-16;
    numit : natural := 0;
    maxit : constant natural := 3;
    fail : boolean;

  begin
    put_line("Task " & Multitasking.to_String(id)
                     & " received solution " 
                     & Multitasking.to_String(nb) & ".");
    Silent_Newton(f,jf,ls.all,epsxa,epsfa,numit,maxit,fail);
  end Refine_Solution;

  procedure Multitasking_Refinement
               ( p : in Poly_Sys; sols : in Solution_List; 
                 n : in natural ) is

  -- DESCRIPTION :
  --   Given a polynomial system p with solutions in sols,
  --   n threads will be launched to multitask on the solution list.

    f : Eval_Poly_Sys(p'range) := Create(p);
    jf : Jaco_Mat(p'range,p'range) := Create(p);
    ejf : Eval_Jaco_Mat(jf'range(1),jf'range(2)) := Create(jf);
    ptr : Solution_List;
    cnt : natural := 0;

    procedure Next_Solution ( i,n : in natural ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list,
    --   advancing the pointer ptr in a critical section,
    --   simultanuously with the counter.

    -- CORRESPONDENCE BETWEEN cnt AND ptr :
    --   cnt = 0                   <=> ptr not set to sols yet
    --   cnt in 1..Length_Of(sols) <=> ptr points to current solution
    --   cnt = Length_Of(sols) + 1 <=> Is_Null(ptr)

      s : Semaphore.Lock;
      myjob : natural;
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
        Refine_Solution(i,myjob,ls,f,ejf);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Reporting_Workers(Next_Solution);

  begin
    do_jobs(n);
    Clear(f); Clear(jf); Clear(ejf);
  end Multitasking_Refinement;

  procedure Distribute_Solutions
               ( head,tail : in out Array_of_Solution_Lists;
                 sols : in Solution_List ) is

  -- DESCRIPTION :
  --   Distributes pointers to the solutions in sols into the array head,
  --   where tail points to the last element in each list.

    tmp : Solution_List := sols;
    ls : Link_to_Solution;
    ind : natural := head'first - 1;

  begin
    while not Is_Null(tmp) loop
      ls := Head_Of(tmp);
      ind := ind + 1;
      if ind > head'last
       then ind := head'first;
      end if;
      Append(head(ind),tail(ind),ls);
      tmp := Tail_Of(tmp);
    end loop;
  end Distribute_Solutions;

  procedure Static_Multitasking
               ( p : in Poly_Sys; head,tail : in Array_of_Solution_Lists;
                 n : in natural ) is

  -- DESCRIPTION :
  --   Creates n tasks, the i-th tasks works on the i-th list.

    f : Eval_Poly_Sys(p'range) := Create(p);
    jf : Jaco_Mat(p'range,p'range) := Create(p);
    ejf : Eval_Jaco_Mat(jf'range(1),jf'range(2)) := Create(jf);

    procedure Next_Solution ( i,n : in natural ) is

    -- DESCRIPTION :
    --   The n threads will run through the solution list head(i).

      ls : Link_to_Solution;
      ptr : Solution_List := head(i);
      cnt : natural := 0;

    begin
      while not Is_Null(ptr) loop
        cnt := cnt + 1;
        ls := Head_Of(ptr);
        Refine_Solution(i,cnt,ls,f,ejf);
        ptr := Tail_Of(ptr);
      end loop;
    end Next_Solution;
    procedure do_jobs is new Multitasking.Reporting_Workers(Next_Solution);

  begin
    do_jobs(n);
    Clear(f); Clear(jf); Clear(ejf);
  end Static_Multitasking;

  procedure Static_Multitasking
               ( p : in Poly_Sys; sols : in Solution_List; n : in natural ) is

  -- DESCRIPTION :
  --   Distributes the solution list first among the threads.

    first,last : Array_of_Solution_Lists(1..n);

  begin
    Distribute_Solutions(first,last,sols);
    put("Distribution counts :");
    for i in 1..n loop
      put(" "); put(Length_Of(first(i)),1);
    end loop;
    new_line;
    Static_Multitasking(p,first,last,n);
  end Static_Multitasking;

  procedure Main is

    p : Link_to_Poly_Sys;
    s : Solution_List;
    n : natural;
    file : file_type;
    timer : Timing_Widget;

  begin
    new_line;
    put_line("Test on multitasking refinement ...");
    new_line;
    put_line("Reading a system and its solutions ...");
    get(p,s);
    new_line;
    put("Read "); put(Length_Of(s),1); put_line(" solutions.");
    new_line;
    put("Give the number of threads : "); get(n);
    new_line;
    skip_line;
    put_line("Reading the name of the output file...");
    Read_Name_and_Create_File(file);
    tstart(timer);
    Multitasking_Refinement(p.all,s,n);
   -- Static_Multitasking(p.all,s,n);
    tstop(timer);
    put(file,p.all,s);
    new_line(file);
    print_times(file,timer,"multitasking refinement");
  end Main;

begin
  Main;
end ts_mtstref;
