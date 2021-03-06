with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers_io;        use Standard_Complex_Numbers_io;
with Standard_Integer_Vectors_io;        use Standard_Integer_Vectors_io;
with Standard_Floating_Vectors_io;       use Standard_Floating_Vectors_io;
with Standard_Complex_Vectors_io;        use Standard_Complex_Vectors_io;
with Standard_Complex_Norms_Equals;
with Standard_Integer_Matrices_io;       use Standard_Integer_Matrices_io;
with Standard_Complex_Matrices_io;       use Standard_Complex_Matrices_io;
with Standard_Integer_Linear_Solvers;
with Standard_Complex_Linear_Solvers;
with Standard_Floating_VecVecs;
with Lists_of_Floating_Vectors;          use Lists_of_Floating_Vectors;
with Arrays_of_Integer_Vector_Lists;
with Standard_Complex_Laur_Systems_io;
 use Standard_Complex_Laur_Systems_io;
with Standard_Complex_Laur_Functions;
with Standard_Tableau_Formats;
with Continuation_Parameters;
with Standard_Continuation_Data;
with Standard_Path_Trackers;
with Supports_of_Polynomial_Systems;
with Floating_Mixed_Subdivisions_io;
--with Mixed_Volume_Computation;
with Standard_Radial_Solvers;
with Standard_Binomial_Systems;
with Standard_Binomial_Solvers;
with Floating_Integer_Convertors;
with Floating_Lifting_Utilities;
with Polyhedral_Coefficient_Homotopies;
with Multitasking,Semaphore;
with Multitasking_Volume_Computation;    use Multitasking_Volume_Computation;

package body Multitasking_Polyhedral_Trackers is

-- (1) TABLEAU DATA STRUCTURES FOR START SYSTEM SELECTION :

  function Is_Equal
             ( x : Standard_Integer_Vectors.Link_to_Vector;
               y : Standard_Floating_Vectors.Link_to_Vector )
             return boolean is
  begin
    for i in x'range loop
      if x(i) /= integer32(y(i))
       then return false;
      end if;
    end loop;
    return true;
  end Is_Equal;

  function Coefficient
              ( cff : Standard_Complex_Vectors.Link_to_Vector;
                exp : Standard_Integer_VecVecs.Link_to_VecVec;
                pt : Standard_Floating_Vectors.Link_to_Vector )
              return Complex_Number is

    res : Complex_Number := Create(0.0);

  begin
    for i in exp'range loop
      if Is_Equal(exp(i),pt)
       then res := cff(i); exit;
      end if;
    end loop;
    return res;
  end Coefficient;

  procedure Select_Coefficients
              ( q_c : in Standard_Complex_VecVecs.VecVec;
                q_e : in Standard_Integer_VecVecs.Array_of_VecVecs;
                pts : in Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                cff : out Standard_Complex_Vectors.Vector ) is

    ind : integer32 := cff'first-1;
    tmp : List;
    lpt : Standard_Floating_Vectors.Link_to_Vector;

  begin
    for i in pts'range loop
      tmp := pts(i);
      while not Is_Null(tmp) loop
        lpt := Head_Of(tmp);
        ind := ind + 1;
        cff(ind) := Coefficient(q_c(i),q_e(i),lpt);
        tmp := Tail_Of(tmp);
      end loop;
    end loop;
  end Select_Coefficients;

  procedure Select_Coefficients
              ( q_c : in Standard_Complex_VecVecs.VecVec;
                q_e : in Exponent_Vectors.Exponent_Vectors_Array;
                pts : in Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                cff : out Standard_Complex_Vectors.Vector ) is

    ind : integer32 := cff'first-1;
    tmp : List;
    lpt : Standard_Floating_Vectors.Link_to_Vector;

  begin
    for i in pts'range loop
      tmp := pts(i);
      while not Is_Null(tmp) loop
        lpt := Head_Of(tmp);
        ind := ind + 1;
        cff(ind) := Coefficient(q_c(i),q_e(i),lpt);
        tmp := Tail_Of(tmp);
      end loop;
    end loop;
  end Select_Coefficients;

  procedure Write_Tableau
              ( c : in Standard_Complex_VecVecs.VecVec;
                e : in Standard_Integer_VecVecs.Array_of_VecVecs ) is
  begin
    put(c'last,1); new_line;
    for i in c'range loop
      put(c(i)'last,1); new_line;
      for j in c(i)'range loop
        put(c(i)(j)); put("  ");
        put(e(i)(j)); new_line;
      end loop;
    end loop;
  end Write_Tableau;

  procedure Write_Tableau
              ( c : in Standard_Complex_Vectors.Vector;
                e : in Arrays_of_Floating_Vector_Lists.Array_of_Lists ) is

    ind : integer32 := c'first - 1;
    tmp : List;
    lpt : Standard_Floating_Vectors.Link_to_Vector;

  begin
    put(e'last,1); new_line;
    for i in e'range loop
      put(Length_Of(e(i)),1); new_line;
      tmp := e(i);
      while not Is_Null(tmp) loop
        lpt := Head_Of(tmp);
        ind := ind + 1;
        put(c(ind)); put("  ");
        for k in lpt'first..lpt'last-1 loop -- drop lifting
          put(" "); put(integer32(lpt(k)),1);
        end loop;
        new_line;
        tmp := Tail_Of(tmp);
      end loop;
    end loop;
  end Write_Tableau;

  procedure Fully_Mixed_to_Binomial_Format
              ( c : in Standard_Complex_Vectors.Vector;
                e : in Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                A : out Standard_Integer_Matrices.Matrix;
                b : out Standard_Complex_Vectors.Vector ) is

    first,second : Standard_Floating_Vectors.Link_to_Vector;
    ind : integer32 := c'first;

  begin
    for i in e'range loop
      first := Head_Of(e(i));
      second := Head_Of(Tail_Of(e(i)));
      for j in A'range(2) loop
        A(j,i) := integer32(first(j)) - integer32(second(j));
      end loop;
      b(i) := (-c(ind+1))/c(ind);
      ind := ind + 2;
    end loop;
  end Fully_Mixed_to_Binomial_Format;

  procedure Select_Subsystem_to_Matrix_Format 
              ( q_c : in Standard_Complex_VecVecs.VecVec;
                q_e : in Standard_Integer_VecVecs.Array_of_VecVecs;
                mix : in Standard_Integer_Vectors.Vector;
                pts : in Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                A : out Standard_Integer_Matrices.Matrix;
                C : out Standard_Complex_Matrices.Matrix;
                b : out Standard_Complex_Vectors.Vector ) is

    ind : integer32 := q_c'first-1;
    first,second : Standard_Floating_Vectors.Link_to_Vector;
    tmp : List;
    col : integer32 := A'first(2) - 1;

  begin
    for i in C'range(1) loop
      for j in C'range(2) loop
        C(i,j) := Create(0.0);
      end loop;
    end loop;
    for i in mix'range loop
      first := Head_Of(pts(i));
      for k in 1..mix(i) loop
        b(ind+k) := -Coefficient(q_c(ind+k),q_e(ind+k),first);
      end loop;
      tmp := Tail_Of(pts(i));
      while not Is_Null(tmp) loop
        second := Head_Of(tmp);
        col := col + 1;
        for row in A'range(1) loop
          A(row,col) := integer32(second(row)) - integer32(first(row));
        end loop;
        for k in 1..mix(i) loop
          C(ind+k,col) := Coefficient(q_c(ind+k),q_e(ind+k),second);
        end loop;
        tmp := Tail_Of(tmp);
      end loop;
      ind := ind + mix(i);
    end loop;
  end Select_Subsystem_to_Matrix_Format;

  procedure Select_Subsystem_to_Matrix_Format 
              ( q_c : in Standard_Complex_VecVecs.VecVec;
                q_e : in Exponent_Vectors.Exponent_Vectors_Array;
                mix : in Standard_Integer_Vectors.Vector;
                pts : in Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                A : out Standard_Integer_Matrices.Matrix;
                C : out Standard_Complex_Matrices.Matrix;
                b : out Standard_Complex_Vectors.Vector ) is

    ind : integer32 := q_c'first-1;
    first,second : Standard_Floating_Vectors.Link_to_Vector;
    tmp : List;
    col : integer32 := A'first(2) - 1;

  begin
    for i in C'range(1) loop
      for j in C'range(2) loop
        C(i,j) := Create(0.0);
      end loop;
    end loop;
    for i in mix'range loop
      first := Head_Of(pts(i));
      for k in 1..mix(i) loop
        b(ind+k) := -Coefficient(q_c(ind+k),q_e(ind+k),first);
      end loop;
      tmp := Tail_Of(pts(i));
      while not Is_Null(tmp) loop
        second := Head_Of(tmp);
        col := col + 1;
        for row in A'range(1) loop
          A(row,col) := integer32(second(row)) - integer32(first(row));
        end loop;
        for k in 1..mix(i) loop
          C(ind+k,col) := Coefficient(q_c(ind+k),q_e(ind+k),second);
        end loop;
        tmp := Tail_Of(tmp);
      end loop;
      ind := ind + mix(i);
    end loop;
  end Select_Subsystem_to_Matrix_Format;

-- (2) INPLACE BINOMIAL SYSTEM SOLVERS FOR START SOLUTIONS :

  function Create ( n : integer32 ) return Solution is

    res : Solution(n);

  begin
    res.t := Create(0.0);
    res.m := 1;
    res.v := (1..n => Create(0.0));
    res.err := 0.0;
    res.rco := 1.0;
    res.res := 0.0;
    return res;
  end Create;

  function Create ( n,m : integer32 ) return Solution_List is

    res,res_last : Solution_List;

  begin
    for i in 1..m loop
      Append(res,res_last,Create(n));
    end loop;
    return res;
  end Create;

  function Product_of_Diagonal
             ( A : Standard_Integer_Matrices.Matrix ) return integer32 is

    res : integer32 := 1;

  begin
    for i in A'range loop
      res := res*A(i,i);
    end loop;
    return res;
  end Product_of_Diagonal;

  function Volume_of_Diagonal
             ( A : Standard_Integer_Matrices.Matrix ) return natural32 is

    res : constant integer32 := Product_of_Diagonal(A);

  begin
    if res >= 0
     then return natural32(res);
     else return natural32(-res);
    end if;
  end Volume_of_Diagonal;

  function Volume_of_Cell
             ( A : Standard_Integer_Matrices.Matrix ) return natural32 is

    res : constant integer32
        := Standard_Integer_Linear_Solvers.Det(A);

  begin
    if res >= 0
     then return natural32(res);
     else return natural32(-res);
    end if;
  end Volume_of_Cell;

  procedure Fully_Mixed_Start_Systems
              ( q : in Laur_Sys; mcc : in Mixed_Subdivision ) is

    n : constant integer32 := q'last;
    cff : Standard_Complex_VecVecs.VecVec(q'range);
    exp : Standard_Integer_VecVecs.Array_of_VecVecs(q'range);
    mic : Mixed_Cell;
    tmp : Mixed_Subdivision := mcc;
    s_c : Standard_Complex_Vectors.Vector(1..2*n); -- fully mixed
    A,M,U : Standard_Integer_Matrices.Matrix(q'range,q'range);
    prod : integer32;
    b,wrk : Standard_Complex_Vectors.Vector(q'range);
    brd,logbrd,logx,e10x : Standard_Floating_Vectors.Vector(b'range);
    bsc : Standard_Complex_Vectors.Vector(b'range);
    rnk : integer32 := 0;
    len,totlen : natural32 := 0;
    res,chksum : double_float := 0.0;
    sols,Asols : Solution_List;

  begin
    Standard_Tableau_Formats.Extract_Coefficients_and_Exponents(q,cff,exp);
   -- put_line("The tableau format : "); Write_Tableau(cff,exp);
    for i in 1..Length_Of(mcc) loop
      mic := Head_Of(tmp);
     -- setting up the binomial system
      Select_Coefficients(cff,exp,mic.pts.all,s_c);
      put("sys "); put(i,1); -- put_line(" :"); Write_Tableau(s_c,mic.pts.all);
      Fully_Mixed_To_Binomial_Format(s_c,mic.pts.all,A,b);
     -- solving in place :
      U := A;
      Standard_Integer_Linear_Solvers.Upper_Triangulate(M,U);
      prod := Product_of_Diagonal(U);
      if prod < 0
       then Asols := Create(n,-prod);
       else Asols := Create(n,prod);
      end if;
      put(" : det : "); put(prod,1);
      brd := Standard_Radial_Solvers.Radii(b);
      bsc := Standard_Radial_Solvers.Scale(b,brd);
     -- Asols := Standard_Binomial_Solvers.Solve_Upper_Square(U,bsc);
      Standard_Binomial_Solvers.Solve_Upper_Square(U,bsc,Asols);
      logbrd := Standard_Radial_Solvers.Log10(brd);
      logx := Standard_Radial_Solvers.Radial_Upper_Solve(U,logbrd);
      logx := Standard_Radial_Solvers.Multiply(M,logx);
      e10x := Standard_Radial_Solvers.Exp10(logx);
      Standard_Binomial_Systems.Eval(M,Asols,wrk);
      Standard_Radial_Solvers.Multiply(Asols,e10x);
     -- solving with one call :
      Standard_Binomial_Solvers.Solve(A,b,rnk,M,U,sols);
     -- checking the solutions :
      len := Length_Of(sols);
      res := Standard_Binomial_Solvers.Sum_Residuals(A,b,Asols);
      put(" det(A) = "); put(Standard_Integer_Linear_Solvers.Det(A),1);
      put(", found "); put(len,1);
      put(" solutions, residual = "); put(res,3); new_line;
      Clear(sols); Clear(Asols);
      chksum := chksum + res;
      totlen := totlen + len;
      tmp := Tail_Of(tmp);
    end loop;
    put("number of solutions found : "); put(totlen,1); new_line;
    put("total sum over all residuals : "); put(chksum,3); new_line;
  end Fully_Mixed_Start_Systems;

  procedure Semi_Mixed_Start_Systems
              ( q : in Laur_Sys; m : in natural32;
                mix : in Standard_Integer_Vectors.Vector;
                mcc : in Mixed_Subdivision ) is

    n : constant integer32 := q'last;
    cff : Standard_Complex_VecVecs.VecVec(q'range);
    exp : Standard_Integer_VecVecs.Array_of_VecVecs(q'range);
    mic : Mixed_Cell;
    tmp : Mixed_Subdivision := mcc;
    A,T,U : Standard_Integer_Matrices.Matrix(q'range,q'range);
    C : Standard_Complex_Matrices.Matrix(q'range,q'range);
    b : Standard_Complex_Vectors.Vector(q'range);
    piv : Standard_Integer_Vectors.Vector(q'range);
    info : integer32;
    vol,mv : natural32 := 0;
    sq : Laur_Sys(q'range);
    brd,logbrd,logx,e10x : Standard_Floating_Vectors.Vector(b'range);
    wrk,bsc : Standard_Complex_Vectors.Vector(b'range);
    res,chksum : double_float := 0.0;
    sols,sols_ptr : Solution_List;
    ls : Link_to_Solution;

  begin
    Standard_Tableau_Formats.Extract_Coefficients_and_Exponents(q,cff,exp);
    for i in 1..Length_Of(mcc) loop
      put("processing cell "); put(i,1); put_line(" :");
      mic := Head_Of(tmp);
      Select_Subsystem_to_Matrix_Format(cff,exp,mix,mic.pts.all,A,C,b);
      sq := Supports_of_Polynomial_Systems.Select_Terms(q,mix,mic.pts.all);
      put_line("The subsystem : "); put_line(sq);
      put_line("The matrix A :"); put(A);
      put_line("The matrix C :"); put(C);
      put_line("The right hand side vector b :"); put_line(b);
      Standard_Complex_Linear_Solvers.lufac(C,n,piv,info);
      Standard_Complex_Linear_Solvers.lusolve(C,n,piv,b);
      U := A;
      Standard_Integer_Linear_Solvers.Upper_Triangulate(T,U);
      vol := Volume_of_Diagonal(U); mv := mv + vol;
      sols := Create(n,integer32(vol));
      brd := Standard_Radial_Solvers.Radii(b);
      bsc := Standard_Radial_Solvers.Scale(b,brd);
      Standard_Binomial_Solvers.Solve_Upper_Square(U,bsc,sols);
      logbrd := Standard_Radial_Solvers.Log10(brd);
      logx := Standard_Radial_Solvers.Radial_Upper_Solve(U,logbrd);
      logx := Standard_Radial_Solvers.Multiply(T,logx);
      e10x := Standard_Radial_Solvers.Exp10(logx);
      Standard_Binomial_Systems.Eval(T,sols,wrk);
      Standard_Radial_Solvers.Multiply(sols,e10x);
      sols_ptr := sols;
      while not Is_Null(sols_ptr) loop
        ls := Head_Of(sols_ptr);
        wrk := Standard_Complex_Laur_SysFun.Eval(sq,ls.v);
        res := Standard_Complex_Norms_Equals.Max_Norm(wrk);
        put("residual : "); put(res); new_line;
        chksum := chksum + res;
        sols_ptr := Tail_Of(sols_ptr);
      end loop;
      Clear(sols); Clear(sq);
      tmp := Tail_Of(tmp);
    end loop;
    put("the mixed volume : "); put(mv,1); new_line;
    put("sum of residuals : "); put(chksum); new_line;
  end Semi_Mixed_Start_Systems;

  procedure Check_Solutions
              ( cff : in Standard_Complex_VecVecs.VecVec;
                exp : in Standard_Integer_VecVecs.Array_of_VecVecs;
                mcc : in Mixed_Subdivision;
                sols : in Array_of_Solution_Lists;
                res : out Standard_Floating_Vectors.Vector ) is

    n : constant integer32 := cff'last;
    nt : constant integer32 := sols'last;
    tmp : Mixed_Subdivision := mcc;
    mic : Mixed_Cell;
    s_c : Standard_Complex_Vectors.Vector(1..2*n); -- fully mixed
    A : Standard_Integer_Matrices.Matrix(1..n,1..n);
    b : Standard_Complex_Vectors.Vector(1..n);
    pdetA : natural32;
    ptrs : Array_of_Solution_Lists(sols'range);
    Asols,Asols_last : Solution_List;
    ind : integer32;
    r : double_float;

  begin
    for i in sols'range loop
      ptrs(i) := sols(i);
      res(i) := 0.0;
    end loop;
    for k in 1..Length_Of(mcc) loop
      mic := Head_Of(tmp);
      Select_Coefficients(cff,exp,mic.pts.all,s_c);
      Fully_Mixed_To_Binomial_Format(s_c,mic.pts.all,A,b);
      pdetA := Volume_of_Cell(A);
      ind := (integer32(k) mod nt) + 1;     -- task index tells where computed
      for i in 1..pdetA loop   -- select next pdetA solutions
        Append(Asols,Asols_last,Head_Of(ptrs(ind)).all);
        ptrs(ind) := Tail_Of(ptrs(ind));
      end loop;
      r := Standard_Binomial_Solvers.Sum_Residuals(A,b,Asols);
      res(ind) := res(ind) + r;
      Clear(Asols);
      tmp := Tail_Of(tmp);
    end loop;
  end Check_Solutions;

  procedure Check_Solutions
              ( q : in Laur_Sys;
                mcc : in Mixed_Subdivision;
                sols : in Array_of_Solution_Lists;
                res : out Standard_Floating_Vectors.Vector ) is

    cff : Standard_Complex_VecVecs.VecVec(q'range);
    exp : Standard_Integer_VecVecs.Array_of_VecVecs(q'range);

  begin
    Standard_Tableau_Formats.Extract_Coefficients_and_Exponents(q,cff,exp);
    Check_Solutions(cff,exp,mcc,sols,res);
  end Check_Solutions;

  procedure Check_Solutions
              ( q : in Laur_Sys;
                mix : in Standard_Integer_Vectors.Vector;
                mcc : in Mixed_Subdivision;
                sols : in Array_of_Solution_Lists;
                res : out Standard_Floating_Vectors.Vector ) is

    nt : constant integer32 := sols'last;
    ptrs : Array_of_Solution_Lists(sols'range);
    ls : Link_to_Solution;
    cff : Standard_Complex_VecVecs.VecVec(q'range);
    exp : Standard_Integer_VecVecs.Array_of_VecVecs(q'range);
    tmp : Mixed_Subdivision := mcc;
    mic : Mixed_Cell;
    A : Standard_Integer_Matrices.Matrix(q'range,q'range);
    C : Standard_Complex_Matrices.Matrix(q'range,q'range);
    b : Standard_Complex_Vectors.Vector(q'range);
    vol : natural32;
    ind : integer32;
    r : double_float;
    sq : Laur_Sys(q'range);

  begin
    Standard_Tableau_Formats.Extract_Coefficients_and_Exponents(q,cff,exp);
    for i in sols'range loop
      ptrs(i) := sols(i);
      res(i) := 0.0;
    end loop;
    for k in 1..Length_Of(mcc) loop
      mic := Head_Of(tmp);
      ind := (integer32(k) mod nt) + 1;
      Select_Subsystem_to_Matrix_Format(cff,exp,mix,mic.pts.all,A,C,b);
      vol := Volume_of_Cell(A);
      sq := Supports_of_Polynomial_Systems.Select_Terms(q,mix,mic.pts.all);
      for i in 1..vol loop
        ls := Head_Of(ptrs(ind));
        b := Standard_Complex_Laur_SysFun.Eval(sq,ls.v);
        r := Standard_Complex_Norms_Equals.Max_Norm(b);
        res(ind) := res(ind) + r;
        ptrs(ind) := Tail_Of(ptrs(ind));
      end loop;
      tmp := Tail_Of(tmp);
    end loop;
  end Check_Solutions;

  procedure Reporting_Multithreaded_Solve_Start_Systems
              ( nt : in integer32; q : in Laur_Sys;
                r : in integer32; mix : in Standard_Integer_Vectors.Vector;
                mcc : in out Mixed_Subdivision;
                mixvol : out natural32;
                sols : out Array_of_Solution_Lists;
                res : out Standard_Floating_Vectors.Vector ) is

    n : constant integer32 := q'last;
    vol : Standard_Integer_Vectors.Vector(1..nt);
    cff : Standard_Complex_VecVecs.VecVec(q'range);
    exp : Standard_Integer_VecVecs.Array_of_VecVecs(q'range);

    procedure Job ( task_id,nb_tasks : integer32 ) is

    -- DESCRIPTION :
    --   This code gets executed by task i (= task_id) out of a number of 
    --   tasks equal to nb_tasks.  The workload assignment is static:
    --   as number k runs from 1 till the total number of cells,
    --   task i takes those cells with k mod nb_tasks = i - 1.

      tmp : Mixed_Subdivision := mcc;
      mic : Mixed_Cell;
      s_c : Standard_Complex_Vectors.Vector(1..2*n); -- for fully mixed
      C : Standard_Complex_Matrices.Matrix(q'range,q'range); -- semi mixed
      piv : Standard_Integer_Vectors.Vector(q'range);
      info : integer32;
      A,M,U : Standard_Integer_Matrices.Matrix(q'range,q'range);
      b,wrk : Standard_Complex_Vectors.Vector(q'range);
      brd,logbrd,logx,e10x : Standard_Floating_Vectors.Vector(b'range);
      bsc : Standard_Complex_Vectors.Vector(b'range);
      pdetU,sum : natural32 := 0;
      mysols : Solution_List := sols(task_id);
      ptr : Solution_List;
      ls : Link_to_Solution;

    begin
      put_line("hello from task " & Multitasking.to_string(natural32(task_id)));
      for k in 1..Length_Of(mcc) loop
        if integer32(k) mod nb_tasks = task_id-1 then
          put_line("task " & Multitasking.to_string(natural32(task_id))
                           & " is at cell "
                           & Multitasking.to_string(k));
          mic := Head_Of(tmp); 
          if r = n then
            Select_Coefficients(cff,exp,mic.pts.all,s_c);
            Fully_Mixed_To_Binomial_Format(s_c,mic.pts.all,A,b);
          else
            Select_Subsystem_to_Matrix_Format(cff,exp,mix,mic.pts.all,A,C,b);
            Standard_Complex_Linear_Solvers.lufac(C,n,piv,info);
            Standard_Complex_Linear_Solvers.lusolve(C,n,piv,b);
          end if;
          U := A;
          Standard_Integer_Linear_Solvers.Upper_Triangulate(M,U);
          pdetU := Volume_of_Diagonal(U);
          brd := Standard_Radial_Solvers.Radii(b);
          bsc := Standard_Radial_Solvers.Scale(b,brd);
          Standard_Binomial_Solvers.Solve_Upper_Square(U,bsc,mysols);
          logbrd := Standard_Radial_Solvers.Log10(brd);
          logx := Standard_Radial_Solvers.Radial_Upper_Solve(U,logbrd);
          logx := Standard_Radial_Solvers.Multiply(M,logx);
          e10x := Standard_Radial_Solvers.Exp10(logx);
          ptr := mysols;
          for i in 1..pdetU loop
            ls := Head_Of(ptr);
            Standard_Binomial_Systems.Eval(M,ls.v,wrk);
            ls.v := wrk;
            Standard_Radial_Solvers.Multiply(ls.v,e10x);
            ptr := Tail_Of(ptr);
          end loop;
          for j in 1..pdetU loop
            mysols := Tail_Of(mysols);
          end loop;
          sum := sum + pdetU;
          put_line("Task " & Multitasking.to_string(natural32(task_id))
                           & " computed "
                           & Multitasking.to_string(pdetU)
                           & " start solutions.");
        end if;
        tmp := Tail_Of(tmp);
      end loop;
      put_line("Task " & Multitasking.to_string(natural32(task_id))
                       & " computed in total "
                       & Multitasking.to_string(sum)
                       & " out of "
                       & Multitasking.to_string(natural32(vol(task_id)))
                       & " start solutions.");

    end Job;
    procedure do_jobs is new Multitasking.Reporting_Workers(Job);

    procedure Main is

    -- DESCRIPTION :
    --   First the distribution of the mixed volume along the static 
    --   workload assignment is computed.
    --   Then the lists of start solutions can be allocated in advance,
    --   before the launching of the tasks.  
    --   Each task modifies its own list of solutions.
    --   At the end, the checking of start solution follows the same
    --   static workload assignment.

    begin
      new_line;
      put_line("computing volumes ...");
      Silent_Static_Multithreaded_Mixed_Volume(nt,n,mcc,vol,mixvol);
      new_line;
      put("volume distribution : "); put(vol); new_line;
      put("the mixed volume : "); put(mixvol,1); new_line;
      new_line;
      put_line("allocating solution lists ...");
      for i in 1..nt loop
        sols(i) := Create(n,vol(i));
      end loop;
      Standard_Tableau_Formats.Extract_Coefficients_and_Exponents(q,cff,exp);
      new_line;
      put_line("launching tasks ...");
      new_line;
      do_jobs(nt);
      new_line;
      put_line("checking the solutions ...");
      new_line;
      if r = q'last
       then Check_Solutions(cff,exp,mcc,sols,res);
       else Check_Solutions(q,mix,mcc,sols,res);
      end if;
    end Main;

  begin
    Main;
  end Reporting_Multithreaded_Solve_Start_Systems;

  procedure Silent_Multithreaded_Solve_Start_Systems
              ( nt : in integer32; q : in Laur_Sys;
                r : in integer32; mix : in Standard_Integer_Vectors.Vector;
                mcc : in out Mixed_Subdivision;
                mixvol : out natural32;
                sols : out Array_of_Solution_Lists;
                res : out Standard_Floating_Vectors.Vector ) is

  -- NOTE :
  --   In an attempt to avoid threads racing for common data,
  --   three modfications (compared to the reporting versions):
  --   (1) every task has its own copy of the tableau data structure;
  --   (2) every task has a deep copy of the tableau data structure;
  --   (3) the mixed cells are distributed in advance of task launch.

    n : constant integer32 := q'last;
    cells,cells_last : array(1..nt) of Mixed_Subdivision;

    procedure Job ( task_id,nb_tasks : integer32 ) is

    -- DESCRIPTION :
    --   This code gets executed by task i (= task_id) out of a number of
    --   tasks equal to nb_tasks.  The workload assignment is static:
    --   as number k runs from 1 till the total number of cells,
    --   task i takes those cells with k mod nb_tasks = i - 1.

      cff : Standard_Complex_VecVecs.VecVec(q'range);
      exp : Standard_Integer_VecVecs.Array_of_VecVecs(q'range);
      mic : Mixed_Cell;
      s_c : Standard_Complex_Vectors.Vector(1..2*n); -- for fully mixed
      C : Standard_Complex_Matrices.Matrix(q'range,q'range); -- semi mixed
      piv : Standard_Integer_Vectors.Vector(q'range);
      info : integer32;
      A,M,U : Standard_Integer_Matrices.Matrix(q'range,q'range);
      b,wrk : Standard_Complex_Vectors.Vector(q'range);
      brd,logbrd,logx,e10x : Standard_Floating_Vectors.Vector(b'range);
      bsc : Standard_Complex_Vectors.Vector(b'range);
      pdetU : natural32 := 0;
      mysols : Solution_List := sols(task_id);
      ptr : Solution_List;
      ls : Link_to_Solution;
      mycells : Mixed_Subdivision := cells(task_id);

    begin
      Standard_Tableau_Formats.Extract_Coefficients_and_Exponents_Copies
        (q,cff,exp);
      while not Is_Null(mycells) loop
        mic := Head_Of(mycells); 
        if r = n then
          Select_Coefficients(cff,exp,mic.pts.all,s_c);
          Fully_Mixed_To_Binomial_Format(s_c,mic.pts.all,A,b);
        else
          Select_Subsystem_to_Matrix_Format(cff,exp,mix,mic.pts.all,A,C,b);
          Standard_Complex_Linear_Solvers.lufac(C,n,piv,info);
          Standard_Complex_Linear_Solvers.lusolve(C,n,piv,b);
        end if;
        U := A;
        Standard_Integer_Linear_Solvers.Upper_Triangulate(M,U);
        pdetU := Volume_of_Diagonal(U);
        brd := Standard_Radial_Solvers.Radii(b);
        bsc := Standard_Radial_Solvers.Scale(b,brd);
        Standard_Binomial_Solvers.Solve_Upper_Square(U,bsc,mysols);
        logbrd := Standard_Radial_Solvers.Log10(brd);
        logx := Standard_Radial_Solvers.Radial_Upper_Solve(U,logbrd);
        logx := Standard_Radial_Solvers.Multiply(M,logx);
        e10x := Standard_Radial_Solvers.Exp10(logx);
        ptr := mysols;
        for i in 1..pdetU loop
          ls := Head_Of(ptr);
          Standard_Binomial_Systems.Eval(M,ls.v,wrk);
          ls.v := wrk;
          Standard_Radial_Solvers.Multiply(ls.v,e10x);
          ptr := Tail_Of(ptr);
        end loop;
        for j in 1..pdetU loop
          mysols := Tail_Of(mysols);
        end loop;
        mycells := Tail_Of(mycells);
      end loop;
    end Job;
    procedure do_jobs is new Multitasking.Silent_Workers(Job);

    procedure Main is

    -- DESCRIPTION :
    --   First the distribution of the mixed volume along the static 
    --   workload assignment is computed.
    --   Then the lists of start solutions can be allocated in advance,
    --   before the launching of the tasks.  
    --   Each task modifies its own list of solutions.
    --   At the end, the checking of start solution follows the same
    --   static workload assignment.

      vol : Standard_Integer_Vectors.Vector(1..nt);
      tmp : Mixed_Subdivision := mcc;
      mic : Mixed_Cell;
      ind : integer32;

    begin
      Silent_Static_Multithreaded_Mixed_Volume(nt,n,mcc,vol,mixvol);
      for i in 1..nt loop
        sols(i) := Create(n,vol(i));
      end loop;
      for k in 1..Length_Of(mcc) loop
        mic := Head_Of(tmp);
        ind := 1 + (integer32(k) mod nt);
        Append(cells(ind),cells_last(ind),mic);
        tmp := Tail_Of(tmp);
      end loop;
      do_jobs(nt);
      if r = n
       then Check_Solutions(q,mcc,sols,res);
       else Check_Solutions(q,mix,mcc,sols,res);
      end if;
    end Main;

  begin
    Main;
  end Silent_Multithreaded_Solve_Start_Systems;

-- (3) TRACKING PATHS DEFINED BY A POLYHEDRAL HOMOTOPY :

  procedure Silent_Multitasking_Path_Tracker
              ( q : in Laur_Sys; nt,n,r : in integer32;
                mix : in Standard_Integer_Vectors.Vector;
                lif : in Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                mcc : in Mixed_Subdivision; h : in Eval_Coeff_Laur_Sys;
                c : in Standard_Complex_VecVecs.VecVec;
                e : in Exponent_Vectors.Exponent_Vectors_Array;
                j : in Eval_Coeff_Jaco_Mat; mf : in Mult_Factors;
                sols : out Solution_List ) is

    cell_ptr : Mixed_Subdivision := mcc;
    first : boolean := true;
    s_cell,s_sols : Semaphore.Lock;
    sols_ptr : Solution_List;
    dpow : Standard_Floating_VecVecs.Array_of_VecVecs(1..nt);
    dctm : Standard_Complex_VecVecs.Array_of_VecVecs(1..nt);
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

    procedure Next_Cell ( task_id,nb_tasks : in integer32 ) is

    -- DESCRIPTION :
    --   Task i processes the next cell.

      mycell_ptr : Mixed_Subdivision;
      mic : Mixed_Cell;
      s_c : Standard_Complex_Vectors.Vector(1..2*n);    -- for fully mixed
      CC : Standard_Complex_Matrices.Matrix(1..n,1..n); -- for semi mixed
      piv : Standard_Integer_Vectors.Vector(1..n);
      info : integer32;
      A,M,U : Standard_Integer_Matrices.Matrix(q'range,q'range);
      b,wrk : Standard_Complex_Vectors.Vector(q'range);
      brd,logbrd,logx,e10x : Standard_Floating_Vectors.Vector(b'range);
      bsc : Standard_Complex_Vectors.Vector(b'range);
      pdetU : natural32 := 0;
      mysols,mysols_ptr : Solution_List;
      ls : Link_to_Solution;

      procedure Call_Path_Tracker is

      -- DESCRIPTION :
      --   Calls the path tracker on the solution ls points to.

        use Standard_Complex_Norms_Equals;
        use Standard_Continuation_Data;
        use Standard_Path_Trackers;
        use Polyhedral_Coefficient_Homotopies;

        function Eval ( x : Standard_Complex_Vectors.Vector;
                        t : Complex_Number )
                      return Standard_Complex_Vectors.Vector is
        begin
          Eval(c,REAL_PART(t),dpow(task_id).all,dctm(task_id).all);
          return Eval(h,dctm(task_id).all,x);
        end Eval;

        function dHt ( x : Standard_Complex_Vectors.Vector;
                       t : Complex_Number )
                     return Standard_Complex_Vectors.Vector is

          res : Standard_Complex_Vectors.Vector(h'range);
          xtl : constant integer32 := x'last+1;

        begin
          Eval(c,REAL_PART(t),dpow(task_id).all,dctm(task_id).all);
          for k in wrk'range loop
            res(k) := Eval(j(k,xtl),mf(k,xtl).all,dctm(task_id)(k).all,x);
          end loop;
          return res;
        end dHt;

        function dHx ( x : Standard_Complex_Vectors.Vector;
                       t : Complex_Number )
                     return Standard_Complex_Matrices.Matrix is

          mt : Standard_Complex_Matrices.Matrix(x'range,x'range);

        begin
          Eval(c,REAL_PART(t),dpow(task_id).all,dctm(task_id).all);
          for k in mt'range(1) loop
            for L in mt'range(2) loop
              mt(k,L) := Eval(j(k,L),mf(k,L).all,dctm(task_id)(k).all,x);
            end loop;
          end loop;
          return mt;
        end dHx;

        procedure Track_Path_along_Path is
          new Linear_Single_Normal_Silent_Continue(Max_Norm,Eval,dHt,dHx);

        procedure Track_Path_at_End is
           new Linear_Single_Conditioned_Silent_Continue
                 (Max_Norm,Eval,dHt,dHx);

      begin
        Power_Transform(e,lif,mix,mic.nor.all,dpow(task_id).all);
        ls.t := Create(0.0);
        declare
          s : Solu_Info := Shallow_Create(ls);
          v : Standard_Floating_Vectors.Link_to_Vector;
          e : double_float := 0.0;
        begin
          Track_Path_along_Path(s,t1,tol,false,pp1,cp1);
          Track_Path_at_End(s,t1,tol,false,0,v,e,pp2,cp2);
          ls.err := s.cora; ls.rco := s.rcond; ls.res := s.resa;
        end;
      end Call_Path_Tracker;

    begin
      loop
        Semaphore.Request(s_cell);  -- request new cell
        if first then
          first := false;
        else
          if not Is_Null(cell_ptr)
           then cell_ptr := Tail_Of(cell_ptr);
          end if;
        end if;
        mycell_ptr := cell_ptr;
        Semaphore.Release(s_cell);  -- end of first critical section
        exit when Is_Null(mycell_ptr);
        mic := Head_Of(mycell_ptr);
        if r = n then
          Select_Coefficients(c,e,mic.pts.all,s_c);
          Fully_Mixed_To_Binomial_Format(s_c,mic.pts.all,A,b);
        else
          Select_Subsystem_to_Matrix_Format(c,e,mix,mic.pts.all,A,CC,b);
          Standard_Complex_Linear_Solvers.lufac(CC,n,piv,info);
          Standard_Complex_Linear_Solvers.lusolve(CC,n,piv,b);
        end if;
        U := A;
        Standard_Integer_Linear_Solvers.Upper_Triangulate(M,U);
        pdetU := Volume_of_Diagonal(U);
        Semaphore.Request(s_sols);    -- occupy solution space
        mysols := sols_ptr;
        for i in 1..pdetU loop
          sols_ptr := Tail_Of(sols_ptr);
        end loop;
        Semaphore.Release(s_sols);    -- end of second critical section
        brd := Standard_Radial_Solvers.Radii(b);
        bsc := Standard_Radial_Solvers.Scale(b,brd);
        Standard_Binomial_Solvers.Solve_Upper_Square(U,bsc,mysols);
        logbrd := Standard_Radial_Solvers.Log10(brd);
        logx := Standard_Radial_Solvers.Radial_Upper_Solve(U,logbrd);
        logx := Standard_Radial_Solvers.Multiply(M,logx);
        e10x := Standard_Radial_Solvers.Exp10(logx);
        mysols_ptr := mysols;
        for i in 1..pdetU loop
          ls := Head_Of(mysols_ptr);
          Standard_Binomial_Systems.Eval(M,ls.v,wrk);
          ls.v := wrk;
          Standard_Radial_Solvers.Multiply(ls.v,e10x);
          Call_Path_Tracker;
          mysols_ptr := Tail_Of(mysols_ptr);
        end loop;
      end loop;
    end Next_Cell;
    procedure do_jobs is new Multitasking.Silent_Workers(Next_Cell);

    procedure Main is

      vol : Standard_Integer_Vectors.Vector(1..nt);
      mixvol : natural32;

    begin
      Silent_Static_Multithreaded_Mixed_Volume(nt,n,cell_ptr,vol,mixvol);
      sols := Create(n,integer32(mixvol));
      sols_ptr := sols;
      for t in 1..nt loop
        dpow(t) := new Standard_Floating_VecVecs.VecVec(e'range);
        dctm(t) := new Standard_Complex_VecVecs.VecVec(c'range);
        for k in dpow(t)'range loop
          dpow(t)(k) := new Standard_Floating_Vectors.Vector(e(k)'range);
          dctm(t)(k) := new Standard_Complex_Vectors.Vector(c(k)'range);
        end loop;
      end loop;
      do_jobs(nt);
      for t in 1..nt loop
        Standard_Floating_VecVecs.Deep_Clear(dpow(t));
        Standard_Complex_VecVecs.Deep_Clear(dctm(t));
      end loop;
    end Main;

  begin
    Main;
  end Silent_Multitasking_Path_Tracker;

  procedure Reporting_Multitasking_Path_Tracker
              ( q : in Laur_Sys; nt,n,r : in integer32;
                mix : in Standard_Integer_Vectors.Vector;
                lif : in Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                mcc : in Mixed_Subdivision; h : in Eval_Coeff_Laur_Sys;
                c : in Standard_Complex_VecVecs.VecVec;
                e : in Exponent_Vectors.Exponent_Vectors_Array;
                j : in Eval_Coeff_Jaco_Mat; mf : in Mult_Factors;
                sols : out Solution_List ) is

    cell_ptr : Mixed_Subdivision := mcc;
    cell_ind : integer32 := 0;
    s_cell,s_sols : Semaphore.Lock;
    sols_ptr : Solution_List;
    dpow : Standard_Floating_VecVecs.Array_of_VecVecs(1..nt);
    dctm : Standard_Complex_VecVecs.Array_of_VecVecs(1..nt);
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

    procedure Next_Cell ( task_id,nb_tasks : integer32 ) is

    -- DESCRIPTION :
    --   Task i processes the next cell. 

      myjob : natural32;
      mycell_ptr : Mixed_Subdivision;
      mic : Mixed_Cell;
      s_c : Standard_Complex_Vectors.Vector(1..2*n); -- fully mixed
      CC : Standard_Complex_Matrices.Matrix(1..n,1..n); -- for semi mixed
      piv : Standard_Integer_Vectors.Vector(1..n);
      info : integer32;
      A,M,U : Standard_Integer_Matrices.Matrix(q'range,q'range);
      b,wrk : Standard_Complex_Vectors.Vector(q'range);
      brd,logbrd,logx,e10x : Standard_Floating_Vectors.Vector(b'range);
      bsc : Standard_Complex_Vectors.Vector(b'range);
      pdetU : natural32 := 0;
      mysols,mysols_ptr : Solution_List;
      ls : Link_to_Solution;

      procedure Call_Path_Tracker is

      -- DESCRIPTION :
      --   Calls the path tracker on the solution ls points to.

        use Standard_Complex_Norms_Equals;
        use Standard_Continuation_Data;
        use Standard_Path_Trackers;
        use Polyhedral_Coefficient_Homotopies;

        function Eval ( x : Standard_Complex_Vectors.Vector;
                        t : Complex_Number )
                      return Standard_Complex_Vectors.Vector is
        begin
          Eval(c,REAL_PART(t),dpow(task_id).all,dctm(task_id).all);
          return Eval(h,dctm(task_id).all,x);
        end Eval;

        function dHt ( x : Standard_Complex_Vectors.Vector;
                       t : Complex_Number )
                     return Standard_Complex_Vectors.Vector is

          res : Standard_Complex_Vectors.Vector(h'range);
          xtl : constant integer32 := x'last+1;

        begin
          Eval(c,REAL_PART(t),dpow(task_id).all,dctm(task_id).all);
          for k in wrk'range loop
            res(k) := Eval(j(k,xtl),mf(k,xtl).all,dctm(task_id)(k).all,x);
          end loop;
          return res;
        end dHt;

        function dHx ( x : Standard_Complex_Vectors.Vector;
                       t : Complex_Number )
                     return Standard_Complex_Matrices.Matrix is

          mt : Standard_Complex_Matrices.Matrix(x'range,x'range);

        begin
          Eval(c,REAL_PART(t),dpow(task_id).all,dctm(task_id).all);
          for k in mt'range(1) loop
            for L in mt'range(2) loop
              mt(k,L) := Eval(j(k,L),mf(k,L).all,dctm(task_id)(k).all,x);
            end loop;
          end loop;
          return mt;
        end dHx;

        procedure Track_Path_along_Path is
          new Linear_Single_Normal_Silent_Continue(Max_Norm,Eval,dHt,dHx);

        procedure Track_Path_at_End is
           new Linear_Single_Conditioned_Silent_Continue
                 (Max_Norm,Eval,dHt,dHx);

      begin
        Power_Transform(e,lif,mix,mic.nor.all,dpow(task_id).all);
        ls.t := Create(0.0);
        declare
          s : Solu_Info := Shallow_Create(ls);
          v : Standard_Floating_Vectors.Link_to_Vector;
          e : double_float := 0.0;
        begin
          Track_Path_along_Path(s,t1,tol,false,pp1,cp1);
          Track_Path_at_End(s,t1,tol,false,0,v,e,pp2,cp2);
          ls.err := s.cora; ls.rco := s.rcond; ls.res := s.resa;
        end;
      end Call_Path_Tracker;

    --  procedure Check_Solution is
    --
    --    y : constant Standard_Complex_Vectors.Vector
    --      := Standard_Binomial_Systems.Eval(A,b,ls.v);
    --    r : constant double_float
    --      := Standard_Complex_Norms_Equals.Max_Norm(y);
    --    use Polyhedral_Coefficient_Homotopies;
    --    fp : Standard_Floating_VecVecs.VecVec(c'range)
    --       := Power_Transform(e,lif,mix,mic.nor.all);
    --    sq : Laur_Sys(q'range)
    --       := Supports_of_Polynomial_Systems.Select_Terms(q,mix,mic.pts.all);
    --    yz : constant Standard_Complex_Vectors.Vector
    --       := Standard_Complex_Laur_SysFun.Eval(sq,ls.v);
    -- 
    --   begin
    --     put_line("The start solution evaluated : "); put_line(yz);
    --     put_line("The binomial start system :"); put(sq);
    --     put_line("The points in the cell :");
    --     Floating_Mixed_Subdivisions_io.put(mic.pts.all);
    --     put_line("The matrix A "); put(A);
    --     put_line("The coefficients :"); put_line(s_c);
    --   end Check_Solution;

    begin
      put_line("hello from task " & Multitasking.to_string(natural32(task_id)));
      loop
        Semaphore.Request(s_cell);   -- take next cell
        if cell_ind = 0 then
          cell_ind := 1;
        else
          cell_ind := cell_ind + 1;
          if not Is_Null(cell_ptr)
           then cell_ptr := Tail_Of(cell_ptr);
          end if;
        end if;
        mycell_ptr := cell_ptr;
        myjob := natural32(cell_ind);
        Semaphore.Release(s_cell);   -- end of first critical section
        exit when Is_Null(mycell_ptr);
        put_line("task " & Multitasking.to_string(natural32(task_id))
                         & " computes cell "
                         & Multitasking.to_string(myjob));
        mic := Head_Of(mycell_ptr);
        if r = n then
          Select_Coefficients(c,e,mic.pts.all,s_c);
          Fully_Mixed_To_Binomial_Format(s_c,mic.pts.all,A,b);
        else
          Select_Subsystem_to_Matrix_Format(c,e,mix,mic.pts.all,A,CC,b);
          Standard_Complex_Linear_Solvers.lufac(CC,n,piv,info);
          Standard_Complex_Linear_Solvers.lusolve(CC,n,piv,b);
        end if;
        U := A;
        Standard_Integer_Linear_Solvers.Upper_Triangulate(M,U);
        pdetU := Volume_of_Diagonal(U);
        Semaphore.Request(s_sols);    -- occupy solution space
        mysols := sols_ptr;
        for k in 1..pdetU loop
          sols_ptr := Tail_Of(sols_ptr);
        end loop;
        Semaphore.Release(s_sols);    -- end of second critical section
        brd := Standard_Radial_Solvers.Radii(b);
        bsc := Standard_Radial_Solvers.Scale(b,brd);
        Standard_Binomial_Solvers.Solve_Upper_Square(U,bsc,mysols);
        logbrd := Standard_Radial_Solvers.Log10(brd);
        logx := Standard_Radial_Solvers.Radial_Upper_Solve(U,logbrd);
        logx := Standard_Radial_Solvers.Multiply(M,logx);
        e10x := Standard_Radial_Solvers.Exp10(logx);
        mysols_ptr := mysols;
        for k in 1..pdetU loop
          ls := Head_Of(mysols_ptr);
          Standard_Binomial_Systems.Eval(M,ls.v,wrk);
          ls.v := wrk;
          Standard_Radial_Solvers.Multiply(ls.v,e10x);
         -- Check_Solution;
          Call_Path_Tracker;
          mysols_ptr := Tail_Of(mysols_ptr);
        end loop;
        put_line("task " & Multitasking.to_string(natural32(task_id))
                         & " computed "
                         & Multitasking.to_string(pdetU)
                         & " solutions");
      end loop;
    end Next_Cell;
    procedure do_jobs is new Multitasking.Silent_Workers(Next_Cell);

    procedure Main is

      vol : Standard_Integer_Vectors.Vector(1..nt);
      mixvol : natural32;

    begin
      new_line;
      put_line("computing volumes ...");
      Silent_Static_Multithreaded_Mixed_Volume(nt,n,cell_ptr,vol,mixvol);
      new_line;
      put("volume distribution : "); put(vol); new_line;
      put("the mixed volume : "); put(mixvol,1); new_line;
      new_line;
      put_line("allocating solution lists and other data...");
      sols := Create(n,integer32(mixvol));
      for t in 1..nt loop
        dpow(t) := new Standard_Floating_VecVecs.VecVec(e'range);
        dctm(t) := new Standard_Complex_VecVecs.VecVec(c'range);
        for k in dpow(t)'range loop
          dpow(t)(k) := new Standard_Floating_Vectors.Vector(e(k)'range);
          dctm(t)(k) := new Standard_Complex_Vectors.Vector(c(k)'range);
        end loop;
      end loop;
      sols_ptr := sols;
      new_line;
      put_line("launching tasks ...");
      new_line;
      do_jobs(nt);
      for t in 1..nt loop
        Standard_Floating_VecVecs.Deep_Clear(dpow(t));
        Standard_Complex_VecVecs.Deep_Clear(dctm(t));
      end loop;
    end Main;

  begin
    Main;
  end Reporting_Multitasking_Path_Tracker;

  procedure Silent_Multitasking_Path_Tracker
              ( q : in Laur_Sys; nt,n,m : in integer32;
                mix : in Standard_Integer_Vectors.Vector;
                mcc : in Mixed_Subdivision; sols : out Solution_List ) is

    sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(q'range);
    pts : Arrays_of_Floating_Vector_Lists.Array_of_Lists(q'range);
    lif : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range);
    h : constant Eval_Coeff_Laur_Sys(q'range) := Create(q);
    c : Standard_Complex_VecVecs.VecVec(h'range);
    e : Exponent_Vectors.Exponent_Vectors_Array(h'range);
    j : Eval_Coeff_Jaco_Mat(h'range,h'first..h'last+1);
    mf : Mult_Factors(j'range(1),j'range(2));

  begin
    sup := Supports_of_Polynomial_Systems.Create(q);
    pts := Floating_Integer_Convertors.Convert(sup);
    lif := Floating_Lifting_Utilities.Occurred_Lifting(n,mix,pts,mcc);
    for i in c'range loop
      declare
        coeff_lq : constant Standard_Complex_Vectors.Vector
                 := Standard_Complex_Laur_Functions.Coeff(q(i));
      begin
        c(i) := new Standard_Complex_Vectors.Vector(coeff_lq'range);
        for k in coeff_lq'range loop
          c(i)(k) := coeff_lq(k);
        end loop;
      end;
    end loop;
    e := Exponent_Vectors.Create(q);
    Create(q,j,mf);
    Silent_Multitasking_Path_Tracker(q,nt,n,m,mix,lif,mcc,h,c,e,j,mf,sols);
  end Silent_Multitasking_Path_Tracker;

  procedure Reporting_Multitasking_Path_Tracker
              ( file : in file_type; q : in Laur_Sys; nt,n,m : in integer32;
                mix : in Standard_Integer_Vectors.Vector;
                mcc : in Mixed_Subdivision; sols : out Solution_List ) is

    sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(q'range);
    pts : Arrays_of_Floating_Vector_Lists.Array_of_Lists(q'range);
    lif : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range);
    h : constant Eval_Coeff_Laur_Sys(q'range) := Create(q);
    c : Standard_Complex_VecVecs.VecVec(h'range);
    e : Exponent_Vectors.Exponent_Vectors_Array(h'range);
    j : Eval_Coeff_Jaco_Mat(h'range,h'first..h'last+1);
    mf : Mult_Factors(j'range(1),j'range(2));

  begin
    sup := Supports_of_Polynomial_Systems.Create(q);
    pts := Floating_Integer_Convertors.Convert(sup);
    lif := Floating_Lifting_Utilities.Occurred_Lifting(n,mix,pts,mcc);
    for i in c'range loop
      declare
        coeff_lq : constant Standard_Complex_Vectors.Vector
                 := Standard_Complex_Laur_Functions.Coeff(q(i));
      begin
        c(i) := new Standard_Complex_Vectors.Vector(coeff_lq'range);
        for k in coeff_lq'range loop
          c(i)(k) := coeff_lq(k);
        end loop;
      end;
    end loop;
    e := Exponent_Vectors.Create(q);
    Create(q,j,mf);
    new_line(file);
    put_line(file,"THE LIFTED SUPPORTS :");
    Floating_Mixed_Subdivisions_io.put(file,lif);
    Reporting_Multitasking_Path_Tracker(q,nt,n,m,mix,lif,mcc,h,c,e,j,mf,sols);
  end Reporting_Multitasking_Path_Tracker;

end Multitasking_Polyhedral_Trackers;
