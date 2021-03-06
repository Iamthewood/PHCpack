with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers_io;        use Standard_Complex_Numbers_io;
with Standard_Complex_Vectors_io;        use Standard_Complex_Vectors_io;
with Standard_Point_Coordinates;         use Standard_Point_Coordinates;
with Hypersurface_Witness_Sets;          use Hypersurface_Witness_Sets;

package body Hypersurfaces_and_Filters is

  procedure RG_Hypersurface_Witness_Set
              ( file : in file_type; n,d : in natural32; b,v : in Vector;
                s : out Solution_List; res : out double_float ) is

    sols,sols_last : Solution_List;
    t,err,resid : Vector(1..integer32(d));
    eps : constant double_float := 1.0E-12;
    nrm : double_float;
    fail : boolean;

    procedure Root_Finder is new Reporting_Root_Finder1(f);

  begin
   -- put_line("Calling Root_Finder...");
    Root_Finder(file,d,eps,10*d,fail,b,v,t,err,resid,nrm);
   -- put_line("...done with Root_Finder.");
    for i in t'range loop
      declare
        s : Solution(1);
      begin
        s.m := 1;
        s.t := Create(1.0);
        s.v(1) := t(i);
        s.err := AbsVal(err(i)); 
        s.rco := 1.0; 
        s.res := AbsVal(resid(i)); 
        Append(sols,sols_last,s);
      end;
    end loop;
    s := sols;
    res := nrm;
  end RG_Hypersurface_Witness_Set;

  procedure RP_Hypersurface_Witness_Set
              ( file : in file_type; n,d : in natural32;
                p : in Eval_Poly; b,v : in Vector;
                s : out Solution_List; res : out double_float ) is

    function Eval ( x : Vector ) return Complex_Number is
    begin
      return Eval(p,x);
    end Eval;
    procedure Find_Roots is new RG_Hypersurface_Witness_Set(Eval);

  begin
   -- put_line("Calling Find_Roots ...");
    Find_Roots(file,n,d,b,v,s,res);
   -- put_line("... done with Find_Roots.");
  end RP_Hypersurface_Witness_Set;

  procedure SG_Hypersurface_Witness_Set
              ( n,d : in natural32; b,v : in Vector;
                s : out Solution_List; res : out double_float ) is

    sols,sols_last : Solution_List;
    t,err,resid : Vector(1..integer32(d));
    eps : constant double_float := 1.0E-12;
    nrm : double_float;
    fail : boolean;

    procedure Root_Finder is new Silent_Root_Finder1(f);

  begin
    Root_Finder(d,eps,10*d,fail,b,v,t,err,resid,nrm);
    for i in t'range loop
      declare
        sol : Solution(1);
      begin
        sol.m := 1;
        sol.t := Create(1.0);
        sol.v(1) := t(i);
        sol.err := AbsVal(err(i)); 
        sol.rco := 1.0; 
        sol.res := AbsVal(resid(i)); 
        Append(sols,sols_last,sol);
      end;
    end loop;
    s := sols;
    res := nrm;
  end SG_Hypersurface_Witness_Set;

  procedure SP_Hypersurface_Witness_Set
              ( n,d : in natural32;
                p : in Eval_Poly; b,v : in Vector;
                s : out Solution_List; res : out double_float ) is

    function Eval ( x : Vector ) return Complex_Number is
    begin
      return Eval(p,x);
    end Eval;
    procedure Find_Roots is new SG_Hypersurface_Witness_Set(Eval);

  begin
    Find_Roots(n,d,b,v,s,res);
  end SP_Hypersurface_Witness_Set;

  procedure RG_Filter ( file : in file_type; ne : in natural32;
                        sols : in out Solution_List;
                        b,v : in Vector; tol : in double_float ) is

    res,res_last : Solution_List;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;
    isin : boolean;

  begin
    for i in 1..Length_Of(sols) loop
      ls := Head_Of(tmp);
      put(file,"Filtering point "); put(file,i,1); put_line(file," :");
      declare
        t : constant Complex_Number := ls.v(1);
        x : constant Vector(b'range) := b + t*v;
        y : Complex_Number;
      begin
        for j in 1..ne loop 
          y := f(integer32(j),x);
          put(file,"  value at eq "); put(file,j,1);
          put(file," : "); put(file,y);
          if AbsVal(y) > tol
           then put(file,"  > "); isin := false;
           else put(file," <= "); isin := true;
          end if;
          put(file,tol,2); new_line(file);
          exit when isin;
        end loop;
        put(file,"Point "); put(file,i,1);
        if isin
         then put_line(file," is discarded.");
         else put_line(file," is retained.");
              Append(res,res_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(sols);
    sols := res;
  end RG_Filter;

  procedure RP_Filter ( file : in file_type; sols : in out Solution_List;
                        p : in Eval_Poly_Sys; b,v : in Vector;
                        tol : in double_float ) is

    res,res_last : Solution_List;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;
    isin : boolean;

  begin
    for i in 1..Length_Of(sols) loop
      ls := Head_Of(tmp);
      put(file,"Filtering point "); put(file,i,1); put_line(file," :");
      declare
        t : constant Complex_Number := ls.v(1);
        x : constant Vector(b'range) := b + t*v;
        y : Complex_Number;
      begin
        for j in p'range loop 
          y := Eval(p(j),x);
          put(file,"  value at eq "); put(file,j,1);
          put(file," : "); put(file,y);
          if AbsVal(y) > tol
           then put(file,"  > "); isin := false;
           else put(file," <= "); isin := true;
          end if;
          put(file,tol,2); new_line(file);
          exit when isin;
        end loop;
        put(file,"Point "); put(file,i,1);
        if isin then
          put_line(file," is discarded.");
        else
          put_line(file," is retained.");
          Append(res,res_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(sols);
    sols := res;
  end RP_Filter;

  procedure SG_Filter ( ne : in natural32; sols : in out Solution_List;
                        b,v : in Vector; tol : in double_float ) is

    res,res_last : Solution_List;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;
    isin : boolean;

  begin
    for i in 1..Length_Of(sols) loop
      ls := Head_Of(tmp);
      declare
        t : constant Complex_Number := ls.v(1);
        x : constant Vector(b'range) := b + t*v;
        y : Complex_Number;
      begin
        for j in 1..ne loop 
          y := f(integer32(j),x);
          if AbsVal(y) > tol
           then isin := false;
           else isin := true;
          end if;
          exit when isin;
        end loop;
        if not isin
         then Append(res,res_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(sols);
    sols := res;
  end SG_Filter;

  procedure SP_Filter ( sols : in out Solution_List;
                        p : in Eval_Poly_Sys; b,v : in Vector;
                        tol : in double_float ) is

    res,res_last : Solution_List;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;
    isin : boolean;

  begin
   -- put_line("inside SP_Filter ...");
    for i in 1..Length_Of(sols) loop
      ls := Head_Of(tmp);
      declare
        t : constant Complex_Number := ls.v(1);
        x : constant Vector(b'range) := b + t*v;
        y : Complex_Number;
      begin
        for j in p'range loop 
          y := Eval(p(j),x);
          if AbsVal(y) > tol
           then isin := false;
           else isin := true;
          end if;
          exit when isin;
        end loop;
        if not isin
         then Append(res,res_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(sols);
    sols := res;
   -- put_line("returning from SP_Filter");
  end SP_Filter;

  procedure RG_Split_Filter
               ( file : in file_type; tol : in double_float;
                 p_sols : in out Solution_List; q_sols : out Solution_List;
                 plane : in Matrix ) is

    q,q_last,w,w_last : Solution_List;
    tmp : Solution_List := p_sols;
    ls : Link_to_Solution;
    isin : boolean;

  begin
    for i in 1..Length_Of(p_sols) loop
      ls := Head_Of(tmp);
      declare
        x : constant Vector(plane'range(1)) := Affine_Expand(ls.v,plane);
        y : constant Complex_Number := f(x);
      begin
        put(file,"Value at point "); put(file,i,1); put(file," : ");
        put(file,y);
        if AbsVal(y) > tol
         then put(file,"  > "); isin := false;
         else put(file," <= "); isin := true;
        end if;
        put(file,tol,2); new_line(file);
        if isin
         then Append(w,w_last,ls.all);
         else Append(q,q_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(p_sols);
    p_sols := w;
    q_sols := q;
  end RG_Split_Filter;

  procedure RP_Split_Filter
               ( file : in file_type; p : in Eval_Poly; tol : in double_float;
                 p_sols : in out Solution_List; q_sols : out Solution_List;
                 plane : in Matrix ) is

    q,q_last,w,w_last : Solution_List;
    tmp : Solution_List := p_sols;
    ls : Link_to_Solution;
    isin : boolean;

  begin
    for i in 1..Length_Of(p_sols) loop
      ls := Head_Of(tmp);
      declare
        x : constant Vector(plane'range(1)) := Affine_Expand(ls.v,plane);
        y : constant Complex_Number := Eval(p,x);
      begin
        put(file,"Value at point "); put(file,i,1); put(file," : ");
        put(file,y);
        if AbsVal(y) > tol
         then put(file,"  > "); isin := false;
         else put(file," <= "); isin := true;
        end if;
        put(file,tol,2); new_line(file);
        if isin
         then Append(w,w_last,ls.all);
         else Append(q,q_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(p_sols);
    p_sols := w;
    q_sols := q;
  end RP_Split_Filter;

  procedure SG_Split_Filter
               ( tol : in double_float;
                 p_sols : in out Solution_List; q_sols : out Solution_List;
                 plane : in Matrix ) is

  -- DESCRIPTION :
  --   Splits the given solution list into two lists: those which satisfy
  --   p and those which do not, with respect to the given tolerance.
  --   This is a silent version without any output.

  -- ON ENTRY :
  --   p         polynomial function, to evaluate a new hypersurface;
  --   tol       tolerance to decide whether number is zero;
  --   p_sols    a witness set for previous equations;
  --   plane     plane which cuts out p_sols.

  -- ON RETURN :
  --   p_sols    witness set which satisfies p;
  --   q_sols    solutions which do not satisfy p become start solutions.

    q,q_last,w,w_last : Solution_List;
    tmp : Solution_List := p_sols;
    ls : Link_to_Solution;

  begin
    for i in 1..Length_Of(p_sols) loop
      ls := Head_Of(tmp);
      declare
        x : constant Vector(plane'range(1)) := Affine_Expand(ls.v,plane);
        y : constant Complex_Number := f(x);
      begin
        if AbsVal(y) > tol
         then Append(q,q_last,ls.all);
         else Append(w,w_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(p_sols);
    p_sols := w;
    q_sols := q;
  end SG_Split_Filter;

  procedure SP_Split_Filter
               ( p : in Eval_Poly; tol : in double_float;
                 p_sols : in out Solution_List; q_sols : out Solution_List;
                 plane : in Matrix ) is

  -- DESCRIPTION :
  --   Splits the given solution list into two lists: those which satisfy
  --   p and those which do not, with respect to the given tolerance.
  --   This is a silent version without any output.

  -- ON ENTRY :
  --   p         polynomial function, to evaluate a new hypersurface;
  --   tol       tolerance to decide whether number is zero;
  --   p_sols    a witness set for previous equations;
  --   plane     plane which cuts out p_sols.

  -- ON RETURN :
  --   p_sols    witness set which satisfies p;
  --   q_sols    solutions which do not satisfy p become start solutions.

    q,q_last,w,w_last : Solution_List;
    tmp : Solution_List := p_sols;
    ls : Link_to_Solution;

  begin
    for i in 1..Length_Of(p_sols) loop
      ls := Head_Of(tmp);
      declare
        x : constant Vector(plane'range(1)) := Affine_Expand(ls.v,plane);
        y : constant Complex_Number := Eval(p,x);
      begin
        if AbsVal(y) > tol
         then Append(q,q_last,ls.all);
         else Append(w,w_last,ls.all);
        end if;
      end;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(p_sols);
    p_sols := w;
    q_sols := q;
  end SP_Split_Filter;

  procedure QSG_Filter ( s : in out Solution_List;
                         p : in Matrix; tol : in double_float ) is

    res,res_last : Solution_List;
    tmp : Solution_List := s;
    ls : Link_to_Solution;
    spurious : boolean;

  begin
    while not Is_Null(tmp) loop
      ls := Head_Of(tmp);
      spurious := false;
      declare
        x : constant Vector := Affine_Expand(ls.v,p);
        y : constant Vector := Q(x);
      begin
        for i in y'range loop
          if AbsVal(y(i)) < tol
           then spurious := true;
          end if;
          exit when spurious;
        end loop;
      end;
      if not spurious
       then Append(res,res_last,ls.all);
      end if;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(s);
    s := res;
  end QSG_Filter;

  procedure QRG_Filter ( file : in file_type; s : in out Solution_List;
                         p : in Matrix; tol : in double_float ) is

    res,res_last : Solution_List;
    tmp : Solution_List := s;
    ls : Link_to_Solution;
    spurious : boolean;

  begin
    for k in 1..Length_Of(s) loop
      ls := Head_Of(tmp);
      spurious := false;
      declare
        x : constant Vector := Affine_Expand(ls.v,p);
        y : constant Vector := Q(x);
      begin
        put(file,"Value of solution "); put(file,k,1);
        put_line(file," at Q :"); put_line(file,y);
        for i in y'range loop
          if AbsVal(y(i)) < tol then
            spurious := true;
            put(file,"Solution "); put(file,k,1);
            put_line(file," is spurious and will be discarded.");
          end if;
          exit when spurious;
        end loop;
      end;
      if not spurious
       then Append(res,res_last,ls.all);
      end if;
      tmp := Tail_Of(tmp);
    end loop;
    Clear(s);
    s := res;
  end QRG_Filter;

end Hypersurfaces_and_Filters;
