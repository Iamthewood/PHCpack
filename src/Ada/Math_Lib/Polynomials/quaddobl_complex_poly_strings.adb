with text_io;                            use text_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Natural_Vectors;
with Standard_Complex_Poly_Strings;
with Multprec_Complex_Polynomials;
with Multprec_Complex_Poly_Strings;
with QuadDobl_Polynomial_Convertors;     use QuadDobl_Polynomial_Convertors;

package body QuadDobl_Complex_Poly_Strings is

-- NOTE : The implementation is a wrapper to Multprec_Complex_Poly_Strings.

  size : constant natural32 := 10;

  procedure Parse ( s : in string; k : in out integer;
                    n : in natural32; p : in out Poly ) is

    q : Multprec_Complex_Polynomials.Poly;

  begin
    Multprec_Complex_Poly_Strings.Parse(s,k,n,size,q);
    p := Multprec_Polynomial_to_QuadDobl_Complex(q);
    Multprec_Complex_Polynomials.Clear(q);
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
        := Standard_Complex_Poly_Strings.Delimiters(n,s);

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
      declare
      begin
        res(integer32(i)) := Parse(m,s(i).all);
      exception
        when others => put("something is wrong with string ");
                       put(integer32(i),1);
                       new_line; put_line(s(i).all); raise;
      end;
    end loop;
    return res;
  end Parse;

  function Write ( p : Poly ) return string is

    q : Multprec_Complex_Polynomials.Poly
      := QuadDobl_Complex_to_Multprec_Polynomial(p);
    res : constant string := Multprec_Complex_Poly_Strings.Write(q);

  begin
    Multprec_Complex_Polynomials.Clear(q);
    return res;
  end Write;

  function Write ( p : Poly_Sys ) return string is
  begin
    if p'first = p'last
     then return Write(p(p'first));
     else return Write(p(p'first)) & Write(p(p'first+1..p'last));
    end if;
  end Write;

end QuadDobl_Complex_Poly_Strings;
