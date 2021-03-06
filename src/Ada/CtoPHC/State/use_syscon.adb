with text_io;                           use text_io;
with Interfaces.C;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Natural_Vectors;
with Standard_Integer_Vectors;
with Standard_Complex_Polynomials;
with Standard_Complex_Poly_Strings;
with Standard_Complex_Laurentials;
with Standard_Complex_Laur_Strings;
with Standard_Complex_Poly_Systems;
with Standard_Complex_Laur_Systems;     use Standard_Complex_Laur_Systems;
with Symbol_Table;
with Standard_Complex_Poly_Systems_io;  use Standard_Complex_Poly_Systems_io;
with Standard_Complex_Laur_Systems_io;  use Standard_Complex_Laur_Systems_io;
with DoblDobl_Complex_Polynomials;
with DoblDobl_Complex_Poly_Strings;
with DoblDobl_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems_io;  use DoblDobl_Complex_Poly_Systems_io;
with QuadDobl_Complex_Polynomials;
with QuadDobl_Complex_Poly_Strings;
with QuadDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems_io;  use QuadDobl_Complex_Poly_Systems_io;
with Multprec_Floating_Numbers;
with Multprec_Complex_Polynomials;
with Multprec_Complex_Polynomials_io;
with Multprec_Complex_Poly_Strings;
with Multprec_Complex_Poly_Systems;
with Multprec_Complex_Poly_Systems_io;  use Multprec_Complex_Poly_Systems_io;
with Polynomial_Drops;
with Total_Degree_Start_Systems;
with PHCpack_Operations;
with Standard_PolySys_Container;
with DoblDobl_PolySys_Container;
with QuadDobl_PolySys_Container;
with Multprec_PolySys_Container;
with Laurent_Systems_Container;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;

function use_syscon ( job : integer32;
                      a : C_intarrs.Pointer;
		      b : C_intarrs.Pointer;
                      c : C_dblarrs.Pointer ) return integer32 is

  function Job0 return integer32 is -- read system into container

    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    new_line;
    put_line("Reading a polynomial system...");
    get(lp);
    Standard_PolySys_Container.Initialize(lp.all);
    return 0;
  end Job0;

  function Job100 return integer32 is -- read Laurent system into container

    lp : Standard_Complex_Laur_Systems.Link_to_Laur_Sys;

  begin
    new_line;
    put_line("Reading a polynomial system...");
    get(lp);
    Laurent_Systems_Container.Initialize(lp.all);
    return 0;
  end Job100;

  function Job200 return integer32 is -- read dobldobl system into container

    lp : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    new_line;
    put_line("Reading a polynomial system...");
    get(lp);
    DoblDobl_PolySys_Container.Initialize(lp.all);
    return 0;
  end Job200;

  function Job210 return integer32 is -- read quaddobl system into container

    lp : QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    new_line;
    put_line("Reading a polynomial system...");
    get(lp);
    QuadDobl_PolySys_Container.Initialize(lp.all);
    return 0;
  end Job210;

  function Job220 return integer32 is -- read multprec system into container

    lp : Multprec_Complex_Poly_Systems.Link_to_Poly_Sys;
    v : constant C_Integer_Array := C_intarrs.Value(a);
    deci : constant natural32 := natural32(v(v'first));
    size : constant natural32
         := Multprec_Floating_Numbers.Decimal_to_Size(deci);

  begin
    Multprec_Complex_Polynomials_io.Set_Working_Precision(size);
    new_line;
    put_line("Reading a polynomial system...");
    get(lp);
    Multprec_PolySys_Container.Initialize(lp.all);
    return 0;
  end Job220;

  function Job1 return integer32 is -- write system in container
 
    use Standard_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := Standard_PolySys_Container.Retrieve;

  begin
    if lp /= null then
      if PHCpack_Operations.file_okay
       then put(PHCpack_Operations.output_file,natural32(lp'last),lp.all);
       else put(standard_output,natural32(lp'last),lp.all);
      end if;
    end if;
    return 0;
  end Job1;

  function Job101 return integer32 is -- write system in container
 
    lp : constant Link_to_Laur_Sys := Laurent_Systems_Container.Retrieve;

  begin
    if lp /= null then
      if PHCpack_Operations.file_okay
       then put(PHCpack_Operations.output_file,natural32(lp'last),lp.all);
       else put(standard_output,natural32(lp'last),lp.all);
      end if;
    end if;
    return 0;
  end Job101;

  function Job201 return integer32 is -- write system in container
 
    use DoblDobl_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := DoblDobl_PolySys_Container.Retrieve;

  begin
    if lp /= null then
      if PHCpack_Operations.file_okay
      -- then put(PHCpack_Operations.output_file,lp'last,lp.all);
       then put(PHCpack_Operations.output_file,lp.all);
      -- else put(standard_output,lp'last,lp.all);
       else put(standard_output,lp.all);
      end if;
    end if;
    return 0;
  end Job201;

  function Job211 return integer32 is -- write system in container
 
    use QuadDobl_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := QuadDobl_PolySys_Container.Retrieve;

  begin
    if lp /= null then
      if PHCpack_Operations.file_okay
      -- then put(PHCpack_Operations.output_file,lp'last,lp.all);
       then put(PHCpack_Operations.output_file,lp.all);
      -- else put(standard_output,lp'last,lp.all);
       else put(standard_output,lp.all);
      end if;
    end if;
    return 0;
  end Job211;

  function Job221 return integer32 is -- write system in container
 
    use Multprec_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := Multprec_PolySys_Container.Retrieve;

  begin
    if lp /= null then
      if PHCpack_Operations.file_okay
      -- then put(PHCpack_Operations.output_file,lp'last,lp.all);
       then put(PHCpack_Operations.output_file,lp.all);
      -- else put(standard_output,lp'last,lp.all);
       else put(standard_output,lp.all);
      end if;
    end if;
    return 0;
  end Job221;

  function Job2 return integer32 is -- return dimension of system
  begin
    Assign(integer32(Standard_PolySys_Container.Dimension),a);
    return 0;
  end Job2;

  function Job102 return integer32 is -- return dimension of Laurent system
  begin
    Assign(integer32(Laurent_Systems_Container.Dimension),a);
    return 0;
  end Job102;

  function Job202 return integer32 is -- return dimension of system
  begin
    Assign(integer32(DoblDobl_PolySys_Container.Dimension),a);
    return 0;
  end Job202;

  function Job212 return integer32 is -- return dimension of system
  begin
    Assign(integer32(QuadDobl_PolySys_Container.Dimension),a);
    return 0;
  end Job212;

  function Job222 return integer32 is -- return dimension of system
  begin
    Assign(integer32(Multprec_PolySys_Container.Dimension),a);
    return 0;
  end Job222;

  function Job3 return integer32 is -- initialize container with dimension

    v : constant C_Integer_Array := C_intarrs.Value(a);
    n : constant integer32 := integer32(v(v'first));

  begin
    Standard_PolySys_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  end Job3;

  function Job103 return integer32 is -- initialize container with dimension

    v : constant C_Integer_Array := C_intarrs.Value(a);
    n : constant integer32 := integer32(v(v'first));

  begin
    Laurent_Systems_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  end Job103;

  function Job203 return integer32 is -- initialize container with dimension

    v : constant C_Integer_Array := C_intarrs.Value(a);
    n : constant integer32 := integer32(v(v'first));

  begin
    DoblDobl_PolySys_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  end Job203;

  function Job213 return integer32 is -- initialize container with dimension

    v : constant C_Integer_Array := C_intarrs.Value(a);
    n : constant integer32 := integer32(v(v'first));

  begin
    QuadDobl_PolySys_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  end Job213;

  function Job223 return integer32 is -- initialize container with dimension

    v : constant C_Integer_Array := C_intarrs.Value(a);
    n : constant integer32 := integer32(v(v'first));

  begin
    Multprec_PolySys_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  end Job223;

  function Job4 return integer32 is -- returns #terms of a polynomial

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    use Interfaces.C;
    i : constant integer32 := integer32(v(v'first+1));

  begin
    Assign(integer32(Standard_PolySys_Container.Number_of_Terms(i)),a);
    return 0;
  end Job4;

  function Job104 return integer32 is -- returns #terms of a Laurential

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    use Interfaces.C;
    i : constant integer32 := integer32(v(v'first+1));

  begin
    Assign(integer32(Laurent_Systems_Container.Number_of_Terms(i)),a);
    return 0;
  end Job104;

  function Job204 return integer32 is -- returns #terms of a polynomial

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    use Interfaces.C;
    i : constant integer32 := integer32(v(v'first+1));

  begin
    Assign(integer32(DoblDobl_PolySys_Container.Number_of_Terms(i)),a);
    return 0;
  end Job204;

  function Job214 return integer32 is -- returns #terms of a polynomial

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    use Interfaces.C;
    i : constant integer32 := integer32(v(v'first+1));

  begin
    Assign(integer32(QuadDobl_PolySys_Container.Number_of_Terms(i)),a);
    return 0;
  end Job214;

  function Job224 return integer32 is -- returns #terms of a polynomial

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    use Interfaces.C;
    i : constant integer32 := integer32(v(v'first+1));

  begin
    Assign(integer32(Multprec_PolySys_Container.Number_of_Terms(i)),a);
    return 0;
  end Job224;

  function Job5 return integer32 is -- returns a term of a polynomial

    v : constant C_Integer_Array(0..2)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    i : constant integer32 := integer32(v(1));
    j : constant natural32 := natural32(v(2));
    t : constant Standard_Complex_Polynomials.Term
      := Standard_PolySys_Container.Retrieve_Term(i,j);

  begin
    Assign(t.cf,c);
    Assign(t.dg.all,b);
    return 0;
  end Job5;

  function Job105 return integer32 is -- returns a term of a polynomial

    v : constant C_Integer_Array(0..2)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    i : constant integer32 := integer32(v(1));
    j : constant natural32 := natural32(v(2));
    t : constant Standard_Complex_Laurentials.Term 
      := Laurent_Systems_Container.Retrieve_Term(i,j);

  begin
    Assign(t.cf,c);
    Assign(t.dg.all,b);
    return 0;
  end Job105;

  function Job205 return integer32 is -- returns a term of a polynomial

    v : constant C_Integer_Array(0..2)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    i : constant integer32 := integer32(v(1));
    j : constant natural32 := natural32(v(2));
    t : constant DoblDobl_Complex_Polynomials.Term
      := DoblDobl_PolySys_Container.Retrieve_Term(i,j);

  begin
    Assign(t.cf,c);
    Assign(t.dg.all,b);
    return 0;
  end Job205;

  function Job215 return integer32 is -- returns a term of a polynomial

    v : constant C_Integer_Array(0..2)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    i : constant integer32 := integer32(v(1));
    j : constant natural32 := natural32(v(2));
    t : constant QuadDobl_Complex_Polynomials.Term
      := QuadDobl_PolySys_Container.Retrieve_Term(i,j);

  begin
    Assign(t.cf,c);
    Assign(t.dg.all,b);
    return 0;
  end Job215;

  function Job6 return integer32 is -- add a term to a polynomial

    v : constant C_Integer_Array(0..1)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    n : constant integer32 := integer32(v(0));
    i : constant integer32 := integer32(v(1));
    e : Standard_Natural_Vectors.Vector(1..n);
    t : Standard_Complex_Polynomials.Term;

  begin
    Assign(c,t.cf);
    Assign(natural32(n),b,e);
    t.dg := new Standard_Natural_Vectors.Vector'(e);
    Standard_PolySys_Container.Add_Term(i,t);
    return 0;
  end Job6;

  function Job106 return integer32 is -- add a term to a polynomial

    v : constant C_Integer_Array(0..1)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    n : constant integer32 := integer32(v(0));
    i : constant integer32 := integer32(v(1));
    e : Standard_Integer_Vectors.Vector(1..n);
    t : Standard_Complex_Laurentials.Term;

  begin
    Assign(c,t.cf);
    Assign(natural32(n),b,e);
    t.dg := new Standard_Integer_Vectors.Vector'(e);
    Laurent_Systems_Container.Add_Term(i,t);
    return 0;
  end Job106;

  function Job206 return integer32 is -- add a term to a polynomial

    v : constant C_Integer_Array(0..1)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    n : constant integer32 := integer32(v(0));
    i : constant integer32 := integer32(v(1));
    e : Standard_Natural_Vectors.Vector(1..n);
    t : DoblDobl_Complex_Polynomials.Term;

  begin
    Assign(c,t.cf);
    Assign(natural32(n),b,e);
    t.dg := new Standard_Natural_Vectors.Vector'(e);
    DoblDobl_PolySys_Container.Add_Term(i,t);
    return 0;
  end Job206;

  function Job216 return integer32 is -- add a term to a polynomial

    v : constant C_Integer_Array(0..1)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    n : constant integer32 := integer32(v(0));
    i : constant integer32 := integer32(v(1));
    e : Standard_Natural_Vectors.Vector(1..n);
    t : QuadDobl_Complex_Polynomials.Term;

  begin
    Assign(c,t.cf);
    Assign(natural32(n),b,e);
    t.dg := new Standard_Natural_Vectors.Vector'(e);
    QuadDobl_PolySys_Container.Add_Term(i,t);
    return 0;
  end Job216;

  function Job7 return integer32 is -- clears the container
  begin
    Standard_PolySys_Container.Clear;
    return 0;
  end Job7;

  function Job107 return integer32 is -- clears the container
  begin
    Laurent_Systems_Container.Clear;
    return 0;
  end Job107;

  function Job207 return integer32 is -- clears the container
  begin
    DoblDobl_PolySys_Container.Clear;
    return 0;
  end Job207;

  function Job217 return integer32 is -- clears the container
  begin
    QuadDobl_PolySys_Container.Clear;
    return 0;
  end Job217;

  function Job227 return integer32 is -- clears the container
  begin
    Multprec_PolySys_Container.Clear;
    return 0;
  end Job227;

  function Job8 return integer32 is -- returns total degree

    use Standard_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := Standard_PolySys_Container.Retrieve;
    td : natural32;

    use Total_Degree_Start_Systems;

  begin
    if lp = null then
      return 1;
    else
      td := Product(Total_Degree_Start_Systems.Degrees(lp.all));
      Assign(integer32(td),a);
    end if;
    return 0;
  end Job8;

  function Job9 return integer32 is -- clears the symbol table
  begin
    Symbol_Table.clear;
    return 0;
  end Job9;

  function Job10 return integer32 is -- creates an evaluator

    use Standard_Complex_Poly_Systems;

  begin
    if Standard_PolySys_Container.Retrieve = null then
      return 10;
    else
      Standard_PolySys_Container.Create_Evaluator;
      return 0;
    end if;
  end Job10;

  function Job11 return integer32 is -- creates a Jacobian matrix evaluator

    use Standard_Complex_Poly_Systems;

  begin
    if Standard_PolySys_Container.Retrieve = null then
      return 11;
    else
      Standard_PolySys_Container.Create_Jacobian_Evaluator;
      return 0;
    end if;
  end Job11;

  function Job67 return integer32 is -- polynomial as string from container

    use Standard_Complex_Poly_Systems;
    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    p : constant Standard_Complex_Polynomials.Poly
      := Standard_PolySys_Container.Retrieve_Poly(equ);
    s : constant string := Standard_Complex_Poly_Strings.Write(p);
    sv : constant Standard_Integer_Vectors.Vector
       := String_to_Integer_Vector(s);
    slast : constant integer32 := integer32(s'last);

  begin
   -- put("Polynomial "); put(equ,1); put(" : "); put_line(s);
   -- put("#characters : "); put(s'last,1); new_line;
    Assign(slast,a);
    Assign(sv,b);
    return 0;
  exception
    when others => return 67;
  end Job67;

  function Job68 return integer32 is -- poly as string from dobldobl container

    use DoblDobl_Complex_Poly_Systems;
    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    p : constant DoblDobl_Complex_Polynomials.Poly
      := DoblDobl_PolySys_Container.Retrieve_Poly(equ);
    s : constant string := DoblDobl_Complex_Poly_Strings.Write(p);
    sv : constant Standard_Integer_Vectors.Vector
       := String_to_Integer_Vector(s);
    slast : constant integer32 := integer32(s'last);

  begin
   -- put("Polynomial "); put(equ,1); put(" : "); put_line(s);
   -- put("#characters : "); put(s'last,1); new_line;
    Assign(slast,a);
    Assign(sv,b);
    return 0;
  exception
    when others => return 68;
  end Job68;

  function Job69 return integer32 is -- poly as string from quaddobl container

    use QuadDobl_Complex_Poly_Systems;
    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    p : constant QuadDobl_Complex_Polynomials.Poly
      := QuadDobl_PolySys_Container.Retrieve_Poly(equ);
    s : constant string := QuadDobl_Complex_Poly_Strings.Write(p);
    sv : constant Standard_Integer_Vectors.Vector
       := String_to_Integer_Vector(s);
    slast : constant integer32 := integer32(s'last);

  begin
   -- put("Polynomial "); put(equ,1); put(" : "); put_line(s);
   -- put("#characters : "); put(s'last,1); new_line;
    Assign(slast,a);
    Assign(sv,b);
    return 0;
  exception
    when others => return 69;
  end Job69;

  function Job70 return integer32 is -- poly as string from multprec container

    use Multprec_Complex_Poly_Systems;
    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    p : constant Multprec_Complex_Polynomials.Poly
      := Multprec_PolySys_Container.Retrieve_Poly(equ);
    s : constant string := Multprec_Complex_Poly_Strings.Write(p);
    sv : constant Standard_Integer_Vectors.Vector
       := String_to_Integer_Vector(s);
    slast : constant integer32 := integer32(s'last);

  begin
   -- put("Polynomial "); put(equ,1); put(" : "); put_line(s);
   -- put("#characters : "); put(s'last,1); new_line;
    Assign(slast,a);
    Assign(sv,b);
    return 0;
  exception
    when others => return 70;
  end Job70;

  function Job74 return integer32 is -- Laurential as string to container

    use Interfaces.C;

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    nc : constant integer := integer(v_a(v_a'first));
    n : constant natural32 := natural32(v_a(v_a'first+1));
    k : constant integer32 := integer32(v_a(v_a'first+2));
    nc1 : constant Interfaces.C.size_t := Interfaces.C.size_t(nc-1);
    v_b : constant C_Integer_Array(0..nc1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc));
    s : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),v_b);
    p : Standard_Complex_Laurentials.Poly;

  begin
   -- put("Polynomial "); put(k,1);
   -- put(" given as string of "); put(integer32(nc),1);
   -- put_line(" characters.");
   -- put("n = "); put(n,1); new_line;
   -- put("Symbol_Table.Number = "); put(Symbol_Table.Number,1); new_line;
   -- put("The string : "); put_line(s);
    if Symbol_Table.Empty then
   --   put_line("initializing symbol table ...");
      Symbol_Table.Init(n);
    elsif Symbol_Table.Maximal_Size < n then
   --   put_line("resetting symbol table ...");
      Symbol_Table.Clear;
      Symbol_Table.Init(n);
   -- else
   --   put_line("symbol table is okay");
    end if;
    p := Standard_Complex_Laur_Strings.Parse(n,s);
    Laurent_Systems_Container.Add_Poly(k,p);
    Standard_Complex_Laurentials.Clear(p);
    return 0;
  end Job74;

  function Job76 return integer32 is -- polynomial as string to container

    use Interfaces.C;

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    nc : constant integer := integer(v_a(v_a'first));
    n : constant natural32 := natural32(v_a(v_a'first+1));
    k : constant integer32 := integer32(v_a(v_a'first+2));
    nc1 : constant Interfaces.C.size_t := Interfaces.C.size_t(nc-1);
    v_b : constant C_Integer_Array(0..nc1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc));
    s : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),v_b);
    p : Standard_Complex_Polynomials.Poly;

  begin
   -- put("Polynomial "); put(k,1);
   -- put(" given as string of "); put(nc,1);
   -- put_line(" characters.");
   -- put("The string : "); put_line(s);
    if Symbol_Table.Empty then
      Symbol_Table.Init(n);
    elsif Symbol_Table.Maximal_Size < n then
      Symbol_Table.Clear;
      Symbol_Table.Init(n);
    end if;
    p := Standard_Complex_Poly_Strings.Parse(n,s);
    Standard_PolySys_Container.Add_Poly(k,p);
    Standard_Complex_Polynomials.Clear(p);
    return 0;
  exception
    when others => return 76;
  end Job76;

  function Job208 return integer32 is -- dd poly as string to container

    use Interfaces.C;

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    nc : constant integer := integer(v_a(v_a'first));
    n : constant natural32 := natural32(v_a(v_a'first+1));
    k : constant integer32 := integer32(v_a(v_a'first+2));
    nc1 : constant Interfaces.C.size_t := Interfaces.C.size_t(nc-1);
    v_b : constant C_Integer_Array(0..nc1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc));
    s : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),v_b);
    p : DoblDobl_Complex_Polynomials.Poly;

  begin
   -- put("Polynomial "); put(k,1);
   -- put(" given as string of "); put(nc,1);
   -- put_line(" characters.");
   -- put("The string : "); put_line(s);
    if Symbol_Table.Empty then
      Symbol_Table.Init(n);
    elsif Symbol_Table.Maximal_Size < n then
      Symbol_Table.Clear;
      Symbol_Table.Init(n);
    end if;
    p := DoblDobl_Complex_Poly_Strings.Parse(n,s);
    DoblDobl_PolySys_Container.Add_Poly(k,p);
    DoblDobl_Complex_Polynomials.Clear(p);
    return 0;
  exception
    when others => return 208;
  end Job208;

  function Job218 return integer32 is -- qd poly as string to container

    use Interfaces.C;

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    nc : constant integer := integer(v_a(v_a'first));
    n : constant natural32 := natural32(v_a(v_a'first+1));
    k : constant integer32 := integer32(v_a(v_a'first+2));
    nc1 : constant Interfaces.C.size_t := Interfaces.C.size_t(nc-1);
    v_b : constant C_Integer_Array(0..nc1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc));
    s : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),v_b);
    p : QuadDobl_Complex_Polynomials.Poly;

  begin
   -- put("Polynomial "); put(k,1);
   -- put(" given as string of "); put(nc,1);
   -- put_line(" characters.");
   -- put("The string : "); put_line(s);
    if Symbol_Table.Empty then
      Symbol_Table.Init(n);
    elsif Symbol_Table.Maximal_Size < n then
      Symbol_Table.Clear;
      Symbol_Table.Init(n);
    end if;
    p := QuadDobl_Complex_Poly_Strings.Parse(n,s);
    QuadDobl_PolySys_Container.Add_Poly(k,p);
    QuadDobl_Complex_Polynomials.Clear(p);
    return 0;
  exception
    when others => return 218;
  end Job218;

  function Job228 return integer32 is -- mp poly as string to container

    use Interfaces.C;

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(4));
    nc : constant integer := integer(v_a(v_a'first));
    n : constant natural32 := natural32(v_a(v_a'first+1));
    k : constant integer32 := integer32(v_a(v_a'first+2));
    deci : constant natural32 := natural32(v_a(v_a'first+3));
    size : constant natural32
         := Multprec_Floating_Numbers.Decimal_to_Size(deci);
    nc1 : constant Interfaces.C.size_t := Interfaces.C.size_t(nc-1);
    v_b : constant C_Integer_Array(0..nc1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc));
    s : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),v_b);
    p : Multprec_Complex_Polynomials.Poly;

  begin
   -- put("Polynomial "); put(k,1);
   -- put(" given as string of "); put(nc,1);
   -- put_line(" characters.");
   -- put("The string : "); put_line(s);
    if Symbol_Table.Empty then
      Symbol_Table.Init(n);
    elsif Symbol_Table.Maximal_Size < n then
      Symbol_Table.Clear;
      Symbol_Table.Init(n);
    end if;
    p := Multprec_Complex_Poly_Strings.Parse(n,size,s);
    Multprec_PolySys_Container.Add_Poly(k,p);
    Multprec_Complex_Polynomials.Clear(p);
    return 0;
  exception
    when others => return 228;
  end Job228;

  function Job20 return integer32 is -- degree of a polynomial

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    deg : constant integer32 := Standard_PolySys_Container.Degree(equ);

  begin
    Assign(deg,b);
    return 0;
  end Job20;

  function Job209 return integer32 is -- degree of a double double polynomial

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    deg : constant integer32 := DoblDobl_PolySys_Container.Degree(equ);

  begin
    Assign(deg,b);
    return 0;
  end Job209;

  function Job219 return integer32 is -- degree of a quad double polynomial

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    deg : constant integer32 := QuadDobl_PolySys_Container.Degree(equ);

  begin
    Assign(deg,b);
    return 0;
  end Job219;

  function Job229 return integer32 is -- degree of a multiprecision polynomial

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    equ : constant integer32 := integer32(v_a(v_a'first));
    deg : constant integer32 := Multprec_PolySys_Container.Degree(equ);

  begin
    Assign(deg,b);
    return 0;
  end Job229;

-- The jobs to drop a coordinate of a system come in two flavors:
-- (1) by index: given the index of the variable in a[0];
-- (2) by name: given the number of characters of the symbol in a[0]
--     and the characters for the symbol name in b.

  function Job12 return integer32 is -- drop variable by index

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    ind : constant integer32 := integer32(v_a(v_a'first));
    use Standard_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := Standard_PolySys_Container.Retrieve;
    dropped : constant Poly_Sys(lp'range) := Polynomial_Drops.Drop(lp.all,ind);

  begin
    Standard_PolySys_Container.Clear;
    Standard_PolySys_Container.Initialize(dropped);
    return 0;
  end Job12;

  function Job13 return integer32 is -- drop variable by index

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    ind : constant integer32 := integer32(v_a(v_a'first));
    use DoblDobl_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := DoblDobl_PolySys_Container.Retrieve;
    dropped : constant Poly_Sys(lp'range) := Polynomial_Drops.Drop(lp.all,ind);

  begin
    DoblDobl_PolySys_Container.Clear;
    DoblDobl_PolySys_Container.Initialize(dropped);
    return 0;
  end Job13;

  function Job14 return integer32 is -- drop variable by index

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    ind : constant integer32 := integer32(v_a(v_a'first));
    use QuadDobl_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := QuadDobl_PolySys_Container.Retrieve;
    dropped : constant Poly_Sys(lp'range) := Polynomial_Drops.Drop(lp.all,ind);

  begin
    QuadDobl_PolySys_Container.Clear;
    QuadDobl_PolySys_Container.Initialize(dropped);
    return 0;
  end Job14;

  function Job15 return integer32 is -- drop variable by name

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    nc : constant natural := natural(v_a(v_a'first));
    vb : constant C_Integer_Array(0..Interfaces.C.size_t(nc))
       := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc+1));
    sv : constant String(1..nc)
       := C_Integer_Array_to_String(natural32(nc),vb);   
    sb : Symbol_Table.Symbol;
    ind : natural32;
    use Standard_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := Standard_PolySys_Container.Retrieve;
    dropped : Poly_Sys(lp'range);

  begin
    for i in 1..nc loop
      sb(i) := sv(i);
    end loop;
    for i in nc+1..sb'last loop
      sb(i) := ' ';
    end loop;
    ind := Symbol_Table.Get(sb);
    dropped := Polynomial_Drops.Drop(lp.all,integer32(ind));
    Standard_PolySys_Container.Clear;
    Standard_PolySys_Container.Initialize(dropped);
    return 0;
  end Job15;

  function Job16 return integer32 is -- drop variable by name

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    nc : constant natural := natural(v_a(v_a'first));
    vb : constant C_Integer_Array(0..Interfaces.C.size_t(nc))
       := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc+1));
    sv : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),vb);
    sb : Symbol_Table.Symbol;
    ind : natural32;
    use DoblDobl_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := DoblDobl_PolySys_Container.Retrieve;
    dropped : Poly_Sys(lp'range);

  begin
    for i in 1..nc loop
      sb(i) := sv(i);
    end loop;
    for i in nc+1..sb'last loop
      sb(i) := ' ';
    end loop;
    ind := Symbol_Table.Get(sb);
    dropped := Polynomial_Drops.Drop(lp.all,integer32(ind));
    DoblDobl_PolySys_Container.Clear;
    DoblDobl_PolySys_Container.Initialize(dropped);
    return 0;
  end Job16;

  function Job17 return integer32 is -- drop variable by name

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    nc : constant natural := natural(v_a(v_a'first));
    vb : constant C_Integer_Array(0..Interfaces.C.size_t(nc))
       := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc+1));
    sv : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),vb);
    sb : Symbol_Table.Symbol;
    ind : natural32;
    use Quaddobl_Complex_Poly_Systems;
    lp : constant Link_to_Poly_Sys := QuadDobl_PolySys_Container.Retrieve;
    dropped : Poly_Sys(lp'range);

  begin
    for i in 1..nc loop
      sb(i) := sv(i);
    end loop;
    for i in nc+1..sb'last loop
      sb(i) := ' ';
    end loop;
    ind := Symbol_Table.Get(sb);
    dropped := Polynomial_Drops.Drop(lp.all,integer32(ind));
    QuadDobl_PolySys_Container.Clear;
    QuadDobl_PolySys_Container.Initialize(dropped);
    return 0;
  end Job17;

  function Handle_Jobs return integer32 is
  begin
    case job is
      when 0 => return Job0; -- read system into container
      when 1 => return Job1; -- write system in container
      when 2 => return Job2; -- return dimension of system
      when 3 => return Job3; -- initialize container with dimension
      when 4 => return Job4; -- return #terms of a polynomial
      when 5 => return Job5; -- return a term of a polynomial
      when 6 => return Job6; -- add a term to a polynomial
      when 7 => return Job7; -- clear the container
      when 8 => return Job8; -- return total degree
      when 9 => return Job9; -- clear the symbol table
      when 10 => return Job10; -- creates a system evaluator
      when 11 => return Job11; -- creates a Jacobian matrix evaluator
     -- dropping variables from polynomials
      when 12 => return Job12; -- standard drop variable by index
      when 13 => return Job13; -- dobldobl drop variable by index
      when 14 => return Job14; -- quaddobl drop variable by index
      when 15 => return Job15; -- standard drop variable by name
      when 16 => return Job16; -- dobldobl drop variable by name
      when 17 => return Job17; -- quaddobl drop variable by name
     -- degrees of polynomials :
      when 20 => return Job20;   -- degree of standard polynomial
     -- jobs for Laurent polynomials :
      when 100 => return Job100; -- read system into container
      when 101 => return Job101; -- write system in container
      when 102 => return Job102; -- return dimension of system
      when 103 => return Job103; -- initialize container with dimension
      when 104 => return Job104; -- return #terms of a polynomial
      when 105 => return Job105; -- return a term of a polynomial
      when 106 => return Job106; -- add a term to a polynomial
      when 107 => return Job107; -- clear the container
     -- jobs for double double complex polynomials
      when 200 => return Job200; -- read system into container
      when 201 => return Job201; -- write system in container
      when 202 => return Job202; -- return dimension of system
      when 203 => return Job203; -- initialize container with dimension
      when 204 => return Job204; -- return #terms of a polynomial
      when 205 => return Job205; -- return a term of a polynomial
      when 206 => return Job206; -- add a term to a polynomial
      when 207 => return Job207; -- clear the container
      when 208 => return Job208; -- store dobldobl polynomial string
      when 209 => return Job209; -- return degree of a polynomial
     -- jobs for quad double complex polynomials
      when 210 => return Job210; -- read system into container
      when 211 => return Job211; -- write system in container
      when 212 => return Job212; -- return dimension of system
      when 213 => return Job213; -- initialize container with dimension
      when 214 => return Job214; -- return #terms of a polynomial
      when 215 => return Job215; -- return a term of a polynomial
      when 216 => return Job216; -- add a term to a polynomial
      when 217 => return Job217; -- clear the container
      when 218 => return Job218; -- store quaddobl polynomial string
      when 219 => return Job219; -- return degree of a polynomial
     -- jobs for multiprecision complex polynomials
      when 220 => return Job220; -- read system into container
      when 221 => return Job221; -- write system in container
      when 222 => return Job222; -- return dimension of system
      when 223 => return Job223; -- initialize container with dimension
      when 224 => return Job224; -- return #terms of a polynomial
      when 227 => return Job227; -- clear the container
      when 228 => return Job228; -- store multprecision polynomial string
      when 229 => return Job229; -- return degree of a polynomial
     -- jobs for interchanging polynomial as strings :
      when 67 => return Job67; -- load standard polynomial from container
      when 68 => return Job68; -- load dobldobl polynomial from container
      when 69 => return Job69; -- load quaddobl polynomial from container
      when 70 => return Job70; -- load multprec polynomial from container
      when 74 => return Job74; -- store standard Laurential in container
      when 76 => return Job76; -- store standard polynomial in container
      when others => put_line("invalid operation"); return 1;
    end case;
  end Handle_Jobs;

begin
  return Handle_Jobs;
end use_syscon;
