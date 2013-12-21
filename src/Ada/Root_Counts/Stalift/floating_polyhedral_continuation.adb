with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Complex_Vectors;
with Standard_Complex_Norms_Equals;      use Standard_Complex_Norms_Equals;
with Standard_Integer_VecVecs;
with Standard_Floating_VecVecs;
with Standard_Complex_Matrices;          use Standard_Complex_Matrices;
with Standard_Complex_Laurentials;
with Standard_Complex_Laur_Functions;    use Standard_Complex_Laur_Functions;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;
with Standard_Laur_Poly_Convertors;      use Standard_Laur_Poly_Convertors;
with Supports_of_Polynomial_Systems;     use Supports_of_Polynomial_Systems;
with Lists_of_Floating_Vectors;          use Lists_of_Floating_Vectors;
with Floating_Lifting_Utilities;         use Floating_Lifting_Utilities;
with Floating_Integer_Convertors;        use Floating_Integer_Convertors;
with Transforming_Laurent_Systems;       use Transforming_Laurent_Systems;
with Standard_IncFix_Continuation;       use Standard_IncFix_Continuation;
with Standard_Simpomial_Solvers;
with Polyhedral_Coefficient_Homotopies;  use Polyhedral_Coefficient_Homotopies;
with BKK_Bound_Computations;             use BKK_Bound_Computations;
-- for exception handler :
with Standard_Complex_Laur_Systems_io;

package body Floating_Polyhedral_Continuation is

-- UTILITIES FOR POLYHEDRAL COEFFICIENT HOMOTOPY :

--  procedure put ( file : in file_type;
--                  v : in Standard_Floating_Vectors.Vector;
--                  fore,aft,exp : in natural32 ) is
--  begin
--    for i in v'range loop
--      put(file,v(i),fore,aft,exp);
--    end loop;
--  end put;

--  procedure put ( file : in file_type;
--                  v : in Standard_Complex_Vectors.Vector;
--                  fore,aft,exp : in natural32 ) is
--  begin
--    for i in v'range loop
--      put(file,REAL_PART(v(i)),fore,aft,exp);
--      put(file,IMAG_PART(v(i)),fore,aft,exp);
--    end loop;
--  end put;

-- SANITY CHECKS :

  procedure Extract_Regular ( sols : in out Solution_List ) is

    function To_Be_Removed ( flag : in integer32 ) return boolean is
    begin
      return ( flag /= 1 );
    end To_Be_Removed;
    procedure Extract_Regular_Solutions is new 
                Standard_Complex_Solutions.Delete(To_Be_Removed);

  begin
    Extract_Regular_Solutions(sols);
  end Extract_Regular;

--  procedure Refine ( file : in file_type; p : in Laur_Sys;
--                     sols : in out Solution_List ) is
--
--  -- DESCRIPTION :
--  --   Given a polyhedral homotopy p and a list of solution for t=1,
--  --   this list of solutions will be refined.
--
--    pp : Poly_Sys(p'range) := Laurent_to_Polynomial_System(p);
--    n : constant integer32 := p'length;
--   -- eps : constant double_float := 10.0**(-12);
--   -- tolsing : constant double_float := 10.0**(-8);
--   -- max : constant natural32 := 3;
--   -- numb : natural32 := 0;
--
--  begin
--    pp := Laurent_to_Polynomial_System(p);
--    Substitute(n+1,Create(1.0),pp);
--   -- Reporting_Root_Refiner(file,pp,sols,eps,eps,tolsing,numb,max,false);
--    Clear(pp); Extract_Regular(sols);
--  end Refine;

-- FIRST LAYER OF CONTINUATION ROUTINES :

  procedure Mixed_Continuation
                ( mix : in Standard_Integer_Vectors.Vector;
                  lifted : in Array_of_Lists; h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  normal : in Standard_Floating_Vectors.Vector;
                  sols : in out Solution_List ) is

    pow : Standard_Floating_VecVecs.VecVec(c'range)
        := Power_Transform(e,lifted,mix,normal);
    scapow : constant Standard_Floating_VecVecs.VecVec(c'range) := Scale(pow);
    ctm : Standard_Complex_VecVecs.VecVec(c'range);

    use Standard_Floating_Vectors;
    use Standard_Complex_Laurentials;

    function Eval ( x : Standard_Complex_Vectors.Vector; t : Complex_Number )
                  return Standard_Complex_Vectors.Vector is
    begin
      Eval(c,REAL_PART(t),scapow,ctm);
      return Eval(h,ctm,x);
    end Eval;

    function dHt ( x : Standard_Complex_Vectors.Vector; t : Complex_Number )
                 return Standard_Complex_Vectors.Vector is

      res : Standard_Complex_Vectors.Vector(h'range);
      xtl : constant integer32 := x'last+1;

    begin
      Eval(c,REAL_PART(t),scapow,ctm);
      for i in res'range loop
        res(i) := Eval(j(i,xtl),m(i,xtl).all,ctm(i).all,x);
      end loop;
      return res;
    end dHt;

    function dHx ( x : Standard_Complex_Vectors.Vector; t : Complex_Number )
                 return matrix is

      mt : Matrix(x'range,x'range);

    begin
      Eval(c,REAL_PART(t),scapow,ctm);
      for k in mt'range(1) loop
        for l in mt'range(2) loop
          mt(k,l) := Eval(j(k,l),m(k,l).all,ctm(k).all,x);
        end loop;
      end loop;
      return mt;
    end dHx;

    procedure Laur_Cont is new Silent_Continue(Max_Norm,Eval,dHt,dHx);

  begin
   -- put_line("The coefficient vectors :" );
   -- for i in c'range loop
   --   put(standard_output,c(i).all,3,3,3); new_line;
   -- end loop;
   -- put("The normal : "); put(standard_output,normal,3,3,3); new_line;
   -- put_line("The exponent vector : ");
   -- for i in pow'range loop
   --   put(standard_output,pow(i).all,3,3,3); new_line;
   -- end loop;
   -- put_line("The scaled exponent vector : ");
   -- for i in pow'range loop
   --   put(standard_output,scapow(i).all,3,3,3); new_line;
   -- end loop;
    for i in c'range loop
      ctm(i) 
        := new Standard_Complex_Vectors.Vector'(c(i).all'range => Create(0.0));
    end loop;
    Laur_Cont(sols,false);
    Standard_Floating_VecVecs.Clear(pow);
   -- Standard_Floating_VecVecs.Clear(scapow);
    Standard_Complex_VecVecs.Clear(ctm);
    Extract_Regular(sols);
  end Mixed_Continuation;

  procedure Mixed_Continuation
                ( file : in file_type;
                  mix : in Standard_Integer_Vectors.Vector;
                  lifted : in Array_of_Lists; h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  normal : in Standard_Floating_Vectors.Vector;
                  sols : in out Solution_List ) is

    pow : Standard_Floating_VecVecs.VecVec(c'range)
        := Power_Transform(e,lifted,mix,normal);
    scapow : constant Standard_Floating_VecVecs.VecVec(c'range) := Scale(pow);
    ctm : Standard_Complex_VecVecs.VecVec(c'range);

    use Standard_Floating_Vectors;
    use Standard_Complex_Laurentials;

    function Eval ( x : Standard_Complex_Vectors.Vector; t : Complex_Number )
                  return Standard_Complex_Vectors.Vector is
    begin
      Eval(c,REAL_PART(t),scapow,ctm);
      return Eval(h,ctm,x);
    end Eval;

    function dHt ( x : Standard_Complex_Vectors.Vector; t : Complex_Number )
                 return Standard_Complex_Vectors.Vector is

      res : Standard_Complex_Vectors.Vector(h'range);
      xtl : constant integer32 := x'last+1;

    begin
      Eval(c,REAL_PART(t),scapow,ctm);
      for i in res'range loop
        res(i) := Eval(j(i,xtl),m(i,xtl).all,ctm(i).all,x);
      end loop;
      return res;
    end dHt;

    function dHx ( x : Standard_Complex_Vectors.Vector; t : Complex_Number )
                 return Matrix is

      mt : Matrix(x'range,x'range);

    begin
      Eval(c,REAL_PART(t),scapow,ctm);
      for k in m'range(1) loop
        for l in m'range(1) loop
          mt(k,l) := Eval(j(k,l),m(k,l).all,ctm(k).all,x);
        end loop;
      end loop;
      return mt;
    end dHx;

    procedure Laur_Cont is new Reporting_Continue(Max_Norm,Eval,dHt,dHx);

  begin
   -- put_line(file,"The coefficient vectors :" );
   -- for i in c'range loop
   --   put(file,c(i).all,3,3,3); new_line(file);
   -- end loop;
   -- put(file,"The normal : "); put(file,normal,3,3,3); new_line(file);
   -- put_line(file,"The exponent vector : ");
   -- for i in pow'range loop
   --   put(file,pow(i).all,3,3,3); new_line(file);
   -- end loop;
   -- put_line(file,"The scaled exponent vector : ");
   -- for i in pow'range loop
   --   put(file,scapow(i).all,3,3,3); new_line(file);
   -- end loop;
    for i in c'range loop
      ctm(i) 
        := new Standard_Complex_Vectors.Vector'(c(i).all'range => Create(0.0));
    end loop;
    Laur_Cont(file,sols,false);
    Standard_Floating_VecVecs.Clear(pow);
   -- Standard_Floating_VecVecs.Clear(scapow);
    Standard_Complex_VecVecs.Clear(ctm);
    Extract_Regular(sols);
  end Mixed_Continuation;

-- UTILITIES FOR SECOND LAYER :

  function Remove_Lifting ( l : List ) return List is

  -- DESCRIPTION :
  --   Removes the lifting value from the vectors.

    tmp,res,res_last : List;

  begin
    tmp := l;
    while not Is_Null(tmp) loop
      declare
        d1 : constant Standard_Floating_Vectors.Vector := Head_Of(tmp).all;
        d2 : constant Standard_Floating_Vectors.Vector
           := d1(d1'first..d1'last-1);
      begin
        Append(res,res_last,d2);
      end;
      tmp := Tail_Of(tmp);
    end loop;
    return res;
  end Remove_Lifting;

  function Sub_Lifting ( q : Laur_Sys; mix : Standard_Integer_Vectors.Vector;
                         mic : Mixed_Cell ) return Array_of_Lists is

  -- DESCRIPTION :
  --   Returns the lifting used to subdivide the cell.

    res : Array_of_Lists(mix'range);
    sup : Array_of_Lists(q'range);
    n : constant integer32 := q'last;
    cnt : integer32 := sup'first;

  begin
    for i in mic.pts'range loop
      sup(cnt) := Remove_Lifting(mic.pts(i));
      for j in 1..(mix(i)-1) loop
        Copy(sup(cnt),sup(cnt+j));
      end loop;
      cnt := cnt + mix(i);
    end loop;
    res := Induced_Lifting(n,mix,sup,mic.sub.all);
    Deep_Clear(sup);
    return res;
  end Sub_Lifting;

  function Sub_Polyhedral_Homotopy
               ( l : List; e : Standard_Integer_VecVecs.VecVec;
                 c : Standard_Complex_Vectors.Vector )
               return Standard_Complex_Vectors.Vector is

  -- DESCRIPTION :
  --   For every vector in e that does not belong to l, the corresponding
  --   index in c will be set to zero, otherwise it is copied to the result.

    res : Standard_Complex_Vectors.Vector(c'range);
    found : boolean;
    lif : double_float;

  begin
    for i in e'range loop
      declare
        fei : constant Standard_Floating_Vectors.Vector := Convert(e(i).all);
      begin
        Search_Lifting(l,fei,found,lif);
        if not found
         then res(i) := Create(0.0);
         else res(i) := c(i);
        end if;
      end;
    end loop;
    return res;
  end Sub_Polyhedral_Homotopy;

  function Sub_Polyhedral_Homotopy
               ( mix : Standard_Integer_Vectors.Vector; mic : Mixed_Cell;
                 e : Exponent_Vectors_Array;
                 c : Standard_Complex_VecVecs.VecVec )
               return Standard_Complex_VecVecs.VecVec is

  -- DESCRIPTION :
  --   Given a subsystem q of p and the coefficient vector of p, the
  --   vector on return will have only nonzero entries for coefficients
  --   that belong to q.

    res : Standard_Complex_VecVecs.VecVec(c'range);

  begin
    for i in mix'range loop
      declare
        cri : constant Standard_Complex_Vectors.Vector
            := Sub_Polyhedral_Homotopy(mic.pts(i),e(i).all,c(i).all);
      begin
        res(i) := new Standard_Complex_Vectors.Vector'(cri);
        for j in 1..(mix(i)-1) loop
          declare
            crj : constant Standard_Complex_Vectors.Vector
                := Sub_Polyhedral_Homotopy(mic.pts(i),e(i+j).all,c(i+j).all);
          begin
            res(i+j) := new Standard_Complex_Vectors.Vector'(crj);
          end;
        end loop;
      end;
    end loop;
    return res;
  end Sub_Polyhedral_Homotopy;

  procedure Refined_Mixed_Solve
                ( q : in Laur_Sys; mix : in Standard_Integer_Vectors.Vector;
                  mic : in Mixed_Cell; h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  qsols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Polyhedral coeffient-homotopy for subsystem q.

  -- REQUIRED : mic.sub /= null.

    lif : Array_of_Lists(mix'range) := Sub_Lifting(q,mix,mic);
    cq : Standard_Complex_VecVecs.VecVec(c'range)
       := Sub_Polyhedral_Homotopy(mix,mic,e,c);

  begin
    Mixed_Solve(q,lif,h,cq,e,j,m,mix,mic.sub.all,qsols);
    Standard_Complex_VecVecs.Clear(cq); Deep_Clear(lif);
  end Refined_Mixed_Solve;

  procedure Refined_Mixed_Solve
                ( file : in file_type; q : in Laur_Sys;
                  mix : in Standard_Integer_Vectors.Vector;
                  mic : in Mixed_Cell; h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  qsols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Polyhedral coeffient-homotopy for subsystem q.

  -- REQUIRED : mic.sub /= null.

    lif : Array_of_Lists(mix'range) := Sub_Lifting(q,mix,mic);
    cq : Standard_Complex_VecVecs.VecVec(c'range)
       := Sub_Polyhedral_Homotopy(mix,mic,e,c);

  begin
    Mixed_Solve(file,q,lif,h,cq,e,j,m,mix,mic.sub.all,qsols);
    Standard_Complex_VecVecs.Clear(cq); Deep_Clear(lif);
  end Refined_Mixed_Solve;

-- SECOND LAYER :

  procedure Mixed_Solve
                ( p : in Laur_Sys; lifted : in Array_of_Lists;
                  h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  mix : in Standard_Integer_Vectors.Vector;
                  mic : in Mixed_Cell;
                  sols,sols_last : in out Solution_List;
                  multprec_hermite : in boolean := false ) is

    q : Laur_Sys(p'range) := Select_Terms(p,mix,mic.pts.all);
    sq : Laur_Sys(q'range);
    pq : Poly_Sys(q'range);
    qsols : Solution_List;
    len : natural32 := 0;
    tol_zero : constant double_float := 1.0E-12; 
    fail,zero_y : boolean;

  begin
    Standard_Simpomial_Solvers.Solve
      (q,tol_zero,qsols,fail,zero_y,multprec_hermite);
    if fail then
      if mic.sub = null then
        sq := Shift(q);
        pq := Laurent_to_Polynomial_System(sq);
        qsols := Solve_by_Static_Lifting(pq);
        Clear(sq); Clear(pq);
      else
        Refined_Mixed_Solve(q,mix,mic,h,c,e,j,m,qsols);
      end if;
      Set_Continuation_Parameter(qsols,Create(0.0));
    end if;
    len := Length_Of(qsols);
    if len > 0 then
      Mixed_Continuation(mix,lifted,h,c,e,j,m,mic.nor.all,qsols);
      Concat(sols,sols_last,qsols);
    end if;
    Clear(q); -- for debugging with multithreading on cyclic 10
    Clear(qsols);
  exception 
    when others => put_line("exception happens here ..."); raise;
  end Mixed_Solve;

  procedure Mixed_Solve
                ( file : in file_type;
                  p : in Laur_Sys; lifted : in Array_of_Lists;
                  h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  mix : in Standard_Integer_Vectors.Vector;
                  mic : in Mixed_Cell;
                  sols,sols_last : in out Solution_List;
                  multprec_hermite : in boolean := false ) is

    q : Laur_Sys(p'range) := Select_Terms(p,mix,mic.pts.all);
    sq : Laur_Sys(q'range);
    pq : Poly_Sys(q'range);
    qsols : Solution_List;
    len : natural32 := 0;
    tol_zero : constant double_float := 1.0E-12;
    fail,zero_y : boolean;

  begin
   -- put_line(" calling standard simpomial solver ...");
   -- if multprec_hermite
   --  then put_line("with multiprecision arithmetic for the Hermite form");
   --  else put_line("with standard arithmetic for the Hermite normal form");
   -- end if;
    declare
    begin
      Standard_Simpomial_Solvers.Solve
        (q,tol_zero,qsols,fail,zero_y,multprec_hermite); -- ,rsum);
    exception
      when others =>
        put_line("exception in Simpomial solver, for system:"); 
        Standard_Complex_Laur_Systems_io.put(q);
        raise;
    end;
   -- if multprec_hermite
   --  then put_line("done with multiprecision Hermite");
   --  else put_line("solved the initial form system");
   -- end if;
    if not fail then
      put_line(file,"It is a simplex system.");
    else
      put_line(file,"No simplex system.");
      if mic.sub = null then
        put_line(file,"Calling the black box solver.");
        sq := Shift(q);
        pq := Laurent_to_Polynomial_System(sq);
        qsols := Solve_by_Static_Lifting(file,pq);
        Clear(sq); Clear(pq);
      else
        put_line(file,"Using the refinement of the cell.");
        Refined_Mixed_Solve(file,q,mix,mic,h,c,e,j,m,qsols);
      end if;
      Set_Continuation_Parameter(qsols,Create(0.0));
    end if;
    len := Length_Of(qsols);
    put(file,len,1); put_line(file," solutions found.");
   -- put("starting to track "); put(len,1); put_line(" paths...");
    if len > 0 then
      Mixed_Continuation(file,mix,lifted,h,c,e,j,m,mic.nor.all,qsols);
      Concat(sols,sols_last,qsols);
    end if;
    Clear(q); Clear(qsols);
  end Mixed_Solve;

-- THIRD LAYER :

  procedure Mixed_Solve
                ( p : in Laur_Sys; lifted : in Array_of_Lists;
                  h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  mix : in Standard_Integer_Vectors.Vector;
                  mixsub : in Mixed_Subdivision;
                  sols : in out Solution_List;
                  multprec_hermite : in boolean := false ) is

    tmp : Mixed_Subdivision := mixsub;
    mic : Mixed_Cell;
    sols_last : Solution_List;

  begin
    while not Is_Null(tmp) loop
      mic := Head_Of(tmp);
      Mixed_Solve(p,lifted,h,c,e,j,m,mix,mic,sols,sols_last,multprec_hermite);
      tmp := Tail_Of(tmp);
    end loop;
  end Mixed_Solve;

  procedure Mixed_Solve
                ( file : in file_type;
                  p : in Laur_Sys; lifted : in Array_of_Lists;
                  h : in Eval_Coeff_Laur_Sys;
                  c : in Standard_Complex_VecVecs.VecVec;
                  e : in Exponent_Vectors_Array;
                  j : in Eval_Coeff_Jaco_Mat; m : in Mult_Factors;
                  mix : in Standard_Integer_Vectors.Vector;
                  mixsub : in Mixed_Subdivision;
                  sols : in out Solution_List;
                  multprec_hermite : in boolean := false ) is

    tmp : Mixed_Subdivision := mixsub;
    mic : Mixed_Cell;
    sols_last : Solution_List;
    cnt : natural32 := 0;

  begin
   -- if multprec_hermite
   --  then put_line("running multprecision Hermite option");
   --  else put_line("running standard Hermite option");
   -- end if;
    while not Is_Null(tmp) loop
      mic := Head_Of(tmp);
      cnt := cnt + 1;
      new_line(file);
      put(file,"*** PROCESSING SUBSYSTEM "); put(file,cnt,1);
      put_line(file," ***");
      new_line(file);
     -- put("starting to solve subsystem "); put(cnt,1); put_line(" ...");
      Mixed_Solve(file,p,lifted,h,c,e,j,m,mix,mic,sols,sols_last,
                  multprec_hermite);
      tmp := Tail_Of(tmp);
    end loop;
  end Mixed_Solve;

end Floating_Polyhedral_Continuation;