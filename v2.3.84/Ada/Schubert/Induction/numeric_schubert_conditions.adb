with Standard_Complex_Numbers;          use Standard_Complex_Numbers;
with Bracket_Monomials;                 use Bracket_Monomials;
with Bracket_Systems;                   use Bracket_Systems;
with Straightening_Syzygies;
with Symbolic_Schubert_Conditions;      use Symbolic_Schubert_Conditions;

package body Numeric_Schubert_Conditions is

  function Degree ( b : Bracket; k : natural32 ) return integer32 is
  begin
    for i in b'range loop
      if b(i) > k
       then return i-1;
      end if;
    end loop;
    return b'last;
  end Degree;

  function Substitute ( p : Bracket_Polynomial; t : Numeric_Minor_Table )
                      return Bracket_Polynomial is

    res : Bracket_Polynomial := Null_Bracket_Poly;

    procedure Subs_Term ( bt : in Bracket_Term; ct : out boolean ) is

      first : boolean := true;

      procedure Subs_Bracket ( b : in Bracket; cb : out boolean ) is

        nt : Bracket_Term;
        nb : Bracket(b'first..b'last-1);  -- to remove leading zero tag
        bm : Bracket_Monomial;

      begin
        if first then
          if b(b'first) = 0 then     -- remove the zero tag
            for i in nb'range loop   -- and shift the range
              nb(i) := b(i+1);
            end loop;
            bm := Create(nb);
          else
            bm := Create(b);
          end if;
          first := false;
        else
          nt.monom := bm;
          nt.coeff := bt.coeff*Search(t,b);
          Add(res,nt);
        end if;
        cb := true;
      end Subs_Bracket;
      procedure Subs_Mono is new Enumerate_Brackets(Subs_Bracket); 

    begin
      Subs_Mono(bt.monom);
      ct := true;
    end Subs_Term;
    procedure Subs_Poly is new Enumerate_Terms(Subs_Term);

  begin
    Subs_Poly(p);
    return res;
  end Substitute;

  function Permute ( b,p : Bracket ) return Bracket is

    res : Bracket(b'range);

  begin
    for i in b'range loop
      res(i) := p(integer32(b(i)));
    end loop;
    return res;
  end Permute;

  function Substitute ( p : Bracket_Polynomial; t : Numeric_Minor_Table;
                        rows : Bracket ) return Bracket_Polynomial is

    res : Bracket_Polynomial := Null_Bracket_Poly;

    procedure Subs_Term ( bt : in Bracket_Term; ct : out boolean ) is

      first : boolean := true;
      bm : Bracket_Monomial;

      procedure Subs_Bracket ( b : in Bracket; cb : out boolean ) is

        nt : Bracket_Term;
        nb : Bracket(b'first..b'last-1); -- to remove leading zero tag

      begin
        if first then
          if b(b'first) = 0 then     -- remove leading zero
            for i in nb'range loop   -- and shift the range
              nb(i) := b(i+1);
            end loop;
            bm := Create(nb);
          else
            bm := Create(Permute(b,rows));
          end if;
          first := false;
        else
          nt.monom := bm;
          nt.coeff := bt.coeff*Search(t,Permute(b,rows));
          Add(res,nt);
        end if;
        cb := true;
      end Subs_Bracket;
      procedure Subs_Mono is new Enumerate_Brackets(Subs_Bracket); 

    begin
      Subs_Mono(bt.monom);
      ct := true;
    end Subs_Term;
    procedure Subs_Poly is new Enumerate_Terms(Subs_Term);

  begin
    Subs_Poly(p);
    return res;
  end Substitute;

  function Substitute ( p : Bracket_Polynomial; t : Symbolic_Minor_Table )
                      return Poly is

    res : Poly := Null_Poly;

    procedure Subs_Term ( bt : in Bracket_Term; ct : out boolean ) is

      procedure Subs_Bracket ( b : in Bracket; cb : out boolean ) is

        tp : Poly;

      begin
        tp := bt.coeff*Search(t,b);
        Add(res,tp);
       -- Clear(tp);
        cb := false;
      end Subs_Bracket;
      procedure Subs_Mono is new Enumerate_Brackets(Subs_Bracket); 

    begin
      Subs_Mono(bt.monom);
      ct := true;
    end Subs_Term;
    procedure Subs_Poly is new Enumerate_Terms(Subs_Term);

  begin
    Subs_Poly(p);
    return res;
  end Substitute;

  function Substitute ( p : Bracket_Polynomial; t : Symbolic_Minor_Table;
                        rows : Bracket ) return Poly is

    res : Poly := Null_Poly;

    procedure Subs_Term ( bt : in Bracket_Term; ct : out boolean ) is

      tp : Poly;

      procedure Subs_Bracket ( b : in Bracket; cb : out boolean ) is
      begin
        tp := bt.coeff*Search(t,Permute(b,rows));
        Add(res,tp);
        Clear(tp);
        cb := false;
      end Subs_Bracket;
      procedure Subs_Mono is new Enumerate_Brackets(Subs_Bracket); 

    begin
      Subs_Mono(bt.monom);
      ct := true;
    end Subs_Term;
    procedure Subs_Poly is new Enumerate_Terms(Subs_Term);

  begin
    Subs_Poly(p);
    return res;
  end Substitute;

  function Substitute ( p : Bracket_Polynomial; nt,st : Symbolic_Minor_Table;
                        rows : Bracket ) return Poly is

    res : Poly := Null_Poly;

    procedure Subs_Term ( bt : in Bracket_Term; ct : out boolean ) is

      first : boolean := true;
      p : Poly;

      procedure Subs_Bracket ( b : in Bracket; cb : out boolean ) is

        nb : Bracket(b'first..b'last-1); -- to remove leading zero tag
        q : Poly;

      begin
        if first then
         -- put("first bracket : "); put(b); new_line;
          if b(b'first) = 0 then     -- remove leading zero
            for i in nb'range loop   -- and shift the range
              nb(i) := b(i+1);
            end loop;
            p := bt.coeff*search(st,Permute(nb,rows));
           -- p := bt.coeff*search(st,nb);
          else
            p := bt.coeff*search(st,Permute(b,rows));
          end if;
          first := false;
        else
         -- put("second bracket : "); put(b); new_line;
          q := Search(nt,Permute(b,rows));
          Mul(p,q);
          Add(res,p); Clear(p);
        end if;
        cb := true;
      end Subs_Bracket;
      procedure Subs_Mono is new Enumerate_Brackets(Subs_Bracket); 

    begin
      Subs_Mono(bt.monom);
      ct := true;
    end Subs_Term;
    procedure Subs_Poly is new Enumerate_Terms(Subs_Term);

  begin
    Subs_Poly(p);
    return res;
  end Substitute;

  function Select_Columns
              ( A : Standard_Complex_Matrices.Matrix;
                col : Bracket; d,k : integer32 )
              return Standard_Complex_Matrices.Matrix is

    res : Standard_Complex_Matrices.Matrix(A'range(1),1..d);
    ind : integer32 := 0;

  begin
    for j in col'range loop
      if integer32(col(j)) > k then
        ind := ind + 1;
        for i in A'range(1) loop 
          res(i,ind) := A(i,integer32(col(j))-k);
        end loop;
      end if;
    end loop;
    return res;
  end Select_Columns;

  function Select_Columns
              ( A : Standard_Complex_Poly_Matrices.Matrix;
                col : Bracket; d,k : integer32 )
              return Standard_Complex_Poly_Matrices.Matrix is

    res : Standard_Complex_Poly_Matrices.Matrix(A'range(1),1..d);
    ind : integer32 := 0;

  begin
    for i in res'range(1) loop
      for j in res'range(2) loop
        res(i,j) := Null_Poly;
      end loop;
    end loop;
    for j in col'range loop
      if integer32(col(j)) > k then
        ind := ind + 1;
        for i in A'range(1) loop 
          Copy(A(i,integer32(col(j))-k),res(i,ind));
        end loop;
      end if;
    end loop;
    return res;
  end Select_Columns;

  function Select_Columns
              ( x : Standard_Complex_Poly_Matrices.Matrix;
                col : Bracket; d : integer32 )
              return Standard_Complex_Poly_Matrices.Matrix is

    res : Standard_Complex_Poly_Matrices.Matrix(x'range(1),1..d);

  begin
    for j in 1..d loop
      for i in x'range(1) loop
        res(i,j) := x(i,integer32(col(j)));
      end loop;
    end loop;
    return res;
  end Select_Columns;

  function Laplace_One_Minor
               ( n,k : integer32; row,col : Bracket;
                 A : Standard_Complex_Matrices.Matrix ) 
               return Bracket_Polynomial is

    res : Bracket_Polynomial;
    c : constant integer32 := Degree(col,natural32(k));
    m : constant integer32 := col'last;
    d : constant integer32 := m - c;
    lp : Bracket_Polynomial
       := Straightening_Syzygies.Laplace_Expansion(natural32(m),natural32(c));
    sA : constant Standard_Complex_Matrices.Matrix(A'range(1),1..d)
       := Select_Columns(A,col,d,k);
    nm : constant natural32
       := Remember_Numeric_Minors.Number_of_Minors(natural32(n),natural32(d));
    rt : Numeric_Minor_Table(integer32(nm))
       := Create(natural32(n),natural32(d),sA);

  begin
   -- put("Row "); put(row); put(" and column "); put(col);
   -- put(" with degree "); put(c,1); new_line;
   -- put_line("The Laplace expansion : "); put(lp); new_line;
   -- put_line("The remember table of numeric minors : "); Write(rt);
   -- Query(rt,d);
    res := Substitute(lp,rt,row);
   -- put("After substitution with numerical minors : "); put_line(res);
    Clear(lp); Clear(rt);
    return res;
  end Laplace_One_Minor;

  function Laplace_One_Minor
               ( n,k : integer32; row,col : Bracket;
                 X : Standard_Complex_Poly_Matrices.Matrix;
                 A : Standard_Complex_Matrices.Matrix ) return Poly is

    res : Poly;
    c : constant integer32 := Degree(col,natural32(k));
    m : constant integer32 := col'last;
    d : constant integer32 := m - c;
    lp : Bracket_Polynomial
       := Straightening_Syzygies.Laplace_Expansion(natural32(m),natural32(c));
    sA : constant Standard_Complex_Matrices.Matrix(A'range(1),1..d)
       := Select_Columns(A,col,d,k);
    sX : constant Standard_Complex_Poly_Matrices.Matrix(X'range(1),1..c)
       := Select_Columns(X,col,c);
    nm : constant natural32
       := Remember_Numeric_Minors.Number_of_Minors(natural32(n),natural32(d));
    sm : constant natural32
       := Remember_Symbolic_Minors.Number_of_Minors(natural32(n),natural32(c));
    nt : Numeric_Minor_Table(integer32(nm))
       := Create(natural32(n),natural32(d),sA);
    st : Symbolic_Minor_Table(integer32(sm))
       := Create(natural32(n),natural32(c),sX);
    sp : constant Bracket_Polynomial := Substitute(lp,nt,row);

  begin
   -- put("Row "); put(row); put(" and column "); put(col);
   -- put(" with degree "); put(c,1); new_line;
   -- put_line("The Laplace expansion : "); put(lp); new_line;
   -- put_line("The remember table of numeric minors : "); Write(nt);
   -- Query(nt,d);
   -- put("After substitution with numerical minors : "); put_line(sp);
   -- put_line("The remember table of symbolic minors : "); Write(st);
   -- Query(st,c);
    res := Substitute(sp,st,row);
   -- put("After substitution with symbolic minors : "); put_line(res);
    Clear(lp); Clear(nt); Clear(st);
    return res;
  end Laplace_One_Minor;

  function Laplace_One_Minor
               ( n,k : integer32; row,col : Bracket;
                 X,A : Standard_Complex_Poly_Matrices.Matrix ) return Poly is

    res : Poly;
    c : constant integer32 := Degree(col,natural32(k));
    m : constant integer32 := col'last;
    d : constant integer32 := m - c;
    lp : Bracket_Polynomial
       := Straightening_Syzygies.Laplace_Expansion(natural32(m),natural32(c));
    sA : constant Standard_Complex_Poly_Matrices.Matrix(A'range(1),1..d)
       := Select_Columns(A,col,d,k);
    sX : constant Standard_Complex_Poly_Matrices.Matrix(X'range(1),1..c)
       := Select_Columns(X,col,c);
    nm : constant natural32
       := Remember_Symbolic_Minors.Number_of_Minors(natural32(n),natural32(d));
    sm : constant natural32
       := Remember_Symbolic_Minors.Number_of_Minors(natural32(n),natural32(c));
    nt : Symbolic_Minor_Table(integer32(nm))
       := Create(natural32(n),natural32(d),sA);
    st : Symbolic_Minor_Table(integer32(sm))
       := Create(natural32(n),natural32(c),sX);

  begin
   -- put("Row "); put(row); put(" and column "); put(col);
   -- put(" with degree "); put(c,1); new_line;
   -- put_line("The Laplace expansion : "); put(lp); new_line;
   -- put_line("The remember table of numeric minors : "); Write(nt);
   -- Query(nt,d);
   -- put_line("The remember table of symbolic minors : "); Write(st);
   -- Query(st,c);
    res := Substitute(lp,nt,st,row);
   -- put("After substitution with symbolic minors : "); put_line(res);
    Clear(lp); Clear(nt); Clear(st);
    return res;
  end Laplace_One_Minor;

  function Elaborate_One_Flag_Minor
               ( n,k,f,i : integer32; fm : Bracket_Polynomial;
                 A : Standard_Complex_Matrices.Matrix )
               return Bracket_Polynomial is

    res : Bracket_Polynomial;
    r : constant integer32 := k+f-i+1;
    row,col : Bracket(1..r);

    procedure Get_Column ( t : in Bracket_Term; ct : out boolean ) is

      first : boolean := true;

      procedure Get_Bracket ( b : in Bracket; cb : out boolean ) is
      begin
        if first then
          row := b; cb := true; first := false;
        else
          col := b; cb := false;
          res := Laplace_One_Minor(n,k,row,col,A);
        end if;
      end Get_Bracket;
      procedure Get_Brackets is new Enumerate_Brackets(Get_Bracket);

    begin
      Get_Brackets(t.monom);
      ct := true;
    end Get_Column;
    procedure Get_Columns is new Enumerate_Terms(Get_Column);

  begin
    Get_Columns(fm);
    return res;
  end Elaborate_One_Flag_Minor;

  function Elaborate_One_Flag_Minor
               ( n,k,f,i : integer32; fm : Bracket_Polynomial;
                 X : Standard_Complex_Poly_Matrices.Matrix;
                 A : Standard_Complex_Matrices.Matrix ) return Poly is

    res : Poly;
    r : constant integer32 := k+f-i+1;
    row,col : Bracket(1..r);

    procedure Get_Column ( t : in Bracket_Term; ct : out boolean ) is

      first : boolean := true;

      procedure Get_Bracket ( b : in Bracket; cb : out boolean ) is
      begin
        if first then
          row := b; cb := true; first := false;
        else
          col := b; cb := false;
          res := Laplace_One_Minor(n,k,row,col,X,A);
        end if;
      end Get_Bracket;
      procedure Get_Brackets is new Enumerate_Brackets(Get_Bracket);

    begin
      Get_Brackets(t.monom);
      ct := true;
    end Get_Column;
    procedure Get_Columns is new Enumerate_Terms(Get_Column);

  begin
    Get_Columns(fm);
    return res;
  end Elaborate_One_Flag_Minor;

  function Elaborate_One_Flag_Minor
               ( n,k,f,i : integer32; fm : Bracket_Polynomial;
                 X,A : Standard_Complex_Poly_Matrices.Matrix ) return Poly is

    res : Poly := Null_Poly;
    r : constant integer32 := k+f-i+1;
    row,col : Bracket(1..r);

    procedure Get_Column ( t : in Bracket_Term; ct : out boolean ) is

      first : boolean := true;

      procedure Get_Bracket ( b : in Bracket; cb : out boolean ) is
      begin
        if first then
          row := b; cb := true; first := false;
        else
          col := b; cb := false;
          res := Laplace_One_Minor(n,k,row,col,X,A);
        end if;
      end Get_Bracket;
      procedure Get_Brackets is new Enumerate_Brackets(Get_Bracket);

    begin
      Get_Brackets(t.monom);
      ct := true;
    end Get_Column;
    procedure Get_Columns is new Enumerate_Terms(Get_Column);

  begin
    Get_Columns(fm);
    return res;
  end Elaborate_One_Flag_Minor;

  function Expand ( n,k,nq : integer32; lambda : Bracket;
                    X : Standard_Complex_Poly_Matrices.Matrix;
                    flag : Standard_Complex_Matrices.Matrix )
                  return Poly_Sys is

    res : Poly_Sys(1..nq);
    fm : constant Bracket_System(lambda'range)
       := Flag_Minors(natural32(n),lambda);
    ind : integer32 := 0;
    nq1 : natural32;

  begin
    for i in lambda'range loop
      if fm(i) /= Null_Bracket_Poly then
        nq1 := Number_of_Equations
                 (natural32(n),natural32(k),lambda(i),natural32(i));
        declare
          fms : constant Bracket_system(1..integer32(nq1))
              := Flag_Minor_System(nq1,fm(i));
        begin
          for j in fms'range loop
            ind := ind + 1;
            res(ind) := Elaborate_One_Flag_Minor
                          (n,k,integer32(lambda(i)),i,fms(j),X,flag);
          end loop;
         -- Clear(fms);
        end;
      end if;
    end loop;
   -- Clear(fm);
    return res;
  end Expand;

  function Expand ( n,k,nq : integer32; lambda : Bracket;
                    X,F : Standard_Complex_Poly_Matrices.Matrix )
                  return Poly_Sys is

    res : Poly_Sys(1..nq);
    fm : constant Bracket_System(lambda'range)
       := Flag_Minors(natural32(n),lambda);
    ind : integer32 := 0;
    nq1 : natural32;

  begin
    for i in lambda'range loop
      if fm(i) /= Null_Bracket_Poly then
        nq1 := Number_of_Equations
                 (natural32(n),natural32(k),lambda(i),natural32(i));
        declare
          fms : constant Bracket_system(1..integer32(nq1))
              := Flag_Minor_System(nq1,fm(i));
        begin
          for j in fms'range loop
            ind := ind + 1;
           -- put("elaborating minor "); put(fms(j)); put_line(" ...");
            res(ind) := Elaborate_One_Flag_Minor
                          (n,k,integer32(lambda(i)),i,fms(j),X,F);
          end loop;
         -- Clear(fms);
        end;
      end if;
    end loop;
   -- Clear(fm);
    return res;
  end Expand;

end Numeric_Schubert_Conditions;
