with text_io;                            use text_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Characters_and_Numbers;             use Characters_and_Numbers;
with Strings_and_Numbers;                use Strings_and_Numbers;
with Standard_Parse_Numbers;             use Standard_Parse_Numbers;
with Symbol_Table_io;
with Parse_Polynomial_Exceptions;        use Parse_Polynomial_Exceptions;

package body Standard_Complex_Poly_Strings is

-- STRING MANIPULATORS :

  procedure Read_Exponent
              ( s : in string; k : in out integer; e : out natural32 ) is

    exp : string(1..16);
    cnt : natural := 0;

  begin
    while Convert(s(k)) < 10 loop
      cnt := cnt+1;
      exp(cnt) := s(k);
      k := k+1;
    end loop;
    e := Convert(exp(1..cnt));
  end Read_Exponent;

  function Delimiters ( n : natural32; s : string )
                      return Standard_Natural_Vectors.Vector is

  -- DESCRIPTION :
  --   Searches the string s for n semicolons and returns the positions
  --   of those semicolons.

    res : Standard_Natural_Vectors.Vector(1..integer32(n));
    ind : integer32 := 1;

  begin
    for i in s'range loop
      if s(i) = ';' then
        res(ind) := natural32(i);
        ind := ind+1;
      end if;
    end loop;
    return res;
  end Delimiters;

  function Concat_Symbol0 ( s : string; sb : Symbol ) return string is

    nb : natural := 0;

  begin
    for i in sb'range loop
      if sb(i) = ' '
       then nb := i-1; exit;
      end if;
    end loop;
    declare
      res : string(1..s'last+nb);
    begin
      res(s'range) := s;
      for i in 1..nb loop
        res(s'last+i) := sb(i);
      end loop;
      return res;
    end;
  end Concat_Symbol0;

  function Concat_Symbol1 ( s : string; sb : Symbol ) return string is

    nb : natural := 0;

  begin
    for i in sb'range loop
      if sb(i) = ' '
       then nb := i-1; exit;
      end if;
    end loop;
    declare
      res : string(1..s'last+1+nb);
    begin
      res(s'range) := s;
      res(s'last+1) := '*';
      for i in 1..nb loop
        res(s'last+1+i) := sb(i);
      end loop;
      return res;
    end;
  end Concat_Symbol1;

-- AUXILIARIES FOR INPUT PARSING OPERATORS :

  procedure Parse_Term
              ( s : in string; bc : in out integer32; p : in out integer;
                n : in natural32; termp : in out Poly );

  -- DESCRIPTION :
  --   Parses the string for a term, starting at s(p).

  -- ON ENTRY :
  --   s        string of characters to contain a polynomial;
  --   bc       counts #open - #closed brackets;
  --   p        current position in the string s;
  --   n        number of variables;
  --   termp    accumulating polynomial for the term.

  -- ON RETURN :
  --   bc       updated bracket counter;
  --   p        updated position in the string;
  --   termp    resulting term read from string.

  procedure Parse_Factor
              ( s : in string; bc : in out integer32; p : in out integer;
                n : in natural32; d : in out Degrees; pb : in out Poly );

  -- DESCRIPTION :
  --   Parses the string s for a factor, starting at s(p).

  -- ON ENTRY :
  --   s        string of characters to contain a polynomial;
  --   bc       counts #open - #closed brackets;
  --   p        current position in the string s;
  --   n        number of variables;
  --   d        current degrees of the factor;
  --   pb       accumulating polynomial for the factor.

  -- ON RETURN :
  --   bc       updated bracket counter;
  --   p        updated position in the string;
  --   pb       resulting factor read from string.

  procedure Parse_Power_Factor
              ( s : in string; k : in out integer; p : in out Poly ) is

  -- DESCRIPTION :
  --   Reads the exponent of a factor stored in s and returns
  --   in p the polynomial p raised to the read exponent.

  -- ON ENTRY :
  --   s        string to contain a polynomial
  --   k        s(k) equals the exponentiation symbol '^';
  --   p        current factor.

  -- ON RETURN :
  --   k        updated position in the string;
  --   p        p raised to the read exponent.
 
    d : natural32 := 0;
    bracket : boolean := false;

  begin
    k := k + 1;                -- skip the '^'
    if s(k) = '('
     then k := k + 1; bracket := true;
    end if;
    Read_Exponent(s,k,d);
    if bracket then
      Skip_Spaces_and_CR(s,k);
      if s(k) = ')'
       then k := k + 1;        -- skip closing bracket
       else raise BAD_BRACKET; -- no closing bracket found
      end if;
    end if;
    Pow(p,d);
    Skip_Spaces_and_CR(s,k);   -- skip last digit of exponent 
  exception
    when others => put("exception raised at character ");
                   put(integer32(k),1);
                   put_line(" of " & s); raise;
  end Parse_Power_Factor;

  procedure Parse_Polynomial
              ( s : in string; bc : in out integer32; k : in out integer;
                n : in natural32; p : in out Poly ) is

  -- DESCRIPTION :
  --   Main parsing routine for a polynomial from a string,
  --   keeps track of the bracket count in bc.

    oper : character;
    term,res,acc : Poly := Null_Poly;

  begin
    oper := '+';
    Skip_Spaces_and_CR(s,k);
    if s(k) = '-'
     then oper := '-';
    end if;                         -- the first term can have no sign
    Parse_Term(s,bc,k,n,res);       -- therefore read it first
    loop
      case s(k) is
        when ' ' | ASCII.CR | ASCII.LF => k := k + 1;   -- skip blanks
        when '+' | '-' =>
          oper := s(k);
          Parse_Term(s,bc,k,n,term);
          Add(res,term); Clear(term);
        when delimiter => 
          if bc /= 0
           then raise BAD_BRACKET;
          end if;
          exit;
        when '(' =>
          bc := bc + 1;
          k := k + 1;
          Parse_Polynomial(s(k..s'last),bc,k,n,term);
          Skip_Spaces_and_CR(s,k);
          if s(k) = '(' -- or s(k) = ')'
           then raise BAD_BRACKET;
          end if;
          if s(k) = '^'
           then Parse_Power_Factor(s,k,term);
          end if;
          case oper is
            when '+' => Add(acc,res); Clear(res); Copy(term,res);
            when '-' => Add(acc,res); Clear(res); Copy(term,res); Min(res);
            when '*' => Mul(res,term);
            when others => raise ILLEGAL_OPERATION;
          end case;
          Clear(term);
        when ')' =>
          bc := bc - 1;
          k := k + 1;
          if bc < 0
           then raise BAD_BRACKET;
          end if;
          exit;
        when '*' =>
          if res = Null_Poly then
            raise ILLEGAL_CHARACTER;
          else -- the case " ) * " :
            oper := s(k); k := k + 1;  -- skip '*'
            Parse_Term(s,bc,k,n,term);
            Skip_Spaces_and_CR(s,k);
            if s(k) = '^'
             then Parse_Power_Factor(s,k,term);
            end if;
            if s(k) /= '(' then
              case oper is
                when '+' => Add(res,term);
                when '-' => Sub(res,term);
                when '*' => Mul(res,term);
                when others => raise ILLEGAL_OPERATION;
              end case;
            end if;
            Clear(term);
          end if;
        when '^' =>
          if res = Null_Poly
           then raise ILLEGAL_CHARACTER;
           else Parse_Power_Factor(s,k,res);
          end if;
        when others => raise ILLEGAL_CHARACTER;
      end case;
    end loop;
    p := acc + res;
    Clear(acc); Clear(res);
  exception
    when others => put("exception raised at character ");
                   put(integer32(k),1);
                   put_line(" of " & s); raise;
  end Parse_Polynomial;

  procedure Parse_Factor
              ( s : in string; bc : in out integer32; p : in out integer;
                n : in natural32; d : in out Degrees; pb : in out Poly ) is

    sb : symbol;
    expo : natural32;
    k : integer32;
 
  begin
    Skip_Spaces_and_CR(s,p);
    if s(p) = '(' then 
      bc := bc + 1;
      p := p + 1;        -- get a new symbol, skip '('
      Parse_Polynomial(s(p..s'last),bc,p,n,pb);
      Skip_Spaces_and_CR(s,p);
      if s(p) = '^'
       then Parse_Power_Factor(s,p,pb);
      end if;
      return;
    end if;
    Symbol_Table_io.Parse_Symbol(s,p,sb);
    k := integer32(Symbol_Table.Check_Symbol(n,sb));
    Skip_Spaces_and_CR(s,p);
    if s(p) = '^' then
      p := p + 1;                               -- skip the '^'
      Read_Exponent(s,p,expo);
      d(k) := d(k) + expo;
      Skip_Spaces_and_CR(s,p);
      if s(p) /= '*'                            -- the case x^2*...
       then return;                             -- end of factor
       else p := p + 1;                         -- skip the '*'
      end if; 
    elsif s(p) = '*' then
      p := p + 1;
      if s(p) = '*' then
        p := p + 1;                             -- the case " x ** expo "
        Read_Exponent(s,p,expo);
        d(k) := d(k) + expo;
        Skip_Spaces_and_CR(s,p);
        if s(p) /= '*'
         then return;                   -- end of factor
         else p := p + 1;               -- skip the '*'
        end if;
      else
        d(k) := d(k) + 1;               -- the case " x * ? "
      end if;
    else -- the case " x ?", with ? /= '*' or ' ' or '^' :
      d(k) := d(k) + 1;
      return;
    end if;
    Skip_Spaces_and_CR(s,p);
    if (s(p) = '-') or (s(p) = '+') 
     then return;
    end if;
    if Convert(s(p)) < 10
     then Parse_Term(s,bc,p,n,pb); -- the case " x * c " or " x ** c * c "
     else Parse_Factor(s,bc,p,n,d,pb); -- the case " x * y " 
    end if;
  exception
    when others => put("exception raised at character ");
                   put(integer32(p),1);
                   put_line(" of " & s); raise;
  end Parse_Factor;
 
  procedure Parse_Term ( s : in string; bc : in out integer32;
                         p : in out integer;
                         n : in natural32; termp : in out Poly ) is

    c : Complex_Number := Create(0.0);
    d : Degrees := new Standard_Natural_Vectors.Vector'(1..integer32(n) => 0);
    pb,res : Poly := Null_Poly;
    tmp : Term;

    procedure Collect_Factor_Polynomial is
    begin
      if pb /= Null_Poly then
        if res = Null_Poly
         then Copy(pb,res); Clear(pb);
         else Mul(res,pb); Clear(pb);
        end if;
      end if;
    end Collect_Factor_Polynomial;

  begin
    Parse(s,p,c); -- look for 'i' :
    Skip_Spaces_and_CR(s,p);
    if ( c = Create(0.0) ) and then ((s(p) = 'i') or (s(p) = 'I')) then
      -- the case "+ i" :
      c := Create(0.0,1.0); 
      p := p + 1;        -- skip 'i'
    elsif ( c = Create(-1.0) ) and then ((s(p) = 'i') or (s(p) = 'I')) then
      -- the case "- i" :
      c := Create(0.0,-1.0);
      p := p + 1;      -- skip 'i'
    elsif s(p) = '*' then -- the case ".. c *.." :
      Skip_Spaces_and_CR(s,p);
      p := p + 1;  -- skip '*'
      Skip_Spaces_and_CR(s,p);
      if (s(p) = 'i') or (s(p) = 'I') then -- the case ".. c * i.." :
        c := Create(0.0,REAL_PART(c));
        p := p + 1;    -- skip 'i'
      else                                 -- the case ".. c * x.." :
        Parse_Factor(s,bc,p,n,d,pb);
        if pb /= Null_Poly
         then Clear(res); Copy(pb,res); Clear(pb);
        end if;
      end if;
    end if; -- the case ".. c ?"  will be treated in the loop
    loop
      case s(p) is
        when ' ' | ASCII.CR | ASCII.LF => p := p + 1;
        when '*' =>
          p := p + 1;
          Parse_Factor(s,bc,p,n,d,pb);
          Collect_Factor_Polynomial;
        when '+' | '-' => 
          if c = Create(0.0)
           then raise ILLEGAL_CHARACTER;
           else exit;
          end if;
        when delimiter =>
          if bc /= 0
           then raise BAD_BRACKET;
          end if;
          exit;
        when '(' => 
          if c = Create(0.0) or else c = Create(-1.0)
           then c := Create(0.0); exit; -- the case "+ (" or "- (" :
           else raise BAD_BRACKET;      -- the case "c  (" :
          end if;
        when ')' =>
          if bc < 0
           then raise BAD_BRACKET;
          end if;
          exit;
        when others  =>
          if c = Create(0.0) then
            c := Create(1.0);
            Parse_Factor(s,bc,p,n,d,pb);
          elsif c = Create(-1.0) then
            Parse_Factor(s,bc,p,n,d,pb);
          elsif s(p) = '^' then
            Parse_Power_Factor(s,p,res);
          else
            raise ILLEGAL_CHARACTER;
          end if;
          Collect_Factor_Polynomial;
      end case;
    end loop;
    tmp.cf := c;
    tmp.dg := d;
    termp := create(tmp);
    Clear(tmp);
    if Number_Of_Unknowns(res) > 0
     then Mul(termp,res); Clear(res);
    end if;
  exception
    when others => put("exception raised at character ");
                   put(integer32(p),1);
                   put_line(" of " & s); raise;
  end Parse_Term;

-- AUXILIARIES FOR OUTPUT :

  function Write ( t : Term; lead : boolean ) return string is

  -- DESCRIPTION :
  --   Returns the string representation of the term.
  --   When the term is the leading term of the polynomial,
  --   then lead is true.

    function Rec_Write ( k : integer32; accu : string; first : boolean )
                       return string is
    begin
      if k > t.dg'last then
        return accu;
      elsif t.dg(k) = 0 then
        return Rec_Write(k+1,accu,first);
      else
        declare
          sb : constant Symbol := Symbol_Table.Get(natural32(k));
        begin
          if t.dg(k) > 1 then
            if first then
              declare
                new_accu : constant string
                         := Concat_Symbol0(accu,sb)
                            & '^' & Convert(integer32(t.dg(k)));
              begin
                return Rec_Write(k+1,new_accu,false);
              end;
            else
              declare
                new_accu : constant string
                         := Concat_Symbol1(accu,sb)
                             & '^' & Convert(integer32(t.dg(k)));
              begin
                return Rec_Write(k+1,new_accu,first);
              end;
            end if;
          elsif first then
            declare
              new_accu : constant string := Concat_Symbol0(accu,sb);
            begin
              return Rec_Write(k+1,new_accu,false);
            end;
          else
            declare
              new_accu : constant string := Concat_Symbol1(accu,sb);
            begin
              return Rec_Write(k+1,new_accu,first);
            end;
          end if;
        end;
      end if;
    end Rec_Write;
 
  begin
    declare
      factor : constant string := Rec_Write(1,"",true);
    begin
      if factor = "" then   -- then we have constant term
        if lead
         then return Unsigned_Constant(t.cf);
         else return Signed_Constant(t.cf);
        end if;
      elsif lead then
        if Is_Unit(t.cf) then
          if Sign(t.cf) = +1
           then return factor;
           else return " - " & factor;
          end if;
        else
          return Unsigned_Coefficient(t.cf) & "*" & factor;
        end if;
      elsif Is_Unit(t.cf) then
        if Sign(t.cf) = +1
         then return " + " & factor;
         else return " - " & factor;
        end if;
      else
        return Signed_Coefficient(t.cf) & "*" & factor;
      end if;
    end;
  end Write;

  function Write ( p : Poly_Sys ) return string is
  begin
    if p'first = p'last
     then return Write(p(p'first));
     else return Write(p(p'first)) & Write(p(p'first+1..p'last));
    end if;
  end Write;

-- TARGET FUNCTIONS for PARSE OPERATORS :

  procedure Parse ( s : in string; k : in out integer;
                    n : in natural32; p : in out Poly ) is

    bc : integer32 := 0;

  begin
    Parse_Polynomial(s,bc,k,n,p);
  end Parse;

  function Parse ( n : natural32; s : string ) return Poly is

    res : Poly;
    p : integer := s'first;

  begin
    Parse(s,p,n,res);
    return res;
  end Parse;

  function Parse ( n,m : natural32; s : string ) return Poly_Sys is

    res : Poly_Sys(1..integer32(n));
    ind : constant Standard_Natural_Vectors.Vector(1..integer32(n))
        := Delimiters(n,s);

  begin
    res(1) := Parse(m,s(s'first..integer(ind(1))));
    for i in 2..integer32(n) loop
      res(i) := Parse(m,s(integer(ind(i-1)+1)..integer(ind(i))));
    end loop;
    return res;
  end Parse;

  function Parse ( m : natural32; s : Array_of_Strings ) return Poly_Sys is

    res : Poly_Sys(integer32(s'first)..integer32(s'last));
 
  begin
    for i in s'range loop
      res(integer32(i)) := Parse(m,s(i).all);
    end loop;
    return res;
  end Parse;

  function Write ( p : Poly ) return string is

    nb : constant natural32 := Number_of_Terms(p);
    terms : array(1..nb) of Term;
    ind : natural32 := 0;

    procedure Store_Term ( t : in Term; continue : out boolean ) is
    begin
      ind := ind + 1;
      terms(ind) := t;
      continue := true;
    end Store_Term;
    procedure Store_Terms is new Visiting_Iterator(Store_Term);
 
    function Write_Terms ( k : natural32; accu : string ) return string is
    begin
      if k > nb then
        return accu;
      elsif k = 1 then
        declare
          new_accu : constant string := accu & Write(terms(k),true);
        begin
          return Write_Terms(k+1,new_accu);
        end;
      else
        declare
          new_accu : constant string := accu & Write(terms(k),false);
        begin
          return Write_Terms(k+1,new_accu);
        end;
      end if;
    end Write_Terms;

  begin
    Store_Terms(p);
    return Write_Terms(1,"") & ";";
  end Write;

end Standard_Complex_Poly_Strings;
