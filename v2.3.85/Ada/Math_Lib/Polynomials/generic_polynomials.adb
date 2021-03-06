with unchecked_deallocation;
with Generic_Lists;
--with Graded_Lexicographic_Order;         use Graded_Lexicographic_Order;

package body Generic_Polynomials is

-- REPRESENTATION INVARIANT :
--   1. Only terms with a coefficient different from zero are stored.
--   2. The terms in any polynomial are ordered from high to low degree
--      according to the graded lexicographic order.

  MAX_INT : constant integer32 := 100000;

-- DATA STRUCTURES : 

  package Term_List is new Generic_Lists(Term);
  type Poly_Rep is new Term_List.List;

  procedure free is new unchecked_deallocation(Poly_Rep,Poly);
 
-- AUXILIARY OPERATIONS :

  procedure Shuffle ( p : in out Poly ) is

  -- DESCRIPTION :
  --   Changes the position of the terms in p back to the normal order.
  --   Needed to guarantee the second representation invariant.

    res : Poly := Null_Poly;

    procedure Shuffle_Term ( t : in Term; cont : out boolean ) is
    begin
      Add(res,t);
      cont := true;
    end Shuffle_Term;
    procedure Shuffle_Terms is new Visiting_Iterator(Shuffle_Term);

  begin
    Shuffle_Terms(p);
    Clear(p); Copy(res,p); Clear(res);
  end Shuffle;

  procedure Append_Copy ( first,last : in out Poly_Rep; t : in Term ) is

  -- DESCRIPTION :
  --   Appends a copy of the term to the list.

    tt : Term;

  begin
    Copy(t,tt);
    Append(first,last,tt);
  end Append_Copy;

-- CONSTRUCTORS :

  function Create ( i : integer ) return Poly is
  begin
    return Create(Ring.Create(i));
  end Create;

  function Create ( n : number ) return Poly is

    t : Term;

  begin
    Copy(n,t.cf);
    return Create(t);
  end Create;
 
  function Create ( t : Term ) return Poly is

    p : Poly;

  begin
    if Equal(t.cf,zero)
     then p := Null_Poly;
     else declare
            tt : Term;
          begin
            Copy(t,tt);
            p := new Poly_Rep;
            Construct(tt,p.all);
          end;
    end if;
    return p;
  end Create;

  procedure Copy ( t1 : in Term; t2 : in out Term ) is
  begin
    Clear(t2);
    Standard_Natural_Vectors.Copy
      (Standard_Natural_Vectors.Link_to_Vector(t1.dg),
       Standard_Natural_Vectors.Link_to_Vector(t2.dg));
    Copy(t1.cf,t2.cf);
  end Copy;

  procedure Copy ( p: in Poly_Rep; q : in out Poly_Rep ) is
 
    lp,lq : Poly_Rep;
    t : Term;
 
  begin
    Clear(q);
    if not Is_Null(p) then
      lp := p;
      while not Is_Null(lp) loop
        t := Head_Of(lp);
        Append_Copy(q,lq,t);
        lp := Tail_Of(lp);
      end loop;
    end if;
  end Copy;

  procedure Copy ( p : in Poly; q : in out Poly ) is

    l : Poly_Rep;

  begin
    Clear(q);
    if p /= Null_Poly
     then Copy(p.all,l);
          q := new Poly_Rep'(l);
     else q := Null_Poly;
    end if;
  end Copy;

-- SELECTORS :

  function Equal ( t1,t2 : Term ) return boolean is
  begin
    if not Equal(t1.dg,t2.dg)
     then return false;
     else return Equal(t1.cf,t2.cf);
    end if;
  end Equal;

  function Equal ( p,q : Poly_Rep ) return boolean is

    lp, lq : Poly_Rep;

  begin
    lp := p;
    lq := q;
    while not Is_Null(lp) and not Is_Null(lq) loop
      if not Equal(Head_Of(lp),Head_Of(lq))
       then return false;
       else lp := Tail_Of(lp);
            lq := Tail_Of(lq);
      end if;
    end loop;
    if Is_Null(lp) and Is_Null(lq)
     then return true;
     else return false;
    end if;
  end Equal;

  function Equal ( p,q : Poly ) return boolean is
  begin
    if (p = Null_Poly) and (q = Null_Poly) then
      return true;
    elsif (p = Null_Poly) or (q = Null_Poly) then
      return false;
    else
      return Equal(p.all,q.all);
    end if;
  end Equal;
 
  function Number_Of_Unknowns ( p : Poly ) return natural32 is

    temp : Term;

  begin
    if (p = Null_Poly) or else Is_Null(p.all) then
      return 0;
    else
      temp := Head_Of(p.all);
      if temp.dg = null
       then return 0;
       else return temp.dg'length;
      end if;
    end if;
  end Number_Of_Unknowns;

  function Number_Of_Terms ( p : Poly ) return natural32 is
  begin
    if (p = Null_Poly) or else Is_Null(p.all)
     then return 0;
     else return Length_Of(p.all);
    end if;
  end Number_Of_Terms;
 
  function Degree ( p : Poly ) return integer32 is

    temp : Term;

  begin
     if (p = Null_Poly) or else Is_Null(p.all) then
       return -1;
     else
       temp := Head_Of(p.all);
       if temp.dg = null
        then return 0;
        else return integer32(Sum(temp.dg));
       end if;
     end if;
  end Degree;
 
  function Degree ( p : Poly; i : integer32 ) return integer32 is

    res : integer32 := 0;
   
    procedure Degree_Term ( t : in Term; continue : out boolean ) is

      index : integer32;
      temp : natural32;

    begin
      if t.dg /= null then
        index := t.dg'first + i - 1;
        temp := t.dg(index);
        if (temp > 0) and then (integer32(temp) > res)
         then res := integer32(temp);
        end if;
        continue := true;
      end if;
    end Degree_Term;
    procedure Degree_Terms is new Visiting_Iterator(process => Degree_Term);

  begin
    if p = Null_Poly or else Is_Null(p.all)
     then return -1;
     else Degree_Terms(p);
          return res;
    end if;
  end Degree;

  function Maximal_Degree ( p : Poly; i : integer32 ) return integer32 is
  begin
    return Degree(p,i);   
  end Maximal_Degree;

  function Maximal_Degrees ( p : Poly ) return Degrees is

    res : Degrees;
    n : constant natural32 := Number_of_Unknowns(p);

    procedure Degree_Term ( t : in Term; cont : out boolean ) is

      index : integer32;
      temp : natural32;

    begin
      for i in t.dg'range loop
        index := t.dg'first + i - 1;
        temp := t.dg(index);
        if temp > res(i)
         then res(i) := temp;
        end if;
      end loop;
      cont := true;
    end Degree_Term;
    procedure Degree_Terms is new Visiting_Iterator(Degree_Term);

  begin
    res := new Standard_Natural_Vectors.Vector'(1..integer32(n) => 0);
    Degree_Terms(p);
    return res;
  end Maximal_Degrees;

  function Minimal_Degree ( p : Poly; i : integer32 ) return integer32 is

    res : integer32 := MAX_INT;

    procedure Degree_Term ( t : in Term; continue : out boolean ) is

      index : integer32;
      temp : natural32;

    begin
      if t.dg /= null then
        index := t.dg'first + i - 1;
        temp := t.dg(index);
        if integer32(temp) < res
         then res := integer32(temp);
        end if;
        continue := true;
      end if;
    end Degree_Term;
    procedure Degree_Terms is new Visiting_Iterator(Degree_Term);

  begin
    Degree_Terms(p);
    return res;
  end Minimal_Degree;

  function Minimal_Degrees ( p : Poly ) return Degrees is

    res : Degrees;
    n : constant natural32 := Number_of_Unknowns(p);

    procedure Degree_Term ( t : in Term; cont : out boolean ) is

      index : integer32;
      temp : natural32;

    begin
      for i in t.dg'range loop
        index := t.dg'first + i - 1;
        temp := t.dg(index);
        if temp < res(i)
         then res(i) := temp;
        end if;
      end loop;
      cont := true;
    end Degree_Term;
    procedure Degree_Terms is new Visiting_Iterator(Degree_Term);

  begin
    res := new Standard_Natural_Vectors.Vector'
                 (1..integer32(n) => natural32(MAX_INT));
    Degree_Terms(p);
    return res;
  end Minimal_Degrees;

  function Equal ( d1,d2 : Degrees ) return boolean is
  begin
    if d1 = null then
      if d2 = null
       then return true;
       else return false;
      end if;
    else
      if d2 = null then
        return false;
      elsif d1'first /= d2'first then
        return false;
      elsif d1'last /= d2'last then
        return false;
      else
        for i in d1'range loop
          if d1(i) /= d2(i) then return false; end if;
        end loop;
      end if;
      return true;
    end if;
  end Equal;

  function "<" ( d1,d2 : Degrees ) return boolean is
  begin
    if d2 = null then
      return false;
    else
      if d1 = null then
        return (Standard_Natural_Vectors.Sum(d2.all) > 0);
      else
        declare
          s1 : constant natural32 := Standard_Natural_Vectors.Sum(d1.all);
          s2 : constant natural32 := Standard_Natural_Vectors.Sum(d2.all);
        begin
          if s1 < s2 then
            return true;
          elsif s1 > s2 then
            return false;
          else
            for i in d1'range loop
              exit when i > d2'last;
              if d1(i) < d2(i) then
                return true;
              elsif d1(i) > d2(i) then
                return false;
              end if;
            end loop;
            return false;
          end if;
        end;
      end if;
    end if;
   -- return Standard_Natural_Vectors.Link_to_Vector(d1)
   --        < Standard_Natural_Vectors.Link_to_Vector(d2);
  end "<";

  function ">" ( d1,d2 : Degrees ) return boolean is
  begin
    if d1 = null then
      return false;
    else
      if d2 = null then
        return (Standard_Natural_Vectors.Sum(d1.all) > 0);
      else
        declare
          s1 : constant natural32 := Standard_Natural_Vectors.Sum(d1.all);
          s2 : constant natural32 := Standard_Natural_Vectors.Sum(d2.all);
        begin
          if s1 > s2 then
            return true;
          elsif s1 < s2 then
            return false;
          else
            for i in d1'range loop
              exit when i > d2'last;
              if d1(i) > d2(i) then
                return true;
              elsif d1(i) < d2(i) then
                return false;
              end if;
            end loop;
            return false;
          end if;
        end;
      end if;
    end if;
   -- return Standard_Natural_Vectors.Link_to_Vector(d1)
   --        > Standard_Natural_Vectors.Link_to_Vector(d2);
  end ">";

  function Coeff ( p : Poly; d : degrees ) return number is

    l : Poly_Rep;
    t : term;
    res : number;

  begin 
    Copy(zero,res);
    if p /= Null_Poly then
      l := p.all;
      while not Is_Null(l) loop
        t := Head_Of(l);
        exit when (t.dg < d);
        if Equal(t.dg,d)
         then Copy(t.cf,res);
              exit;
         else l := Tail_Of(l);
        end if;
      end loop;
    end if;
    return res;
  end Coeff;

  function Head ( p : Poly ) return Term is

    res : Term;

  begin
    if p = Null_Poly
     then Copy(zero,res.cf);
     else res := Head_Of(p.all);
    end if;
    return res;
  end Head;

-- ARITHMETICAL OPERATIONS :
 
  function "+" ( p : Poly; t : Term ) return Poly is

    temp : Poly;

  begin
    Copy(p,temp);
    Add(temp,t);
    return temp;
  end "+";

  function "+" ( t : Term; p : Poly ) return Poly is
  begin
    return p+t;
  end "+";
 
  function "+" ( p,q : Poly ) return Poly is

    temp : Poly;

  begin
    Copy(p,temp);
    Add(temp,q);
    return temp;
  end "+";

  function "+" ( p : Poly ) return Poly is

    res : Poly;

  begin
    Copy(p,res);
    return res;
  end "+";
 
  function "-" ( p : Poly; t : Term ) return Poly is

    temp : Poly;

  begin
    Copy(p,temp);
    Sub(temp,t);
    return temp;
  end "-";
 
  function "-" ( t : Term; p : Poly ) return Poly is

    temp : Poly;

  begin
    temp := Create(t);
    Sub(temp,p);
    return temp;
  end "-";
   
  function "-" ( p : Poly ) return Poly is

    temp : Poly;

  begin
    Copy(p,temp);
    Min(temp);
    return temp;
  end "-";
 
  function "-" ( p,q : Poly ) return Poly is
 
    temp : Poly;

  begin
    Copy(p,temp);
    Sub(temp,q);
    return temp;
  end "-";
 
  function "*" ( p : Poly; a : number ) return Poly is

    temp : Poly;

  begin
    Copy(p,temp);
    Mul(temp,a);
    return temp;
  end "*";
 
  function "*" ( a : number; p : Poly ) return Poly is
  begin
    return p*a;
  end "*";
 
  function "*" ( p : Poly; t : Term ) return Poly is

    temp : Poly;

  begin
    Copy(p,temp);
    Mul(temp,t);
    return temp;
  end "*";
 
  function "*" ( t : Term; p : Poly ) return Poly is
  begin
    return p*t;
  end "*";
 
  function "*" ( p,q : Poly ) return Poly is

    temp : Poly;

  begin
    Copy(p,temp);
    Mul(temp,q);
    return temp;
  end "*";

  function "**" ( t : Term; k : natural32 ) return Term is

    res : Term;

  begin
    if k = 0 then
      res.dg := new Standard_Natural_Vectors.Vector'(t.dg'range => 0);
      copy(one,res.cf);
    elsif k = 1 then
      copy(t,res);
    elsif k > 1 then
      copy(t,res);
      for i in 2..k loop
        Mul(res.cf,t.cf);
      end loop;
      for i in res.dg'range loop
        res.dg(i) := k*t.dg(i);
      end loop;
    end if;
    return res;
  end "**";

  function "**" ( p : Poly; k : natural32 ) return Poly is

    t : Term;
    res : Poly;
    n : natural32;

  begin
    if k = 0 then
      copy(one,t.cf);
      n := Number_of_Unknowns(p);
      t.dg := new Standard_Natural_Vectors.Vector'(1..integer32(n) => 0);
      res := Create(t);
    elsif k > 1 then
      Copy(p,res);
      for i in 2..k loop
        Mul(res,p);
      end loop;
    end if;
    return res;
  end "**";
   
  procedure Add ( p : in out Poly; t : in Term ) is

    l1,l2,temp : Poly_Rep;
    tt,tp : Term;

  begin
    if t.cf /= zero then
      Copy(t,tt);
      if p = Null_Poly then
        p := new Poly_Rep;
        Construct(tt,p.all);
      else
        tp := Head_Of(p.all);
        if tt.dg > tp.dg then
          Construct(tt,p.all);
        elsif Equal(tt.dg,tp.dg) then
          Add(tp.cf,tt.cf);
          if tp.cf /= zero then
            Set_Head(p.all,tp);
          else
            Clear(tp);
            if Is_Null(Tail_Of(p.all))
             then Term_List.Clear(Term_List.List(p.all));
                  free(p); p := Null_Poly;
             else Swap_Tail(p.all,l1);
                  Term_List.Clear(Term_List.List(p.all));
                  p.all := l1;
            end if;
          end if;
          Clear(tt);
        else
          l1 := p.all;
          l2 := Tail_Of(l1);
          while not Is_Null(l2) loop
            tp := Head_Of(l2);
            if tt.dg > tp.dg then
              Construct(tt,temp);
              Swap_Tail(l1,temp);
              l1 := Tail_Of(l1);
              Swap_Tail(l1,temp);
              return;
            elsif Equal(tt.dg,tp.dg) then
              Add(tp.cf,tt.cf);
              if tp.cf /= zero then
                Set_Head(l2,tp); 
              else
                Clear(tp);
                temp := Tail_Of(l2);
                Swap_Tail(l1,temp);
              end if;
              Clear(tt);
              return;
            else
              l1 := l2;
              l2 := Tail_Of(l1);
            end if;
          end loop;
          Construct(tt,temp);
          Swap_Tail(l1,temp);
        end if;
      end if;
    end if;
  end Add;

  procedure Add ( p : in out Poly; q : in Poly ) is

    procedure Add ( t : in Term; continue : out boolean ) is
    begin
      Add(p,t);
      continue := true;
    end Add;
    procedure Adds is new Visiting_Iterator(Add);
 
  begin
    Adds(q);
  end Add;
 
  procedure Sub ( p : in out Poly; t : in Term ) is

    temp : Term;

  begin
    Standard_Natural_Vectors.Copy
      (Standard_Natural_Vectors.Link_to_Vector(t.dg),
       Standard_Natural_Vectors.Link_to_Vector(temp.dg));
    temp.cf := -t.cf;
    Add(p,temp);
    Standard_Natural_Vectors.Clear
      (Standard_Natural_Vectors.Link_to_Vector(temp.dg));
    Clear(temp.cf);
  end Sub;

  procedure Sub ( p : in out Poly; q : in Poly ) is

    temp : Poly := -q;

  begin
    Add(p,temp);
    Clear(temp);
  end Sub;
 
  procedure Min ( p : in out Poly ) is
 
    procedure Min ( t : in out Term; continue : out boolean ) is
    begin
      Min(t.cf);
      continue := true;
    end Min;
    procedure Min_Terms is new Changing_Iterator (process => Min);
 
  begin
    Min_Terms(p);
  end Min;
 
  procedure Mul ( p : in out Poly; a : in number ) is
 
    procedure Mul_Term ( t : in out Term; continue : out boolean ) is
    begin
      Mul(t.cf,a);
      continue := true;
    end Mul_Term;
    procedure Mul_Terms is new Changing_Iterator (process => Mul_Term);
 
  begin
    Mul_Terms(p);
  end Mul;

  procedure Mul ( p : in out Poly; t : in Term ) is

    procedure Mul ( tp : in out Term; continue : out boolean ) is
    begin
      Standard_Natural_Vectors.Add
        (Standard_Natural_Vectors.Link_to_Vector(tp.dg),
         Standard_Natural_Vectors.Link_to_Vector(t.dg));
      Mul(tp.cf,t.cf);
      continue := true;
    end Mul;
    procedure Mul_Terms is new Changing_Iterator (process => Mul);

  begin
    Mul_Terms(p);
  end Mul;
 
  procedure Mul ( p : in out Poly; q : in Poly ) is

    res : Poly;
    l : Poly_Rep;
    t : Term;

  begin
    if (q = Null_Poly) or else Is_Null(q.all) then
      Clear(p);
    else
      l := q.all;
      res := Null_Poly;
      while not Is_Null(l) loop
        t := Head_Of(l);
        declare
          temp : Poly;
        begin
          temp := p * t;
          Add(res,temp);
          Clear(temp);
        end;
        l := Tail_Of(l);
      end loop;
      Copy(res,p); Clear(res);
    end if;
  end Mul;

  procedure Pow ( t : in out Term; k : in natural32 ) is

    c : number;

  begin
    if k = 0 then
      copy(one,t.cf);
      for i in t.dg'range loop
        t.dg(i) := 0;
      end loop;
    elsif k > 1 then
      copy(t.cf,c);
      for i in 2..k loop
        Mul(c,t.cf);
      end loop;
      copy(c,t.cf); clear(c);
      for i in t.dg'range loop
        t.dg(i) := k*t.dg(i);
      end loop;
    end if;
  end Pow;

  procedure Pow ( p : in out Poly; k : in natural32 ) is

    t : Term;
    res : Poly;
    n : natural32;

  begin
    if k = 0 then
      copy(one,t.cf);
      n := Number_of_Unknowns(p);
      t.dg := new Standard_Natural_Vectors.Vector'(1..integer32(n) => 0);
      Clear(p);
      p := Create(t);
      Clear(t);
    elsif k > 1 then
      Copy(p,res);
      for i in 2..k loop
        Mul(res,p);
      end loop;
      Clear(p);
      p := res;
    end if;
  end Pow;
 
  procedure Diff ( p : in out Poly; i : in integer32 ) is

    procedure Diff_Term ( t : in out Term; continue : out boolean ) is

      temp : number;
      index : constant integer32 := t.dg'first + i - 1;

    begin
      if t.dg(index) = 0 then
        Clear(t);
        Copy(zero,t.cf);
      else
        temp := Create(integer(t.dg(index)));
        Mul(t.cf,temp);
        Clear(temp);
        t.dg(index) := t.dg(index) - 1;
      end if;
      continue := true;
    end Diff_Term;
    procedure Diff_Terms is new Changing_Iterator( process => Diff_Term );

  begin
    Diff_Terms(p);
  end Diff;

  function Diff ( p : Poly; i : integer32 ) return Poly is

    res : Poly;

  begin
    Copy(p,res);
    Diff(res,i);
    return res;
  end Diff;

-- ITERATORS :

  procedure Visiting_Iterator ( p : in Poly ) is

    l : Poly_Rep;
    temp : Term;
    continue : boolean;

  begin
    if p /= Null_Poly then
      l := p.all;
      while not Is_Null(l) loop 
        temp := Head_Of(l);
        process(temp,continue);
        exit when not continue;
        l := Tail_Of(l);
      end loop;
    end if;
  end Visiting_Iterator;

  procedure Changing_Iterator ( p : in out Poly ) is

    q,lq,lp : Poly_Rep;
    t : Term;
    continue : boolean := true;

    procedure Copy_append is

      temp : Term;

    begin
      Copy(t,temp);
      if continue
       then process(temp,continue);
      end if;
      if not Equal(temp.cf,zero)
       then Append(q,lq,temp);
       else Clear(temp);
      end if;
      Clear(t);
    end Copy_append;

  begin
    if p = Null_Poly
     then return;
     else lp := p.all;
          while not Is_Null(lp) loop
            t := Head_Of(lp);
            Copy_append;
            lp := Tail_Of(lp);
          end loop;
          Term_List.Clear(Term_List.List(p.all));  free(p);
          if Is_Null(q)
           then p := Null_Poly;
           else p := new Poly_Rep'(q);
          end if;
          Shuffle(p);  -- ensure the second representation invariant
    end if;
  end Changing_Iterator;

-- DESTRUCTORS :

  procedure Clear ( d : in out Degrees ) is
  begin
    Standard_Natural_Vectors.Clear(Standard_Natural_Vectors.Link_to_Vector(d));
  end Clear;

  procedure Clear ( t : in out Term ) is
  begin
    Clear(t.dg);
    Clear(t.cf);
  end Clear;
 
  procedure Clear ( p : in out Poly_Rep ) is

    l : Poly_Rep := p;
    t : Term;

  begin
    if not Is_Null(p) then
      while not Is_Null(l) loop
        t := Head_Of(l);
        Clear(t);
        l := Tail_Of(l);
      end loop;
      Term_List.Clear(Term_List.List(p));
    end if;
  end Clear;
 
  procedure Clear ( p : in out Poly ) is
  begin
    if p /= Null_Poly then
      Clear(p.all);
      free(p);
      p := Null_Poly;
    end if;
  end Clear;

end Generic_Polynomials;
